extends Node
class_name Simulator

enum SimulationMode {DONT_CARE, HIGH_FREQ, LOW_FREQ}

### Properties ###
@export var elapsed_seconds : float = 0

# Paths
const log_dir = "sim_log/"
const base_name = "SiSHoDiT"

var file_manager

# Simulation variables
var _simulable_entities : Array[Simulable] = []
var _n_high_freq_entities = 0
var _time_skips : Array[float] = []

### Overriden methods ###
func _ready():
	for node in get_tree().get_nodes_in_group("simulable"):
		if node is Simulable:
			_simulable_entities.append(node)
			node.simulation_mode_changed.connect(on_simulable_mode_changed)
			node.log_event.connect(log_event)
			if node.simulation_mode == SimulationMode.HIGH_FREQ:
				_n_high_freq_entities += 1
	
	file_manager = FileManager.new()
	add_child(file_manager)
	file_manager.init_file(base_name, log_dir)

func _physics_process(delta):
	# If every entity is in low_freq_mode delta will be equal to the wait time
	if _n_high_freq_entities <= 0 and len(_time_skips) > 0:
		delta = _time_skips.min()
	
	_simulate(delta)

### Private Methods ###
func _simulate(delta):
	_update_time_skips(delta)
	elapsed_seconds += delta
	for simulable in _simulable_entities:
		simulable.simulated.emit(delta)

func _update_time_skips(delta):
	var to_remove = []
	for i in len(_time_skips):
		_time_skips[i] -= delta
		if _time_skips[i] <= 0.0:
			to_remove.append(i)
	for i in to_remove:
		_time_skips.remove_at(i)
		
### Callbacks ###
func on_simulable_mode_changed(simulable : Simulable, previous: SimulationMode):
	if previous == SimulationMode.HIGH_FREQ:
		_n_high_freq_entities -= 1
	elif simulable.simulation_mode == SimulationMode.HIGH_FREQ:
		_n_high_freq_entities += 1
	if simulable.simulation_mode == SimulationMode.LOW_FREQ:
		_time_skips.append(simulable.wait_time)


### Public Methods ###
func log_event(from, type, value, delta : float = 0.0):
	var log_data = {"time": elapsed_seconds + delta, "from": from, 
					"type": type, "value": value}
	
	file_manager.store_line(JSON.stringify(log_data) + ", ")
