## Encapsulates the sequence of [class SolutionStep]s needed for solving a [class Need]
class_name Solution
extends Resource

## Sequence of [class SolutionStep]s that must be followed to finish the solution
@export var steps : Array[SolutionStep]
## Solutions with higher weights are more probable to be chosen
@export var weight : float = 1.0

## Index of the current [class SolutionStep] being performed
var current_step : int = -1
## List of all the need keys that are solved by the [class SolutionStep]s of the solution
var needs_solved : Array[String] : get = _get_needs_solved_by_steps

func _to_string():
	return "[Solution] %s"%resource_name

## Resets [member current_step] to -1
func reset():
	current_step = -1

## Returns the next step and increases in 1 [member current_step]
func get_next_step():
	current_step += 1
	if current_step >= steps.size():
		current_step = -1
		return null
	return steps[current_step]

## Returns true if the Soution is feasible for the actual [code]tree[/code]
func is_solution_feasible(tree: SceneTree):
	for step in steps:
		if not tree.has_group(step.object_group) and step.object_group != "":
			return false
	
	return true

## Getter for [member needs_solved]. If empty, it is also initialized.
func _get_needs_solved_by_steps():
	if needs_solved.is_empty():
		for step in steps:
			for need in step.needs_solved:
				if need not in needs_solved:
					needs_solved.append(need)
	return needs_solved
