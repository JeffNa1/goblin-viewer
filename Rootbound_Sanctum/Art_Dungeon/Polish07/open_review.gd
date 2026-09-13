extends SceneTree

func _init() -> void:
	call_deferred("_open")

func _open() -> void:
	root.size = Vector2i(1600, 900)
	root.content_scale_size = Vector2i(1600, 900)
	root.msaa_3d = Viewport.MSAA_4X
	var scene = load("res://Rootbound_Sanctum/Art_Dungeon/dungeon.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	while not scene.built:
		await process_frame
	scene.select_room("07", "shoulder")
	print("ROOM_07_REVIEW_OPEN room=", scene.selected_id, " adapter=", RenderingServer.get_video_adapter_name())
