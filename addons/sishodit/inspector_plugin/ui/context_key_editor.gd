extends EditorProperty

# Dict reference
var keys : Array[String]

# Button for showing the bottom editor
var drop_down = OptionButton.new()

#region overrides
func _init():
	# Property control
	add_child(drop_down)
	add_focusable(drop_down)
	drop_down.item_selected.connect(_on_key_selected)

func _enter_tree() -> void:
	_update_keys()
	for key in keys:
		drop_down.add_item(key)

func _update_property() -> void:
	var new_value = get_edited_object()[get_edited_property()]
	drop_down.select(keys.find(new_value))
#endregion

#region callbacks

func _on_key_selected(group_i: int) -> void:
	emit_changed(get_edited_property(), drop_down.get_item_text(group_i))
#endregion

#region auxiliar_methods

func _update_keys() -> void:
	var nodes : Array[Node] = []
	for scene_path in EditorInterface.get_open_scenes():
		nodes.append(load(scene_path).instantiate())
	
	keys.append_array(SishoditUtils.find_context_keys(nodes))
	keys.sort() # Sorted for easy finding
	
	for node in nodes:
		node.queue_free()
#endregion
