extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	root.size = Vector2i(1600, 900)
	root.content_scale_size = Vector2i(1600, 900)
	root.msaa_3d = Viewport.MSAA_4X
	var scene = load("res://Rootbound_Sanctum/Art_Sample/sanctuary.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.hud.visible = false
	var records: Array = []
	var output = "res://Rootbound_Sanctum/Art_Sample/Renders/"
	DirAccess.make_dir_recursive_absolute(output)
	for view in ["shoulder", "corridor", "eye_level", "overview", "detail"]:
		scene.set_view(view)
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var image = root.get_texture().get_image()
		var path = output + view + ".png"
		var result = image.save_png(path)
		if result != OK:
			printerr("FAIL: Could not capture " + path)
			quit(1)
			return
		records.append({"view": view, "path": path, "width": image.get_width(), "height": image.get_height(), "camera_position": str(scene.camera.global_position), "camera_fov": scene.camera.fov})
		var manifest = FileAccess.open(output + "manifest.json", FileAccess.WRITE)
		manifest.store_string(JSON.stringify(records, "\t"))
		manifest.close()
		print("CAPTURED ", view, " ", image.get_width(), "x", image.get_height())
	print("RENDER_COMPLETE ", records.size(), " views; adapter=", RenderingServer.get_video_adapter_name())
	scene.queue_free()
	await process_frame
	quit(0)
