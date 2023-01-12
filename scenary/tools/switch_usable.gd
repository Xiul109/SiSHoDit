class_name SwitchUsable
extends AbstractUsable

@export var switch_on_value : float = 1
@export var switch_off_value : float = 0

@export var is_switched : bool

@export var switch_on = "start" # (String, "start", "end")

@onready var _sensor : Sensor = $Sensor

### overriden methods ###
func _ready():
	_sensor.sensor_name = get_parent().name

	
### To be overriden if needed ###
func start_using(_user: Agent):
	if switch_on == "start":
		switch()
	super.start_using(_user)
	
func finish_using(_user: Agent):
	if switch_on == "end":
		switch()
	super.finish_using(_user)

### Aux methods ###
func switch():
	is_switched = not is_switched
	if is_switched:
		_sensor.activate(switch_on_value)
	else:
		_sensor.activate(switch_off_value)
