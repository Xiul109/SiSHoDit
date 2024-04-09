class_name TSTemplate
extends Resource

## Template for defining the behaviour of a time series compound by [TSTemplateSegment]s

## Sequence of segments of the template
@export var segments : Array[TSTemplateSegment]

@export_group("Advanced chosing")
## If true the segment is selected randomly
@export var random : bool = false
## Only relevant if random is false. If true, once the last segment is generated, the first will be
## the next to be generated
@export var loop : bool = false

# These two members are used for ensuring that a segment random value is consistent when keeping
# the same. This should be changed to ensure different sensors using the same template to work
# correctly
var _last_random_i : int = -1
var _last_random_segment_i : int = 0

## Returns the corresponding segment for the index [param i]
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
