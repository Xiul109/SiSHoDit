extends State

## Time until the state finishes, which won't be the same to the remaining time if an interruption
## is predicted
var state_time_left : float = 0.0
## A reference to the information of the step associated with the state
var current_step : Step
### True when an interruption has happened
var interrupted = false


func on_process(delta: float):
	# Update state time
	state_time_left -= delta
	
	# If step has finished completly
	if current_step.do(delta, my_agent):
		_console_log_finish()
		my_agent.pop_current_step()
		transitioned_to.emit("CheckNextStep")
	# If is interrupted
	elif state_time_left <= 0:
		interrupted = true
		_console_log_finish(true)
		my_agent.log_event("activity_interrupted",
							my_agent.current_solutions.back().info.resource_name)
		transitioned_to.emit("NewNeed")

func on_enter():
	# Sets current step to be the last element in [member Agent.current_steps]
	current_step = my_agent.current_steps.back()
	current_step.start(my_agent)
	
	state_time_left = my_agent.obtain_time_until_interruption()
	my_agent.wait(state_time_left)

func on_exit():
	current_step.stop(my_agent)
	if interrupted and current_step.info.cancel_on_interruption:
		_abort_need()
	current_step = null
	interrupted = false
	

## Deletes every element related with the current need
func _abort_need():
	my_agent.pop_current_step()
	my_agent.pop_current_solution()
	my_agent.pop_current_need()

## Shows an output text once the execution has finished
func _console_log_finish(interrupted = false):
	var text = "finished"
	if interrupted:
		text = "interrupted"
	my_agent.console_log("(DoingStep) Step %s %s"%[current_step, text])
