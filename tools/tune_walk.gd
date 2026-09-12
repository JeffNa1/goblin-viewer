extends SceneTree

func _init() -> void:
	call_deferred("_test_walk")

func _test_walk() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	print("--- TUNING WALK BOB & STRIDE ---")
	var bob_amp = 0.020
	for i in range(16):
		var t = (float(i) / 16.0) * TAU
		var p = _compute_candidate_walk(t, 0.601, bob_amp)
		ogre._apply_pose(p)
		ogre.hips.force_update_transform()
		ogre.left_shin.force_update_transform()
		ogre.right_shin.force_update_transform()
		
		var l_y = _get_min_y(ogre.left_shin_mesh)
		var r_y = _get_min_y(ogre.right_shin_mesh)
		var plant_y = minf(l_y, r_y)
		print("t=%.2f (step %2d): L=%+5.1f mm | R=%+5.1f mm | Plant=%+5.1f mm" % [t, i, l_y*1000, r_y*1000, plant_y*1000])

		
	quit(0)

func _compute_candidate_walk(t: float, ground_hips_y: float, bob_amp: float) -> Dictionary:
	var p: Dictionary = {}
	var s_leg = sin(t)
	var c_leg = cos(t)
	
	# Bobbing: Lowest at max stride extension (-cos(2t)), highest at single support (+cos(2t))
	# Note: cos(2t) is +1 at t=0 and t=PI (max stride), and -1 at t=PI/2, 3PI/2.
	# So -cos(2t) dips at t=0 and t=PI!
	var bob = -cos(2.0 * t) * bob_amp
	var sway = s_leg * 0.038
	p["hips_pos"] = Vector3(sway, ground_hips_y + bob - 0.015, 0.0)
	
	p["hips_rot"] = Vector3(10.0 + cos(2.0 * t) * 1.5, s_leg * 7.0, -c_leg * 4.0)
	p["torso_rot"] = Vector3(12.0 - cos(2.0 * t) * 2.0, -s_leg * 6.0, c_leg * 3.0)
	p["head_rot"] = Vector3(-6.0 + cos(2.0 * t) * 1.5, -s_leg * 3.0, -c_leg * 2.0)
	
	# Left Leg:
	var thigh_l = -c_leg * 20.0
	var swing_l = pow(maxf(0.0, cos(t - 1.35 * PI)), 1.8) * 34.0
	var stance_l = pow(maxf(0.0, cos(t - 0.3 * PI)), 2.0) * 8.0
	p["left_thigh_rot"] = Vector3(thigh_l, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(6.5 + stance_l + swing_l, 0.0, 0.0)
	
	# Right Leg:
	var t_r = t + PI
	var thigh_r = -cos(t_r) * 20.0
	var swing_r = pow(maxf(0.0, cos(t_r - 1.35 * PI)), 1.8) * 34.0
	var stance_r = pow(maxf(0.0, cos(t_r - 0.3 * PI)), 2.0) * 8.0
	p["right_thigh_rot"] = Vector3(thigh_r, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(6.5 + stance_r + swing_r, 0.0, 0.0)
	
	return p

func _get_min_y(mi: MeshInstance3D) -> float:
	var min_y = 999.0
	var mesh: ArrayMesh = mi.mesh as ArrayMesh
	for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = mi.global_transform * v
		if wv.y < min_y: min_y = wv.y
	return min_y
