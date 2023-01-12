class_name Usable
extends AbstractUsable

@export var start_event_value : float = 1
@export var end_event_value : float = 0

@onready var _sensor : Sensor = $Sensor

### overriden methods ###
func _ready():
	_sensor.sensor_name = get_parent().name
	
### To be overriden if needed ###
func start_using(_user: Agent):
	_sensor.activate(start_event_value)
	super.start_using(_user)
	
func finish_using(_user: Agent):
	_sensor.activate(end_event_value)
	super.finish_using(_user)


