extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	await create_timer(0.2).timeout
	
	viewer.editor_panel.visible = false
	viewer.switch_monster("chieftain")
	viewer.m_chieftain.set_outfit(2)
	viewer.m_chieftain.play_anim("idle")
	
	for f in range(20):
		viewer.m_chieftain._process(0.016)
		await process_frame

	# 1. Front 3/4 full body shot
	viewer.yaw = 25.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 1.1, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("ogre_outfit2_new_front.png")
	
	# 2. Closeup of head, face, tusks and torso
	viewer.yaw = 15.0
	viewer.pitch = -2.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 1.4, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("ogre_outfit2_new_closeup.png")
	
	# 3. Side profile showing arm muscle, rerebrace, and flank straps
	viewer.yaw = 75.0
	viewer.pitch = -5.0
	viewer.camera_distance = 3.6
	viewer.camera_pivot.position = Vector3(0.0, 1.1, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("ogre_outfit2_new_side.png")
	
	# 4. Rear view showing spine spikes and thigh muscles
	viewer.yaw = 150.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 1.1, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.2).timeout
	_take_screenshot("ogre_outfit2_new_rear.png")
	
	quit(0)

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])

