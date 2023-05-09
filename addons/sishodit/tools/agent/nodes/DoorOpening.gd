extends RayCast3D


var current_door

func _process(_delta):
	var collider = get_collider()
	if is_colliding() and collider.is_in_group("door"):
			if current_door != collider:
				current_door = collider
				if collider is Area3D:
					collider.get_parent().open()
				else:
					collider.open()
			else:
				current_door = null
