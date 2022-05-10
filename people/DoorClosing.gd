extends RayCast


export(float, 1) var close_door_rate = 1.0

var current_door

func _process(_delta):
	var collider = get_collider()
	if is_colliding() and collider.is_in_group("door"):
			current_door = collider
	
	if current_door == collider or current_door == null:
		return
	
	var door = current_door.get_parent() if current_door is Area else current_door
	
	if door.autocloses or randf() <= close_door_rate:
		door.close()
	current_door = null
