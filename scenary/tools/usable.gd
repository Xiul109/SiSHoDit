class_name Usable
extends Node

export var start_event_value : float
export var end_event_value : float

var _sensor : Sensor

### overriden methods ###
func _ready():
	_sensor = Sensor.new()
	_sensor.sensor_name = get_parent().name
	add_child(_sensor)

	
### To be overriden if needed ###
func start_using(_user: BasicPerson):
	_sensor.activate(start_event_value)
	
func finish_using(_user: BasicPerson):
	_sensor.activate(end_event_value)

func being_used(_user: BasicPerson, _delta):
	_user._wait()
