extends State

## The maximum time the [Agent] will wait until the object is freed
@export var max_wait_time : float = 600
## Extra time that the agent will wait over the needed one. It must be positive
## to ensure correct working.
@export_range(0.0, 10.0, .001, "or_greater") var extra_wait_time : float = .1


var wait_time : float = 0

func on_process(delta: float):
	wait_time -= delta
	if wait_time <= 0.0:
		transitioned_to.emit("Traveling")

func on_enter():
	var step : Step = my_agent.current_steps.back()
	var object = step.object
	var time = _time_until_free(object)
	my_agent.current_needs.back().change_timeout(time)
	
	# The agent will wait
	if time < max_wait_time:
		wait_time = time + extra_wait_time
		my_agent.simulable.wait(wait_time)
		print("Agent ", my_agent, " is waiting ", wait_time)
	# The agent finds another object
	elif step.find_target_object(my_agent, step.excluded_objects + [object]):
		step.excluded_objects.append(object)
		step.set_agent_destination(my_agent)
		transitioned_to.emit("Traveling")
	# The agent does another need
	else:
		step.excluded_objects.clear()
		transitioned_to.emit("NewNeed")

func on_exit():
	pass

# Auxiliar methods
## Returns the time needed until the current [Agent] has finished using it. If the user is not an
## [Agent] or is not being use, the method returns INF. In the last case, it also pushes an error.
func _time_until_free(object: Node) -> float:
	var object_users = object.find_children("*", "ObjectUser", false, false)
	
	if object_users.is_empty():
		push_error("ObjectInUse state entered without object in use.")
		return INF
	
	if not object_users[0].real_parent is Agent:
		return INF
		
	return object_users[0].real_parent.current_steps.back().time_left
