class_name BasicPerson
extends KinematicBody

export var speed = 10
export var distance_to_objective = 4

export var step_total_divisions : int = 20

export(Array, Resource) var needs

onready var smp = $StateMachinePlayer

var navigation : Navigation setget navigation_set

var to
var path

var current_solutions = []
var current_steps = []
var steps_divisions = []

### Overriden methods ###
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


### Public methods ###
func new_path():
	path = navigation.get_simple_path(global_transform.origin, to, true)


### Setgets ###
func navigation_set(new_nav):
	navigation = new_nav
	smp.set_trigger("start")

### Aux methods ###
func _process_needs(delta):
	for need in needs:
		if smp.get_current() == "doing_step" and need.need_key in current_steps.back()["step"].needs_solved:
			continue
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
	var current_step = current_steps.back()
	if current_step:
		current_step["time"] = current_step["step"].generate_duration()
		smp.set_param("time_left", current_step["time"])

func _set_place_of_next_step(object_key):
	if object_key != "":
		var objects = get_tree().get_nodes_in_group(object_key)
		current_steps.back()["object"] = objects[randi() % objects.size()] as Spatial
		to = current_steps.back()["object"].global_transform.origin
	else:
		current_steps.back()["object"] = null
		to = global_transform.origin
	new_path()

func _apply_current_solution():
	smp.set_trigger("need_solved")
	# Esto hay que cambiarlo al step y modificarlo en cada paso de la simulación
	current_solutions.pop_back()

func wait():
	var time = current_steps.back()["time"] / step_total_divisions
	TimeSim.fast_forward(time)
	_process_needs(time)
	
	smp.set_param("time_left", smp.get_param("time_left") - time)

func _get_usable_of(object: Node):
	if object == null:
		return null
	
	var usable = object.find_node("*Usable*", false)
	
	return usable

func _solve_needs(needs_to_solve, quantity = 1):
	for need in needs:
		if need.need_key in needs_to_solve:
			need.level -= quantity

## State Machine transitions ##
func _from_doing_step():
	var usable = _get_usable_of(current_steps.back()["object"])
	if usable != null:
		usable.finish_using(self)
	
	current_steps.pop_back()

func _to_doing_step():
	_set_duration_for_current_step()
	var usable = _get_usable_of(current_steps.back()["object"])
	if usable != null and current_steps.back()["step"].use_object:
		usable.start_using(self)


func _to_new_need():
	var current_need = _get_next_need_to_cover()
	current_solutions.append(current_need.get_solution())
	EventLogger.log_event(self.name, current_solutions.back().resource_name)
	print("-------------------------")
	print("New need: ", current_need.need_key, ". It can be solved in ",
			current_solutions.back().steps.size(), " steps.")
	smp.set_trigger("solution_chosen")

func _to_check_next_step():
	var current_step = current_solutions.back().get_next_step()
	current_steps.append({step = current_step})
	if current_step:
		_set_place_of_next_step(current_step.object_key)
		print("Current step can be solved with ", current_step.object_key,
			  " and solves: ", current_step.needs_solved)
		smp.set_trigger("next_step_chosen")
	else:
		_apply_current_solution()

## State Machine states ##
func _traveling(delta):
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

func _doing_step(delta):
	var step = current_steps.back()
	var usable = _get_usable_of(step["object"])
	# Do activity defined by object
	if usable != null:
		usable.being_used(self, delta)
	else:
		wait()
	# Solve needs partially
	var advance = 1.0/step_total_divisions
	_solve_needs(step["step"].needs_solved, 
				advance+rand_range(-advance/4, advance/4)) # This should be parametrized

### Callbacks ###
func _on_StateMachinePlayer_updated(state, delta):
	match state:
		"traveling":
			_traveling(delta)
		"doing_step":
			_doing_step(delta)


func _on_StateMachinePlayer_transited(from_state, to_state):
		match from_state:
			"doing_step":
				_from_doing_step()
		
		match to_state:
			"new_need":
				_to_new_need()
			"check_next_step":
				_to_check_next_step()
			"traveling":
				pass#_set_place_to_solve_need(need)
			"doing_step":
				_to_doing_step()
