extends Simulable

@export var year : int = 2022
@export var month : Time.Month = Time.MONTH_JANUARY
@export_range(1,31) var day : int = 1
@export_range(0, 23) var hour : int
@export_range(0, 59) var minute : int
@export_range(0, 60-0.001) var second : float

var _timestamp : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	simulated.connect(_on_simulated)
	_timestamp += Time.get_unix_time_from_datetime_dict({"year":year, "month":month, "day":day,
													"hour":hour, "minute":minute, "second":second})
	# Add an initial log with the original context data as a datetime


func _on_simulated(delta):
	_timestamp += delta
	var time_dict = Time.get_datetime_dict_from_unix_time(_timestamp)
	time_dict["second"] += fmod(_timestamp, 1.0)
	context.merge(time_dict, true)
