class_name DurationUsable
extends SingleTriggerUsable

## Triggers once in the same way than [SingleTriggerUsable] and later another time after a specified
## [member duration] with [member end_duration_value].

## The time until the second trigger.
@export var duration : float
## The value produced by the second trigger.
@export var end_duration_value : float = 0

var _timer : Timer

## Emitted when the second trigger is produced.
signal duration_ended

func _ready():
	super()
	_timer = Timer.new()
	_timer.connect("timeout",Callable(self,"_on_timer_timeout"))
	add_child(_timer)
	_timer.one_shot = true

func trigger():
	super()
	_timer.start(duration)

func _on_timer_timeout():
	activate_sensors(end_duration_value)
	emit_signal("duration_ended")
