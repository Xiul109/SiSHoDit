extends State

var mesh_instance : MeshInstance3D
var mesh_texture = preload("res://addons/sishodit/assets/target_position.png")

func _ready():
	# Setting the mesh instance
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = QuadMesh.new()#ImmediateMesh.new()
	mesh_instance.mesh.size = Vector2(3.5,3.5)
	mesh_instance.top_level = true
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Setting the material
	var mesh_material = StandardMaterial3D.new()
	mesh_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mesh_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_material.no_depth_test = true
	mesh_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_material.albedo_texture = mesh_texture
	
	mesh_instance.mesh.surface_set_material(0, mesh_material)
	add_child(mesh_instance)

func on_process(_delta: float):
	if my_agent.nav_agent.is_navigation_finished():
		transitioned_to.emit("DoingStep")
		return

	var next_pos = my_agent.nav_agent.get_next_path_position()
	var vel = my_agent.speed*(next_pos-my_agent.global_position).normalized()
	
	if(vel.length() < 0.001):
		return
	
	my_agent.velocity = vel
	my_agent.move_and_slide()
	if abs(Vector3.UP.cross(vel).length()) > 0.001:
		my_agent.look_at(next_pos)
	


func on_enter():
	mesh_instance.position = my_agent.nav_agent.target_position

func on_exit():
	pass
