extends State

@export var mesh_material = preload("res://addons/sishodit/assets/target_material.tres")
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
	# If the agent has reached its objective, transition to [i]DoingStep[/i]
	if my_agent.nav_agent.is_navigation_finished():
		transitioned_to.emit("DoingStep")
		return
	
	# If not the agent will move towards the next_position
	var next_pos = my_agent.nav_agent.get_next_path_position()
	var vel = my_agent.speed*(next_pos-my_agent.global_position).normalized()
	
	my_agent.velocity = vel
	my_agent.move_and_slide()
	# To avoid errors, [method Agent.look_at] is only called when it is not parallel or very close
	# to UP vector
	if abs(Vector3.UP.cross(vel).length()) > 0.001:
		my_agent.look_at(next_pos)


func on_enter():
	# When this state enters the machine, it sets the target mesh position to the agent destination
	mesh_instance.position = my_agent.to

