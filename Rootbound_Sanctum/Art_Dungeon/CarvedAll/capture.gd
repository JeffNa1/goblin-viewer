extends SceneTree

const OUTPUT = "res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Renders/"
var records: Array = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	root.size = Vector2i(1600, 900)
	root.content_scale_size = Vector2i(1600, 900)
	root.msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute(OUTPUT)
	if FileAccess.file_exists(OUTPUT + "manifest.json"):
		records = JSON.parse_string(FileAccess.get_file_as_string(OUTPUT + "manifest.json"))
	var scene = load("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/dungeon.tscn").instantiate()
	root.add_child(scene)
	var middle_saved = false
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(OUTPUT+"loading_start.png")
	while not scene.built:
		if scene.loading_failed:
			printerr("CAPTURE_LOADING_FAILED")
			quit(1)
			return
		if scene.loading.bar.value>40 and not middle_saved:
			await RenderingServer.frame_post_draw
			root.get_texture().get_image().save_png(OUTPUT+"loading_middle.png")
			middle_saved = true
		await process_frame
	var trace = FileAccess.open(OUTPUT+"loading.json",FileAccess.WRITE)
	trace.store_string(JSON.stringify(scene.loading_events,"  "))
	scene.hud.visible = false
	var requested = OS.get_cmdline_user_args()
	for id in scene.ids:
		if not requested.is_empty() and not requested.has(id):
			continue
		for view in ["shoulder","eye_level","overview","detail"]:
			scene.select_room(id, view)
			await _capture(scene, id, view)
	if requested.is_empty() or requested.has("map"):
		scene.select_map()
		await _capture(scene, "map", "overview")
	print("RENDER_COMPLETE ", records.size(), " views; adapter=", RenderingServer.get_video_adapter_name())
	scene.queue_free()
	await process_frame
	quit(0)

func _capture(scene, id: String, view: String) -> void:
	for frame in range(8):
		await process_frame
	var samples: Array[float] = []
	for frame in range(45):
		var started = Time.get_ticks_usec()
		await RenderingServer.frame_post_draw
		await process_frame
		samples.append(float(Time.get_ticks_usec()-started)/1000.0)
	samples.sort()
	await RenderingServer.frame_post_draw
	var image = root.get_texture().get_image()
	var path = OUTPUT + id + "_" + view + ".png"
	if image.save_png(path) != OK:
		printerr("FAIL: Could not capture " + path)
		quit(1)
		return
	for i in range(records.size() - 1, -1, -1):
		if records[i]["id"] == id and records[i]["view"] == view:
			records.remove_at(i)
	records.append({"id": id, "view": view, "path": path, "width": image.get_width(), "height": image.get_height(), "camera_position": str(scene.camera.global_position), "camera_fov": scene.camera.fov, "adapter": RenderingServer.get_video_adapter_name(), "median_frame_ms": samples[samples.size()/2], "p95_frame_ms": samples[int(samples.size()*.95)], "draw_calls":Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), "primitives":Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)})
	var file = FileAccess.open(OUTPUT + "manifest.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(records, "\t"))
	file.close()
	print("CAPTURED ", id, " ", view, " ", image.get_width(), "x", image.get_height())
