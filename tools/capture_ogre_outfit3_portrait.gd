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

	viewer.auto_rotate = false
	viewer.chk_auto_rotate.button_pressed = false

	# Head Portrait
	viewer.yaw = 20.0
	viewer.pitch = -3.0
	viewer.camera_distance = 1.9
	viewer.camera_pivot.position.y = 1.55
	viewer._update_camera_transform()
	for i in range(10): await process_frame
	
	var img = root.get_viewport().get_texture().get_image()
	img.save_png("C:/Users/Administrator/.gemini/antigravity/brain/54c73c44-ee29-4a92-aca0-7765050ddc20/ogre_outfit3_head_portrait.png")
	print("[+] Saved ogre_outfit3_head_portrait.png")
	quit(0)
