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
var feasible_solutions = []

## Index of relevance of a Need. It is used for determining the probability of choosing a Need to be
## solved. It is computed as the [method @GlobalScope.smoothstep] of [member level] between
## [member min_level_before_solve] and 1.0
var relevance : float :
	get:
		relevance = smoothstep(info.min_level_before_solve, 1.0, level)
		return relevance

## Computed after calling [method can_be_solved] and used for obtaining a random [class Solution] in
## method [method get_a_solution].
var _feasible_solutions_total_weight : float


func _init(need_info : NeedInfo, tree: SceneTree):
	info = need_info
	level = info.initial_level
	_find_feasible_solutions(tree)
	

func _to_string():
	return info._to_string()


## Increase the level of the need based on the elapsed time
func increase_level(delta):
	level+=delta/info.time_to_fill_level


## Returns a feasible solution if there is any. If not, returns null. Parameter [code]i[/code] is
## the index at which the Solution is stored, but if its value is smaller than 0, a random
## [class Solution] based on weights will be chosen.
func get_a_feasible_solution(i : int = -1) -> Solution:
	if i >= 0:
		return feasible_solutions[i]
	
	var rand_n = randf_range(0, _feasible_solutions_total_weight)
	var ref_value = 0
	for sol in feasible_solutions:
		ref_value += sol.weight
		if rand_n <= ref_value:
			return Solution.new(sol)
	return null

## Computes the time needed for a need to reach a target level. A return value of 0 means that the
## target level has already been reached
func time_until_level(target_level: float, rate : float = 1.0):
	return max(0.0, (target_level - level) * info.time_to_fill_level * rate)


## Computes the list of feasible solutions.
func _find_feasible_solutions(tree: SceneTree):
	_feasible_solutions_total_weight = 0.0
	for sol in info.solutions:
		if sol.is_solution_feasible(tree):
			feasible_solutions.append(sol)
			_feasible_solutions_total_weight += sol.weight
