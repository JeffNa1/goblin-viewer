extends SceneTree

func _init() -> void:
	call_deferred("_test")

func _test() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	print("--- TUNING STANCES ---")
	# 1. SHOULDER:
	# ground_hips_y = 0.6015
	# left_thigh = (-4, 0, -6), left_shin = (8, 0, 0)
	# right_thigh = (4, 0, 6), right_shin = (6, 0, 0)
	var pose_shoulder = {
		"hips_pos": Vector3(0.0, 0.6015, 0.0),
		"hips_rot": Vector3(4.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-4.0, 0.0, -6.0),
		"left_shin_rot": Vector3(8.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(4.0, 0.0, 6.0),
		"right_shin_rot": Vector3(6.0, 0.0, 0.0)
	}
	_eval_pose(ogre, "Shoulder", pose_shoulder)
	
	# 2. GROUND: Mace planted on earth. Weight shifted slightly to right leg.
	# Hips shifted right (+0.02, 0.6015, 0.0)
	# Right leg straight/braced: right_thigh = (0, 0, 4), right_shin = (4, 0, 0)
	# Left leg casual kickstand: left_thigh = (-8, 0, -8), left_shin = (12, 0, 0)
	for test_hips_y in [0.6015, 0.602, 0.600]:
		var pose_ground = {
			"hips_pos": Vector3(0.02, test_hips_y, 0.0),
			"hips_rot": Vector3(3.0, 4.0, -2.0),
			"left_thigh_rot": Vector3(-8.0, 0.0, -8.0),
			"left_shin_rot": Vector3(12.0, 0.0, 0.0),
			"right_thigh_rot": Vector3(0.0, 0.0, 4.0),
			"right_shin_rot": Vector3(4.0, 0.0, 0.0)
		}
		_eval_pose(ogre, "Ground (hips_y=%.4f)" % test_hips_y, pose_ground)
		
	# 3. GUARD: Deep battle crouch. Left foot forward, right foot back.
	# To keep feet grounded when knees bend, what hips_y is needed?
	for test_hips_y in [0.575, 0.580, 0.585, 0.590]:
		var pose_guard = {
			"hips_pos": Vector3(0.0, test_hips_y, 0.0),
			"hips_rot": Vector3(8.0, 0.0, 0.0),
			"left_thigh_rot": Vector3(-16.0, 0.0, -8.0),
			"left_shin_rot": Vector3(22.0, 0.0, 0.0),
			"right_thigh_rot": Vector3(12.0, 0.0, 8.0),
			"right_shin_rot": Vector3(16.0, 0.0, 0.0)
		}
		_eval_pose(ogre, "Guard (hips_y=%.4f)" % test_hips_y, pose_guard)

	quit(0)

func _eval_pose(ogre: GoblinChieftain, label: String, pose: Dictionary) -> void:
	ogre._apply_pose(pose)
	ogre.hips.force_update_transform()
	ogre.left_shin.force_update_transform()
	ogre.right_shin.force_update_transform()
	
	var min_l = 999.0
	var l_mesh: ArrayMesh = ogre.left_shin_mesh.mesh as ArrayMesh
	for v in l_mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = ogre.left_shin_mesh.global_transform * v
		if wv.y < min_l: min_l = wv.y
		
	var min_r = 999.0
	var r_mesh: ArrayMesh = ogre.right_shin_mesh.mesh as ArrayMesh
	for v in r_mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		var wv = ogre.right_shin_mesh.global_transform * v
		if wv.y < min_r: min_r = wv.y
		
	print("%-24s: Left Foot Y = %+.5f m (%+.1f mm) | Right Foot Y = %+.5f m (%+.1f mm)" % [
		label, min_l, min_l * 1000.0, min_r, min_r * 1000.0
	])
