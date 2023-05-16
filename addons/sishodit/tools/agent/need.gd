class_name Need
extends RefCounted

## General parameters for this need
var info : NeedInfo

## Filling percentage of a need. Higher values mean that the need is more probable to be solved
## next.
var level : float = 0 :
	set(new_level):
		level = clamp(new_level, 0, 1)

## List of aplicable solutions for the current environment.
var feasible_solutions : Array[SolutionInfo] = []

## Index of relevance of a Need. It is used for determining the probability of choosing a Need to be
## solved. It is computed as the [method @GlobalScope.smoothstep] of [member level] between
## [member min_level_before_solve] and 1.0
var relevance : float :
	get:
		relevance = smoothstep(info.min_level_before_solve, 1.0, level)
		return relevance


func _init(need_info : NeedInfo, tree: SceneTree):
	info = need_info
	level = info.initial_level
	_find_feasible_solutions(tree)
	

func _to_string():
	return info._to_string()


## Increase the level of the need based on the elapsed time
func increase_level(delta):
	level+=delta/info.time_to_fill_level


## Computes the time needed for a need to reach a target level. A return value of 0 means that the
## target level has already been reached
func time_until_level(target_level: float, rate : float = 1.0):
	var diff = max(0.0, target_level - level)
	if diff == 0.0:
		return diff
	if rate <= 0.0:
		return INF
	return diff * info.time_to_fill_level / rate


## Evaluates the conditions for each feasible solution for the context and only returns those that
## are evaluated as true.
func get_feasible_solutions_in_context(context: Dictionary) -> Array[SolutionInfo]:
	return feasible_solutions.filter(
		func(sol):
			if sol.condition_manager == null:
				return true
			return sol.condition_manager.evaluate(context)
	)

## True if at least one solution is avilable for the specified context, and false otherwise
func has_solutions_in_context(context: Dictionary) -> bool:
	return not get_feasible_solutions_in_context(context).is_empty()


## Returns a feasible [Solution] if there is any. If not, returns null. Parameter [code]i[/code] is
## the index at which the [Solution] is stored, but if its value is smaller than 0, a random
## [Solution] based on weights will be chosen.
func get_random_feasible_solution_in_context(context: Dictionary) -> Solution:
	var sols = get_feasible_solutions_in_context(context)
	
	var total_weigth = sols.reduce(func(cum_weight, sol): return cum_weight + sol.weight, 0.0)
	var rand_n = randf_range(0, total_weigth)
	var ref_value = 0
	for sol in sols:
		ref_value += sol.weight
		if rand_n <= ref_value:
			return Solution.new(sol)
	return null

## Computes the list of feasible solutions.
func _find_feasible_solutions(tree: SceneTree):
	for sol in info.solutions:
		if sol.is_solution_feasible(tree):
			feasible_solutions.append(sol)
