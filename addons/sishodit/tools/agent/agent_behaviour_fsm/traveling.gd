extends State

## If the [Agent] is closest to the target object than this distance, it will check if it is in use.
## It should be big enought to avoid colliding to another object.
@export var check_distance : float = 10

@export_group("Visual feedback")
## Texture to show on top of the target position.
@export var mesh_material = preload("res://addons/sishodit/assets/target_material.tres")
## Size of the texture shown on top of the target position.
@export var size = Vector2(4, 4)

var mesh_instance : MeshInstance3D

func _ready():
	# Setting the mesh instance that will hightlight the target of the agent
	mesh_instance = MeshInstance3D.new()
	mesh_instance.top_level = true
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	mesh_instance.mesh = QuadMesh.new()
	mesh_instance.mesh.size = size
	mesh_instance.mesh.surface_set_material(0, mesh_material)
	
	add_child(mesh_instance)


func on_process(_delta: float):
	var nav_agent = my_agent.nav_agent
	var object = my_agent.current_steps.back().object
	# If the item is being used, transition to [i]ObjectInUse[i]
	if (my_agent.global_position.distance_to(nav_agent.get_final_position()) <= check_distance and 
		object != null and
		not object.find_children("*", "ObjectUser", false, false).is_empty()):
			transitioned_to.emit("ObjectInUse")
			return
	# If the agent has reached its objective, transition to [i]DoingStep[/i]
	elif nav_agent.is_navigation_finished():
		transitioned_to.emit("DoingStep")
		my_agent.current_needs.back().timeout = 0
		return
	
	# If not the agent will move towards the next_position
	var next_pos = nav_agent.get_next_path_position()
	var vel = my_agent.speed*(next_pos-my_agent.global_position).normalized()
	
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(vel)
	else:
		my_agent._on_velocity_computed(vel)

	# To avoid errors, [method Agent.look_at] is only called when it is not parallel or very close
	# to UP vector
	if abs(Vector3.UP.cross(vel).length()) > 0.001:
		my_agent.look_at(next_pos)


func on_enter():
	# When this state enters the machine, it sets the target mesh position to the agent destination
	mesh_instance.position = my_agent.to

