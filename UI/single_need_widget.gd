extends HBoxContainer

var need_name : String setget neeed_name_set
var need_level: float setget need_level_set

onready var name_label = $NeedName
onready var level_progress_bar = $NeedLevel


func neeed_name_set(nname : String):
	print("name ", nname)
	need_name = nname
	if name_label:
		name_label.text = need_name
	
func need_level_set(nlevel : float):
	need_level = nlevel
	if level_progress_bar:
		level_progress_bar.value = need_level
