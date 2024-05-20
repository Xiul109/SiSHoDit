class_name FileManager
extends Node

## Tool for managing JSON files where logs will be stored.

## Directory where the file will be saved.
var dir : String = ""
## Complete path for the directory where the file will be stored.
var full_dir : String 
## Name of the file where contents will be saved.
var file_name : String
## Reference for managing the file
var file : FileAccess
## Timer used for autosaving
var timer


func _exit_tree():
	save_file()

## Initializes the file where data will be stored
func init_file(filename_base, directory = ""):
	dir = directory
	full_dir = "user://" + dir
	_check_directory()
	
	var time = Time.get_datetime_dict_from_system()
	file_name = "%s%s_%d-%d-%d-%d-%d-%d.json"%[filename_base,
												OS.get_unique_id() ,
												time["year"], time["month"],
												time["day"], time["hour"],
												time["minute"], time["second"]]
	var path = full_dir + file_name
	
	file = FileAccess.open(path, FileAccess.WRITE)
	if file != null:
		# init file content
		file.store_line("[")
		# timer to save the date once every 10 seconds
		timer = Timer.new()
		timer.wait_time = 10
		timer.timeout.connect(file.flush)# connect("timeout",Callable(file,"flush"))
		add_child(timer)
		timer.start()

## Saves into storage the contents of the file and closes it.
func save_file():
	if file == null or not file.is_open():
		return
	timer.queue_free()
	file.seek_end(-3)
	file.store_line("]")
	file.close()
	file = null

## Adds a line to the file
func store_line(text):
	if file == null or not file.is_open():
		return
	file.store_line(text)


### Private methods ###
## Checks if the directory exists, and, if it doesn't, this methods creates it.
func _check_directory():
	var d = DirAccess.open("user://")
	if d != null:
		if dir != "" and not d.dir_exists(dir):
			d.make_dir(dir)
