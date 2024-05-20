class_name ContinuousValueRange
extends ValueRange

## Defines a range of float values between two limits

## Upper limit of the range
@export var upper_limit : float
## Lower limit of the range
@export var lower_limit : float


func is_value_in_range(val) -> bool:
	return val < upper_limit and val > lower_limit


func get_random_valid_value():
	return randf_range(lower_limit, upper_limit)
