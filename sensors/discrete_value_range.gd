class_name DiscreteValueRange
extends ValueRange

var values = []

func is_value_in_range(val) -> bool:
	return val in values

func get_random_valid_value():
	if values.empty():
		return null
	return values[randi()%values.size()]
