class_name Sensor
extends Node

## A type of node that represents a sensor deployed in the smart environment. It manages uncertainty
## for sensor triggers. By default, it should be used by manually calling [method activate], but
## more complex behaviours can be included by creating classes that inheriths from it.

## Sensor name that will appear in the logs.
@export var sensor_name : String = "sensor"
## Sensor type that will appear in the logs.
@export var sensor_type: String = "generic"


## Parameters to specify different froms of malfunction for a sensor
@export_group("Malfunction parameters")
## Used for specifying what range of values can produce a sensor, which is useful for simulating
## correctly the wrong triggers.
@export var value_range : ValueRange = BinaryValueRange.new()
## Probability of not being triggered when it should.
@export_range(0,1) var not_triggered_prob : float = 0
## Probability of producing a wrong value when triggered.
@export_range(0,1) var wrong_value_prob: float = 0
## For simulating the triggering of a sensor when it should not, it is assumed that those triggers
## appear after a random amount of time that follows a normal distribution for which this and
## [member std_time_between_wrong_triggers] parameters are used. If it is 0 or lesser, the sensor
## won't produce wrong triggers.
@export var average_time_between_wrong_triggers: float = 0
## See [member average_time_between_wrong_triggers]
@export var std_time_between_wrong_triggers: float = 0

## A simulable instance to inform the [Simulator] that sensors needs to be simulated
var simulable : Simulable

## Used for controlling the time in simulation need until a sensor produces a wrong trigger. Only
## relevant if [member average_time_between_wrong_triggers] > 0.
var _time_until_wrong_trigger = 0


func _init():
	name = "Sensor"

func _ready():
	simulable = Simulable.new()
	simulable.simulated.connect(_simulate)
	add_child(simulable)

func _to_string() -> String:
	return "[Sensor] %s"%sensor_name

# Public methods
## When called, the sensor is activated and
func activate(value, delta: float = 0) :
	if randf() < not_triggered_prob or not value_range.is_value_in_range(value):
		return
	if randf() < wrong_value_prob:
		value = value_range.get_random_valid_value()
	_post_activation(value, delta)

# Private methods
## When called simulates the sensor during the specified time
func _simulate(delta):
	_compute_wrong_activations(delta)

# Private methods
## Computes the time needed until the next wrong trigger
func _get_time_until_wrong_trigger():
	return max(randfn(average_time_between_wrong_triggers,
						std_time_between_wrong_triggers), 0.001)

func _compute_wrong_activations(delta: float):
	if average_time_between_wrong_triggers <= 0:
		return
	_time_until_wrong_trigger -= delta
	while _time_until_wrong_trigger < 0:
		activate(value_range.get_random_valid_value(), _time_until_wrong_trigger)
		_time_until_wrong_trigger += _get_time_until_wrong_trigger()

## Called after activation errors have been computed
func _post_activation(value, delta: float) -> void:
	simulable.log_event.emit(sensor_name, sensor_type, value, delta)
