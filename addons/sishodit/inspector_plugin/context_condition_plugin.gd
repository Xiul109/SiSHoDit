extends EditorInspectorPlugin

var ContextKeyEditor = preload("res://addons/sishodit/inspector_plugin/ui/context_key_editor.gd")

func _can_handle(object):
	if object is ContextCondition:
		return true
	return false

func _parse_property(object, type, name, hint, hint_text, usage, wide):
	if name == "key" and type == TYPE_STRING:
		add_property_editor(name, ContextKeyEditor.new())
		return true
	
	return false
