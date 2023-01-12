extends State


func on_process(_delta: float):
	pass

func on_enter():
	var current_need = _get_next_need_to_cover()
	my_agent.current_needs.append(current_need)
	var need_solution : Solution = current_need.get_solution()
	my_agent.current_solutions.append(need_solution)
	EventLogger.log_event(my_agent.name, "activity_begin", need_solution.resource_name)
	print("-------------------------")
	print("New need: ", current_need.need_key, ". It can be solved in ",
			need_solution.steps.size(), " steps.")
	
	transitioned_to.emit("CheckNextStep")

func on_exit():
	pass

## Aux functions ##
func _get_next_need_to_cover():
	var min_level = 0.0
	if not my_agent.current_steps.is_empty():
		min_level = my_agent.current_steps.back()["step"].min_value_to_be_interrupted
	var probs = []
	var choosable_needs = []
	for need in my_agent.needs:
		if need.level >= min_level:
			probs.append(need.get_probability())
			choosable_needs.append(need)
	
	var next_need_i = probs.find(1.0)
	if next_need_i == -1:
		next_need_i = _get_random_i_based_on_probs(probs)

	return choosable_needs[next_need_i]

func _get_random_i_based_on_probs(probs):
	var total = 0
	for p in probs:
		total += p
	var prob = randf_range(0, total)
	var sum = 0
	for i in range(len(probs)):
		sum += probs[i]
		if prob < sum:
			return i
	
	return 0
