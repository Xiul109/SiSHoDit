extends State


func on_enter():
	var current_need = _get_next_need_to_cover()
	var is_returning = current_need in my_agent.current_needs or current_need == null
	var need_solution : Solution
	var log_event_type : String = "activity_begin"
	
	if is_returning:
		current_need = my_agent.current_needs.back()
		need_solution = my_agent.current_solutions.back()
		log_event_type = "activity_return"
	else:
		need_solution = current_need.get_random_feasible_solution_in_context(
																		my_agent.simulable.context)
		my_agent.current_needs.append(current_need)
		my_agent.current_solutions.append(need_solution)
		
	my_agent.log_event(log_event_type, need_solution.info.resource_name)
	_console_log(current_need, is_returning)
	
	transitioned_to.emit("CheckNextStep")

## Obatains the next need to be cover based only on the probabilities of a need to be chosen
## considering needs priorities but not additional constrains, like if the need is pending to be
## solved
func _get_next_need_to_cover():
	var priority = (my_agent.current_steps.back().priority
					# If it is interupting a step
					if (not my_agent.current_steps.is_empty() and
					# and the need interrupted timeout is not higher than 0
						my_agent.current_needs.back().timeout <= 0.0)
					else -INF)
	
	var choosable_needs : Array[Need] = my_agent.needs.filter(
		func(need: Need): 
			return (need.info.priority > priority and 
			need.relevance > 0.0 and
			need.has_solutions_in_context(my_agent.simulable.context) and
			need.timeout <= 0.0)
	)
	if len(choosable_needs) == 0:
		return null
	
	var probabilities = choosable_needs.map(func(need: Need): return need.relevance)
	
	var next_need_i = probabilities.find(1.0)
	if next_need_i == -1:
		next_need_i = _get_random_i_based_on_probabilities(probabilities)

	return choosable_needs[next_need_i]


# Returns and index based on the probabilities of each one to be chosen
func _get_random_i_based_on_probabilities(probabilities):
	var total = 0
	for p in probabilities:
		total += p
		
	var target = randf_range(0, total)
	var sum = 0
	for i in range(len(probabilities)):
		sum += probabilities[i]
		if target < sum:
			return i
	
	return 0

## Logs texts to the console based on the current need being solved
func _console_log(need, is_returning = false):
	print("---------------------------------------")
	if is_returning:
		print("Returning to need: ", need.info.need_key)
	else:
		print("New need: ", need.info.need_key)
