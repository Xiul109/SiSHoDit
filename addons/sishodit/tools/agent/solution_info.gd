@icon("res://addons/sishodit/assets/icons/solution.png")
class_name SolutionInfo
extends Resource

## Encapsulates the sequence of [StepInfo]s needed for solving a [Need]


## Sequence of [StepInfo]s that must be followed to finish the solution
@export var steps : Array[StepSetting]

## Solutions with higher weights are more probable to be chosen
@export var weight : float = 1.0

## Manager of conditions stablished for selecting a solution for a need.
@export var condition_manager : ConditionManager

func _to_string():
	return "[Solution] %s"%resource_name
	

## Returns true if the Soution is feasible for the actual [code]tree[/code]
func is_solution_feasible(tree: SceneTree):
	for step in get_step_infos():
		if not tree.has_group(step.object_group) and step.object_group != "":
			push_warning("The object group %s specified in %s does not exit, so %s is excluded." % [
				step.object_group, step, self
			])
			return false
	
	return true

# Returns the total list of [class StepInfo]s in the Solution
func get_step_infos() -> Array[StepInfo]:
	var step_groups = steps.map(
		func(setting: StepSetting): 
			return setting.get_step_infos())
	var step_infos : Array[StepInfo] = []
	
	for group in step_groups:
		step_infos.append_array(group)
	
	return step_infos
