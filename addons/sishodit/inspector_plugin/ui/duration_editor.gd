extends EditorProperty

#region constants
const seconds_in_minute = 60
const seconds_in_hour = 60 * seconds_in_minute
const seconds_in_day = 24 * seconds_in_hour
#endregion

#region vars
var total_time : float = 0 : 
	set(new_time) :
		total_time = new_time
		_update_time_vars()
		_update_time_widgets()
var days : int
var hours : int
var minutes : int
var seconds : float
#endregion

#region widgets
var day_widget = SpinBox.new()
var hour_widget = SpinBox.new()
var minute_widget = SpinBox.new()
var second_widget = SpinBox.new()
#endregion

#region overrides
func _init():
	# Configure time widgets
	_configure_time_widget(day_widget, "d")
	_configure_time_widget(hour_widget, "h")
	_configure_time_widget(minute_widget, "m")
	_configure_time_widget(second_widget, "s")
	
	# Create containers
	var widgets_container = HBoxContainer.new()
	
	# Add childs
	widgets_container.add_child(day_widget)
	widgets_container.add_child(hour_widget)
	widgets_container.add_child(minute_widget)
	widgets_container.add_child(second_widget)
	
	add_child(widgets_container)
	set_bottom_editor(widgets_container)

func _update_property() -> void:
	total_time = get_edited_object()[get_edited_property()]
#endregion

#region callbacks
func _on_time_widget_value_change(_value):
	total_time = (day_widget.value * seconds_in_day       +
				  hour_widget.value * seconds_in_hour     +
				  minute_widget.value * seconds_in_minute +
				  second_widget.value )
	emit_changed(get_edited_property(), total_time)
#endregion

#region auxiliar_methods
func _update_time_vars():
	var aux_time = total_time
	days = int(aux_time / seconds_in_day)
	aux_time = fmod(aux_time, seconds_in_day)
	hours = int(aux_time / seconds_in_hour)
	aux_time = fmod(aux_time, seconds_in_hour) 
	minutes = int(aux_time / seconds_in_minute)
	seconds = fmod(aux_time, seconds_in_minute)

func _update_time_widgets():
	day_widget.set_value_no_signal(days)
	hour_widget.set_value_no_signal(hours)
	minute_widget.set_value_no_signal(minutes)
	second_widget.set_value_no_signal(seconds)

func _configure_time_widget(widget : SpinBox, unit := ""):
	widget.suffix = unit
	if unit == "s":
		widget.step = 0.0001
		widget.custom_arrow_step = 1
	widget.value_changed.connect(_on_time_widget_value_change)
#endregion
