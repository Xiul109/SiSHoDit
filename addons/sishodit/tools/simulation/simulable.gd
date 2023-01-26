extends Node
class_name Simulable

@export var simulation_mode = Simulator.SimulationMode.DONT_CARE : 
	set(mode):
		if mode == simulation_mode:
			return
		var previous = simulation_mode
		simulation_mode = mode
		simulation_mode_changed.emit(self, previous)

var wait_time : float = 0.0

signal simulation_mode_changed(me: Simulable, previous : Simulator.SimulationMode)
signal simulated(delta: float)
signal log_event(from, type, value)

func _init():
	add_to_group("simulable", true)
