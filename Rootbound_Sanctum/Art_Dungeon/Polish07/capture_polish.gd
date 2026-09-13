extends SceneTree

const OUTPUT = "res://Rootbound_Sanctum/Art_Dungeon/Polish07/Renders/"
const VIEWS = ["shoulder", "eye_level", "overview", "carving", "fountain", "corridor"]

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var phase = OS.get_cmdline_user_args()[0]
	var destination = OUTPUT + phase + "/"
	DirAccess.make_dir_recursive_absolute(destination)
	root.size = Vector2i(1600, 900)
	root.content_scale_size = Vector2i(1600, 900)
	root.msaa_3d = Viewport.MSAA_4X
	var scene = load("res://Rootbound_Sanctum/Art_Dungeon/dungeon.tscn").instantiate()
	root.add_child(scene)
	while not scene.built:
		await process_frame
	scene.hud.visible = false
	var records: Array = []
	for view in VIEWS:
		scene.select_room("07", view if view in scene.VIEW_NAMES else "eye_level")
		var origin: Vector3 = scene.rooms["07"].position
		match view:
			"carving":
				scene.camera.position = origin + Vector3(6.7, 2.6, -4.8)
				scene.camera.look_at(origin + Vector3(4.35, 3.0, -9.7))
				scene.camera.fov = 58.0
			"fountain":
				scene.camera.position = origin + Vector3(3.6, 1.65, -0.7)
				scene.camera.look_at(origin + Vector3(0, 2.4, -4.0))
			"corridor":
				scene.figure.visible = true
				scene.figure.position = origin + Vector3(-0.45, 0.024, 15.4)
				scene.figure.rotation.y = 0
				scene.camera.position = scene.figure.position + Vector3(0.62, 1.68, 1.75)
				scene.camera.look_at(origin + Vector3(0, 2, -3))
				scene.passages.visible = true
		for frame in range(10):
			await process_frame
		await RenderingServer.frame_post_draw
		var image = root.get_texture().get_image()
		var path = destination + view + ".png"
		if image.save_png(path) != OK:
			printerr("FAIL: Could not capture " + path)
			quit(1)
			return
		records.append({"room": "07", "view": view, "phase": phase, "path": path, "width": image.get_width(), "height": image.get_height(), "camera": str(scene.camera.position), "basis": str(scene.camera.basis), "fov": scene.camera.fov, "adapter": RenderingServer.get_video_adapter_name()})
		var file = FileAccess.open(destination + "manifest.json", FileAccess.WRITE)
		file.store_string(JSON.stringify(records, "\t"))
		file.close()
		print("POLISH_CAPTURE ", phase, " ", view, " ", image.get_width(), "x", image.get_height())
	scene.queue_free()
	await process_frame
	quit(0)
