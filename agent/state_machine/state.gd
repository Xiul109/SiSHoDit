class_name State
extends Node

var my_agent : Agent

signal transitioned_to(to: String)

# Must be overriden
func on_process(_delta: float):
	pass

func on_enter():
	pass

func on_exit():
	pass
