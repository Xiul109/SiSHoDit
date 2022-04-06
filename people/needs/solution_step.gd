class_name SolutionStep
extends Resource

export var object_key: String

export var use_object : bool = true

export var min_duration: float
export var max_duration: float

export(Array, String) var needs_solved

export(float, 1) var probability_of_being_interrupted = 0.0
export(float, 1) var min_value_to_be_interrupted = 1.0

func generate_duration():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var mean_duration = (min_duration+max_duration)/2
	return clamp(rng.randfn(mean_duration, (max_duration-mean_duration)/4),
					  min_duration, max_duration)
