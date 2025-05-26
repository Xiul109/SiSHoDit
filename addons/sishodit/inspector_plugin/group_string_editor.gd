extends EditorProperty

# Dict reference
var groups : Array[String]

# Button for showing the bottom editor
var drop_down = OptionButton.new()

#region overrides
func _init():
	# Property control
	add_child(drop_down)
	add_focusable(drop_down)
	drop_down.item_selected.connect(_on_group_selected)

func _enter_tree() -> void:
	_update_groups()
	for group in groups:
		drop_down.add_item(group)

func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	drop_down.select(groups.find(new_value))
#endregion

#region callbacks

func _on_group_selected(group_i: int) -> void:
	emit_changed(get_edited_property(), drop_down.get_item_text(group_i))
#endregion

#region auxiliar_methods

func _update_groups() -> void:
	var nodes : Array[Node] = []
	for scene_path in EditorInterface.get_open_scenes():
		nodes.append(load(scene_path).instantiate())
	
	groups = [""]
	groups.append_array(SishoditUtils.find_groups(nodes))
	groups = groups.filter(func(g): return not g.begins_with("_"))
	groups.sort() # Sorted for easy finding
	
	for node in nodes:
		node.queue_free()
#endregion
