class_name TSPPScaler
extends TSPostprocessing

## Scales the output by the stablished [member scaling_factor].

## Scaling factor
var scaling_factor : float

func postprocess(x: float) -> float:
	return x*scaling_factor
