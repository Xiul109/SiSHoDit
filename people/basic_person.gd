class_name BasicPerson
extends KinematicBody

export var speed = 10
export var distance_to_objective = 4

export(Array, Resource) var needs

onready var smp = $StateMachinePlayer

var navigation : Navigation setget navigation_set

var to
var path

var current_needs : Array
var _time_left_in_current_need : float = 0

# Overriden methods
func _process(delta):
	_process_needs(delta)


# Public methods
func new_path():
	path = navigation.get_simple_path(global_transform.origin, to, true)

# Setgets
func navigation_set(new_nav):
	navigation = new_nav
	smp.set_trigger("start")

# Aux methods
func _movement(delta):
	if path and len(path) > 0:
		var velocity = speed*(path[0]-global_transform.origin).normalized()
		if translation.distance_to(path[0]) < delta * speed:
			velocity = path[0]-global_transform.origin
			path.remove(0)
		
		if translation.distance_to(to) < distance_to_objective:
			path = []
			return
		
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)
		if Vector3.UP.cross(velocity) != Vector3():
			look_at(global_transform.origin+velocity, Vector3.UP)
	else:
		smp.set_trigger("need_location_reached")

func _process_needs(delta):
	for need in needs:
		need.increase_level(delta)

func _get_next_need_to_cover():
	var probs = []
	for need in needs:
		probs.append(need.get_probability())
	
	var next_need_i = probs.find(1)
	if next_need_i == -1:
		next_need_i = _get_random_i_based_on_probs(probs)

	return needs[next_need_i]

func _get_random_i_based_on_probs(probs):
	var total = 0
	for p in probs:
		total += p
	var prob = rand_range(0, total)
	var sum = 0
	for i in range(len(probs)):
		sum += probs[i]
		if prob < sum:
			return i
	
	return 0

func _set_duration_for_current_needs():
	if not current_needs.empty():
		_time_left_in_current_need = 0
		for n in current_needs:
			var dur = n.generate_duration()
			if dur > _time_left_in_current_need:
				_time_left_in_current_need = dur
		smp.set_param("time_left", _time_left_in_current_need)

func _set_place_to_solve_need(need : Need):
	var objects = get_tree().get_nodes_in_group(need.need_key)
	var object = objects[randi() % objects.size()] as Spatial
	
	# Path
	to = object.global_transform.origin
	new_path()
	
	# Current needs
	var needs_of_object = object.get_groups()
	for n in needs:
		if n.need_key in needs_of_object:
			current_needs.append(n)

func _solve_current_needs():	
	TimeSim.fast_forward(_time_left_in_current_need)
	_process_needs(_time_left_in_current_need)
	
	_time_left_in_current_need = 0
	smp.set_param("time_left", _time_left_in_current_need)
	
	for need in current_needs:
		need.level = 0
	current_needs = []

# Callbacks
func _on_StateMachinePlayer_updated(state, delta):
	match state:
		"traveling_to_need":
			_movement(delta)
		"solving_need":
			pass
#			_time_left_in_current_need -= delta
#			smp.set_param("time_left", _time_left_in_current_need)


func _on_StateMachinePlayer_transited(from_state, to_state):
		match from_state:
			"solving_need":
				pass
			
		match to_state:
			"traveling_to_need":
				var need = _get_next_need_to_cover()
				_set_place_to_solve_need(need)
				print("Traveling to ", to, " to solve needs:", need.need_key, ", p ", need.get_probability())
			"solving_need":
				_set_duration_for_current_needs()
				print("solving ", current_needs, " will take ", _time_left_in_current_need, " s")
				_solve_current_needs()
