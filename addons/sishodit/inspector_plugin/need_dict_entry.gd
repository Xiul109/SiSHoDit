extends HBoxContainer

#region properties
var is_for_display : bool = true :
	set(val):
		is_for_display = val
		erase_button.visible = is_for_display
		if key_editor is LineEdit:
			key_editor.editable = not is_for_display
		else:
			key_editor.disabled = is_for_display

var range_low : float :
	set(val):
		range_low = val
		value_editor.min_value = range_low
var range_high : float :
	set(val):
		range_high = val
		value_editor.max_value = range_high
var need_list : Array[String]

var key_editor
var value_editor = EditorSpinSlider.new()
var erase_button = Button.new()

var key : String :
	get:
		if key_editor is LineEdit:
			return key_editor.text
		else:
			return key_editor.get_item_text(key_editor.selected)
	set(new_key):
		if key_editor is LineEdit:
			key_editor.text = new_key
		else:
			print(new_key, need_list.find(new_key))
			key_editor.select(need_list.find(new_key))

var value: float :
	get:
		return value_editor.value
	set(new_value):
		value_editor.value = new_value
#endregion

#region signals
signal value_changed(key, value)
signal entry_erased(key)
#endregion

#region overrides
func _init(p_key: String = "", p_value: float = 1.0,
			p_need_list: Array[String] = [],
			p_range_low : bool = 0.0, p_range_high : bool = 1.0):
	# Key related fields initialization
	need_list = p_need_list
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
#endregion

#region public
func default_entry():
	if need_list == null or need_list.is_empty():
		key = ""
	else:
		key = need_list[0]
	print(key)
	value = 1.0
#endregion

#region private
func _init_key_editor():
	if need_list == null or need_list.is_empty():
		key_editor = LineEdit.new()
		key_editor.editable = false
	else:
		key_editor = OptionButton.new()
		for need in need_list:
			key_editor.add_item(need)
		key_editor.disabled = true
	key_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func _init_value_editor():
	value_editor.value_changed.connect(_on_value_changed)
	value_editor.step = 0.001
	value_editor.allow_greater = true
	value_editor.allow_lesser = true
	value_editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
#endregion

#region callbacks
func _on_value_changed(new_value: float):
	value_changed.emit(key, value)

func _on_erase_button_pressed():
	entry_erased.emit(key)
	queue_free()
#endregion
