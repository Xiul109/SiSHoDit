class_name Need

extends Resource

@export var need_key : String
@export var solutions : Array[Solution] = [] # (Array, Resource)
var viable_solutions = []

@export var time_to_fill_level : float
 
@export_range(0,1) var level : float = 0 : set = level_set
@export_range(0,1, 0.01, "or_less") var min_level_before_solve : float

@export_range(0, 20, 1, "or_greater") var priority : int = 0
@export_range(0,1) var urgent_level : float = 1


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
	
func time_until_level(target_level: float, rate : float = 1.0):
	return (target_level - level) * time_to_fill_level * rate

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
