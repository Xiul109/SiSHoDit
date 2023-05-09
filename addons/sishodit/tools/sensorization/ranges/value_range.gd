class_name ValueRange
extends Resource

## Used for defining the limits of outputs of a sensor. It should be considered as an abstract class
## , so only instances of inhereting classes should be used.

## Determines if a given value belongs to the specified range.
func is_value_in_range(_val) -> bool:
	return true

## Produces a random valid value within the range.
func get_random_valid_value():
	return 0
