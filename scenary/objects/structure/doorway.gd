extends StaticBody

onready var door = $"doorway(Clone)/door"

var state = "close"

func open():
	if state != "open":
		state = "open"
		door.rotate_y(90)

func close():
	if state != "close":
		state = "close"
		door.rotate_y(-90)
