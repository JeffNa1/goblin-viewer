extends SceneTree

# Capture real rendered frames. This script never launches the viewer scene.
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var output = "user://rootbound-captures"
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			output = arg.trim_prefix("--out=")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	var scene = load("res://scenes/rootbound_sanctum.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	var captures: Array = []
	for view in ["overview", "court", "scale", "boss", "archive", "sanctuary"]:
		match view:
			"overview": scene.focus_overview()
			"court": scene.focus_room(2)
			"scale": scene.focus_scale()
			"boss": scene.focus_boss()
			"archive": scene.focus_room(7)
			"sanctuary": scene.focus_room(6)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var image = root.get_texture().get_image()
		var target = output.path_join(view + ".png")
		var result = image.save_png(target)
		if result != OK:
			printerr("Capture failed: ", target, " error=", result)
			quit(1)
			return
		captures.append({"view": view, "file": ProjectSettings.globalize_path(target), "width": image.get_width(), "height": image.get_height()})
		print("CAPTURE ", ProjectSettings.globalize_path(target))
	var report = FileAccess.open(output.path_join("render-checks.json"), FileAccess.WRITE)
	report.store_string(JSON.stringify({"captures": captures, "rooms": scene.builder.room_meshes.size(), "terrain_triangles": scene.builder.triangles, "renderer": RenderingServer.get_video_adapter_name()}, "\t"))
	report.close()
	scene.queue_free()
	await process_frame
	quit(0)
