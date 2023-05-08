class_name DiscreteValueRange
extends ValueRange

## Defines a range composed by a limited number of values.

## Only the values contained in this array are valid for this range.
@export var values = []

func is_value_in_range(val) -> bool:
	return val in values

func get_random_valid_value():
	if values.is_empty():
		return null
	return values[randi()%values.size()]
