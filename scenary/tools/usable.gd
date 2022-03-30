class_name Usable
extends AbstractUsable

export var start_event_value : float = 1
export var end_event_value : float = 0

var _sensor : Sensor

### overriden methods ###
func _ready():
	_sensor = Sensor.new()
	_sensor.sensor_name = get_parent().name
	add_child(_sensor)

	
### To be overriden if needed ###
func start_using(_user: BasicPerson):
	_sensor.activate(start_event_value)
	.start_using(_user)
	
func finish_using(_user: BasicPerson):
	_sensor.activate(end_event_value)
	.finish_using(_user)


