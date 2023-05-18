extends StaticBody3D


@export var autocloses = false

@onready var door = $"doorway(Clone)/door"
@onready var sensor = $Sensor

var state = "close"

func _ready():
	get_node("Sensor").sensor_name = name

func open():
	if state != "open":
		state = "open"
		door.rotate_y(90)
		sensor.activate(1.0)

func close():
	if state != "close":
		state = "close"
		door.rotate_y(-90)
		sensor.activate(0.0)
