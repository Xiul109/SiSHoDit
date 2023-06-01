extends HBoxContainer

var agent : Agent :
	set(new_agent):
		agent = new_agent
		
		agent.new_current_need.connect(func(need): add_label(need.info.need_key, needs))
		agent.new_current_solution.connect(func(sol): add_label(sol.info.resource_name, solutions))
		agent.new_current_step.connect(func(step): add_label(step.info.resource_name, steps))

		agent.current_need_poped.connect(func(_need): remove_last_label(needs))
		agent.current_solution_poped.connect(func(_sol): remove_last_label(solutions))
		agent.current_step_poped.connect(func(_step): remove_last_label(steps))

@onready var needs = $needs/needs_list
@onready var solutions = $solutions/solutions_list
@onready var steps = $steps/steps_list

func add_label(text: String, where: VBoxContainer):
	var label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	where.add_child(label)
	
func remove_last_label(where : VBoxContainer):
	where.get_children()[-1].queue_free()
