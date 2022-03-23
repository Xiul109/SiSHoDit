extends Node


var elapsed_seconds : float = 0

func _process(delta):
	elapsed_seconds += delta

func fast_forward(seconds):
	elapsed_seconds += seconds
