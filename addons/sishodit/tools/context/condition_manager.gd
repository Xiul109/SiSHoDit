class_name ConditionManager
extends EvaluableCondition

enum EvaluationMode {
	ANY, ## True when at least one condition is satisfied.
	ALL, ## Only true when every condition is satisfied.
}

## The requirements that should be met to consider the evaluation correct.
@export var evaluation_mode : EvaluationMode = EvaluationMode.ALL

## List of conditions to be evaluated.
@export var conditions : Array[EvaluableCondition]


## Computes every comparison for each condition and returns an array with the results.
func compute_all_comparisons(context: Dictionary) -> Array[bool]:
	return conditions.map(func(condition): condition.evaluate(context))

## Evaluates the result of each condition in [member conditions] depending of 
##[member evaluation_mode].
func evaluate(context: Dictionary) -> bool:
	print("manager")
	if conditions.is_empty():
		return true
	
	var evaluate_condition = func(condition): return condition.evaluate(context)
	match evaluation_mode:
		EvaluationMode.ANY:
			return conditions.any(evaluate_condition)
		EvaluationMode.ALL:
			return conditions.all(evaluate_condition)
	return false
