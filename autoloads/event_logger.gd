extends Node

### Properties ###
# paths
const log_dir = "sim_log/"
const base_name = "SADL"

var file_manager

### Overriden methods ###
func _ready():
	file_manager = FileManager.new()
	add_child(file_manager)
	file_manager.init_file(base_name, log_dir)
			

### Public methods ###
func log_event(from, value):
	var log_data = {"time": TimeSim.elapsed_seconds, "from": from, 
					"value": value}
	
	file_manager.store_line(to_json(log_data) + ", ")
