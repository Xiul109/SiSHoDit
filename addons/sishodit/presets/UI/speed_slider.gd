extends VSlider


func _on_SpeedSlider_value_changed(val):
	Engine.time_scale = val
