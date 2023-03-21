## Encapsulates the sequence of [class SolutionStep]s needed for solving a [class Need]
class_name SolutionInfo
extends Resource

## Sequence of [class SolutionStep]s that must be followed to finish the solution
@export var steps : Array[StepInfo]
## Solutions with higher weights are more probable to be chosen
@export var weight : float = 1.0


func _to_string():
	return "[Solution] %s"%resource_name
	

## Returns true if the Soution is feasible for the actual [code]tree[/code]
func is_solution_feasible(tree: SceneTree):
	for step in steps:
		if not tree.has_group(step.object_group) and step.object_group != "":
			return false
	
	return true
