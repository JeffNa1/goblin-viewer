extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var v_scene = load("res://scenes/viewer.tscn")
	var viewer = v_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	viewer.switch_monster("chieftain")
	await process_frame
	viewer._select_outfit(3)
	await process_frame
	await process_frame

	# Disable auto-rotate
	viewer.auto_rotate = false
	viewer.chk_auto_rotate.button_pressed = false

	var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/1778e7a6-2511-494d-9c2a-487553413d1e/"

	# 1. Front View (Full Body)
	viewer.yaw = 22.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position.y = 0.90
	viewer._update_camera_transform()
	for i in range(8): await process_frame
	
	var img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_full_front.png")
	print("[+] Saved ogre_outfit3_full_front.png")

	# 2. Close-up Head & Imperial Crown & Pectoral Sun Engine
	viewer.yaw = 18.0
	viewer.pitch = -2.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position.y = 1.25
	viewer._update_camera_transform()
	for i in range(8): await process_frame
	
	img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_portrait.png")
	print("[+] Saved ogre_outfit3_portrait.png")

	# 3. Imperial Sun-Shatterer Mace Detail View
	viewer.yaw = -28.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.3
	viewer.camera_pivot.position.y = 1.05
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("idle")
	for i in range(10): await process_frame

	img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_mace_detail.png")
	print("[+] Saved ogre_outfit3_mace_detail.png")

	# 4. Cleave Attack with Imperial Gold & Ruby Weapon Trail
	viewer.yaw = 32.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.5
	viewer.camera_pivot.position.y = 0.90
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("cleave")
	# Advance into mid-swing
	for i in range(22): await process_frame
	
	img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_cleave_trail.png")
	print("[+] Saved ogre_outfit3_cleave_trail.png")

	# 5. Rear / Cape View
	viewer.yaw = 195.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position.y = 0.95
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("idle")
	for i in range(10): await process_frame

	img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_cape_back.png")
	print("[+] Saved ogre_outfit3_cape_back.png")

	print("=== ALL 5 OGRE OUTFIT 3 SCREENSHOTS CAPTURED SUCCESSFULLY! ===")
	quit(0)
