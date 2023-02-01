extends Node3D

var agents = []

var cameras = []
var camera_i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	agents = get_tree().get_nodes_in_group("agent")
	cameras.append($Camera3D)
	for agent in agents:
		cameras.append(agent.get_node("CameraOrbit/Camera3D"))
	$CanvasLayer/ui/needs_widget.agent = agents[0]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		switch_camera()
	
	if event.is_action_pressed("ui_cancel"):
		$Simulator.file_manager.save_file()
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
		

func switch_camera():
	camera_i = (camera_i + 1) % len(cameras)
	cameras[camera_i].make_current()
	$CanvasLayer/ui/needs_widget.agent = agents[(camera_i-1)%len(agents)]
