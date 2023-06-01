extends TabContainer

const AgentDataWidget = preload("res://addons/sishodit/presets/UI/agent_data/single_agent_data_widget.tscn")

func add_agent(agent: Agent):
	var widget = AgentDataWidget.instantiate()
	add_child(widget)
	
	widget.agent = agent
