class_name TSPostprocessing
extends Resource

## Dummy class to represent a postprocess step. For new postprocess types the [member postprocess]
## method should be overriden.

## It defines the postprocess step for each single point of the time series.
func postprocess(x: float) -> float:
	return x
