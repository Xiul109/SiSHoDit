extends KinematicBody

export var speed = 50

onready var to = $"../to"
onready var camera = $"../Camera"
onready var navigation = $"../Navigation"

var space_state : PhysicsDirectSpaceState
var path = []
var path_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	space_state = get_world().direct_space_state
	
func _input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event == null:
		return
	
	if mouse_event.pressed and mouse_event.button_index == 1:
		var from = camera.project_ray_origin(mouse_event.position)
		var to = from + camera.project_ray_normal(mouse_event.position) * 1000
		var result = space_state.intersect_ray(from, to)
		
		if result .size() > 0 and result["collider"] != null:
			path = navigation.get_simple_path(global_transform.origin, result["position"])
			path_index = 0

func _physics_process(delta):
	if path_index < path.size():
		var direction = path[path_index] - global_transform.origin
		if direction.length() < .02:
			path_index += 1
		else:
			move_and_slide(direction.normalized() * speed*delta)
