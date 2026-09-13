extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/1778e7a6-2511-494d-9c2a-487553413d1e"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var log_file = FileAccess.open("res://test_rogue_outfit3_log.txt", FileAccess.WRITE)
	log_file.store_line("=== TESTING GOBLIN ROGUE OUTFIT 3 (IMPERIAL GOLDEN ASSASSIN) ===")
	
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	for i in range(5):
		await process_frame
		
	viewer.editor_panel.visible = false
	viewer.switch_monster("rogue")
	viewer._select_outfit(3)
	
	await process_frame
	await process_frame
	
	var rogue: GoblinRogue = viewer.m_rogue
	assert(rogue != null, "Rogue instance must not be null")
	assert(rogue.current_outfit == 3, "Rogue current_outfit must be 3")
	log_file.store_line("SUCCESS: Switched to Outfit 3 (Imperial Golden Assassin)")
	
	# Verify all 12 mesh parts in outfit_meshes[3]
	var o3_meshes: Dictionary = rogue.outfit_meshes.get(3, {})
	var expected_keys = [
		"head", "torso", "left_arm", "left_forearm", "right_arm", "right_forearm",
		"left_dagger", "right_dagger", "left_thigh", "left_shin", "right_thigh", "right_shin"
	]
	
	var total_verts = 0
	for k in expected_keys:
		assert(o3_meshes.has(k), "Missing mesh key: " + k)
		var mesh: ArrayMesh = o3_meshes[k]
		assert(mesh != null, "Mesh must not be null for " + k)
		assert(mesh.get_surface_count() > 0, "Mesh must have surfaces for " + k)
		var arrays = mesh.surface_get_arrays(0)
		var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		assert(verts.size() > 0, "Mesh vertex count must be > 0 for " + k)
		total_verts += verts.size()
		log_file.store_line("  - Mesh [%s]: %d vertices" % [k, verts.size()])
		
	log_file.store_line("Total Outfit 3 Vertices: %d" % total_verts)
	assert(total_verts > 2000, "Outfit 3 should be rich and detailed (>2000 verts)")
	
	# Verify Animation Poses in Outfit 3
	for anim in ["idle", "dual_slash", "backstab", "parry", "hurt", "stunned"]:
		var p = rogue._compute_pose(anim, 0.2)
		assert(p.has("left_dagger_rot") and p.has("right_dagger_rot"), "Pose must have dagger rotations")
		log_file.store_line("  - Pose [%s] verified successfully" % anim)
		
	# Setup Camera & Render Screenshots
	# 1. Front Full-Body View
	viewer.yaw = 18.0
	viewer.pitch = -4.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("rogue_outfit3_front.png", log_file)
	
	# 2. Daggers & Gauntlets Close-Up
	viewer.yaw = -25.0
	viewer.pitch = -2.0
	viewer.camera_distance = 1.35
	viewer.camera_pivot.position = Vector3(0.18, 0.48, 0.1)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("rogue_outfit3_daggers_closeup.png", log_file)
	
	# 3. Rear View: Flowing Silk-Velvet Tassels & Back Armor
	viewer.yaw = 190.0
	viewer.pitch = -5.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("rogue_outfit3_rear.png", log_file)
	
	# 4. Action Pose: Dual Slash with Radiant Golden-Crimson Weapon Trails
	rogue.play_anim("dual_slash")
	rogue.anim_speed = 0.0
	rogue.action_time = 0.28
	var strike_pose = rogue._compute_dual_slash(0.28)
	rogue._apply_pose(strike_pose)
	rogue._update_weapon_trails(0.28)
	
	viewer.yaw = 35.0
	viewer.pitch = -6.0
	viewer.camera_distance = 2.5
	viewer.camera_pivot.position = Vector3(0.05, 0.55, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.25).timeout
	_take_screenshot("rogue_outfit3_action_strike.png", log_file)
	
	log_file.store_line("ALL ROGUE OUTFIT 3 TESTS & SCREENSHOTS COMPLETED SUCCESSFULLY!")
	log_file.close()
	quit(0)

func _take_screenshot(filename: String, log_file: FileAccess) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		var msg = "Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()]
		print(msg)
		log_file.store_line(msg)
	else:
		var msg = "Failed to capture image for " + filename
		printerr(msg)
		log_file.store_line(msg)
