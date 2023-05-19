class_name Step
extends RefCounted

## General parameters for this step
var info : StepInfo

## Maximum between [member StepInfo.priority] and argument [code]min_priority[/code] of the init
## method.
var priority : int

## Target object for this Step
var object : Node3D = null

## Reference to the Usable node of the object relevant for the step.
var usable : Usable = null

## Total duration of this Step if it is not cancelled
var total_duration : float

## Time left in this Step until finished
var time_left : float


func _init(step_info : StepInfo, min_priority : int = -INF):
	info = step_info
	
	priority = max(min_priority, info.priority)
	
	total_duration = info.generate_duration()
	time_left = total_duration
	

func _to_string():
	return info._to_string()


## Called when starting doing a new Step
func start(agent:Agent):
	if usable != null and info.use_object:
		usable.start_using(agent)


## Called when a delta update is received while doing a Step. Returns true if done.
func do(delta:float, agent:Agent) -> bool:
	time_left -= delta
	# Use the object associated to the step
	if usable != null:
		usable.being_used(agent, delta)
	
	var time_percentage = delta/total_duration
	# Update needs
	for need in agent.needs:
		if need.info.need_key in info.needs_solved:
			need.level -= time_percentage * info.needs_solved[need.info.need_key]
		elif need.info.need_key in info.needs_increased:
			need.level += time_percentage * info.needs_increased[need.info.need_key]
	
	return time_left <= 0

## Called when Step is stopped, either because it is finished or because it is interrupted
func stop(agent:Agent):
	if usable != null:
		usable.finish_using(agent)

## Returns an adequate object from the [code]tree[/code] for this step attending to
## the [member object_group] and the [member object_selection_criterion]. If one of the distance
## related criteria is used, [code]nav_agent[/code] internal state is modified.
func find_target_object(agent : Agent):
	if info.object_group != "":
		var objects = agent.get_tree().get_nodes_in_group(info.object_group)
		match info.object_selection_criterion:
			StepInfo.ObjectSelectionCriteria.RANDOM:
				object = objects[randi() % objects.size()]
			_:
				object = _object_with_distance_criterion(objects, agent,
														info.object_selection_criterion)
	
	if object == null:
		return
	
	var usable_nodes = object.find_children("*", "Usable", false)
	if not usable_nodes.is_empty():
		usable = usable_nodes[0]


## Returns an object after applying one of the distance related critera
func _object_with_distance_criterion(objects : Array, agent: Agent,
									criterion: StepInfo.ObjectSelectionCriteria):
	var dists : Array = objects.map(func(obj):
			return _compute_path_distance(NavigationServer3D.map_get_path(
				agent.get_world_3d().navigation_map,
				agent.position,
				obj.position,
				true)
			)
			)
	var d
	match info.object_selection_criterion:
		StepInfo.ObjectSelectionCriteria.NEAREST:
			d = dists.min()
		StepInfo.ObjectSelectionCriteria.FURTHEST:
			d = dists.max()
		_:
			return null
	
	return objects[dists.find(d)]

## Computes the length of a path by adding the length of its segments
func _compute_path_distance(path: PackedVector3Array):
	var dist = 0
	for i in len(path)-1:
		dist += (path[i+1]-path[i]).length()
	return dist
