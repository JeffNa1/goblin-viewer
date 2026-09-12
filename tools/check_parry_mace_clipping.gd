extends SceneTree

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	var ogre: GoblinChieftain = viewer.m_chieftain
	ogre.set_process(false)
	
	print("--- CHECKING EXACT VERTEX INTERSECTION: MACE VS HEAD ---")
	ogre.play_anim("stagger")
	
	var num_steps = 100
	var dt = ogre.PARRY_DURATION / float(num_steps)
	
	# Sample vertices of mace (focus on stone head and spikes: Y in [0.20, 0.85])
	var mace_mesh: ArrayMesh = ogre.warhammer_mesh.mesh
	var mdata = mace_mesh.surface_get_arrays(0)
	var mace_verts: PackedVector3Array = mdata[Mesh.ARRAY_VERTEX]
	
	# Filter vertices of mace head
	var head_verts_filtered: Array = []
	for v in mace_verts:
		if v.y >= 0.20:
			head_verts_filtered.append(v)
			
	print("Mace head sample vertices: %d" % head_verts_filtered.size())
	
	var total_clips = 0
	
	for step in range(num_steps + 1):
		ogre._process(dt)
		await process_frame
		
		var t = ogre.action_time
		var head_xf = ogre.head.global_transform
		var mace_xf = ogre.warhammer_mesh.global_transform
		
		# For each vertex on mace head, transform into head local space
		var clipping_count = 0
		
		for mv in head_verts_filtered:
			var g_mv = mace_xf * mv
			var loc_mv = head_xf.affine_inverse() * g_mv
			
			# Check if loc_mv is inside the head bounding volume:
			# Head box: X in [-0.20, 0.20], Y in [-0.05, 0.52], Z in [-0.20, 0.20]
			if abs(loc_mv.x) < 0.20 and loc_mv.y > -0.05 and loc_mv.y < 0.52 and abs(loc_mv.z) < 0.20:
				clipping_count += 1
				
		if clipping_count > 0:
			print(">>> CLIPPING at t = %.3f s (tau = %.2f): %d mace vertices inside head!" % [t, t / ogre.PARRY_DURATION, clipping_count])
			total_clips += clipping_count
			
	if total_clips == 0:
		print("=======================================================")
		print("[PASS] 100% ZERO CLIPPING VERIFIED ACROSS 100 FRAMES!")
		print("=======================================================")
		quit(0)
	else:
		printerr("[FAIL] %d mace vertices clipped into head!" % total_clips)
		quit(1)

