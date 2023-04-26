extends EditorProperty

var EntryAdder = preload("res://addons/sishodit/inspector_plugin/need_dict_entry_adder.gd")
var DictDisplay = preload("res://addons/sishodit/inspector_plugin/need_dict_display.gd")

# Dict reference
var dict

# Button for showing the bottom editor
var property_control = Button.new()

# Bottom editor
var bottom_container = VBoxContainer.new()
var entry_adder = EntryAdder.new()
var dict_display = DictDisplay.new()

func _init(obj_dict):
	dict = obj_dict
	
	# Property control
	add_child(property_control)
	add_focusable(property_control)
	property_control.text = "Dictionary"
	property_control.pressed.connect(_on_button_pressed)
	
	# Bottom editor
	add_child(bottom_container)
	bottom_container.add_child(entry_adder)
	bottom_container.add_child(dict_display)
	set_bottom_editor(bottom_container)
	

func _on_button_pressed():
	bottom_container.visible = not bottom_container.visible
