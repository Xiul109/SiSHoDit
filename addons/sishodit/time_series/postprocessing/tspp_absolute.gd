class_name TSPPAbsolute
extends TSPostprocessing

## Converts the signal values to positive

func postprocess(x: float) -> float:
	return abs(x)
