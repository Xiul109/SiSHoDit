class_name SingleTriggerUsable
extends AbstractUsable

export var trigger_value : float

export(String, "start", "end") var trigger_on = "start"

var _sensor : Sensor

### overriden methods ###
func _ready():
	_sensor = Sensor.new()
	_sensor.sensor_name = get_parent().name
	add_child(_sensor)

	
### To be overriden if needed ###
func start_using(_user: BasicPerson):
	if trigger_on == "start":
		_sensor.activate(trigger_value)
	.start_using(_user)
	
func finish_using(_user: BasicPerson):
	if trigger_on == "end":
		_sensor.activate(trigger_value)
	.finish_using(_user)

func being_used(_user: BasicPerson, _delta):
	_user._wait()
