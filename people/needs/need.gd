class_name Need

extends Resource

export var need_key : String

export var min_duration: float
export var max_duration: float

export var time_to_fill_level : float
 
export(float, 1) var level : float = 0
export(float, 1) var min_level_before_solve : float


func increase_level(delta):
	level = clamp(level+delta/time_to_fill_level, 0, 1)

func generate_duration():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var mean_duration = (min_duration+max_duration)/2
	return clamp(rng.randfn(mean_duration, (max_duration-mean_duration)/4),
					  min_duration, max_duration)

func get_probability():
	if level <= min_level_before_solve:
		return 0.0
	return 1/(1+ pow(level/(1.0001-level), -2.5))
