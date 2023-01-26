extends VBoxContainer

@export var simulator : Simulator

@onready var day_label = $HBoxContainer/Day
@onready var hour_label = $Hour

var seconds_in_a_minute = 60.0
var seconds_in_a_hour = 60*seconds_in_a_minute
var seconds_in_a_day= seconds_in_a_hour*24

func _process(_delta):
	if not simulator:
		return
	var time = int(simulator.elapsed_seconds)
	day_label.text = str(floor(time/seconds_in_a_day))
	
	var day_seconds = time%int(seconds_in_a_day)
	var hours = floor(day_seconds/seconds_in_a_hour)
	var hour_seconds = day_seconds%int(seconds_in_a_hour)
	var minutes = floor(hour_seconds/seconds_in_a_minute)
	var seconds = hour_seconds%int(seconds_in_a_minute)
	hour_label.text = "%.f:%.f:%.f"%[hours, minutes, seconds]
