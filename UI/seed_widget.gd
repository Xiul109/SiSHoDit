extends VBoxContainer

func _ready():
	seed(0)


func _on_SpinBox_value_changed(value):
	seed(value)
	GlobalVar.rnd_seed = value
