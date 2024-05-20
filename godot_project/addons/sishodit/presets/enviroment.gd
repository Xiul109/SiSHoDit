extends Node3D

## Code for an environment which manages basic inputs and cameras. It is recomended to be attached
## to the top scene, but not necesary. This code will change a lot in the future.

var agents = []

var cameras = []
var camera_i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	agents = get_tree().get_nodes_in_group("agent")
	cameras.append($Camera3D)
	for agent in agents:
		cameras.append(agent.get_node("CameraOrbit/Camera3D"))
		$CanvasLayer/ui/MultiAgentDataWidget.add_agent(agent)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		switch_camera()
	
	if event.is_action_pressed("ui_cancel"):
		$Simulator.file_manager.save_file()
		get_tree().quit()
		

func switch_camera():
	camera_i = (camera_i + 1) % len(cameras)
	cameras[camera_i].make_current()
