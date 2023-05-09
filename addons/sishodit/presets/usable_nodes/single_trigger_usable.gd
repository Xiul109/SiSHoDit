class_name SingleTriggerUsable
extends AbstractUsable

## Works for sensors that are only triggered once, for example the toilet flush.

enum TriggerMode {START, END}

## Value that will be produced when triggered.
@export var trigger_value : float = 1
## The trigger will be activated when starting using the object or when finishing.
@export var trigger_on : TriggerMode = TriggerMode.START


@onready var _sensor : Sensor = $Sensor

## Emitted when sensor is triggered
signal triggered


func _ready():
	_sensor.sensor_name = get_parent().name


func start_using(_user: Agent):
	if trigger_on == TriggerMode.START:
		trigger()
	super.start_using(_user)


func finish_using(_user: Agent):
	if trigger_on == TriggerMode.END:
		trigger()
	super.finish_using(_user)


## When called, the sensor is triggered
func trigger():
	_sensor.activate(trigger_value)
	emit_signal("triggered")
