extends EditorProperty

var EntryAdder = preload("res://addons/sishodit/inspector_plugin/need_dict_entry_adder.gd")
var DictDisplay = preload("res://addons/sishodit/inspector_plugin/need_dict_display.gd")

# Dict reference
var dict : Dictionary

# Button for showing the bottom editor
var property_control = Button.new()

# Bottom editor
var bottom_container = VBoxContainer.new()
var entry_adder = EntryAdder.new()
var dict_display = DictDisplay.new()

func _init(obj_dict: Dictionary):
	dict = obj_dict
	
	# Property control
	add_child(property_control)
	add_focusable(property_control)
	property_control.text = "Need Dictionary"
	property_control.pressed.connect(_on_button_pressed)
	
	# Bottom editor
	add_child(bottom_container)
	bottom_container.add_child(entry_adder)
	entry_adder.entry_added.connect(_on_entry_added)
	bottom_container.add_child(dict_display)
	dict_display.load_dict(dict)
	dict_display.entry_updated.connect(_on_entry_updated)
	dict_display.entry_erased.connect(_on_entry_erased)
	set_bottom_editor(bottom_container)

# Callbacks
func _on_button_pressed():
	bottom_container.visible = not bottom_container.visible

func _on_entry_updated(key, value):
	dict[key] = value
	emit_changed(get_edited_property(), dict, "", true)

func _on_entry_erased(key):
	dict.erase(key)
	emit_changed(get_edited_property(), dict, "", true)

func _on_entry_added(key, value):
	if key not in dict:
		dict_display.add_entry(key, value)
	else:
		dict_display.entries[key].value = value
	
	# If this is not done, when a new entry is added, the default dictionary is changed for all
	if dict.is_empty():
		dict = {key: value}
	else:
		dict[key] = value
	
	emit_changed(get_edited_property(), dict, "", true)

func _update_property():
	dict = get_edited_object()[get_edited_property()]
	dict_display.load_dict(dict)
