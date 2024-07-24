class_name SensorizedUsable
extends Usable

## Every sensorized Usable should inherit from this class which adds an array of sensors
## automatically detected from their children. This class should be considered as abstract given
## that, by itself, it does not add any behaviour. 

## List of children sensors
var _sensors : Array[Sensor]

# Override methods
func _ready():
	var names = {}
	for child in get_children():
		if child is Sensor:
			_sensors.append(child)
			var name = get_parent().name + "-" + child.sensor_type
			if child.sensor_name in names:
				names[name] += 1
				name += "_%d"%names[name]
			else:
				names[name] = 0
			
			child.sensor_name = name

# Public methods

## Activates every sensor with the same value
func activate_sensors(value, delta: float = 0) -> void:
	for sensor in _sensors:
		sensor.activate(value, delta)
