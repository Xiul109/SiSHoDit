class_name Need

extends Resource

@export var need_key : String
@export var solutions : Array[Solution] = [] # (Array, Resource)
var viable_solutions = []

@export var time_to_fill_level : float
 
@export var level : float = 0 : set = level_set # (float, 1)
@export var min_level_before_solve : float # (float, 1)


func increase_level(delta):
	level_set(level+delta/time_to_fill_level)

func get_probability():
	var prob = smoothstep(min_level_before_solve, 1, level)
	return prob

func can_be_solved(tree: SceneTree):
	if solutions.size() == 0:
		return false
	
	for sol in solutions:
		if sol.is_solution_viable(tree):
			viable_solutions.append(sol)
	if viable_solutions.size() > 0:
		return true
	
	return false

func get_solution():
	var weights = _get_solutions_weights(viable_solutions)
	return viable_solutions[_get_random_weighted(weights)]

### Setters ###
func level_set(new_level):
	level = clamp(new_level, 0, 1)

### Aux methods ###
func _get_solutions_weights(sols):
	var total_weight = 0
	for sol in sols:
		total_weight += sol.weight
		
	var weights = []
	var prev_weight = 0
	for sol in sols:
		prev_weight += sol.weight/total_weight
		weights.append(prev_weight)
	return weights

func _get_random_weighted(weights):
	var rn = randf()
	for i in len(weights):
		if rn <= weights[i]:
			return i
	return randi()%weights.size()
