extends VSlider


func _on_SpeedSlider_value_changed(value):
	Engine.time_scale = value
