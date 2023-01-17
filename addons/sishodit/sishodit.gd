@tool
extends EditorPlugin

const TIME_SIM_NAME = "TimeSim"
const EVENT_LOGGER_NAME = "EventLogger"

func _enter_tree():
	add_autoload_singleton(TIME_SIM_NAME, "res://addons/sishodit/tools/autoloads/time_sim.gd")
	add_autoload_singleton(EVENT_LOGGER_NAME, "res://addons/sishodit/tools/autoloads/event_logger.gd")


func _exit_tree():
	remove_autoload_singleton(TIME_SIM_NAME)
	remove_autoload_singleton(EVENT_LOGGER_NAME)
