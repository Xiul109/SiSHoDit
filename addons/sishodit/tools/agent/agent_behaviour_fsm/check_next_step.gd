extends State


func on_process(_delta: float):
	pass

func on_enter():
	var current_step = my_agent.current_solutions.back().get_next_step()
	# If there's still steps in the current solution, we find where we should go next
	if current_step:
		_set_place_of_next_step(current_step)	
	# If not, we consider the solution as applied
	else:
		_apply_current_solution()

func on_exit():
	pass

## Aux functions ##
func _set_place_of_next_step(current_step):
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
	
	_set_agent_destination(step_info)

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
	
	if my_agent.current_needs.size() > 0:
		_set_agent_destination(my_agent.current_steps.back())
	else:
		transitioned_to.emit("NewNeed")
