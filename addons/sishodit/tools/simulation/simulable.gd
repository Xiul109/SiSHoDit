extends Node
class_name Simulable

## This node should be added to every node that requires active simulation. Each time the
## simulation advances [signal simulated] will be emitted, which informs the parent node how much
## time has advanced since the last simulation update, so the parent should avoid using _process
## or _physic_process functions.

## Emitted when waiting is requested.
signal waiting_started
## Emitted in each simulation step.
signal simulated(delta: float)
## Emitted for requesting to the [Simulator] to log an event.
signal log_event(from, type, value)

## If true, simulation steps will coincide with _physic_process, unless waiting is requested.
@export var requires_real_time = false

## Only relevant for nodes that do not [member requires_real_time]. Informs that the entity is
## waiting during [member wait_time], which means that during that simulation time, it won't require
## real time.
var is_waiting : bool = false
## See [member is_waiting].
var wait_time : float = 0.0

#Overriden methods
func _init():
	add_to_group("simulable", true)

# Public methods
## Called by [Simulator] whenever the simulation advances.
func simulate(delta: float):
	simulated.emit(delta)
	wait_time -= delta
	if wait_time <= 0.0:
		is_waiting = false

## When called, puts the entity in wait mode.
func wait(time: float):
	if is_waiting:
		return
	if time <= 0.0:
		push_warning("Method 'wait' from 'Simulable' class should be called with positive values.")
		return
	is_waiting = true
	wait_time = time
	waiting_started.emit()
