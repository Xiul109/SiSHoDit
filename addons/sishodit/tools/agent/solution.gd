class_name Solution
extends Resource

@export var steps : Array[SolutionStep] = [] # (Array, Resource)
@export var weight : float = 1.0

var current_step = -1
var needs_solved : Array[String] : get = _get_needs_solved_by_steps, set = _set_needs_solved

func _to_string():
	return "[Solution] %s"%resource_name

func reset():
	current_step = -1

func get_next_step():
	current_step += 1
	if current_step < steps.size():
		return steps[current_step]
	else:
		current_step = -1
		return null

func is_solution_feasible(tree: SceneTree):
	for step in steps:
		if not tree.has_group(step.object_key) and step.object_key != "":
			return false
	
	return true

func _get_needs_solved_by_steps():
	var needs : Array[String] = []
	for step in steps:
		for need in step.needs_solved:
			if need not in needs:
				needs.append(need)
	return needs

func _set_needs_solved(_val):
	push_warning("This value cannot be modified")
