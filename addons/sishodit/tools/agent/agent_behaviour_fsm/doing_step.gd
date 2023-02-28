extends State

## Time until the state finishes, which won't be the same to the remaining time if an interruption
## is predicted
var state_time_left : float = 0.0
## A reference to the information of the step associated with the state
var current_step : Dictionary
## Reference to the Usable node of the object relevant for the step.
var usable : AbstractUsable

func on_process(delta: float):
	# Update times
	current_step["time_left"] -= delta
	state_time_left -= delta
	
	# Solve needs based on delta
	_solve_needs(current_step["step"].needs_solved, delta/current_step["total_time"])
	
	# Use the object associated to the step
	if usable != null:
		usable.being_used(my_agent, delta)
	
	# If step has finished completly
	if current_step["time_left"] <= 0:
		my_agent.current_steps.pop_back()
		_console_log_finish()
		transitioned_to.emit("CheckNextStep")
	# If is interrupted
	elif state_time_left <= 0:
		if current_step["step"].cancel_on_interruption:
			_abort_need()
		_console_log_finish(true)
		my_agent.log_event("activity_interrupted", my_agent.current_solutions.back().resource_name)
		transitioned_to.emit("NewNeed")

func on_enter():
	# Sets current step to be the last element in [member Agent.current_steps]
	current_step = my_agent.current_steps.back()

	_initialize_duration_for_current_step()
	
	usable = _get_usable_of(current_step["object"])
	if usable != null and current_step["step"].use_object:
		usable.start_using(my_agent)

	state_time_left = my_agent.obtain_time_until_interruption()
	my_agent.wait(state_time_left)

func on_exit():
	if usable != null:
		usable.finish_using(my_agent)
	my_agent.finish_wait()
	

## Initialize duration for current step if it does not have one.
func _initialize_duration_for_current_step():
	if not "time_left" in current_step:
		current_step["total_time"] = current_step["step"].generate_duration()
		current_step["time_left"] = current_step["total_time"]

## Returns the [class AbstractUsable] node of an object or null if either the object is null or it
## does not have node with "Usable" in its name.
func _get_usable_of(object: Node) -> AbstractUsable:
	if object == null:
		return null
	
	return object.find_child("*Usable*", false)

## Reduces the level the specified [code]needs_to_solve[/code] by a [code]quantity[/code].
func _solve_needs(needs_to_solve, quantity = 1.0):
	for need in my_agent.needs:
		if need.need_key in needs_to_solve:
			need.level -= quantity

## Deletes every element related with the current need
func _abort_need():
	my_agent.current_steps.pop_back()
	my_agent.current_solutions.pop_back().reset()
	my_agent.current_needs.pop_back()

## Shows an output text once the execution has finished
func _console_log_finish(interrupted = false):
	var text = "finished"
	if interrupted:
		text = "interrupted"
	print("Step %s %s"%[current_step["step"].resource_path, text])
