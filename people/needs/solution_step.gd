class_name SolutionStep
extends Resource

export var object_key: String

export var use_object : bool = true

export var min_duration: float
export var max_duration: float

func generate_duration():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var mean_duration = (min_duration+max_duration)/2
	return clamp(rng.randfn(mean_duration, (max_duration-mean_duration)/4),
					  min_duration, max_duration)
