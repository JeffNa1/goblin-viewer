extends SceneTree

func _init() -> void:
	call_deferred("_test_grounded_stance")

func _test_grounded_stance() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	ogre.set_process(false)
	
	for hips_y in [0.6010, 0.6014, 0.6015, 0.6020]:
		var pose = {
			"hips_pos": Vector3(0.0, hips_y, 0.0),
			"hips_rot": Vector3(4.0, 0.0, 0.0),
			"left_thigh_rot": Vector3(-4.0, 0.0, -6.0),
			"left_shin_rot": Vector3(8.0, 0.0, 0.0),
			"right_thigh_rot": Vector3(4.0, 0.0, 6.0),
			"right_shin_rot": Vector3(6.0, 0.0, 0.0)
		}
		ogre._apply_pose(pose)
		ogre.hips.force_update_transform()
		ogre.left_shin.force_update_transform()
		ogre.right_shin.force_update_transform()
		
		var min_y = 999.0
		for mi in [ogre.left_shin_mesh, ogre.right_shin_mesh]:
			var mesh: ArrayMesh = mi.mesh as ArrayMesh
			var verts = mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			for v in verts:
				var wv = mi.global_transform * v
				if wv.y < min_y:
					min_y = wv.y
		print("hips_y = %.4f -> lowest foot vertex Y = %+.5f m (%.2f mm)" % [hips_y, min_y, min_y * 1000.0])
		
	quit(0)
