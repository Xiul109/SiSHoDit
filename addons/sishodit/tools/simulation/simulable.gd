extends Node
class_name Simulable

## This node should be added to every node that requires active simulation. Each time the
## simulation advances [signal simulated] will be emitted, which informs the parent node how much
## time has advanced since the last simulation update, so the parent should avoid using _process
## or _physic_process functions.

## Emitted just before the first simulation step is executed
signal simulation_start
## Emitted when waiting is requested.
signal waiting_started
## Emitted in each simulation step.
signal simulated(delta: float)
## Emitted for requesting to the [Simulator] to log an event.
signal log_event(from, type, value)
## Emitted when the timer has finished while indicating how many time within the simulated segment
## has passed since that occured
signal timer_finished(since: float)

## If true, simulation steps will coincide with _physic_process, unless waiting is requested.
@export var requires_real_time = false
## Higher values will be simulated before lower ones in the same tick
@export var priority : int = 0

## Initialized with the context variable provided by the [Simulator]
var context : Dictionary

## Only relevant for nodes that do not [member requires_real_time]. Informs that the entity is
## waiting during [member wait_time], which means that during that simulation time, it won't require
## real time.
var is_waiting : bool = false
## See [member is_waiting].
var wait_time : float = 0.0

## If true, then a timer is setted up and will emmit a signal once finished
var is_timer_set_up : bool = false
## Time in seconds that must advance for the timer to finish
var timer_time: float = 0.0

#Overriden methods
func _init():
	add_to_group("simulable", true)

func _to_string() -> String:
	return "[Simulable] (%s)"%get_parent()

# Public methods
## Called by [Simulator] whenever the simulation advances. The method is called after the internal
## time of the simulation is updated.
func simulate(delta: float) -> void:
	simulated.emit(delta)
	# Wait time management
	wait_time -= delta
	if wait_time <= 0.0:
		is_waiting = false
	# Timer management
	if not is_timer_set_up:
		return
	timer_time -= delta
	if timer_time <= 0.0:
		is_timer_set_up = false
		timer_finished.emit(timer_time)

## When called, puts the entity in wait mode.
func wait(time: float) -> void:
	# Ignores the call if the entity does not require real time
	if not requires_real_time:
		push_warning("Only real time entities can actively wait, the rest are waiting by default.")
		return
	if is_waiting:
		push_warning("The entity is already waiting for %f s, but instead it will wait for %f s."%
					[wait_time, time])
	if time <= 0.0:
		push_warning("Method 'wait' from 'Simulable' class should be called with positive values.")
		return
	is_waiting = true
	wait_time = time
	waiting_started.emit()

## Sets a timer using the internal timing of the simulation instead of global one used by Godot for
## [param time] seconds. When the timer finishes, it emits [signal timer_finished]. This timer
## should be considered always in one-shot mode.
func set_timer(time: float) -> void:
	is_timer_set_up = true
	timer_time = time
