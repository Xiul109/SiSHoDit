class_name Solution
extends RefCounted

## General parameters for this solution
var info : SolutionInfo

## Index of the current [Step] being performed
var current_step : int = -1

## List of all the need keys that are solved by the [Step]s of the solution
var needs_solved : Array[String] : get = _get_needs_solved_by_steps


func _init(sol_info : SolutionInfo):
	info = sol_info

func _to_string():
	return info._to_string()

## Resets [member current_step] to -1
func reset():
	current_step = -1

## Returns the next step and increases in 1 [member current_step]
func get_next_step(min_priority : int, context: Dictionary):
	current_step += 1
	while  (current_step < info.steps.size() and 
			info.steps[current_step].condition_manager != null and
			not info.steps[current_step].condition_manager.evaluate(context)):
				current_step += 1
	if current_step >= info.steps.size():
		current_step = -1
		return null
	return Step.new(info.steps[current_step], min_priority)

## Getter for [member needs_solved]. If empty, it is also initialized.
func _get_needs_solved_by_steps():
	if needs_solved.is_empty():
		for step in info.steps:
			for need in step.needs_solved:
				if need not in needs_solved:
					needs_solved.append(need)
	return needs_solved
