extends State


func on_process(_delta: float):
	pass

func on_enter():
	var current_need = _get_next_need_to_cover()
	if current_need not in my_agent.current_needs and current_need != null:
		my_agent.current_needs.append(current_need)
		var need_solution : Solution = current_need.get_solution()
		my_agent.current_solutions.append(need_solution)
		my_agent.log_event("activity_begin", need_solution.resource_name)
	
		print("-------------------------")
		print("New need: ", current_need.need_key, ". It can be solved in ",
				need_solution.steps.size(), " steps.")
	else:
		print("---------------------------------------")
		print("Return to need: %s" % my_agent.current_needs.back().need_key)
	
	transitioned_to.emit("CheckNextStep")

func on_exit():
	pass

## Aux functions ##
func _get_next_need_to_cover():
	var probs = []
	var choosable_needs = []
	var priority = _find_priority_based_on_current_needs()
	for need in my_agent.needs:
		var prob = need.get_probability()
		if need.priority <= priority or prob <= 0.0:
			continue
		
		probs.append(prob)
		choosable_needs.append(need)
	
	if len(choosable_needs) == 0:
		return null
	
	var next_need_i = probs.find(1.0)
	if next_need_i == -1:
		next_need_i = _get_random_i_based_on_probs(probs)

	return choosable_needs[next_need_i]

func _find_priority_based_on_current_needs():
	var priority = -1
	for need in my_agent.current_needs:
		priority = max(need.priority, priority)
	for step in my_agent.current_steps:
		priority = max(step["step"].priority, priority)
	return priority

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
