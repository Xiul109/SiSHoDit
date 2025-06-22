class_name EvaluableCondition
extends Resource

## Evaluates if the condition is true for the given context. This method should be overriden.
func evaluate(_context: Dictionary) -> bool:
	return false
