extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	# Wait for init
	for i in range(5):
		await process_frame
		
	viewer.editor_panel.visible = false
	viewer.switch_monster("shaman")
	viewer._select_outfit(3)
	
	await process_frame
	await process_frame
	
	# 1. Front Full-Body View
	viewer.yaw = 15.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("shaman_outfit3_front.png")
	
	# 2. Side View - Staff Focus
	viewer.yaw = -65.0
	viewer.pitch = -3.0
	viewer.camera_distance = 2.8
	viewer.camera_pivot.position = Vector3(0.15, 0.8, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("shaman_outfit3_side_staff.png")
	
	# 3. Close-up: Enlarged Skull & Thick Horns
	viewer.yaw = 20.0
	viewer.pitch = -2.0
	viewer.camera_distance = 1.7
	viewer.camera_pivot.position = Vector3(0.0, 1.05, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("shaman_outfit3_skull_horns_closeup.png")
	
	# 4. Rear View: Imperial Cloak & Back Horns
	viewer.yaw = 185.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("shaman_outfit3_rear_cloak.png")
	
	# 5. Summon Action & Imperial Golden Totem Monolith
	viewer.m_shaman.play_anim("summon")
	viewer.m_shaman.anim_speed = 0.0
	viewer.m_shaman.action_time = 0.85 # Peak summon pose with glowing staff & totem
	viewer.m_shaman.is_blending = false
	var summon_pose = viewer.m_shaman._compute_summon(0.85)
	viewer.m_shaman._apply_pose(summon_pose)
	
	viewer.yaw = 35.0
	viewer.pitch = -8.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.5, 0.85, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.25).timeout
	_take_screenshot("shaman_outfit3_summon_totem.png")
	
	print("ALL SHAMAN OUTFIT 3 SCREENSHOTS CAPTURED SUCCESSFULLY")
	quit(0)

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])
	else:
		printerr("Failed to capture image for %s" % filename)
