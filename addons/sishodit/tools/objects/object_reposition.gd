class_name ObjectReposition
extends Node3D

## This Node steal the groups and copy Usable nodes of parent object using
## redirect_usables. Its main function is to move the position of an object to
## improve pathfinding.

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if not parent:
		push_warning("ObjectReposition does not have a parent.")
		return
	_steal_groups(parent)
	_make_redirect_usables(parent)

## Copies and removes the groups from the child argument
func _steal_groups(node:Node):
	var node_groups = node.get_groups()
	for group in node_groups:
		add_to_group(group)
		node.remove_from_group(group)

## Moves the Usable object from the child argument if it has any
func _make_redirect_usables(node:Node):
	for child in node.get_children():
		if child is Usable:
			var redirect_usable = RedirectUsable.new()
			redirect_usable.usable = child
			add_child(redirect_usable)
