class_name ContSensor
extends Sensor

## A type of node that represents a sensor deployed in the smart environment. It manages uncertainty
## for sensor triggers. By default, it should be used by manually calling [method activate], but
## more complex behaviours can be included by creating classes that inheriths from it.

@export var sample_rate : float = 1
@export var activations_templates : Dictionary
@export var default_activation_index : int = 0

## Used for registering the activations before procesing them
var activations : PackedVector2Array = PackedVector2Array()

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
	var n_activations = floor(delta*sample_rate)
	remaining = delta - n_activations/sample_rate
	var outputs = PackedFloat32Array()
	outputs.resize(n_activations)
	var asd = []
	for a in n_activations:
		simulable.log_event.emit(sensor_name, sensor_type,
								randfn(0, 1), (a+1)*(1/sample_rate)-delta) # +1 to generate the current value and not the previous one

# Private methods
## Computes the time needed until the next wrong trigger
func _get_time_until_wrong_trigger():
	return max(randfn(average_time_between_wrong_triggers,
						std_time_between_wrong_triggers), 0.001)

func _post_activation(value, delta: float) -> void:
	activations.append(Vector2(delta, value))
