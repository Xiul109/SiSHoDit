class_name State
extends Node

## Abstract class for defining [StateMachinePlayer] states

## A reference to the agent whose behaviour is defined by the state
var my_agent : Agent

## Must be emitted for asking the [StateMachinePlayer] to transition to a new State
signal transitioned_to(to: String)

# Next methods must be overriden
## Called when [method StateMachinePlayer.simulate]
func on_process(_delta: float):
	pass

## Called when the state enters to the [StateMachinePlayer]
func on_enter():
	pass

## Called when the state exits from the [StateMachinePlayer]
func on_exit():
	pass
