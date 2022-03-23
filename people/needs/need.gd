class_name Need

extends Resource

export var need_key : String

export var min_duration: float
export var max_duration: float

export var time_to_fill_level : float

var mean_duration = (min_duration+max_duration)/2
 
export(float, 1) var level : float = 0

func increase_level(delta):
	level += delta/time_to_fill_level

func generate_duration():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return clamp(rng.randfn(mean_duration, (max_duration-mean_duration)/4),
					  min_duration, max_duration)

func get_probability():
	return 1/(1+ pow(level/(1.000001-level), -2.5))
