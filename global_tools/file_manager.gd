class_name FileManager
extends Node

### Properties ###
# paths
var dir : String = ""
var full_dir : String 
var file_name

var file : File
var timer

### Overriden methods ###
func init_file(filename_base, directory = ""):
	dir = directory
	full_dir = "user://" + dir
	_check_directory()
	
	var time = OS.get_datetime()
	file_name = "%s%s_%d-%d-%d-%d-%d-%d.json"%[filename_base,
												OS.get_unique_id() ,
												time["year"], time["month"],
												time["day"], time["hour"],
												time["minute"], time["second"]]
	var path = full_dir + file_name
	
	file = File.new()
	if file.open(path, File.WRITE) == OK:
		# init file content
		file.store_line("[")
		# timer to save the date once every 10 seconds
		timer = Timer.new()
		timer.wait_time = 10
		timer.connect("timeout", file, "flush")
		add_child(timer)
		timer.start()

func save_file():
	if file != null and file.is_open():
		timer.queue_free()
		file.seek_end(-3)
		file.store_line("]")
		file.close()

func _exit_tree():
		save_file()

### Private methods ###
func _check_directory():
	var d = Directory.new()
	if d.open("user://") == OK:
		if dir != "" and not d.dir_exists(dir):
			d.make_dir(dir)
			

### Public methods ###
func store_line(text):
	if not file.is_open():
		return

	file.store_line(text)
