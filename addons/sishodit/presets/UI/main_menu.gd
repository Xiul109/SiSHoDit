extends Control

const enviroment_launcher = preload("res://addons/sishodit/presets/UI/enviroment_launcher.tscn")


@export var enviroments_path = "res://examples/"
var enviroments = {}

func _ready():
	enviroments = _load_scenes_from(enviroments_path)
	_init_enviroments_menu()

func _init_enviroments_menu():
	for key in enviroments:
		var el = enviroment_launcher.instantiate()
		el.text = key
		el.scene = enviroments[key]
		$ScrollContainer/VBoxContainer.add_child(el)

func _load_scenes_from(path):
	var scenes = {}
	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".tscn"):
			scenes[file.left(file.length()-5)] = path+file
	
	dir.list_dir_end()
	return scenes
