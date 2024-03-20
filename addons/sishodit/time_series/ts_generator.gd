extends RefCounted

class_name TSGenerator

var time : float = 0
var template : TSTemplate

var _current_segment = 0
var _cum_segment_durs = 0

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
		while i < segment_n :
			values[i] = segment.shape.sample(offset) if segment.shape else 0
			values[i] += randfn(segment.noise_mean, segment.noise_std)
			time += period
			offset += (time - _cum_segment_durs)/segment.duration
			i += 1
		if (time - _cum_segment_durs) >= segment.duration:
			_current_segment += 1
			_cum_segment_durs += segment.duration
		dur -= segment.duration
	
	return values
