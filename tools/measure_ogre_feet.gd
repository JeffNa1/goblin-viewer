extends SceneTree

func _init() -> void:
	call_deferred("_measure")

func _measure() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	ogre.ground_hips_y = 0.601
	print("--- TESTING STANCES AT ground_hips_y = 0.601 ---")
	for s_name in ["shoulder", "ground", "guard"]:
		ogre.current_stance = s_name
		ogre.play_anim(s_name)
		ogre._process(0.5)
		ogre.anim_time = 0.0
		ogre._process(0.0)
		await process_frame
		var min_y = _get_min_foot_y(ogre)
		print("Stance [%-10s]: lowest foot vertex Y = %+.5f m (%.2f mm)" % [s_name, min_y, min_y * 1000.0])
		
	quit(0)

func _get_min_foot_y(ogre: GoblinChieftain) -> float:
	var min_y: float = 999.0
	for mi in [ogre.left_shin_mesh, ogre.right_shin_mesh]:
		var mesh: ArrayMesh = mi.mesh as ArrayMesh
		var xform = mi.global_transform
		var arrays = mesh.surface_get_arrays(0)
		var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		for v in verts:
			var world_v = xform * v
			if world_v.y < min_y:
				min_y = world_v.y
	return min_y
