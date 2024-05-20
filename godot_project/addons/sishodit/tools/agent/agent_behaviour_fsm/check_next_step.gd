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
		my_agent.add_current_step(step)
		console_log(step)
		# This should never return false without objects excluded, so it will never transition here.
		# However, this may change in the future, so it is better to write the full logic.
		if not step.find_target_object(my_agent):
			transitioned_to.emit("NewNeed")
	else:
		step = steps.back()
	
	var t = my_agent.obtain_time_until_interruption(INF)
	if t <= 0.0:
		transitioned_to.emit("NewNeed")
		return
	
	step.set_agent_destination(my_agent)
	transitioned_to.emit("Traveling")

## Pops the last current need and solution and transitions to [i]NewNeed[/i] state
func _apply_current_solution():
	var solution = my_agent.pop_current_solution()
	my_agent.pop_current_need()
	
	my_agent.log_event("activity_end", solution.info.resource_name)
	transitioned_to.emit("NewNeed")

## Prints information about the current step chosen
func console_log(step):
	my_agent.console_log("(CheckNextStep) Current step %s can be solved with %s solves: %s" %
	 					[step, step.info.object_group, step.info.needs_solved])
