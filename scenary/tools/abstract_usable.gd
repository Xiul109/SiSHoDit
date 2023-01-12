@tool
class_name AbstractUsable
extends Node

signal using_started
signal using_finished


### To be overriden if needed ###
func start_using(_user: Agent):
	emit_signal("using_started")
	
func finish_using(_user: Agent):
	emit_signal("using_finished")

func being_used(_user: Agent, _delta: float):
	pass#user.wait()
