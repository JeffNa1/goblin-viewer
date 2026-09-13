extends SceneTree

var viewer: Node = null
var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	# Wait for viewer._ready() to fully complete
	await process_frame
	await process_frame
	await create_timer(0.2).timeout
	
	viewer.editor_panel.visible = false
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	var ogre: GoblinChieftain = viewer.m_chieftain
	ogre.set_outfit(2)
	ogre.anim_speed = 0.0 # freeze auto advance
	ogre.play_anim("cleave")
	
	var shots = [
		{"name": "ogre_outfit2_cleave_1_windup", "tau": 0.28, "yaw": 38.0, "pitch": -6.0, "dist": 3.8},
		{"name": "ogre_outfit2_cleave_2_sweep", "tau": 0.48, "yaw": -42.0, "pitch": -8.0, "dist": 3.8},
		{"name": "ogre_outfit2_cleave_3_follow", "tau": 0.66, "yaw": -68.0, "pitch": -6.0, "dist": 3.8}
	]
	
	for s in shots:
		viewer.yaw = s["yaw"]
		viewer.pitch = s["pitch"]
		viewer.camera_distance = s["dist"]
		viewer.camera_pivot.position = Vector3(0.0, 1.1, 0.0)
		viewer._update_camera_transform()
		
		var t = s["tau"] * ogre.CLEAVE_DURATION
		ogre.action_time = t
		ogre.is_blending = false
		var pose = ogre._compute_cleave(t)
		ogre._apply_pose(pose)
		
		await process_frame
		await process_frame
		await create_timer(0.2).timeout
		_take_screenshot(s["name"] + ".png")
		
	print("ALL OGRE CLEAVE SHOWCASE SHOTS CAPTURED")
	quit(0)

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = brain_dir + "/" + filename
		var err = img.save_png(path)
		print("Saved %s (code: %s, size: %dx%d)" % [path, err, img.get_width(), img.get_height()])
