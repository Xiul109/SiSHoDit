extends HBoxContainer

var is_for_display : bool = true :
	set(val):
		is_for_display = val
		key_editor.editable = not is_for_display
		erase_button.visible = is_for_display

var range_low : float :
	set(val):
		range_low = val
		value_editor.min_value = range_low
var range_high : float :
	set(val):
		range_high = val
		value_editor.max_value = range_high

var key_editor = LineEdit.new()
var value_editor = EditorSpinSlider.new()
var erase_button = Button.new()

var key : String :
	get:
		return key_editor.text
	set(new_key):
		key_editor.text = new_key

var value: float :
	get:
		return value_editor.value
	set(new_value):
		value_editor.value = new_value

signal value_changed(key, value)
signal entry_erased(key)

func _init(p_key: String = "", p_value: float = 0,
			p_range_low : bool = 0.0, p_range_high : bool = 1.0):
	# Key related fields initialization
	_init_key_editor()
	key = p_key
	add_child(key_editor)
	
	# Value related fields initialization
	_init_value_editor()
	range_low = p_range_low
	range_high = p_range_high
	value = p_value
	add_child(value_editor)
	
func _ready():
	# Remove button initialization
	erase_button.icon = get_theme_icon("Remove", "EditorIcons")
	erase_button.pressed.connect(_on_erase_button_pressed)
	add_child(erase_button)

# Public methods
func default_entry():
	key = ""
	value = 0.0

# Auxiliar methods
func _init_key_editor():
	key_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	key_editor.editable = false

func _init_value_editor():
	value_editor.value_changed.connect(_on_value_changed)
	value_editor.step = 0.001
	value_editor.allow_greater = true
	value_editor.allow_lesser = true
	value_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL

# Callbacks
func _on_value_changed(new_value: float):
	value_changed.emit(key, value)

func _on_erase_button_pressed():
	entry_erased.emit(key)
	queue_free()
