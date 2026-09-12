extends SceneTree

func _init() -> void:
	call_deferred("_run_tuner")

func _run_tuner() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	print("--- TUNING SYMMETRICAL SHOULDERS ---")
	for thigh_pitch in [-4.0, -3.0, -2.0, -1.0, 0.0]:
		for shin_pitch in [4.0, 5.0, 6.0, 7.0]:
			var pose = {
				"hips_pos": Vector3(0.0, 0.6015, 0.0),
				"hips_rot": Vector3(4.0, 0.0, 0.0),
				"left_thigh_rot": Vector3(thigh_pitch, 0.0, -6.0),
				"left_shin_rot": Vector3(shin_pitch, 0.0, 0.0),
				"right_thigh_rot": Vector3(thigh_pitch, 0.0, 6.0),
				"right_shin_rot": Vector3(shin_pitch, 0.0, 0.0)
			}
			ogre._apply_pose(pose)
			ogre.hips.force_update_transform()
			ogre.left_shin.force_update_transform()
			ogre.right_shin.force_update_transform()
			var l_y = _get_min_y(ogre.left_shin_mesh)
			var r_y = _get_min_y(ogre.right_shin_mesh)
			if abs(l_y) < 0.005 and abs(r_y) < 0.005:
				print("MATCH! thigh_pitch=%.1f shin_pitch=%.1f -> L=%+.4f m (%+.1f mm), R=%+.4f m (%+.1f mm)" % [
					thigh_pitch, shin_pitch, l_y, l_y*1000, r_y, r_y*1000
				])
				
	quit(0)

func _get_min_y(mi: MeshInstance3D) -> float:
	var min_y = 999.0
	var mesh: ArrayMesh = mi.mesh as ArrayMesh
	for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = mi.global_transform * v
		if wv.y < min_y: min_y = wv.y
	return min_y
