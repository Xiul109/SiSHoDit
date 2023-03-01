## The representation of a need of the agent.
class_name Need
extends Resource

## Unique identifier for the need. Using the same name for two different needs should be
## avoided. Every reference to needs in other elements of the model will always refer to this key.
@export var need_key : String :
	set(key):
		need_key = key
		resource_name = key
		
## List of posible [class Solution]s to solve this need.
@export var solutions : Array[Solution]

## Time needed until the need reachs its maximum level, when the probability of choosing this
## need is maximum
@export var time_to_fill_level : float

## Filling percentage of a need. Higher values mean that the need is more probable to be solved
## next.
@export_range(0, 1) var level : float = 0 :
	set(new_level):
		level = clamp(new_level, 0, 1)

## Minimum value needed until the need can be chosen to be solved.
@export_range(0,1, 0.01, "or_less") var min_level_before_solve : float

## Needs with higher priority than a [class SolutionStep] can interrupt that step.
@export_range(0, 20, 1, "or_greater") var priority : int = 0

## Represents the value at which a Need is urgent and, therefore, can interrupt a lower priority
## [class Step].
@export_range(0,1) var urgent_level : float = 1

## List of aplicable solutions for the current environment. It is filled after calling
## [method Need.can_be_solved]
var feasible_solutions = []

## Index of relevance of a Need. It is used for determining the probability of choosing a Need to be
## solved. It is computed as the [method @GlobalScope.smoothstep] of [member level] between
## [member min_level_before_solve] and 1.0
var relevance : float :
	get:
		relevance = smoothstep(min_level_before_solve, 1.0, level)
		return relevance

## Computed after calling [method can_be_solved] and used for obtaining a random [class Solution] in
## method [method get_a_solution].
var _feasible_solutions_total_weight : float


func _to_string():
	return "[Need] %s"%need_key

## Increase the level of the need based on the elapsed time
func increase_level(delta):
	level+=delta/time_to_fill_level

## Computes the list of feasible solutions and returns true if there is at least one [class Solution]
## aplicable in the scenary or false otherwise. The method must be called one time before running
## the simulation.
func can_be_solved(tree: SceneTree) -> bool:
	_feasible_solutions_total_weight = 0.0
	for sol in solutions:
		if sol.is_solution_feasible(tree):
			feasible_solutions.append(sol)
			_feasible_solutions_total_weight += sol.weight
	
	if feasible_solutions.size() > 0:
		return true
	
	return false

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
			return sol
	return null

## Computes the time needed for a need to reach a target level. A return value of 0 means that the
## target level has already been reached
func time_until_level(target_level: float, rate : float = 1.0):
	return max(0.0, (target_level - level) * time_to_fill_level * rate)
