## Representation of each of the steps needed to apply a [class Solution]. A step can modify the
## state of [class Need]s or not.
class_name StepInfo
extends Resource

## Criteria for deciding which object will be chosen for applying the step
enum ObjectSelectionCriteria {
	RANDOM,		## Pick a random object between all the available
	NEAREST,	## Pick the nearest available object
	FURTHEST,	## Pick the furthest available object
}

@export_group("Object")
## The group name in which objects required for the step must be in. If empty, the step will be
## performed in the position of the [class Agent] in that moment.
@export var object_group: String
## Criterion to follow for selecting which object will be used.
@export var object_selection_criterion :ObjectSelectionCriteria
## If true, the [class Agent] will call the methods of [class Usable] atached to the object if it
## have the node.
@export var use_object : bool = true

@export_group("Duration")
## The minimum posible duration for the step
@export var min_duration: float
## The maximum posible duration for the step
@export var max_duration: float

@export_group("Needs")
# This two must ve changed for giving more flexibility to increase a need value, and also needs
# should be able to be freezed
## Needs that are solved by the step
@export var needs_solved : Array[String]
## Needs that whose filling rate is modified during the step. The dictionary expected entries are:
## [code]"need_key":rate[/code], where "need_key" should be the need_key of an existing [class Need]
## and rate must be a float that will multiply the default filling rate of the Need.
@export var needs_with_modified_rate: Dictionary

@export_group("Step fine tuning")
## Steps can only be interrupted by [class Need]s with higher priority than them. The final value
## used depends of the Need this Step is helping to solve being max([member priority],
## [member NeedInfo.priority]).
@export_range(0, 20, 1, "or_greater") var priority : int
## When true, if interrupted the step will be canceled along with the [class Solution] it is part of
## and the [class Need] for which that Solution is being applied
@export var cancel_on_interruption = false


func _to_string():
	return "[Step] %s"%resource_name

## Generates a random duration following a normal distribution with mean equal to
## ([member max_duration] + [member min_duration])/2 and standard deviation of
## [code]std_streching[/code] * ([member max_duration] - [member min_duration])/2.
func generate_duration(std_streching : float = .25):
	var mean_duration = (max_duration+min_duration)/2
	var std_duration = std_streching*(max_duration-min_duration)/2
	return clamp(randfn(mean_duration, std_duration),
					min_duration, max_duration)
