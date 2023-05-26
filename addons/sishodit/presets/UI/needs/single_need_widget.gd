extends HBoxContainer

var need_name : String : set = neeed_name_set
var need_level: float : set = need_level_set

@onready var name_label = $NeedName
@onready var level_progress_bar = $NeedLevel


func neeed_name_set(nname : String):
	need_name = nname
	if name_label:
		name_label.text = need_name
	
func need_level_set(nlevel : float):
	need_level = nlevel
	if level_progress_bar:
		level_progress_bar.value = need_level
