extends State


func on_enter():
	# By default the next step to be solve is assumed to be the current one
	var step : Step
	var solutions = my_agent.current_solutions
	var steps = my_agent.current_steps
	
	# If there are more current solutions than steps, a new one should be retrieved
	if len(solutions) > len(steps):
		step = solutions.back().get_next_step(  my_agent.current_needs.back().info.priority,
												my_agent.simulable.context)
		# If there aren't more steps left for the current solution, then the solution can be applied
		if step == null:
			_apply_current_solution()
			return
		step.find_target_object(my_agent)
		steps.append(step)
		console_log(step)
	else:
		step = steps.back()
	
	var t = my_agent.obtain_time_until_interruption(INF)
	if t <= 0.0:
		transitioned_to.emit("NewNeed")
		return
	
	_set_agent_destination(step)


## Sets the next destination of the agent based on the object associated to the step and transitions
## to [i]Travelling[/i] state
func _set_agent_destination(step: Step):
	var destination : Vector3 = my_agent.global_transform.origin
	if step.object != null:
		destination = step.object.global_transform.origin
	
	my_agent.to = destination
	transitioned_to.emit("Traveling")

## Pops the last current need and solution and transitions to [i]NewNeed[/i] state
func _apply_current_solution():
	my_agent.current_needs.pop_back()
	my_agent.log_event("activity_end", my_agent.current_solutions.pop_back().info.resource_name)
	transitioned_to.emit("NewNeed")

## Prints information about the current step chosen
func console_log(step):
	print("Current step (", step,
		") can be solved with ", step.info.object_group,
		" and solves: ", step.info.needs_solved)
