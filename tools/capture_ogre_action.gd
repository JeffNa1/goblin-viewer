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

	viewer.auto_rotate = false
	viewer.chk_auto_rotate.button_pressed = false

	var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/1778e7a6-2511-494d-9c2a-487553413d1e/"

	# 1. Earthshaker Impact Frame (Địa Chấn)
	viewer.yaw = 28.0
	viewer.pitch = -12.0
	viewer.camera_distance = 4.8
	viewer.camera_pivot.position.y = 0.70
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("earthshaker")
	for i in range(25): await process_frame
	
	var img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_earthshaker.png")
	print("[+] Saved ogre_outfit3_earthshaker.png")

	# 2. Roar Stance (Gầm Thét)
	viewer.yaw = 15.0
	viewer.pitch = -6.0
	viewer.camera_distance = 3.8
	viewer.camera_pivot.position.y = 1.05
	viewer._update_camera_transform()
	viewer.current_monster_node.play_anim("roar")
	for i in range(24): await process_frame

	img = root.get_viewport().get_texture().get_image()
	img.save_png(out_dir + "ogre_outfit3_roar.png")
	print("[+] Saved ogre_outfit3_roar.png")

	print("=== ACTION SHOTS CAPTURED! ===")
	quit(0)
