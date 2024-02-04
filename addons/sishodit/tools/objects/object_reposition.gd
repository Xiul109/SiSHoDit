class_name ObjectReposition
extends Node3D

## This Node steal the groups and Usable nodes of child object. Its main function is to move the
## position of an object to improve pathfinding. It is not advisable to use it for objects that have
## subchildrens with redirect usables.

# Called when the node enters the scene tree for the first time.
func _ready():
	var child = _check_and_get_child()
	_steal_groups(child)
	_steal_usable(child)

## Copies and removes the groups from the child argument
func _steal_groups(child:Node):
	var child_groups = child.get_groups()
	for group in child_groups:
		add_to_group(group)
		child.remove_from_group(group)

## Moves the Usable object from the child argument if it has any
func _steal_usable(child:Node):
	for node in child.get_children():
		if node is Usable:
			child.remove_child(node)
			add_child(node)
			break

## Checks if the child tree has the correct format and returns the child if correct.
func _check_and_get_child() -> Node:
	var children = get_children()
	
	if children.is_empty():
		push_warning("ObjectReposition does not have a child.")
		return
	
	if children.size() > 1:
		push_warning("ObjectReposition should only have one child. Only the first one will be used.")
	
	var child = children[0]
	
	return child
