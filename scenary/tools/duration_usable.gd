class_name DurationUsable
extends SingleTriggerUsable

export var duration : float
export var end_duration_value : float = 0

var _timer : Timer

signal duration_ended

func _ready():
	_timer = Timer.new()
	# warning-ignore:return_value_discarded
	_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(_timer)
	_timer.one_shot = true

func trigger():
	.trigger()
	_timer.start(duration)

func _on_timer_timeout():
	_sensor.activate(end_duration_value)
	emit_signal("duration_ended")
