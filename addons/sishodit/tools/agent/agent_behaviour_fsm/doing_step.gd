extends State

var time_left = 0
var current_step : Dictionary

func on_process(delta: float):
	_solve_needs(current_step["step"].needs_solved, delta/current_step["total_time"])
	
	# Do activity defined by object
	var usable = _get_usable_of(current_step["object"])
	if usable != null:
		usable.being_used(my_agent, delta)
	
	
	
	if current_step["divisions_simulated"]>=my_agent.simulation_total_divisions:
		my_agent.current_steps.pop_back()
		transitioned_to.emit("CheckNextStep")

func on_enter():
	current_step = my_agent.current_steps.back()
	_set_duration_for_current_step()
	var usable = _get_usable_of(current_step["object"])
	if usable != null and current_step["step"].use_object:
		usable.start_using(my_agent)
	
	## This loop will change when interruption system is changed
	while not _check_interruptions(current_step["step"]) and current_step["divisions_simulated"]<my_agent.simulation_total_divisions:
		current_step["divisions_simulated"] += 1

	var time : float = current_step["divisions_simulated"]*current_step["total_time"]/my_agent.simulation_total_divisions
	
	my_agent.wait(time)

func on_exit():
	var usable = _get_usable_of(current_step["object"])
	if usable != null:
		usable.finish_using(my_agent)
	my_agent.finish_wait()
	

## Aux functions ##
func _set_duration_for_current_step():	
	if not "time_left" in current_step:
		current_step["total_time"] = current_step["step"].generate_duration()
		current_step["time_left"] = current_step["total_time"]
		current_step["divisions_simulated"] = 0

func _get_usable_of(object: Node) -> AbstractUsable:
	if object == null:
		return null
	
	return object.find_child("*Usable*", false)

func _solve_needs(needs_to_solve, quantity = 1.0):
	for need in my_agent.needs:
		if need.need_key in needs_to_solve:
			need.level -= quantity

func _check_interruptions(step : SolutionStep):
	# (1-p)^s = ~t; p = 1 - ~t^(1/s)
	if (1 - pow(step.probability_of_not_being_interrupted,
				1.0/my_agent.simulation_total_divisions)
	) <= randf():
		return false
	
	for need in my_agent.needs:
		if not need in my_agent.current_needs and need.level >= step.min_value_to_be_interrupted:
			transitioned_to.emit("NewNeed")
			my_agent.log_event("activity_interrupted", my_agent.current_solutions.back().resource_name)
			print("Interrupted")
			return true
	
	return false
