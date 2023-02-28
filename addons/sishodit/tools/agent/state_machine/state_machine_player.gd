## It is used specifically for playing Agent's behaviour modelled as StateMachine
class_name StateMachinePlayer
extends Node

## The state that will be played when [method start] is called
@export var initial_state : State

## It stores references to [class State]s that can be accessed trought the states names. Read only.
var states = {} : 
	set(_val): push_warning("The variable 'states' cannot be modified")
## A reference to the state that is currently being played
var current_state : State = null :
	set(new):
		if current_state != null:
			current_state.on_exit()
		current_state = new
		current_state.on_enter()


func _ready():
	# Loading nodes in a dict structure
	for node in get_children():
		if node is State:
			states[node.name] = node
			node.my_agent = get_parent()
			node.transitioned_to.connect(transition)

## Calls [method State.on_process] of the current state. It should be called every physic frame
func simulate(delta):
	if current_state == null:
		return
	current_state.on_process(delta)

## Starts playing the state machine
func start():
	# Setting the initial state
	if not initial_state:
		push_warning("Initial state has not been defined.")
		return
	
	current_state = initial_state

## Transitions to the target State 
func transition(to: String):
	if not to in states.keys():
		push_warning("The state '%s' is not included in the StateMachine" % to)
	current_state = states[to]
