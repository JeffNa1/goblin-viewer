extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/75728a4d-fc04-43bb-a8c4-d7f4280ff39e"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	viewer.editor_panel.visible = false
	viewer.switch_monster("chieftain")
	
	# Shot 1: Front 3/4 Full Body - Idle / Shoulder Stance
	viewer.m_chieftain.play_anim("idle")
	viewer.yaw = 28.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 0.95, 0.0)
	viewer._update_camera_transform()
	for f in range(25):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.3).timeout
	_take_screenshot("mace_ogre_full_body_idle.png")
	
	# Shot 2: Close-up Head & Torso - Tusks, Horns, Bone Piercing, Fur Pelt, Scars
	viewer.yaw = 20.0
	viewer.pitch = -2.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 1.4, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.3).timeout
	_take_screenshot("mace_ogre_head_closeup.png")
	
	# Shot 3: Weapon Close-up - Primitive Great Mace
	viewer.yaw = -25.0
	viewer.pitch = -4.0
	viewer.camera_distance = 2.8
	viewer.camera_pivot.position = Vector3(0.5, 1.2, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.3).timeout
	_take_screenshot("mace_ogre_mace_closeup.png")
	
	# Shot 4: Action Pose - Earthshaker Slam
	viewer.m_chieftain.play_anim("earthshaker")
	viewer.yaw = 40.0
	viewer.pitch = -8.0
	viewer.camera_distance = 4.4
	viewer.camera_pivot.position = Vector3(0.0, 0.9, 0.0)
	viewer._update_camera_transform()
	for f in range(35):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.3).timeout
	_take_screenshot("mace_ogre_earthshaker.png")
	
	print("ALL MACE OGRE SCREENSHOTS CAPTURED")
	quit(0)

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])
	else:
		printerr("Failed to get viewport image for %s" % filename)
