class_name SolutionStep
extends Resource

@export var object_key: String

@export var use_object : bool = true

@export var min_duration: float
@export var max_duration: float

@export var needs_solved : Array[String]# (Array, String)
@export var needs_with_modified_rate: Dictionary

@export var probability_of_not_being_interrupted = 1.0 # (float, 1)
@export var min_value_to_be_interrupted = 1.0 # (float, 1)

func generate_duration():
	var rng = RandomNumberGenerator.new()
	rng.seed = GlobalVar.rnd_seed
	var mean_duration = (min_duration+max_duration)/2
	return clamp(rng.randfn(mean_duration, (max_duration-mean_duration)/4),
					min_duration, max_duration)
