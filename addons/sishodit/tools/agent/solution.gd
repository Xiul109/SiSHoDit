class_name Solution
extends Resource

@export var steps : Array[SolutionStep] = [] # (Array, Resource)
@export var weight : float = 1.0

var current_step = -1


func get_next_step():
	current_step += 1
	if current_step < steps.size():
		return steps[current_step]
	else:
		current_step = -1
		return null

func is_solution_viable(tree: SceneTree):
	for step in steps:
		if not tree.has_group(step.object_key) and step.object_key != "":
			return false
	
	return true