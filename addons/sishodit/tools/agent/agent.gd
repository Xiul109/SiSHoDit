class_name Agent
extends CharacterBody3D

## An agent is an entity in the simulation that emulates the bahaviour of a person.

## Emmitted when a new [Need] is chosen
signal new_current_need(need : Need)
## Emmited when a [Need] is poped from the stack
signal current_need_poped(need: Need)
## Emmited when a new [Solution] is chosen
signal new_current_solution(solution: Solution)
## Emmited when a [Solution] is poped from the stack
signal current_solution_poped(solution: Solution)
## Emmited when a new [Step] is chosen
signal new_current_step(step: Step)
## Emmithed when a [Step] is poped from the stack
signal current_step_poped(step: Step)

## The agent speed in units per second.
@export_range(0, 20, 0.001, "or_greater")
var speed: float = 10

## The list of information of each need of the agent.
@export var needs_info : Array[NeedInfo]

## The list of needs of the agent.
var needs : Array[Need]

## New destination for the agent.
var to : Vector3:
	set(new_to):
		to = new_to
		nav_agent.target_position = to
		
## List of needs that are pending to be solved or being solved. The last one is always being solved
## at that moment.
var current_needs : Array[Need] = []

## List of solutions that are pending to be solved or being solved. The last one is always being
## solved at that moment.
var current_solutions: Array[Solution] = []

## List of steps that are pending to be solved or being solved. The last one is always being solved
## at that moment.
var current_steps : Array[Step] = []

## The state_machine is used for helping to model the behaviour of the agent and for distributing
## the code between specialized nodes, which makes it easier to maintain.
@onready var state_machine : StateMachinePlayer = $StateMachinePlayer
## Helps in the communication with the [code] Simulator [/code]
@onready var simulable : Simulable = $Simulable
## Used for agent pathfinding
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

@onready var object_user : ObjectUser = $ObjectUser

func _ready():
	# Finding and deleting unsolvable needs
	var unsolvable_needs = []
	for need_info in needs_info:
		var need = Need.new(need_info, get_tree())
		if not need.feasible_solutions.is_empty():
			needs.append(need)
	# The state machine should not be initialized until the simulator is started
	# TODO: move this responsability to the Simulable class
	
	# If state machine is started in ready, navigation map is not active and that generates problems
	# , so a timer is the best solution I could find for now. I also tried using call_deferred, but
	# it did not work.
	var timer = get_tree().create_timer(.0001)
	timer.timeout.connect(state_machine.start)
	

## Informs the Simulator that this agent will enter into low frequency mode during [code]time[/code]
## seconds
func wait(time: float):
	simulable.wait(time)

## Anticipates when a need will interrupt the step and returns the time remaining until that
## happens. If there is no interruption, it returns the maximum time setted as argument, which, by
## default, is the time the step needs to be completed.
func obtain_time_until_interruption(maximum_time = current_steps.back().time_left) -> float:
	var step = current_steps.back()
	var times = [maximum_time]
	
	for need in needs:
		# Avoid interruptions by needs solved by current step, by the current need being solved or
		# by needs of lower priority
		if (need.info.need_key in current_solutions.back().needs_solved or 
			need.info.need_key == current_needs.back().info.need_key or
			need.info.priority <= step.priority or
			not need.has_solutions_in_context(simulable.context)):
			continue
		var rate = 1.0
		if need.info.need_key in step.info.needs_with_modified_rate:
			rate = step.info.needs_with_modified_rate[need.info.need_key]
		
		times.append(need.time_until_level(need.info.urgent_level, rate))
	
	return times.min()

## Adds a new [Need] to the array containing them
func add_current_need(need: Need):
	current_needs.append(need)
	new_current_need.emit(need)

## Deletes the current [Need] from the array containing it
func pop_current_need() -> Need:
	var need = current_needs.pop_back()
	current_need_poped.emit(need)
	return need

## Adds a new [Solution] to the array containing them
func add_current_solution(sol: Solution):
	current_solutions.append(sol)
	new_current_solution.emit(sol)

## Deletes the current [Solution] from the array containing it
func pop_current_solution() -> Solution:
	var sol = current_solutions.pop_back()
	current_solution_poped.emit(sol)
	return sol

## Adds a new [Step] to the array containing them
func add_current_step(step: Step):
	current_steps.append(step)
	new_current_step.emit(step)

## Deletes the current [Step] from the array containing it
func pop_current_step() -> Step:
	var step = current_steps.pop_back()
	current_step_poped.emit(step)
	return step

## Prints a message to the console including the id of the agent before it
func console_log(message):
	print("[", name, "] ", message)

## Emits [signal Simulable.log_event]
func log_event(type, value):
	simulable.log_event.emit(name, type, value)

## Processes the needs updates in a frame, excluding the ones solved in a [Step] and taking into
## account those with modified rates
func _process_needs(delta):
	if state_machine.current_state== null or state_machine.current_state.name != "DoingStep":
		return
	
	for need in needs:
		var modified_delta = delta # Used for handling steps with modified rates
		var step = current_steps.back()
		
		if need.info.need_key in step.info.needs_solved:
			continue
		elif need.info.need_key in step.info.needs_with_modified_rate:
			modified_delta *= step.info.needs_with_modified_rate[need.info.need_key]
		
		need.increase_level(modified_delta)
		need.timeout -= delta

## Callback for [signal Simulable.simulated]
func _on_simulable_simulated(delta):
		_process_needs(delta)


func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
