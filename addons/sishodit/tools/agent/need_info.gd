@icon("res://addons/sishodit/assets/icons/need.png")
class_name NeedInfo
extends Resource

## The representation of a need of the agent.

## Unique identifier for the need. Using the same name for two different needs should be
## avoided. Every reference to needs in other elements of the model will always refer to this key.
@export var need_key : String :
	set(key):
		need_key = key
		resource_name = key
		
## List of posible [class Solution]s to solve this need.
@export var solutions : Array[SolutionInfo]

## Time needed until the need reachs its maximum level, when the probability of choosing this
## need is maximum
@export var time_to_fill_level : float

## The value of [member Need.level] when the simulation starts
@export_range(0, 1) var initial_level : float = 0

## Minimum value needed until the need can be chosen to be solved.
@export_range(0,1, 0.01, "or_less") var min_level_before_solve : float

## Needs with higher priority than a [Step] can interrupt that step.
@export_range(0, 20, 1, "or_greater") var priority : int = 0

## Represents the value at which a Need is urgent and, therefore, can interrupt a lower priority
## [Step].
@export_range(0,1) var urgent_level : float = 1

func _to_string():
	return "[Need] %s"%need_key
