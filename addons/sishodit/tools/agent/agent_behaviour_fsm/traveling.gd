extends State

var mesh_instance : MeshInstance3D

func on_process(_delta: float):
	if my_agent.nav_agent.is_target_reached():
		transitioned_to.emit("DoingStep")
		return
	
	_draw_path(my_agent.nav_agent.get_current_navigation_path())
	var next_pos = my_agent.nav_agent.get_next_path_position()
	var vel = my_agent.speed*(next_pos-my_agent.global_position).normalized()
	
	if(vel.length() < 0.001):
		return
	
	my_agent.velocity = vel
	my_agent.move_and_slide()
	if abs(Vector3.UP.cross(vel).length()) > 0.001:
		my_agent.look_at(next_pos)

func on_enter():
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = ImmediateMesh.new()
	mesh_instance.cast_shadow = false
	
	get_tree().get_root().add_child.call_deferred(mesh_instance)

func on_exit():
	pass

## Aux functions ##
func _draw_path(path: PackedVector3Array, color = Color.RED) -> MeshInstance3D:
	var mesh = mesh_instance.mesh as ImmediateMesh
	var material := ORMMaterial3D.new()
	mesh.clear_surfaces()

	for i in path.size()-1:
		mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		mesh.surface_add_vertex(path[i])
		mesh.surface_add_vertex(path[i+1])
		mesh.surface_end()	
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	return mesh_instance
