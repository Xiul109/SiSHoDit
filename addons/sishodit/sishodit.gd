@tool
extends EditorPlugin

var step_info_plugin = preload("res://addons/sishodit/inspector_plugin/step_info_plugin.gd").new()
var context_condition_plugin = preload("res://addons/sishodit/inspector_plugin/context_condition_plugin.gd").new()
var duration_editor_plugin = preload("res://addons/sishodit/inspector_plugin/duration_editor_plugin.gd").new()

func _enter_tree():
	add_inspector_plugin(step_info_plugin)
	add_inspector_plugin(context_condition_plugin)
	add_inspector_plugin(duration_editor_plugin)

func _exit_tree():
	remove_inspector_plugin(step_info_plugin)
	remove_inspector_plugin(context_condition_plugin)
	remove_inspector_plugin(duration_editor_plugin)
