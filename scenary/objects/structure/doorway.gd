extends StaticBody

onready var door = $"doorway(Clone)/door"

var state = "close"

func _ready():
	get_node("Sensor").sensor_name = name

func open():
	if state != "open":
		state = "open"
		door.rotate_y(90)
		get_node("Sensor").activate(1)

func close():
	if state != "close":
		state = "close"
		door.rotate_y(-90)
		get_node("Sensor").activate(0)
