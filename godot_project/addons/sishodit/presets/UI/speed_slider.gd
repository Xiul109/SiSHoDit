@tool
extends VSlider

## Base of the exponent for the ticks of the slider
@export var base : float = 2 :
	set(new_base):
		base = new_base
		_update_values()

## Maximum exponent for the slider ticks
@export var exponent : int = 3 :
	set(new_exp):
		exponent = new_exp
		_update_values()

## Distance from the limits of the control towards the first tick
@export var pix_until_first_tick : float = 15 :
	set(new_pix):
		pix_until_first_tick = new_pix
		_update_values()

## Distance for the labels from the x origin of the slider
@export var horizontal_offset : float = 10 :
	set(new_offset):
		horizontal_offset = new_offset
		_update_values()

# Overriden
func _ready():
	resized.connect(_update_values)
	_update_values()

# Private methods
func _update_values():
	# Removing previous children
	for child in get_children():
		child.queue_free()
	
	# Recalculate values
	min_value = pow(base, -exponent)
	max_value = pow(base, exponent)
	tick_count = 1 + 2*exponent
	
	# Add new labels
	for i in tick_count:
		var tick = exponent - i
		var label = Label.new()
		add_child(label)
		if tick <= -exponent:
			label.text = "x 0"
		elif tick < 0:
			label.text = "x 1/%d"%pow(base, -tick)
		elif tick == 0:
			label.text = "x 1"
		else:
			label.text = "x %d"%pow(base, tick)
		label.position.y = ((size.y-pix_until_first_tick*2)/(tick_count-1) * i
							- label.size.y/2 + pix_until_first_tick)
		label.position.x = size.x + horizontal_offset


# Callbacks
func _on_SpeedSlider_value_changed(val):
	if val == min_value:
		val = 0
	Engine.time_scale = val
