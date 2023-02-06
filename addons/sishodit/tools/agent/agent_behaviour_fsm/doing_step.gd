extends State

var time_left : float = 0.0
var current_step : Dictionary

func on_process(delta: float):
	_solve_needs(current_step["step"].needs_solved, delta/current_step["total_time"])
	
	# Do activity defined by object
	var usable = _get_usable_of(current_step["object"])
	if usable != null:
		usable.being_used(my_agent, delta)
	
	current_step["time_left"] -= delta
	time_left -= delta
	
	# If step has finished completly
	if current_step["time_left"] <= 0:
		my_agent.current_steps.pop_back()
		print("Step %s finished"%current_step["step"].resource_path)
		transitioned_to.emit("CheckNextStep")
	# If is interrupted
	elif time_left <= 0:
		if current_step["step"].cancel_on_interruption:
			my_agent.current_steps.pop_back()
			my_agent.current_solutions.pop_back().reset()
			my_agent.current_needs.pop_back()
		print("Step %s interrupted"%current_step["step"].resource_path)
		transitioned_to.emit("NewNeed")
		my_agent.log_event("activity_interrupted", my_agent.current_solutions.back().resource_name)

func on_enter():
	current_step = my_agent.current_steps.back()
	_set_duration_for_current_step()
	var usable = _get_usable_of(current_step["object"])
	if usable != null and current_step["step"].use_object:
		usable.start_using(my_agent)

	time_left = _check_time_until_interruption()
	my_agent.wait(time_left)

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

func _get_usable_of(object: Node) -> AbstractUsable:
	if object == null:
		return null
	
	return object.find_child("*Usable*", false)

func _solve_needs(needs_to_solve, quantity = 1.0):
	for need in my_agent.needs:
		if need.need_key in needs_to_solve:
			need.level -= quantity

#
func _check_time_until_interruption() -> float:
	var step : SolutionStep = current_step["step"]
	var times = [current_step["time_left"]]
	for need in my_agent.needs:
		# Avoid interruptions by needs solved by current step or by current need
		if need.need_key in step.needs_solved or need.need_key == my_agent.current_needs.back().need_key:
			continue
		if need.priority > step.priority:
			var time : float
			if need.need_key in step.needs_with_modified_rate:
				time = need.time_until_level(need.urgent_level, step.needs_with_modified_rate[need.need_key])
			else:
				time = need.time_until_level(need.urgent_level)
			
			if time > 0:
				times.append(time)
			
	
	return times.min()
