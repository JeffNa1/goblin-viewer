extends SceneTree

var viewer: Node = null
var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/1778e7a6-2511-494d-9c2a-487553413d1e"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	var ui = viewer.get_node_or_null("UI")
	if ui:
		ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false
		
	viewer.switch_monster("chieftain")
	viewer._select_outfit(3)
	await _wait_frames(10)

	# 1. Full Body Idle Pose
	viewer.m_chieftain.play_anim("idle")
	viewer.yaw = 28.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 1.2, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("ogre_current_outfit3_idle.png")

	# 2. Close up
	viewer.yaw = 15.0
	viewer.pitch = -2.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 1.5, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("ogre_current_outfit3_close.png")

	# 3. Roar
	viewer.m_chieftain.play_anim("roar")
	viewer.yaw = 35.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 1.2, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(30)
	_take_screenshot("ogre_current_outfit3_roar.png")

	# 4. Cleave
	viewer.m_chieftain.play_anim("cleave")
	viewer.yaw = 45.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 1.2, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(35)
	_take_screenshot("ogre_current_outfit3_cleave.png")

	print("Captured screenshots successfully!")
	quit()

func _take_screenshot(filename: String) -> void:
	var image = root.get_viewport().get_texture().get_image()
	var path = out_dir + "/" + filename
	var err = image.save_png(path)
	if err == OK:
		print("Saved screenshot: ", path)
	else:
		print("Failed to save screenshot: ", err)

func _wait_frames(count: int) -> void:
	for i in range(count):
		await process_frame
