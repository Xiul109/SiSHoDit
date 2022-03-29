extends Node

### Properties ###
# paths
const log_dir = "sim_log/"
const final_dir = "user://" + log_dir
var file_name

var file : File

### Overriden methods ###
func _ready():
	_check_directory()
	var time = OS.get_datetime()
	file_name = "log%s_%d-%d-%d-%d-%d-%d.json"%[OS.get_unique_id() ,
												time["year"], time["month"],
												time["day"], time["hour"],
												time["minute"], time["second"]]
	var path = final_dir + file_name
	
	file = File.new()
	if file.open(path, File.WRITE) == OK:
		# init file content
		file.store_line("[")
		# timer to save the date once every 10 seconds
		var timer = Timer.new()
		timer.wait_time = 10
		timer.connect("timeout", file, "flush")
		add_child(timer)
		timer.start()


func _exit_tree():
	if file.is_open():
		file.seek_end(-3)
		file.store_line("]")
		file.close()

### Private methods ###
func _check_directory():
	var dir = Directory.new()
	if dir.open("user://") == OK:
		if not dir.dir_exists(log_dir):
			dir.make_dir(log_dir)
			

### Public methods ###
func log_event(from, value):
	if not file.is_open():
		return
	var log_data = {"time": TimeSim.elapsed_seconds, "from": from, 
					"value": value}
	
	file.store_line(to_json(log_data) + ", ")
