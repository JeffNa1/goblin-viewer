extends SceneTree

var viewer: Node = null
var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/dee0e0b1-646b-4b32-99e0-a9b632535458"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	# Hide UI for clean cinematic presentation
	var ui = viewer.get_node_or_null("UI")
	if ui:
		ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false
		
	viewer.switch_monster("archer")
	viewer._select_outfit(3) # Switch to Outfit 3: Imperial Golden Marksman
	await _wait_frames(10)

	# 1. Full Body Idle Pose
	viewer.m_archer.play_anim("idle")
	viewer.yaw = 28.0
	viewer.pitch = -4.0
	viewer.camera_distance = 2.8
	viewer.camera_pivot.position = Vector3(0.0, 0.62, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("archer_outfit3_idle.png")

	# 2. Aiming Pose with Drawn Imperial Bow & Golden String
	viewer.m_archer.play_anim("aim")
	viewer.yaw = 42.0
	viewer.pitch = -5.0
	viewer.camera_distance = 2.8
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(30)
	_take_screenshot("archer_outfit3_aim.png")

	# 3. Close-up: Winged Crown, Targeting Monocle & Imperial Bow Details
	viewer.m_archer.play_anim("idle")
	viewer.yaw = 22.0
	viewer.pitch = -2.0
	viewer.camera_distance = 1.45
	viewer.camera_pivot.position = Vector3(-0.05, 0.72, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(25)
	_take_screenshot("archer_outfit3_details.png")

	# 4. Action: Shooting Pose
	viewer.m_archer.play_anim("shoot")
	viewer.yaw = 48.0
	viewer.pitch = -6.0
	viewer.camera_distance = 2.9
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)
	viewer._update_camera_transform()
	await _wait_frames(18)
	_take_screenshot("archer_outfit3_shoot.png")

	print(">>> ALL OUTFIT 3 SCREENSHOTS CAPTURED SUCCESSFULLY! <<<")
	quit(0)

func _wait_frames(n: int) -> void:
	for i in range(n):
		await process_frame
	await create_timer(0.12).timeout

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = out_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])
	else:
		printerr("Failed to get viewport image for %s" % filename)
