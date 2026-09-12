extends SceneTree

var viewer: Node = null
var out_dir = "C:/Users/Administrator/goblin-viewer/showcase/public/assets/monsters"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	# Hide all UI for 100% clean cinematic renders
	var ui = viewer.get_node_or_null("UI")
	if ui:
		ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false

	# 1. WARRIOR
	viewer.switch_monster("warrior")
	viewer.m_warrior.play_anim("idle")
	viewer.yaw = 28.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(15)
	_take_screenshot("warrior_idle.png")
	
	viewer.m_warrior.play_anim("smash")
	viewer.yaw = 35.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.5
	viewer.camera_pivot.position = Vector3(0.0, 0.70, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("warrior_action.png")

	# 2. ARCHER
	viewer.switch_monster("archer")
	viewer._select_outfit(2) # Ranger outfit
	viewer.m_archer.play_anim("idle")
	viewer.yaw = 25.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(15)
	_take_screenshot("archer_idle.png")

	viewer.m_archer.play_anim("aim_shoot")
	viewer.yaw = 45.0
	viewer.pitch = -5.0
	viewer.camera_distance = 3.3
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(20)
	_take_screenshot("archer_action.png")

	# 3. SHAMAN
	viewer.switch_monster("shaman")
	viewer._select_outfit(2) # Grand Arch-Shaman with 3D Cloak
	viewer.m_shaman.play_anim("idle")
	viewer.yaw = 26.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(15)
	_take_screenshot("shaman_idle.png")

	viewer.m_shaman.play_anim("chant")
	viewer.yaw = -20.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.4
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("shaman_action.png")

	# 4. ROGUE
	viewer.switch_monster("rogue")
	viewer.m_rogue.play_anim("idle")
	viewer.yaw = 30.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.0
	viewer.camera_pivot.position = Vector3(0.0, 0.60, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(15)
	_take_screenshot("rogue_idle.png")

	viewer.m_rogue.play_anim("dual_slash")
	viewer.yaw = 38.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.3
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("rogue_action.png")

	# 5. MACE OGRE (BOSS)
	viewer.switch_monster("chieftain")
	viewer.m_chieftain.play_anim("idle")
	viewer.yaw = 26.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.8
	viewer.camera_pivot.position = Vector3(0.0, 1.15, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(20)
	_take_screenshot("ogre_idle.png")

	viewer.m_chieftain.play_anim("earthshaker")
	viewer.yaw = 36.0
	viewer.pitch = -7.0
	viewer.camera_distance = 5.6
	viewer.camera_pivot.position = Vector3(0.0, 1.45, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(30)
	_take_screenshot("ogre_action.png")

	print(">>> ALL SHOWCASE MONSTER ASSETS CAPTURED SUCCESSFULLY! <<<")
	quit(0)

func _wait_frames(n: int) -> void:
	for i in range(n):
		await process_frame
	await create_timer(0.15).timeout

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = out_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])
	else:
		printerr("Failed to get viewport image for %s" % filename)
