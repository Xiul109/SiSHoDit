class_name SwitchUsable
extends AbstractUsable

export var switch_on_value : float = 1
export var switch_off_value : float = 0

export var is_switched : bool

export(String, "start", "end") var switch_on = "start"

onready var _sensor : Sensor = $Sensor

### overriden methods ###
func _ready():
	_sensor.sensor_name = get_parent().name

	
### To be overriden if needed ###
func start_using(_user: BasicPerson):
	if switch_on == "start":
		switch()
	.start_using(_user)
	
func finish_using(_user: BasicPerson):
	if switch_on == "end":
		switch()
	.finish_using(_user)

### Aux methods ###
func switch():
	is_switched = not is_switched
	if is_switched:
		_sensor.activate(switch_on_value)
	else:
		_sensor.activate(switch_off_value)
