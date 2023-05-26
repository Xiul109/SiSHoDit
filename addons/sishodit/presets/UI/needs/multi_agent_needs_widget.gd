extends TabContainer

const needs_widget = preload("res://addons/sishodit/presets/UI/needs/needs_widget.tscn")

func add_agent(agent: Agent):
	var widget = needs_widget.instantiate()
	add_child(widget)
	
	widget.agent = agent
