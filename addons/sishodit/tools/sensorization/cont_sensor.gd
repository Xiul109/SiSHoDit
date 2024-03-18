class_name ContSensor
extends Sensor

## A type of node that represents a sensor deployed in the smart environment. It manages uncertainty
## for sensor triggers. By default, it should be used by manually calling [method activate], but
## more complex behaviours can be included by creating classes that inheriths from it.

@export var sample_rate : float = 1:
	set(new_value):
		sample_rate = new_value
		period = 1/sample_rate
@export var activations_templates : Dictionary
@export var default_activation_index : int = 0

## Used for registering the activations before procesing them
var activations : PackedVector2Array = PackedVector2Array()

var period = 1
var remaining : float = 0
var generator : TSGenerator = null

func _init():
	name = "Sensor"

func _ready():
	generator = TSGenerator.new()
	var key = activations_templates.keys()[default_activation_index]
	generator.template = activations_templates[key]
	
	simulable = Simulable.new()
	simulable.simulated.connect(_simulate)
	add_child(simulable)

func _to_string() -> String:
	return "[Sensor] %s"%sensor_name


# Callbacks
## When called simulates the sensor during the specified time
func _simulate(delta: float):
	super(delta)
	# Aquí ya están computadas las wrong activations
	delta += remaining
	for activation in activations:
		_compute_and_log(activation.x, delta)
		delta -= snapped(activation.x, period) + period
		generator = TSGenerator.new()
		generator.template = activations_templates[activation.y]
	_compute_and_log(delta, delta)
	remaining = fmod(delta, period)
	# # +1 to generate the current value and not the previous one

func _post_activation(value, delta: float) -> void:
	activations.append(Vector2(delta, value))

# Private methods
## Computes the time needed until the next wrong trigger
func _compute_and_log(duration: float, delta: float) -> void:
	var data = generator.generate(duration, sample_rate)
	for i in data.size():
		simulable.log_event.emit(sensor_name, sensor_type, data[i], (i+1)*(period)-delta)
