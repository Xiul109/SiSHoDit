@tool
class_name SishoditUtils
extends Object

## Returns all the groups in each node of [param nodes] and their children
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

## Returns all the context keys in each ContextProvider node of [param nodes] and their children
static func find_context_keys(nodes : Array[Node]) -> Array[String]:
	if nodes == null:
		return []
	var keys : Dictionary[String, bool] = {}
	for node in nodes:
		for provider in node.find_children("*", "ContextProvider"):
			if provider.keys.is_empty():
				push_warning("The ContextProvider ", provider, "does not contain any key.")
			for key in provider.keys:
				keys[key] = true
	
	return keys.keys()
