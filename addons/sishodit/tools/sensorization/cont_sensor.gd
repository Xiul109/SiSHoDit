class_name ContSensor
extends Sensor

## A type of node that represents a sensor deployed in the smart environment. It manages uncertainty
## for sensor triggers. By default, it should be used by manually calling [method activate], but
## more complex behaviours can be included by creating classes that inheriths from it.

#region export_properties
## How many times the sensor produces a value per second
@export var sample_rate : float = 1:
	set(new_value):
		sample_rate = new_value
		period = 1/sample_rate
		
## The [TSTemplate]s (values) asociated with each activation value (key). This will change in
## the future to manage complex activations
@export var activations_templates : Dictionary[float, TSTemplate]

## This is considered the default activation value that will be used to select the initial 
@export var default_activation_index : int = 0
#endregion

#region general_properties
## Used for registering the activations before procesing them
var activations : PackedVector2Array = PackedVector2Array()

## The inverse of [member sample_rate]. It is computed automatically when sample_rate changes, but
## not the other way.
var period = 1

## How much time has not been consumed for creating a value. It always must be smaller than period.
var remaining : float = 0

## An instance of [TSGenerator] which is created each time the [TSTemplate] is changed
var generator : TSGenerator = null
#endregion

func _ready():
	super()
	# The generator is initialized with the default [TSTemplate]
	var key = activations_templates.keys()[default_activation_index]
	_create_generator(key)

# Callbacks
## When called simulates the sensor during the specified time
func _simulate(delta: float):
	super(delta)
	# Delta modified including time from previous calls that did not produce any value
	delta += remaining
	# If the modified delta is smaller than the period, the simulation is not performed
	if delta < period:
		remaining = delta
		return
	# Each activation must finish the computation of the previous one and create a new generator
	for activation in activations:
		# Activation.x should be always negative or zero
		var duration = snapped(delta + activation.x, period)
		if duration > 0:
			_compute_and_log(duration, delta)
		_create_generator(activation.y)
		delta -= duration
	activations.clear()
	# Finish computing the rest of the time series
	if delta >= period: # Checking for not doing useless logging
		_compute_and_log(delta, 
						 delta)
	remaining = fmod(delta, period)
	

func _post_activation(value, since: float) -> void:
	# The activation is stored to produce the value when data is simulated
	activations.append(Vector2(since, value))

# Private methods
## Computes the values of the time series and logs each of them.
func _compute_and_log(duration: float, delta: float) -> void:
	var data = generator.generate(duration)
	simulable.log_events.emit(sensor_name, sensor_type, data, period, (-delta) + period)

## Creates a generator for the corresponding template in its activation value
func _create_generator(activation_value) -> void:
	generator = TSGenerator.new(sample_rate,
								activations_templates[activation_value])
