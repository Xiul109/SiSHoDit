class_name ConditionManager
extends Resource

enum EvaluationMode {
	ANY, ## True when at least one condition is satisfied.
	ALL, ## Only true when every condition is satisfied.
}

## List of conditions to be evaluated.
@export var conditions : Array[ContextCondition]

## The requirements that should be met to consider the evaluation correct.
@export var evaluation_mode : EvaluationMode = EvaluationMode.ALL

## Computes every comparison for each condition and returns an array with the results.
func compute_all_comparisons(context: Dictionary) -> Array[bool]:
	return conditions.map(func(condition): condition.compare(context))

## Evaluates the result of each condition in [member conditions] depending of 
##[member evaluation_mode].
func evaluate(context: Dictionary) -> bool:
	if conditions.is_empty():
		return true
	
	var evaluate_condition = func(condition): return condition.compare(context)
	match evaluation_mode:
		EvaluationMode.ANY:
			return conditions.any(evaluate_condition)
		EvaluationMode.ALL:
			return conditions.all(evaluate_condition)
	return false
