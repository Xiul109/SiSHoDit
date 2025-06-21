@icon("res://addons/sishodit/assets/icons/step_group.png")
class_name StepGroup
extends StepSetting

## Groups steps or other step groups in order

@export var steps : Array[StepSetting]

func get_step_infos() -> Array[StepInfo]:
	var step_groups = steps.map(func(setting: StepInfo): return setting.get_step_infos())
	var step_infos : Array[StepInfo] = []
	
	for group in step_groups:
		step_infos.append_array(group)
	
	return step_infos
