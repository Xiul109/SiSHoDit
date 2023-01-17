extends Node


var elapsed_seconds : float = 0
var sensors = []

#func _ready():
#	sensors = get_tree().get_nodes_in_group("sensor")

func _process(delta):
	simulate(delta)

func fast_forward(seconds):
	simulate(seconds)

func simulate(delta):
	elapsed_seconds += delta
	for sensor in sensors:
		sensor.simulate(delta)

func register_sensor(sensor):
	sensors.append(sensor)
	
func reset():
	elapsed_seconds = 0
	sensors = []
