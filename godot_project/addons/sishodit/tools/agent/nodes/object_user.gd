class_name ObjectUser
extends Node

## It is used to check if an object is being used by someone. When it is added as a child to a 
## [Node] different than its [member real_parent], that means that the object represented by that
## [Node] is being used.

## Reference to the real parent which is set up in [method _ready]. Usually an [Agent].
var real_parent : Node

func _ready():
	real_parent = get_parent()

## Called when an object starts being used.
func start_using(object: Node):
	reparent(object)

## Called when the object finish being used.
func finish_using():
	reparent(real_parent)
