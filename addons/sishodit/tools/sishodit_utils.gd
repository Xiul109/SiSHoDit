@tool
class_name SishoditUtils
extends Object

## Returns all the groups in each node of [param nodes] and their childrens
static func find_groups(nodes : Array[Node]) -> Array[String]:
	if nodes == null:
		return []
	var groups : Dictionary[String, bool] = {}
	while not nodes.is_empty():
		var current_node : Node = nodes.pop_front()
		for group in current_node.get_groups():
			groups[group] = true
		nodes.append_array(current_node.get_children())
		
	
	return groups.keys()
