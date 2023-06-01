extends VBoxContainer

const NeedsWidget = preload("res://addons/sishodit/presets/UI/agent_data/needs_widget.tscn")
const StackWidget = preload("res://addons/sishodit/presets/UI/agent_data/stack_widget.tscn")

var needs_widget
var stack_widget

var agent : Agent : 
	set(new_agent):
		agent = new_agent
		name = agent.name
		if needs_widget != null:
			needs_widget.agent = agent
		if stack_widget != null:
			stack_widget.agent = agent
		agent.state_machine.transitioned.connect(_on_state_changed)

func _ready():
	needs_widget = NeedsWidget.instantiate()
	$needs/CenterContainer.add_child(needs_widget)
	stack_widget = StackWidget.instantiate()
	$stack/MarginContainer.add_child(stack_widget)

func _on_state_changed(_from: State, to: State):
	if to != null:
		$state.text = to.name
