## His duty is to provide the user interface for adding entrys to the dictionary
extends PanelContainer

var Entry = preload("res://addons/sishodit/inspector_plugin/need_dict_entry.gd")

var container = VBoxContainer.new()
var entry = Entry.new("", 0)
var add_entry_button = Button.new()

signal entry_added(key: String, value: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Changing background
	var style = StyleBoxFlat.new()
	style.bg_color = Color(.4, .45, .5)
	style.set_corner_radius_all(4)
	style.content_margin_bottom = 2
	style.content_margin_top = 4
	style.content_margin_left = 6
	style.content_margin_right = 6
	add_theme_stylebox_override("panel", style)
	
	# Adding elements
	add_child(container)
	# Entry
	container.add_child(entry)
	entry.is_for_display = false
	# Button
	add_entry_button.text = "Add entry"
	add_entry_button.pressed.connect(_on_entry_add_button_pressed)
	container.add_child(add_entry_button) 
	

# Callbacks
func _on_entry_add_button_pressed():
	entry_added.emit(entry.key, entry.value)
	entry.default_entry()
