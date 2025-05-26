class_name SingleTriggerUsable
extends SensorizedUsable

## Works for sensors that are only triggered once, for example the toilet flush.

enum TriggerMode {START, END}

## Value that will be produced when triggered.
@export var trigger_value : float = 1

## The trigger will be activated when starting using the object or when finishing.
@export var trigger_on : TriggerMode = TriggerMode.START


## Emitted when sensor is triggered
signal triggered

func start_using(_user: Agent):
	if trigger_on == TriggerMode.START:
		trigger()
	super.start_using(_user)


func finish_using(_user: Agent):
	if trigger_on == TriggerMode.END:
		trigger()
	super.finish_using(_user)


## When called, the sensors are triggered
func trigger():
	activate_sensors(trigger_value)
	emit_signal("triggered")
