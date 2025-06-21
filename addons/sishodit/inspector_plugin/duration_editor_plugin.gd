extends EditorInspectorPlugin

var DurationEditor = preload("res://addons/sishodit/inspector_plugin/ui/duration_editor.gd")

func _can_handle(object):
	if object is StepInfo or object is NeedInfo:
		return true
	return false

func _parse_property(object, type, name, hint, hint_text, usage, wide):
	if type == TYPE_FLOAT and ("duration" in name or "time" in name):
		add_property_editor(name, DurationEditor.new())
		return true
	
	return false
