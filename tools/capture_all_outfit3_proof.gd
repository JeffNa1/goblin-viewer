extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var v_scene = load("res://scenes/viewer.tscn")
	var viewer = v_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame

	viewer.auto_rotate = false
	viewer.chk_auto_rotate.button_pressed = false

	var brain_dir = "C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20"
	var monsters = ["warrior", "archer", "shaman", "rogue", "chieftain"]

	for m in monsters:
		viewer.switch_monster(m)
		await process_frame
		viewer._select_outfit(3)
		await process_frame
		await process_frame
		
		# Reset camera per monster
		viewer.reset_camera()
		viewer.yaw = 22.0
		viewer.pitch = -4.0
		if m == "chieftain":
			viewer.camera_distance = 4.2
			viewer.camera_pivot.position.y = 0.85
		else:
			viewer.camera_distance = 2.6
			viewer.camera_pivot.position.y = 0.65
		viewer._update_camera_transform()
		
		for i in range(12): await process_frame
		
		var img = root.get_viewport().get_texture().get_image()
		var out_path = brain_dir + "/" + m + "_outfit3_proof.png"
		img.save_png(out_path)
		print("[+] Captured Outfit 3 for ", m, " -> ", out_path)

	print("ALL 5 OUTFIT 3 PROOF SCREENSHOTS CAPTURED!")
	quit(0)
