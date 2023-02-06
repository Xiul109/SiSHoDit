extends State


func on_process(_delta: float):
	pass

func on_enter():
	var step_info = null
	if len(my_agent.current_solutions) > len(my_agent.current_steps):
		var current_step = my_agent.current_solutions.back().get_next_step()
		if current_step != null:
			step_info = _init_current_step_info(current_step)
	else:
		step_info = my_agent.current_steps.back()
	# If there's still steps in the current solution or there are interupted steps, we find where the agent should go next
	if step_info:
		_set_agent_destination(step_info)
	# If not, we consider the solution as applied
	else:
		_apply_current_solution()

func on_exit():
	pass

## Aux functions ##
func _init_current_step_info(current_step):
	var step_info = {step = current_step}
	var object_key = current_step.object_key
	# If object key is not empty, agent should move towards an object that solve its current problem
	if object_key != "":
		var objects = get_tree().get_nodes_in_group(object_key)
		var selected_object = objects[randi() % objects.size()] as Node3D
		step_info["object"] = selected_object
	# If not it stays in its position, which is the same than travelling to the agent own position
	else:
		step_info["object"] = null

	print("Current step can be solved with ", current_step.object_key,
			" and solves: ", current_step.needs_solved)
	my_agent.current_steps.append(step_info)
	return step_info


func _set_agent_destination(step_info: Dictionary):
	if step_info["object"] == null:
		my_agent.to = my_agent.global_transform.origin
	else:
		my_agent.to = step_info["object"].global_transform.origin
	my_agent.new_path()
	transitioned_to.emit("Traveling")

func _apply_current_solution():
	my_agent.current_needs.pop_back()
	my_agent.log_event("activity_end", my_agent.current_solutions.pop_back().resource_name)
	
	transitioned_to.emit("NewNeed")
