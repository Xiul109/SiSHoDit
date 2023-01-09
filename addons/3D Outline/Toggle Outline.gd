extends Node3D


# Just copy the "_toggle_outline" function and it should work in MOST cases (for more read the NOTICE below)

func _toggle_outline(value):
	var mesh_instance = $MeshInstance3D
	
	# loop trhow all materials attached to the MeshInstance3D and if they have a next_pass applied, toogle the shader_parameter "enable" = value
	for i in range(mesh_instance.get_surface_override_material_count()):
		if mesh_instance.get_surface_override_material(i).next_pass != null: # check if a next_pass is attached
			mesh_instance.get_surface_override_material(i).next_pass.set_shader_parameter("enable", value) # apply new value for "enable"
	
	# ! NOTICE ! This moethod isn't free of Errors. It assumes that all next_passes are the Outline Shader.
	# If you got a next_pass attached to a material which is used by the MeshInstance3D your are tying to toggle
	# the outline checked by using this method,
	# it should throw you an error, due to the fact that the next_pass doesn't have the shader_parameter "enable"
#
# This might be a rare case but shouldn't be underestimated.
