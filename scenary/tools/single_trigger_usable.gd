class_name SingleTriggerUsable
extends AbstractUsable

export var trigger_value : float = 1

export(String, "start", "end") var trigger_on = "start"

onready var _sensor : Sensor = $Sensor

signal triggered

### overriden methods ###
func _ready():
	_sensor.sensor_name = get_parent().name


### To be overriden if needed ###
func start_using(_user: BasicPerson):
	if trigger_on == "start":
		trigger()
	.start_using(_user)
	
func finish_using(_user: BasicPerson):
	if trigger_on == "end":
		trigger()
	.finish_using(_user)

### Aux methods ###
func trigger():
	_sensor.activate(trigger_value)
	emit_signal("triggered")
