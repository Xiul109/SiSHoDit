extends Spatial

onready var person = $People/person

var cameras = []
var camera_i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	cameras.append($Camera)
	cameras.append(person.get_node("CameraOrbit/ClippedCamera"))
	
	person.navigation = $Navigation

func _input(event):
	if event.is_action_pressed("ui_accept"):
		switch_camera()

func switch_camera():
	camera_i = (camera_i + 1) % len(cameras)
	cameras[camera_i].make_current()

