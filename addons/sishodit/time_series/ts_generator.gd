class_name TSGenerator
extends RefCounted

## Used to generate time series following a [Template]

## How much time has been generated
var time := 0.0
## Sample rate of the generated data
var _sample_rate := 1.0
## Template of how the time series must be generated
var _template : TSTemplate

## Current segment index
var _current_segment := 0
## How much time has been generated from previous segments
var _cum_segment_durs := 0.0

## The number of values generated per second is [param sample_rate] and the description of how to
## generate them is [param template].
func _init(sample_rate: float, template: TSTemplate):
	_sample_rate = sample_rate
	# Templates are duplicated for random selection management
	_template = template.duplicate(true)
	# And it is done to subresources to modify the duration to avoid infinite
	# loops during the generation and other kind of errors
	for segment in _template.segments:
		segment.duration = max(segment.duration, 1.0001/_sample_rate)

## Generates a time series of [member sample_rate] for [param dur] seconds
func generate(dur: float) -> PackedFloat32Array:
	var values := PackedFloat32Array()
	var i := 0
	var n : int = dur*_sample_rate
	var period := 1/_sample_rate
	values.resize(n)
	
	while dur > 0:
		var segment := _template.get_segment(_current_segment)
		if segment == null:
			return values
		
		var segment_time := (time - _cum_segment_durs)
		var offset := segment_time/segment.duration
		var not_last_segment := (_current_segment < _template.segments.size() - 1
								or _template.loop or _template.random)
		var segment_generation_dur := (min(segment.duration - segment_time, dur) if not_last_segment 
									   else dur)
		
		var segment_n : int = segment_generation_dur*_sample_rate + i
		# Segment generation
		while i < segment_n :
			var val := segment.shape.sample(offset) if segment.shape else 0.0
			for postpro in _template.postprocessings:
				val = postpro.postprocess(val)
			values[i] = val
			time += period
			offset = (time - _cum_segment_durs)/segment.duration
			i += 1
		# Checking if the segment has been completed
		if not_last_segment and (time - _cum_segment_durs) >= segment_generation_dur:
			_current_segment += 1
			_cum_segment_durs += segment.duration
		# Updating remainig time
		dur -= segment_generation_dur
	
	return values
