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

	# 1. Front View
	viewer.yaw = 25.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position.y = 0.85
	viewer._update_camera_transform()
	for i in range(5): await process_frame
	
	var img = root.get_viewport().get_texture().get_image()
	img.save_png("C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20/ogre_outfit3_front.png")
	print("[+] Saved ogre_outfit3_front.png")

	# 2. Close-up Head & Cuirass View
	viewer.yaw = 15.0
	viewer.pitch = -2.0
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position.y = 1.15
	viewer._update_camera_transform()
	for i in range(5): await process_frame
	
	img = root.get_viewport().get_texture().get_image()
	img.save_png("C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20/ogre_outfit3_closeup.png")
	print("[+] Saved ogre_outfit3_closeup.png")

	# 3. Action / Cleave View
	viewer.yaw = 35.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.5
	viewer.camera_pivot.position.y = 0.85
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("cleave")
	# Advance 20 frames into animation
	for i in range(20): await process_frame
	
	img = root.get_viewport().get_texture().get_image()
	img.save_png("C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20/ogre_outfit3_cleave.png")
	print("[+] Saved ogre_outfit3_cleave.png")

	# 4. Mace Detail View
	viewer.yaw = -25.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position.y = 0.95
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("idle")
	for i in range(10): await process_frame

	img = root.get_viewport().get_texture().get_image()
	img.save_png("C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20/ogre_outfit3_mace.png")
	print("[+] Saved ogre_outfit3_mace.png")

	print("ALL SCREENSHOTS CAPTURED!")
	quit(0)
