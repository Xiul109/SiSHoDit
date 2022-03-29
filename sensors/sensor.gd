class_name Sensor
extends Node

export var sensor_name : String = "sensor"

export(float, 1) var not_triggered_prob : float = 0
export(float, 1) var wrong_value : float = 0


func activate(value):
	if randf() >= not_triggered_prob:
		EventLogger.log_event(sensor_name, value)
