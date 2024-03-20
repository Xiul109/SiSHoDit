extends Resource # Tal vez ref counted mejor?

class_name TSTemplate

enum OrderType {SEQUENTIAL, RANDOM, EXPANDED}

@export var segments : Array[TSTemplateSegment]

@export_group("Advanced chosing")
@export var random : bool = false
@export var loop : bool = false

var _last_random_i : int = -1
var _last_random_segment_i : int = 0

func get_segment(i: int) -> TSTemplateSegment:
	if segments.size() == 0:
		push_error("Segments array is empty.")
		return null
	
	if random:
		if _last_random_i != i:
			_last_random_i = i
			_last_random_segment_i = randi_range(0, segments.size()-1)
		i = _last_random_segment_i
	else:
		i = max(0, i)
		if loop:
			i = i%segments.size()
		else:
			i = min(i, segments.size()-1)
	
	return segments[i]
