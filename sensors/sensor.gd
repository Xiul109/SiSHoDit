class_name Sensor
extends Node

@export var sensor_name : String = "sensor"
@export var sensor_type: String = "generic"

@export var not_triggered_prob : float = 0 # (float, 1)
@export var wrong_value_prob: float = 0 # (float, 1)
@export var average_time_between_wrong_triggers: float = 0
@export var std_time_between_wrong_triggers: float = 0

@export var range_type = "binary" # (String, "binary", "other")
var value_range : ValueRange

var stored_not_triggered_prob : float = 0
var stored_wrong_value_prob: float = 0
var stored_average_time_between_wrong_triggers : float = 0
var stored_std_time_between_wrong_triggers : float = 0


var time_until_wrong_trigger = 0

### overriden methods ###
func _init():
	name = "Sensor"

func _ready():
	add_to_group("sensor")
	init_value_range(range_type)
	TimeSim.register_sensor(self)

### Aux methods ###
func get_time_until_wrong_trigger():
	var rng = RandomNumberGenerator.new()
	rng.seed = GlobalVar.rnd_seed
	return max(rng.randfn(average_time_between_wrong_triggers,
						std_time_between_wrong_triggers), 0.001)
	
### public methods ###
func init_value_range(r_type):
	match r_type:
		"binary":
			value_range = BinaryValueRange.new()
		_:
			value_range = ValueRange.new()

func activate(value, delta = 0):
	if randf() >= not_triggered_prob:
		if randf() < wrong_value_prob:
			value = value_range.get_random_valid_value()
		EventLogger.log_event(sensor_name, sensor_type, value, delta)

func override_malfunction_params(nt_prob, wv_prob, atb_wrong_triggers, stb_wrong_triggers):
	stored_not_triggered_prob = not_triggered_prob
	stored_wrong_value_prob = wrong_value_prob
	stored_average_time_between_wrong_triggers = average_time_between_wrong_triggers
	stored_std_time_between_wrong_triggers = std_time_between_wrong_triggers
	
	not_triggered_prob = nt_prob
	wrong_value_prob = wv_prob
	average_time_between_wrong_triggers = atb_wrong_triggers
	std_time_between_wrong_triggers = stb_wrong_triggers

func recover_malfunction_params():
	not_triggered_prob = stored_not_triggered_prob
	average_time_between_wrong_triggers = stored_average_time_between_wrong_triggers
	std_time_between_wrong_triggers = stored_std_time_between_wrong_triggers

func simulate(delta):
	if average_time_between_wrong_triggers <= 0:
		return
	time_until_wrong_trigger -= delta
	while time_until_wrong_trigger < 0:
		activate(value_range.get_random_valid_value(), time_until_wrong_trigger)
		time_until_wrong_trigger += get_time_until_wrong_trigger()
