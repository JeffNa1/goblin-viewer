extends SceneTree

func _init() -> void:
	call_deferred("_audit")

func _audit() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	var anims = ["shoulder", "ground", "guard", "walk", "roar", "earthshaker", "whirlwind", "stagger", "stunned"]
	print("==========================================================")
	print("FINAL AUDIT: OGRE FOOT GROUND CONTACT IN ENGINE")
	print("==========================================================")
	print("Initial ground_hips_y = ", ogre.ground_hips_y)
	
	for anim in anims:
		ogre.play_anim(anim)
		ogre.action_time = 0.0
		ogre.anim_time = 0.0
		# Fast forward blend
		ogre.is_blending = false
		
		var duration = 1.0
		match anim:
			"walk": duration = 2.5
			"roar": duration = ogre.ROAR_DURATION
			"earthshaker": duration = ogre.EARTHSHAKER_DURATION
			"whirlwind": duration = ogre.WHIRLWIND_DURATION
			"stagger": duration = ogre.STAGGER_DURATION
			"stunned": duration = 2.8
			_: duration = 1.0
			
		var min_seen = 999.0
		var max_seen = -999.0
		var num_samples = 25
		var dt = duration / float(num_samples)
		
		for i in range(num_samples + 1):
			ogre._process(dt)
			await process_frame
			var l_y = _get_min_y(ogre.left_shin_mesh)
			var r_y = _get_min_y(ogre.right_shin_mesh)
			var lowest = minf(l_y, r_y)
			
			# Exclude mid-air airborne phase of earthshaker leap
			if anim == "earthshaker" and ogre.action_time >= 0.35 and ogre.action_time <= 0.85:
				pass
			else:
				if lowest < min_seen: min_seen = lowest
				if lowest > max_seen: max_seen = lowest
				
		print("Anim %-12s: Lowest Planted Foot Y = [%+6.2f mm to %+6.2f mm]" % [
			anim, min_seen * 1000.0, max_seen * 1000.0
		])
		
	quit(0)

func _get_min_y(mi: MeshInstance3D) -> float:
	var min_y = 999.0
	var mesh: ArrayMesh = mi.mesh as ArrayMesh
	for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = mi.global_transform * v
		if wv.y < min_y: min_y = wv.y
	return min_y
