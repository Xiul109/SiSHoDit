class_name ContextCondition
extends Resource

## Tool for defining boolean conditions that are assesed against a [member Simulator.context].

## Represents the type of comparisons available
enum ComparisonMode {
	EQUAL,
	NOT_EQUAL,
	LESSER,
	LESSER_EQUAL,
	GREATER,
	GREATER_EQUAL,
}

## The key identifier for the context variable to be compared
@export var key : String

## The kind of comparison to be made
@export var comparison : ComparisonMode

## Value compared to the context variable. Only float allowed due to Godot restrictions. That may
## change in the future
@export var comparison_value: float

## Compares the context variable asociated with [member key] with [member comparison_value]
func compare(context: Dictionary) -> bool:
	if key not in context:
		push_warning("Key '", key,"' is not in context.")
		return false
	match comparison:
		ComparisonMode.EQUAL:
			return context[key] == comparison_value
		ComparisonMode.NOT_EQUAL:
			return context[key] != comparison_value
		ComparisonMode.LESSER:
			return context[key] < comparison_value
		ComparisonMode.LESSER_EQUAL:
			return context[key] <= comparison_value
		ComparisonMode.GREATER:
			return context[key] > comparison_value
		ComparisonMode.GREATER_EQUAL:
			return context[key] >= comparison_value
	return false
