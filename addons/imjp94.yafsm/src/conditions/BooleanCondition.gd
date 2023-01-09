@tool
extends "ValueCondition.gd"

@export var value: bool : get = get_value, set = set_value


func set_value(v):
	if value != v:
		value = v
		emit_signal("value_changed", v)
		emit_signal("display_string_changed", display_string())

func get_value():
	return value

func compare(v):
	if typeof(v) != TYPE_BOOL:
		return false
	return super.compare(v)
