extends VBoxContainer

onready var day_label = $HBoxContainer/Day
onready var hour_label = $Hour

var seconds_in_a_minute = 60
var seconds_in_a_hour = 60*seconds_in_a_minute
var seconds_in_a_day= seconds_in_a_hour*24

func _process(_delta):
	var time = int(TimeSim.elapsed_seconds)
	day_label.text = str(time/seconds_in_a_day)
	
	var day_seconds = time%seconds_in_a_day
	var hours = floor(day_seconds/seconds_in_a_hour)
	var hour_seconds = day_seconds%seconds_in_a_hour
	var minutes = floor(hour_seconds/seconds_in_a_minute)
	var seconds = hour_seconds%seconds_in_a_minute
	hour_label.text = "%.f:%.f:%.f"%[hours, minutes, seconds]
