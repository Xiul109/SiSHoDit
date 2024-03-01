## This class contains a group of functions for working with time series (TSs) used mostly for
## sensor data generation.
extends Object

class_name TSFunctions

## Compute 
static func compute_ts():
	pass

## Returns an array with [param n] elements withing the range [[param start], [param stop]), 
## excluding the former one
static func linspace(n: int, start: float = 0, stop: float=1) -> PackedFloat32Array:
	var new_ts = PackedFloat32Array()
	new_ts.resize(n)
	new_ts.fill(0)
	var step = (stop - start)/n
	for i in n:
		new_ts[i] = start + i * step
	return new_ts

## Produces a TS of the form f(t) = c[0]*t^0 + c[1]*t^1 + ... + c[n]*t^n, where c is 
## [param coefficients]
static func poly_ts(t: PackedFloat32Array, coefficients : Array[float]) -> PackedFloat32Array:
	var new_ts = PackedFloat32Array()
	new_ts.resize(t.size())
	new_ts.fill(0)
	for i in t.size():
		for d in coefficients.size():
			new_ts[i]+= pow(t[i], d)*coefficients[d]
	return new_ts

## Produces a zero-mean random TS of length [param n] following a normal distribution with
## [param sigma] as standard deviation
static func white_noise(n: int, sigma: float = 1.0) -> PackedFloat32Array:
	var noise = PackedFloat32Array()
	noise.resize(n)
	noise.fill(0)
	for i in n:
		noise[i] = randfn(0, sigma)
	return noise

## Adds every TS contained in [param time_series] and returns the addition whenever they have the
## same size, otherwise it returns and empty [PackedFloat32Array].
static func add_time_series(time_series: Array[PackedFloat32Array]) -> PackedFloat32Array:
	var new_ts = PackedFloat32Array()
	# Check no signals error
	if time_series.size() == 0:
		push_warning("Signals array is empty.")
		return new_ts
	# Check different size error
	var size = time_series[0].size()
	for ts in time_series:
		if ts.size() != size:
			push_warning("Not every signal has the same length.")
			return new_ts
	new_ts.resize(size)
	new_ts.fill(0)
	# Perform computation
	for ts in time_series:
		for i in new_ts:
			new_ts[i] += ts[i]
	return new_ts
