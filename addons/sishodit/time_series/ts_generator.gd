extends RefCounted

class_name TSGenerator

var time : float = 0
var total_duration : float = 0
var template : TSTemplate

var _current_segment = 0
var _cum_durs = 0

func generate(dur: float, sample_rate: float) -> PackedFloat32Array:
	var values = PackedFloat32Array()
	var i = 0
	var n : int = dur*sample_rate
	values.resize(n)
	
	while dur > 0: # Check zero approx and last segment
		var segment = template.get_segment(_current_segment)
		var offset = (time - _cum_durs)/segment.duration
		var segment_duration = min(segment.duration, dur)
		while (time - _cum_durs) < segment_duration:
			values[i] = segment.shape.sample(offset) + randfn(segment.noise_mean, segment.noise_std)
			time += 1/sample_rate
			offset += (time - _cum_durs)/segment.duration
			i += 1
		if (time - _cum_durs) >= segment_duration:
			_current_segment += 1
			_cum_durs += segment.duration
		# segment.duration is a better choice than segment_duration here because it will be
		# different only for the last segment in which is preferable to be smaller to avoid near
		# zero problems with floats
		dur -= segment.duration
	
	# Clean up
	time = dur - sample_rate*n
	if is_zero_approx(time):
		time = 0
	return values
