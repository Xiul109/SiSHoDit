class_name RedirectUsable
extends Usable

@export var usable : Usable


func start_using(user: Agent):
	if usable != null:
		usable.start_using(user)


func finish_using(user: Agent):
	if usable != null:
		usable.finish_using(user)

func being_used(user: Agent, delta: float):
	if usable != null:
		usable.being_used(user, delta)
