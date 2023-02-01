class_name SolutionStep
extends Resource

@export var object_key: String

@export var use_object : bool = true

@export var min_duration: float
@export var max_duration: float

@export var needs_solved : Array[String]# (Array, String)
@export var needs_with_modified_rate: Dictionary

@export_range(0, 20, 1, "or_greater") var priority : int

func generate_duration():
	var mean_duration = (min_duration+max_duration)/2
	return clamp(randfn(mean_duration, (max_duration-mean_duration)/4),
					min_duration, max_duration)
