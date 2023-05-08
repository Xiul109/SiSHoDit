@tool
class_name AbstractUsable
extends Node

## If an instance of this class or a subclass is added as child to an object, the agent will call
## the methods when starts, finish and during the use of the object. It is a general tool for
## sensorizing the objects with which an [Agent] interacts.

## Emitted when an [Agent] starts using the object
signal using_started
## Emitted when an [Agent] finishes using the object
signal using_finished

## Called by the [Agent] when they starts using the object
func start_using(_user: Agent):
	emit_signal("using_started")

## Called by the [Agent] when they finish using the object
func finish_using(_user: Agent):
	emit_signal("using_finished")

## Called while the [Agent] is using the object. Can be called once or more times. It should be
## overriden to add functionality.
func being_used(_user: Agent, _delta: float):
	pass
