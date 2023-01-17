extends Button

var scene : String

func _on_Button_pressed():
	if scene != null:
# warning-ignore:return_value_discarded
		get_tree().change_scene_to_file(scene)
