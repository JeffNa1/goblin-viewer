extends SceneTree

func _init() -> void:
	call_deferred("_debug_leg")

func _debug_leg() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	for test_y in [0.587, 0.588, 0.589, 0.590]:
		ogre.ground_hips_y = test_y
		ogre.play_anim("shoulder")
		ogre._process(0.5)
		await process_frame
		
		var min_world_v = Vector3(0, 999, 0)
		for mi in [ogre.left_shin_mesh, ogre.right_shin_mesh]:
			var mesh: ArrayMesh = mi.mesh as ArrayMesh
			var verts = mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			for v in verts:
				var wv = mi.global_transform * v
				if wv.y < min_world_v.y:
					min_world_v = wv
				
		print("ground_hips_y = %.4f -> Lowest foot vertex Y = %+.5f m (%.2f mm)" % [test_y, min_world_v.y, min_world_v.y * 1000.0])
		
	quit(0)
