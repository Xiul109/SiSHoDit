class_name TSPPGaussianNoise
extends TSPostprocessing

## Adds random noise to the signal by following a gaussian distribution

## Standard deviation for a gaussian distribution used to produce noise
@export var std : float = 0

func postprocess(x : float) -> float:
	return x + randfn(0, std)
