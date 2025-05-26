extends EditorInspectorPlugin

var NeedDictEditor = preload("res://addons/sishodit/inspector_plugin/need_dict_editor.gd")
var GroupStringEditor = preload("res://addons/sishodit/inspector_plugin/group_string_editor.gd")

func _can_handle(object):
	if object is StepInfo or object is NeedInfo:
		return true
	return false


func _parse_property(object, type, name, hint, hint_text, usage, wide):
	if object is StepInfo:
		if type == TYPE_DICTIONARY:
			add_property_editor(name, NeedDictEditor.new(object[name]))
			return true
		if name == "object_group":
			add_property_editor(name, GroupStringEditor.new())
			return true
	
	
	return false
