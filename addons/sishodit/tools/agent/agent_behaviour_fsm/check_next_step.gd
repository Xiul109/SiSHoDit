extends State


func on_enter():
	# By default the next step to be solve is assumed to be the current one
	var step_info
	# If there are more current solutions than steps, a new one should be retrieved
	if len(my_agent.current_solutions) > len(my_agent.current_steps):
		var current_step = my_agent.current_solutions.back().get_next_step()
		# If there aren't more steps left for the current solution, then the solution can be applied
		if current_step == null:
			_apply_current_solution()
			return
		step_info = _init_current_step_info(current_step)
	else:
		step_info = my_agent.current_steps.back()
	
	# If there is a need with high urgence, more priority than next one and that will interrupt it
	# as soon as it starts, then that need will be prioritized
	var t = my_agent.obtain_time_until_interruption(INF)
	if t <= 0.0:
		transitioned_to.emit("NewNeed")
	
	_set_agent_destination(step_info)

## Initializes the dictionary including information related to the current [class Step]
func _init_current_step_info(current_step):
	var step_info = {"step" : current_step,
					"object" : null,
					"priority": max(current_step.priority, my_agent.current_needs.back().priority)}
	var object_key = current_step.object_key
	# If object key is not empty, agent should move towards an object that solve its current problem
	if object_key != "":
		var objects = get_tree().get_nodes_in_group(object_key)
		step_info["object"] = objects[randi() % objects.size()]
	
	my_agent.current_steps.append(step_info) # The step info is appended to the current steps
	
	console_log(current_step)
	
	return step_info

## Sets the next destination of the agent based on the object associated to the step and transitions
## to [i]Travelling[/i] state
func _set_agent_destination(step_info: Dictionary):
	var destination : Vector3 = my_agent.global_transform.origin
	if step_info["object"] != null:
		destination = step_info["object"].global_transform.origin
	
	my_agent.to = destination
	transitioned_to.emit("Traveling")

## Pops the last current need and solution and transitions to [i]NewNeed[/i] state
func _apply_current_solution():
	my_agent.current_needs.pop_back()
	my_agent.log_event("activity_end", my_agent.current_solutions.pop_back().resource_name)
	transitioned_to.emit("NewNeed")

## Prints information about the current step chosen
func console_log(step):
	print("Current step can be solved with ", step.object_key, " and solves: ", step.needs_solved)
