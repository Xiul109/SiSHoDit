class_name Need

extends Resource

export var need_key : String
export(Array, Resource) var solutions = []
var viable_solutions = []

export var time_to_fill_level : float
 
export(float, 1) var level : float = 0
export(float, 1) var min_level_before_solve : float


func increase_level(delta):
	level = clamp(level+delta/time_to_fill_level, 0, 1)

func get_probability():
	if level <= min_level_before_solve:
		return 0.0
	return 1/(1+ pow(level/(1.0001-level), -2.5))

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
	return viable_solutions[randi()%viable_solutions.size()]
