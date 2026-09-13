extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/26739e25-6360-4de3-a46b-386f58c284da"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	print("========================================")
	print("💀 SKELETON WARRIOR SHOWCASE CAPTURE")
	print("========================================")

	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	# Wait for scene tree and voxel meshes to finish building
	for i in range(10):
		await process_frame
		
	viewer.editor_panel.visible = false
	viewer.switch_monster("skeleton")
	
	for i in range(5):
		await process_frame
		
	var sk = viewer.m_skeleton
	assert(sk != null, "Skeleton monster node is null!")
	print("  ✓ Switched to Skeleton Warrior successfully!")
	print("  ✓ Current animation: %s, Current stance: %s" % [sk.current_anim, sk.current_stance])
	
	# ----------------------------------------------------
	# 1. Front Full-Body View (Ready Stance)
	# ----------------------------------------------------
	sk.play_anim("idle")
	sk.set_stance("ready")
	viewer.yaw = 22.0
	viewer.pitch = -5.0
	viewer.camera_distance = 2.9
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.35).timeout
	_take_screenshot("skeleton_idle_front.png")
	
	# ----------------------------------------------------
	# 2. Close-up on Skull, Ribcage, Notched Sword & Wooden Shield
	# ----------------------------------------------------
	viewer.yaw = 18.0
	viewer.pitch = -3.0
	viewer.camera_distance = 1.75
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.35).timeout
	_take_screenshot("skeleton_gear_closeup.png")
	
	# ----------------------------------------------------
	# 3. Action Pose: Slash (Chém Kiếm Cũ với Ghostly Weapon Trail)
	# ----------------------------------------------------
	sk.play_anim("slash")
	sk.anim_speed = 0.0
	sk.action_time = 0.42 # Apex swing pose with extended blade
	sk.is_blending = false
	var slash_pose = sk._compute_slash(0.42)
	sk._apply_pose(slash_pose)
	
	viewer.yaw = 35.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.0
	viewer.camera_pivot.position = Vector3(0.0, 0.68, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.35).timeout
	_take_screenshot("skeleton_action_slash.png")
	
	# ----------------------------------------------------
	# 4. Action Pose: Defensive Block (Chắn Khiên Gỗ)
	# ----------------------------------------------------
	sk.play_anim("block")
	sk.anim_speed = 0.0
	sk.action_time = 0.50 # Solid defensive brace with raised shield
	sk.is_blending = false
	var block_pose = sk._compute_block(0.50)
	sk._apply_pose(block_pose)
	
	viewer.yaw = -30.0
	viewer.pitch = -4.0
	viewer.camera_distance = 2.8
	viewer.camera_pivot.position = Vector3(-0.05, 0.66, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.35).timeout
	_take_screenshot("skeleton_action_block.png")
	
	# ----------------------------------------------------
	# 5. Rear View: Spinal Column, Scapulae & Pelvis
	# ----------------------------------------------------
	sk.play_anim("idle")
	sk.set_stance("high_guard")
	sk.anim_speed = 1.0
	sk.is_blending = false
	var idle_pose = sk._compute_idle(0.0)
	sk._apply_pose(idle_pose)
	
	viewer.yaw = 195.0
	viewer.pitch = -7.0
	viewer.camera_distance = 2.85
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.35).timeout
	_take_screenshot("skeleton_rear_spine.png")
	
	print("\n🎉 ALL 5 SKELETON SHOWCASE SCREENSHOTS CAPTURED SUCCESSFULLY!")
	quit(0)

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		print("  ✓ Saved %s (err: %s, %dx%d)" % [filename, err, img.get_width(), img.get_height()])
	else:
		printerr("Failed to capture image for %s" % filename)
