class_name BasicUsable
extends Usable

## Basic Usable object that produces a value when the [Agent] starts using it and another one when
## it finish.

## Value produced when the [Agent] starts using the object.
@export var start_event_value : float = 1
## Value produced when the [Agent] finish using the object.
@export var end_event_value : float = 0

@onready var _sensor : Sensor = $Sensor


func _ready():
	_sensor.sensor_name = get_parent().name
	

func start_using(_user: Agent):
	activate(start_event_value)
	super.start_using(_user)


func finish_using(_user: Agent):
	activate(end_event_value)
	super.finish_using(_user)

func activate(value):
	_sensor.activate(value)
