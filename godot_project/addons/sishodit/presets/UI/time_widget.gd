extends VBoxContainer

@onready var day_label = $Day
@onready var hour_label = $Hour
@onready var simulable : Simulable = $Simulable

## Weekdays in godot order
var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]


func _on_simulable_simulated(delta):
	if simulable.context.has_all(["day", "month", "year", "weekday"]):
		
		day_label.text = "%d/%d/%d (%s)" % [simulable.context["day"],
											simulable.context["month"],
											simulable.context["year"],
											weekdays[simulable.context["weekday"]]]
	if simulable.context.has_all(["hour", "minute", "second"]):
		hour_label.text = "%d:%d:%.f" % [simulable.context["hour"],
										simulable.context["minute"],
										simulable.context["second"],]
