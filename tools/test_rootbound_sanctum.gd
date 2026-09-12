extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene_path = "res://scenes/rootbound_sanctum.tscn"
	if not ResourceLoader.exists(scene_path):
		printerr("FAIL: Approved Rootbound B floor is missing.")
		quit(1)
		return
	var packed = load(scene_path)
	var floor_scene = packed.instantiate()
	root.add_child(floor_scene)
	await process_frame
	await process_frame
	var rooms = get_nodes_in_group("rootbound_room")
	if rooms.size() != 14:
		printerr("FAIL: Expected all 14 approved spaces; got ", rooms.size())
		quit(1)
		return
	for room in rooms:
		if room.mesh == null or room.mesh.get_surface_count() == 0:
			printerr("FAIL: Empty room geometry: ", room.name)
			quit(1)
			return
	if get_nodes_in_group("rootbound_collision").size() < 17:
		printerr("FAIL: Room floors, walls, and obstacles need physical collision.")
		quit(1)
		return
	if get_nodes_in_group("rootbound_wall").is_empty() or floor_scene.builder.blocked_cells.is_empty():
		printerr("FAIL: Shaped walls or planned obstacles are missing.")
		quit(1)
		return
	await physics_frame
	await physics_frame
	var space = floor_scene.get_world_3d().direct_space_state
	for spec in floor_scene.layout["rooms"]:
		var point: Vector3 = floor_scene.builder.world_point(spec["label"])
		var ray = PhysicsRayQueryParameters3D.create(point + Vector3.UP * 40.0, point - Vector3.UP * 2.0)
		var hit = space.intersect_ray(ray)
		if hit.is_empty():
			printerr("FAIL: Room ", spec["id"], " has no solid floor under its interior sample.")
			quit(1)
			return
	if not floor_scene.has_method("focus_room") or get_nodes_in_group("rootbound_unit").size() != 5:
		printerr("FAIL: Room inspection and five existing-scale reference monsters are missing.")
		quit(1)
		return
	if floor_scene.get_node_or_null("Camera3D") == null or get_nodes_in_group("rootbound_landmark").size() < 3:
		printerr("FAIL: The rendered map needs its camera, water, boat, and ascent landmarks.")
		quit(1)
		return
	if floor_scene.gates.size() != 5:
		printerr("FAIL: Expected all five gated connections from the approved layout.")
		quit(1)
		return
	for flag in ["sanctuary07", "elite09", "boss12", "discover13"]:
		floor_scene.set_gate_flags({flag: true})
		for gate in floor_scene.gates:
			if bool(gate.get_meta("open")) != (str(gate.get_meta("condition")) == flag):
				printerr("FAIL: A gate opens without its own prerequisite: ", gate.name)
				quit(1)
				return
	floor_scene.set_gate_flags({"sanctuary07": true, "elite09": true, "boss12": true, "discover13": true})
	for index in range(14):
		floor_scene.focus_room(index)
		if not floor_scene.camera.current or not floor_scene.camera.position.is_finite():
			printerr("FAIL: Room camera cannot inspect room ", index + 1)
			quit(1)
			return
	floor_scene.focus_room(2)
	floor_scene.focus_boss()
	if floor_scene.selection.selected != 11:
		printerr("FAIL: Boss inspection still displays the previous room name.")
		quit(1)
		return
	floor_scene.focus_scale()
	if floor_scene.selection.selected != 2:
		printerr("FAIL: Scale inspection still displays the previous room name.")
		quit(1)
		return
	floor_scene.focus_overview()
	if floor_scene.selection.selected != -1:
		printerr("FAIL: Overview claims that a single room is selected.")
		quit(1)
		return
	print("PASS: 14 rooms, collision, landmarks, five unchanged-scale units, room inspection, and gate prerequisites.")
	floor_scene.queue_free()
	await process_frame
	quit(0)
