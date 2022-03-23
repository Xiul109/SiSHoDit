extends Spatial

export var look_sensitivity : float = 15.0
export var min_look_angle : float = -20
export var max_look_angle : float = 75

var mouse_delta : Vector2 = Vector2()

onready var player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$ClippedCamera.add_exception(get_parent())


func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

	
func _process(delta):
	var rot = Vector3(mouse_delta.y, mouse_delta.x, 0) * look_sensitivity * delta

	rotation_degrees.x += rot.x 
	rotation_degrees.x = clamp(rotation_degrees.x, min_look_angle, max_look_angle)
	rotation_degrees.y -= rot.y

	mouse_delta = Vector2()
