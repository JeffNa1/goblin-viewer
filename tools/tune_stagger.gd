extends SceneTree

func _init() -> void:
	call_deferred("_test_stagger")

func _test_stagger() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	print("--- TUNING STAGGER KNEE DROP HEIGHT ---")
	
	for hips_y in [0.550, 0.560, 0.570, 0.580]:
		var pose = {
			"hips_pos": Vector3(0.0, hips_y, -0.10),
			"hips_rot": Vector3(14.0, 0.0, 0.0),
			"left_thigh_rot": Vector3(-12.0, 0.0, -8.0),
			"left_shin_rot": Vector3(18.0, 0.0, 0.0),
			"right_thigh_rot": Vector3(16.0, 0.0, 7.0),
			"right_shin_rot": Vector3(14.0, 0.0, 0.0)
		}
		ogre._apply_pose(pose)
		ogre.hips.force_update_transform()
		ogre.left_thigh.force_update_transform()
		ogre.left_shin.force_update_transform()
		ogre.right_thigh.force_update_transform()
		ogre.right_shin.force_update_transform()
		
		var l_y = 999.0
		for mi in [ogre.left_thigh_mesh, ogre.left_shin_mesh]:
			var mesh: ArrayMesh = mi.mesh as ArrayMesh
			for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
				var wv = mi.global_transform * v
				if wv.y < l_y: l_y = wv.y
				
		var r_y = 999.0
		for mi in [ogre.right_thigh_mesh, ogre.right_shin_mesh]:
			var mesh: ArrayMesh = mi.mesh as ArrayMesh
			for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
				var wv = mi.global_transform * v
				if wv.y < r_y: r_y = wv.y
			
		print("hips_y=%.3f -> Left Foot Y=%+6.1f mm | Right Leg Y=%+6.1f mm" % [
			hips_y, l_y * 1000.0, r_y * 1000.0
		])
		
	quit(0)
