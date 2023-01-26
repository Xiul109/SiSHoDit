class_name StateMachinePlayer
extends Node

@export_node_path(State) var initial_state : NodePath

var states = {} : 
	set(_val): push_warning("The variable 'states' cannot be modified")
var current_state : State = null :
	set(new):
		if current_state != null:
			current_state.on_exit()
		current_state = new
		current_state.on_enter()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Loading nodes in a dict structure
	for node in get_children():
		if node is State:
			states[node.name] = node
			node.my_agent = get_parent()
			node.transitioned_to.connect(transition)



func simulate(delta):
	if current_state == null:
		return
	current_state.on_process(delta)


# Called when the StateMachine needs to move to a new State
func start():
	# Setting the initial state
	if not initial_state.is_empty():
		current_state = get_node(initial_state)

func transition(to: String):
	if not to in states.keys():
		push_warning("The state '%s' is not included in the StateMachine" % to)
	current_state = states[to]
