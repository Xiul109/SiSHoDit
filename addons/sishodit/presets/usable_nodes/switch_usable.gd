class_name SwitchUsable
extends Usable

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

@onready var _sensor : Sensor = $Sensor


func _ready():
	_sensor.sensor_name = get_parent().name


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
		_sensor.activate(switch_on_value)
	else:
		_sensor.activate(switch_off_value)
