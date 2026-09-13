extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	root.size = Vector2i(1600,900)
	root.content_scale_size = Vector2i(1600,900)
	var scene = load("res://Rootbound_Sanctum/Art_Dungeon/Carved07/viewer.tscn").instantiate()
	root.add_child(scene)
	while not scene.built:
		await process_frame
	scene.hud.visible = false
	var directory = "res://Rootbound_Sanctum/Art_Dungeon/Carved07/Renders/" + scene.phase + "/"
	DirAccess.make_dir_recursive_absolute(directory)
	var lights: Array = []
	for node in scene.find_children("*", "Light3D", true, false):
		lights.append({"type":node.get_class(), "position":str(node.global_position), "rotation":str(node.global_rotation), "color":str(node.light_color), "energy":node.light_energy, "shadows":node.shadow_enabled})
	var lighting_file = FileAccess.open(directory + "lighting.json",FileAccess.WRITE)
	lighting_file.store_string(JSON.stringify(lights,"	"))
	lighting_file.close()
	var records: Array = []
	for view in scene.VIEW_NAMES:
		scene.set_view(view)
		for frame in range(12):
			await process_frame
		await RenderingServer.frame_post_draw
		var image = root.get_texture().get_image()
		var path = directory + view + ".png"
		if image.save_png(path) != OK:
			printerr("Failed to capture " + path)
			quit(1)
			return
		var camera: Camera3D = scene.camera
		records.append({"room":"07", "phase":scene.phase, "view":view, "path":path, "width":image.get_width(), "height":image.get_height(), "camera":str(camera.position), "basis":str(camera.basis), "fov":camera.fov, "projection":camera.projection, "size":camera.size, "adapter":RenderingServer.get_video_adapter_name()})
		var file = FileAccess.open(directory + "manifest.json",FileAccess.WRITE)
		file.store_string(JSON.stringify(records,"\t"))
		file.close()
		print("CAPTURE ",scene.phase," ",view," ",image.get_width(),"x",image.get_height())
	scene.queue_free()
	await process_frame
	quit(0)
