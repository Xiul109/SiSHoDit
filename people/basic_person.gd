class_name BasicPerson
extends KinematicBody

export var speed = 10

export var simulation_total_divisions : int = 20

export(Array, Resource) var needs

onready var smp = $StateMachinePlayer

var navigation : Navigation setget navigation_set

var to
var path

var current_needs = []
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
	# Init SMP parameters
	smp.set_param("pending_needs", 0)

func _physics_process(delta):
	_process_needs(delta)


### Public methods ###
func new_path():
	var closest = navigation.get_closest_point(global_transform.origin)
#	var nav_mesh = navigation.get_children()[0].navmesh as NavigationMesh
#	var rad = nav_mesh.get_agent_radius()
	var p0 = closest
	path = navigation.get_simple_path(p0,
									  navigation.get_closest_point(to), true)
	
	if path.empty():
		path.append(navigation.get_closest_point(to))


func wait():
	var step = current_steps.back()
	var time = step["total_time"]/simulation_total_divisions
	step["time_left"] -= time
	TimeSim.fast_forward(time)
	_process_needs(time)

### Setgets ###
func navigation_set(new_nav):
	navigation = new_nav
	smp.set_trigger("start")

### Aux methods ###
func _process_needs(delta):
	for need in needs:
		var modified_delta = delta
		if smp.get_current() == "doing_step":
			var step = current_steps.back()["step"] as SolutionStep
			if need.need_key in step.needs_solved:
				continue
			elif need.need_key in step.needs_with_modified_rate:
				modified_delta *= step.needs_with_modified_rate[need.need_key]
		need.increase_level(modified_delta)

func _get_next_need_to_cover():
	var min_level = 0.0
	if not current_steps.empty():
		 min_level = current_steps.back()["step"].min_value_to_be_interrupted
	var probs = []
	var choosable_needs = []
	for need in needs:
		if need.level >= min_level:
			probs.append(need.get_probability())
			choosable_needs.append(need)
	
	var next_need_i = probs.find(1.0)
	if next_need_i == -1:
		next_need_i = _get_random_i_based_on_probs(probs)

	return choosable_needs[next_need_i]

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
		if not "time_left" in current_step:
			current_step["total_time"] = current_step["step"].generate_duration()
			current_step["time_left"] = current_step["total_time"]
			current_step["divisions_simulated"] = 0
		smp.set_param("time_left", current_step["time_left"])

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
	current_needs.pop_back()
	EventLogger.log_event(self.name, "activity_end",
						  current_solutions.pop_back().resource_name)
	
	smp.set_param("pending_needs", smp.get_param("pending_needs")-1)
	smp.set_trigger("need_solved")

func _get_usable_of(object: Node):
	if object == null:
		return null
	
	var usable = object.find_node("*Usable*", false)
	
	return usable

func _solve_needs(needs_to_solve, quantity = 1):
	for need in needs:
		if need.need_key in needs_to_solve:
			need.level -= quantity

func _check_interruptions(step : SolutionStep):
	# (1-p)^s = ~t; p = 1 - ~t^(1/s)
	if (1 - pow(step.probability_of_being_interrupted,
				1/simulation_total_divisions)
	) > randf():
		return false
	
	for need in needs:
		if not need in current_needs and need.level >= step.min_value_to_be_interrupted:
			smp.set_trigger("interrupted")
			EventLogger.log_event(self.name, "activity_interrupted", current_solutions.back().resource_name)
			print("Interrupted")
			return true
	
	return false

## State Machine transitions ##
func _from_doing_step():
	var usable = _get_usable_of(current_steps.back()["object"])
	if usable != null:
		usable.finish_using(self)

func _to_doing_step():
	_set_duration_for_current_step()
	var usable = _get_usable_of(current_steps.back()["object"])
	if usable != null and current_steps.back()["step"].use_object:
		usable.start_using(self)


func _to_new_need():
	var current_need = _get_next_need_to_cover()
	current_needs.append(current_need)
	current_solutions.append(current_need.get_solution())
	EventLogger.log_event(self.name, "activity_begin", current_solutions.back().resource_name)
	print("-------------------------")
	print("New need: ", current_need.need_key, ". It can be solved in ",
			current_solutions.back().steps.size(), " steps.")
	
	smp.set_param("pending_needs", smp.get_param("pending_needs")+1)
	smp.set_trigger("solution_chosen")

func _to_check_next_step():
	var current_step = current_solutions.back().get_next_step()
	if current_step:
		current_steps.append({step = current_step})
		_set_place_of_next_step(current_step.object_key)
		print("Current step can be solved with ", current_step.object_key,
			  " and solves: ", current_step.needs_solved)
		smp.set_trigger("next_step_chosen")
	else:
		_apply_current_solution()

func _to_pending_need():
	to = current_steps.back()["object"].global_transform.origin
	new_path()
	_set_duration_for_current_step()
	smp.set_trigger("next_step_chosen")

## State Machine states ##
func _traveling(delta):
	if path and len(path) > 0:
		var velocity = speed*(path[0]-global_transform.origin).normalized()
		if translation.distance_to(path[0]) < delta * speed:
			velocity = path[0]-global_transform.origin
			path.remove(0)
			if path.empty():
				smp.set_trigger("need_location_reached")
		
		# warning-ignore:return_value_discarded
		move_and_slide(velocity)
		if Vector3.UP.cross(velocity) != Vector3():
			look_at(global_transform.origin+velocity, Vector3.UP)
	else:
		new_path()

func _doing_step(delta):
	var step = current_steps.back()
	while not _check_interruptions(step["step"]) and step["divisions_simulated"]<simulation_total_divisions:
		step["divisions_simulated"] += 1
		var usable = _get_usable_of(step["object"])
		# Do activity defined by object
		if usable != null:
			usable.being_used(self, delta)
		else:
			wait()
		# Solve needs partially
		var advance = 1.0/simulation_total_divisions
		_solve_needs(step["step"].needs_solved, 
					advance+rand_range(-advance/4.0, advance/4.0))
	
	if step["divisions_simulated"]>=simulation_total_divisions:
		smp.set_trigger("step_finished")

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
				pass#print("Traveling")
			"doing_step":
				_to_doing_step()
			"finish_step":
				current_steps.pop_back()
			"pending_need":
				_to_pending_need()
