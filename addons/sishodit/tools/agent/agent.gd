class_name Agent
extends CharacterBody3D

@export var speed = 10

@export var simulation_total_divisions : int = 20

@export var needs : Array[Need]# (Array, Resource)

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var state_machine : StateMachinePlayer = $StateMachinePlayer

@onready var simulable : Simulable = $Simulable

var to

var current_needs = []
var current_solutions = []
var current_steps = []
var steps_divisions = []

### Overriden methods ###
func _ready():
	var unsolvable_needs = []
	for need in needs:
		if not need.can_be_solved(get_tree()):
			unsolvable_needs.append(need)
	# Delete unsolvable needs
	for need in unsolvable_needs:
		needs.erase(need)
	
	if owner:
		await owner.ready
		state_machine.start()
		
		
### Public methods ###
func new_path():
	nav_agent.target_position = to


func wait(time: float):
	var step = current_steps.back()
	simulable.wait_time = time
	simulable.simulation_mode = Simulator.SimulationMode.LOW_FREQ

func finish_wait():
	simulable.simulation_mode = Simulator.SimulationMode.HIGH_FREQ
	
func log_event(type, value):
	simulable.log_event.emit(name, type, value)


### Aux methods ###
func _process_needs(delta):
	for need in needs:
		var modified_delta = delta
		if state_machine.current_state!= null and state_machine.current_state.name == "DoingStep":
			var step = current_steps.back()["step"] as SolutionStep
			if need.need_key in step.needs_solved:
				continue
			elif need.need_key in step.needs_with_modified_rate:
				modified_delta *= step.needs_with_modified_rate[need.need_key]
		need.increase_level(modified_delta)


### Call backs ###
func _on_simulable_simulated(delta):
		_process_needs(delta)
