class_name DurationUsable
extends SingleTriggerUsable

## Triggers once in the same way than [SingleTriggerUsable] and later another time after a specified
## [member duration] with [member end_duration_value].

## The time until the second trigger.
@export var duration : float

## The value produced by the second trigger.
@export var end_duration_value : float = 0

var _simulable: Simulable

## Emitted when the second trigger is produced.
signal duration_ended

func _ready():
	super()
	_simulable = Simulable.new()
	_simulable.timer_finished.connect(_on_timer_timeout)
	_simulable.priority = 1
	add_child(_simulable)

func trigger():
	super()
	_simulable.set_timer(duration)

func _on_timer_timeout(since: float):
	activate_sensors(end_duration_value, since)
	duration_ended.emit()
