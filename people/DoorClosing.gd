extends RayCast

var current_door

func _process(_delta):
	var collider = get_collider()
	if is_colliding() and collider.is_in_group("door"):
			current_door = collider
	
	if current_door != collider and current_door != null:
		if current_door is Area:
			current_door.get_parent().close()
		else:
			current_door.close()
		current_door = null
