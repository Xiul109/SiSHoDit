extends Button

var scene : String

func _on_Button_pressed():
	if scene != null:
		print(scene)
# warning-ignore:return_value_discarded
		get_tree().change_scene(scene)
