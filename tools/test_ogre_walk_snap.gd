extends SceneTree

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	var ui = viewer.get_node_or_null("UI")
	if ui: ui.visible = false
	if viewer.editor_panel: viewer.editor_panel.visible = false
	
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	viewer.m_chieftain.play_anim("walk")
	viewer.yaw = 26.0
	viewer.pitch = -6.0
	viewer.camera_distance = 4.8
	viewer.camera_pivot.position = Vector3(0.0, 1.15, 0.0)
	viewer._update_camera_transform()
	
	for i in range(30):
		viewer.m_chieftain._process(0.033)
		await process_frame
		
	var vp = root.get_viewport()
	var img = vp.get_texture().get_image()
	img.save_png("tools/test_ogre_walk_snap.png")
	print("Saved test_ogre_walk_snap.png")
	quit(0)
