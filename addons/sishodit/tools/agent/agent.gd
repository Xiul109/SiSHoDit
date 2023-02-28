## An agent is an entity in the simulation that emulates the bahaviour of a person.
class_name Agent
extends CharacterBody3D

## The agent speed in units per second.
@export_range(0, 20, 0.001, "or_greater")
var speed: float = 10

## The list of needs of the agent.
@export 
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
## at that moment. Each element must be a dictionary with the following entries:[br]
## [code] "step" [/code]: A reference to the step object [br]
## [code] "object" [/code]: The specific object needed for the step [br]
## [code] "total_time" [/code]: The total time the step needs to be completed [br]
## [code] "time_left" [/code]: The remaining time the step needs to be completed [br]
## Both [code]"total_time"[/code] and [code]"time_left"[/code] entries are not added until the state
## machine enters for the first time after the step is chosen in the [i]DoingStep[/i] state.
var current_steps : Array[Dictionary] = []

## The state_machine is used for helping to model the behaviour of the agent and for distributing
## the code between specialized nodes, which makes it easier to maintain.
@onready var state_machine : StateMachinePlayer = $StateMachinePlayer
## Helps in the communication with the [code] Simulator [/code]
@onready var simulable : Simulable = $Simulable
## Used for agent pathfinding
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D


func _ready():
	# Finding and deleting unsolvable needs
	var unsolvable_needs = []
	for need in needs:
		if not need.can_be_solved(get_tree()):
			unsolvable_needs.append(need)
	for need in unsolvable_needs:
		needs.erase(need)
	# The state machine should not be initialized until the simulator is started
	# TODO: move this responsability to the Simulable class
	if owner:
		await owner.ready
		state_machine.start()

## Informs the Simulator that this agent will enter into low frequency mode during [code]time[/code]
## seconds
func wait(time: float):
	var step = current_steps.back()
	simulable.wait_time = time
	simulable.simulation_mode = Simulator.SimulationMode.LOW_FREQ

## Anticipates when a need will interrupt the step and returns the time remaining until that
## happens. If there is no interruption, it returns the maximum time setted as argument, which, by
## default, is the time the step needs to be completed.
func obtain_time_until_interruption(maximum_time = current_steps.back()["time_left"]) -> float:
	var step = current_steps.back()
	var times = [maximum_time]
	
	for need in needs:
		# Avoid interruptions by needs solved by current step, by the current need being solved or
		# by needs of lower priority
		if (need.need_key in current_solutions.back().needs_solved or 
			need.need_key == current_needs.back().need_key or
			need.priority <= step["priority"]):
			continue
		
		var rate = 1.0
		if need.need_key in step["step"].needs_with_modified_rate:
			rate = step["step"].needs_with_modified_rate[need.need_key]
		
		times.append(need.time_until_level(need.urgent_level, rate))
	
	return times.min()

## Informs the Simulator that this agent will enter into high frequency mode
## TODO: move the responsability to return to previous HIGH_FREQ mode to Simulable
func finish_wait():
	simulable.simulation_mode = Simulator.SimulationMode.HIGH_FREQ

## Emits [signal Simulable.log_event]
func log_event(type, value):
	simulable.log_event.emit(name, type, value)

## Processes the needs updates in a frame, excluding the ones solved in a [class SolutionStep] and
## taking into account those with modified rates
func _process_needs(delta):
	if state_machine.current_state== null or state_machine.current_state.name != "DoingStep":
		return
	
	for need in needs:
		var modified_delta = delta # Used for handling steps with modified rates
		var step = current_steps.back()["step"] as SolutionStep
		
		if need.need_key in step.needs_solved:
			continue
		elif need.need_key in step.needs_with_modified_rate:
			modified_delta *= step.needs_with_modified_rate[need.need_key]
		
		need.increase_level(modified_delta)

## Callback for [signal Simulable.simulated]
func _on_simulable_simulated(delta):
		_process_needs(delta)
