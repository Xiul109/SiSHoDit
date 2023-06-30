extends Area3D

@onready var sensor : Sensor = $Sensor

var bodies = 0

func _ready():
	sensor.sensor_name = self.name

func _on_body_entered(body):
	bodies += 1
	# Only activated when the first agent enters
	if bodies == 1:
		sensor.activate(1.0)


func _on_body_exited(body):
	bodies -= 1
	# Only activated when the last agent exits
	if bodies == 0:
		sensor.activate(0.0)
