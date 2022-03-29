class_name BasicPerson
extends KinematicBody

export var speed = 10
export var distance_to_objective = 4

export(Array, Resource) var needs

onready var smp = $StateMachinePlayer

var navigation : Navigation setget navigation_set

var to
var path

var current_need : Need
var current_solution
var current_step
var current_object
var _time_left_in_current_step : float = 0

# Overriden methods
func _ready():
	var unsolvable_needs = []
	for need in needs:
		if not need.can_be_solved(get_tree()):
			unsolvable_needs.append(need)
	# Delete unsolvable needs
	for need in unsolvable_needs:
		needs.erase(need)

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
	
	var next_need_i = probs.find(1.0)
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

func _set_duration_for_current_step():
	if current_step:
		_time_left_in_current_step = current_step.generate_duration()
		smp.set_param("time_left", _time_left_in_current_step)

func _set_place_of_next_step(object_key):
	var objects = get_tree().get_nodes_in_group(object_key)
	current_object = objects[randi() % objects.size()] as Spatial
	
	# Path
	to = current_object.global_transform.origin
	new_path()

func _apply_current_solution():	
	smp.set_trigger("need_solved")
	for need in needs:
		if need.need_key in current_solution.needs_solved:
			need.level = 0
	print("Following needs has been solved: ", current_solution.needs_solved)
	current_solution = null

func _wait():
	TimeSim.fast_forward(_time_left_in_current_step)
	_process_needs(_time_left_in_current_step)
	
	_time_left_in_current_step = 0
	smp.set_param("time_left", _time_left_in_current_step)

# Callbacks
func _on_StateMachinePlayer_updated(state, delta):
	match state:
		"traveling":
			_movement(delta)
		"doing_step":
			if current_object.has_node("Usable"):
				current_object.get_node("Usable").being_used(self, delta)


func _on_StateMachinePlayer_transited(from_state, to_state):
		match from_state:
			"doing_step":
				if current_object.has_node("Usable"):
					current_object.get_node("Usable").finish_using(self)
		
		match to_state:
			"new_need":
				current_need = _get_next_need_to_cover()
				current_solution = current_need.get_solution()
				print("-------------------------")
				print("New need: ", current_need.need_key, ". It can be solved in ",
				 current_solution.steps.size(), " steps.")
				smp.set_trigger("solution_chosen")
			"check_next_step":
				current_step = current_solution.get_next_step()
				if current_step:
					_set_place_of_next_step(current_step.object_key)
					print("Current step can be solved with ", current_step.object_key)
					smp.set_trigger("next_step_chosen")
				else:
					_apply_current_solution()
			"traveling":
				pass#_set_place_to_solve_need(need)
			"doing_step":
				_set_duration_for_current_step()
				if current_object.has_node("Usable"):
					current_object.get_node("Usable").start_using(self)
				else:
					_wait()
