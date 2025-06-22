@tool
class_name ContextCondition
extends EvaluableCondition

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

const COMPARISON_SYMBOLS : Dictionary[ComparisonMode, String] = {
	ComparisonMode.EQUAL: "==",
	ComparisonMode.NOT_EQUAL: "=/=",
	ComparisonMode.LESSER: "<",
	ComparisonMode.LESSER_EQUAL: "≤",
	ComparisonMode.GREATER: ">",
	ComparisonMode.GREATER_EQUAL: "≥",
}

## The key identifier for the context variable to be compared. It is retrieved from ContextProviders
## of any other opened scene in the editor.
@export var key : String :
	set(new_key):
		key = new_key
		_update_resource_name()

## The kind of comparison to be made
@export var comparison : ComparisonMode :
	set(new_comp_mode):
		comparison = new_comp_mode
		_update_resource_name()

## Value compared to the context variable. Only float allowed due to Godot restrictions. That may
## change in the future
@export var comparison_value: float :
	set(new_comp_value):
		comparison_value = new_comp_value
		_update_resource_name()

## Compares the context variable asociated with [member key] to [member comparison_value]
func evaluate(context: Dictionary) -> bool:
	print(resource_name)
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

func _update_resource_name():
	resource_name = "%s %s %.2f" % [key, COMPARISON_SYMBOLS[comparison], comparison_value]
