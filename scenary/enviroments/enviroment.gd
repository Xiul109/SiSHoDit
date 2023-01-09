extends Node3D

@onready var person = $People/person

var cameras = []
var camera_i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	TimeSim.reset()
	EventLogger.init_file()
	
	cameras.append($Camera3D)
	cameras.append(person.get_node("CameraOrbit/Camera3D"))
	$CanvasLayer/ui/needs_widget.person = person

func _input(event):
	if event.is_action_pressed("ui_accept"):
		switch_camera()
	
	if event.is_action_pressed("ui_cancel"):
# warning-ignore:return_value_discarded
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
		EventLogger.file_manager.save_file()

func switch_camera():
	camera_i = (camera_i + 1) % len(cameras)
	cameras[camera_i].make_current()

