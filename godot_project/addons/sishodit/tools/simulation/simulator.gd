extends Node
class_name Simulator

## It is in charge of controlling general aspects of the simulation, and of managing every entity
## that requires active simulation, such as [Agent]s or some [Sensor]s. Only one should be added to
## the scene and it should be the last child to ensure every other node has been added to the tree.

# Paths
## Directory for storing the logs of the simulator.
const log_dir = "sim_log/"
## Base name of the log files.
const base_name = "SiSHoDiT"

## Number of seconds elapsed since the beggining of the simulation. It can be modified before
## starting the simulation to include an offset in the time.
@export var elapsed_seconds : float = 0.0

## Time between save files periods in seconds
@export var save_period : float = 5.0
var _save_timer : Timer

## Reference to the [FileManager] that produces the logs.
var file_manager : FileManager
## Stores log data for the frame before saving it
var _temp_log_data : Array[Dictionary] = []

## Simulation context including variables relevant to [Simulable] entities, mainly [Agent]s.
var context = {}

# Simulation variables
## A list of every [Simulable] node of the simulation.
var _simulable_entities : Array[Simulable] = []
## A list of [Simulable] nodes that require real time simulation.
var _real_time_entities : Array[Simulable] = []


# Overriden methods
func _ready():
	# Finding Simulable nodes
	for node in get_tree().get_nodes_in_group("simulable"):
		if not node is Simulable:
			push_warning("Only objects of type Simulable should belong to 'simulable' group.")
			continue
		node.log_event.connect(log_event)
		node.log_events.connect(log_events)
		node.waiting_started.connect(_on_entity_waiting)
		node.context = context
		_simulable_entities.append(node)
		if node.requires_real_time:
			_real_time_entities.append(node)
	_simulable_entities.sort_custom(func(a, b): return a.priority > b.priority)
	
	# FileManager initialization
	file_manager = FileManager.new()
	add_child(file_manager)
	file_manager.init_file(base_name, log_dir)
	
	# Save timer initialization
	_save_timer = Timer.new()
	_save_timer.wait_time
	add_child(_save_timer)
	_save_timer.timeout.connect(_save_events)
	_save_timer.start()
	
	# This is done to avoid starting the simulation until after the first physics frame, so the
	# Navigation Server has been initialized
	call_deferred("_late_init")

func _physics_process(delta: float):
	_simulate(delta)

# Public Methods
## Called when adding a new line to the log file
func log_event(from, type, value, delta : float = 0.0):
	var log_data = {"time": elapsed_seconds + delta, "from": from, 
					"type": type, "value": value}
	_temp_log_data.append((log_data))

## Logs multiple events at once with a constant time difference between them equals to [param period].
func log_events(from: String, type : String, values : PackedFloat32Array,
				period : float, time_offset : float = 0.0):
	_temp_log_data.append_array(EventsDictCreator.create_dict(  from, type, values, period,
																elapsed_seconds + time_offset))

# Private methods
func _simulate(delta: float):
	elapsed_seconds += delta
	for simulable in _simulable_entities:
		simulable.simulate(delta)

func _late_init():
	await get_tree().physics_frame
	for entity in _simulable_entities:
		entity.simulation_start.emit()

# Callbacks
func _on_entity_waiting():
	# The time is only fast forwarded if every real time entity is waiting
	var times = []
	for entity in _real_time_entities:
		if not entity.is_waiting:
			return
		times.append(entity.wait_time)
	_simulate(times.min())

func _save_events():
	if not _temp_log_data.is_empty():
		var line = JSON.stringify(_temp_log_data)
		line = line.replace("},","},\n")
		file_manager.store_line(line.strip_edges().substr(1, line.length()-2) + ", ")
		_temp_log_data.clear()

