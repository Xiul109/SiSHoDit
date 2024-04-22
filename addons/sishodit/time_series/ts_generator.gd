class_name TSGenerator
extends RefCounted

## Used to generate time series following a [Template]

## How much time has been generated
var time : float = 0
## Template of how the time series must be generated
var template : TSTemplate

## Current segment index
var _current_segment = 0
## How much time has been generated from previous segments
var _cum_segment_durs = 0

## Generates a time series of [param sample_rate] for [param dur] seconds
func generate(dur: float, sample_rate: float) -> PackedFloat32Array:
	var values = PackedFloat32Array()
	var i = 0
	var n : int = dur*sample_rate
	var period = 1/sample_rate
	values.resize(n)
	
	while dur > 0:
		var segment = template.get_segment(_current_segment)
		var offset = (time - _cum_segment_durs)/segment.duration
		var segment_n : int = min(segment.duration, dur)*sample_rate + i
		# Segment generation
		while i < segment_n :
			values[i] = segment.shape.sample(offset) if segment.shape else 0
			values[i] += randfn(0, segment.noise_std)
			time += period
			offset += (time - _cum_segment_durs)/segment.duration
			i += 1
		# Checking if the segment has been completed
		if (time - _cum_segment_durs) >= segment.duration:
			_current_segment += 1
			_cum_segment_durs += segment.duration
		# Updating remainig time
		dur -= segment.duration
	
	return values
