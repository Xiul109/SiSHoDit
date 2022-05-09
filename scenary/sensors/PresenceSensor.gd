extends Spatial

onready var sensor = $Sensor

func _on_Area_body_entered(body):
	print("enter")
	#sensor.activate(1)


func _on_Area_body_exited(body):
	#sensor.activate(0)
	print("exit")
