extends EditorInspectorPlugin

var NeedDictEditor = preload("res://addons/sishodit/inspector_plugin/need_dict_editor.gd")

func _can_handle(object):
	if object is StepInfo:
		return true
	return false


func _parse_property(object, type, path, hint, hint_text, usage, wide):
	if type == TYPE_DICTIONARY:
		add_property_editor(path, NeedDictEditor.new(object[path]))
		return true
	
	return false
