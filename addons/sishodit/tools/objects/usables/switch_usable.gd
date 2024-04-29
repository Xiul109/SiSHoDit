class_name SwitchUsable
extends SensorizedUsable

## Usable object that keeps and internal record of its state which can be switched or not. Whenever
## its state changes, it produces a value based on it. It changes once per use. One example of this
## can be the TV.

## State of the device
@export var is_switched : bool
## Value produced when the device is switched on
@export var switch_on_value : float = 1
## Value produced when the device is switched off
@export var switch_off_value : float = 0
## The trigger will be activated when starting using the object or when finishing.
@export var trigger_on: SingleTriggerUsable.TriggerMode = SingleTriggerUsable.TriggerMode.START


func start_using(_user: Agent):
	if trigger_on == SingleTriggerUsable.TriggerMode.START:
		switch()
	super.start_using(_user)


func finish_using(_user: Agent):
	if trigger_on == SingleTriggerUsable.TriggerMode.END:
		switch()
	super.finish_using(_user)


## Called to switch the device
func switch():
	is_switched = not is_switched
	if is_switched:
		activate_sensors(switch_on_value)
	else:
		activate_sensors(switch_off_value)
