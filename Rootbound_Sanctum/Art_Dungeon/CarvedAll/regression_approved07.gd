extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var path = "res://Rootbound_Sanctum/Art_Dungeon/Carved07/viewer.tscn"
	if not ResourceLoader.exists(path):
		printerr("FAIL: The true cubic carved sanctuary viewer is missing.")
		quit(1)
		return
	var scene = load(path).instantiate()
	root.add_child(scene)
	while not scene.built:
		await process_frame
	var failures: Array[String] = []
	var triangles = 0
	var oblique_normals = 0
	var categories: Dictionary = {}
	for node in scene.room.sculpture.find_children("*", "MeshInstance3D", true, false):
		categories[str(node.name)] = true
		for surface in range(node.mesh.get_surface_count()):
			var arrays: Array = node.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
			var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
			triangles += indices.size() / 3
			for i in range(vertices.size()):
				if not vertices[i].is_finite():
					failures.append("Non-finite geometry")
				var n = (node.global_basis * normals[i]).normalized().abs()
				if maxf(n.x, maxf(n.y, n.z)) < 0.9999:
					oblique_normals += 1
		# Test the visible carved geometry, not just broad production proxies.
		node.create_trimesh_collision()
	if oblique_normals != 0:
		failures.append("Faceted substitute detected: %d non-cubic normals" % oblique_normals)
	if triangles > 650000:
		failures.append("Fine details exceed the room-only triangle budget")
	for category in ["Guardian", "Columns", "Fountain", "Vessels", "Heartwood", "Walls", "Portals", "WallRoots", "VaultRibs", "Sconces", "CorridorAshlar", "FloorSeal"]:
		var found = false
		for key in categories:
			found = found or str(key).begins_with(category)
		if not found:
			failures.append("Missing authored detail: " + category)
	await physics_frame
	await physics_frame
	var space = scene.get_world_3d().direct_space_state
	var sphere = SphereShape3D.new()
	sphere.radius = 0.15
	for view in scene.VIEW_NAMES:
		scene.set_view(view)
		var q = PhysicsShapeQueryParameters3D.new()
		q.shape = sphere
		q.transform.origin = scene.camera.global_position
		var hits = space.intersect_shape(q)
		if not hits.is_empty():
			var blockers: Array = []
			for hit in hits:
				blockers.append(str(hit["collider"].get_path()))
			failures.append("Visible geometry intersects camera: " + view + " / " + str(blockers))
	var capsule = CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	var samples = 0
	var routes = [[Vector3(0,0,10), Vector3(0,0,0)], [Vector3(-3.4,0,-7), Vector3(-3.4,0,0)], [Vector3(3.4,0,-7), Vector3(3.4,0,0)], [Vector3(-3.4,0,-7), Vector3(3.4,0,-7)], [Vector3(-3.4,0,0), Vector3(3.4,0,0)]]
	for route in routes:
		var count = ceili(route[0].distance_to(route[1]) / 0.3)
		for i in range(count + 1):
			var p: Vector3 = scene.room.position + route[0].lerp(route[1], float(i) / float(count))
			if space.intersect_ray(PhysicsRayQueryParameters3D.create(p + Vector3.UP * 0.3, p - Vector3.UP * 0.3)).is_empty():
				failures.append("Missing floor: " + str(p))
			var q = PhysicsShapeQueryParameters3D.new()
			q.shape = capsule
			q.transform.origin = p + Vector3.UP * 0.98
			q.margin = 0.01
			if not space.intersect_shape(q).is_empty():
				failures.append("Carving blocks approach/ring: " + str(p))
			samples += 1
	# Physical ray-depth evidence distinguishes carved sockets from painted marks.
	var relief_origin: Vector3 = scene.room.position + Vector3(4.35,0,-9.7)
	var nose = space.intersect_ray(PhysicsRayQueryParameters3D.create(relief_origin + Vector3(0,3.50,1.5), relief_origin + Vector3(0,3.50,-.3)))
	var socket = space.intersect_ray(PhysicsRayQueryParameters3D.create(relief_origin + Vector3(.21,3.69,1.5), relief_origin + Vector3(.21,3.69,-.3)))
	var socket_depth = 0.0
	if nose.is_empty() or socket.is_empty():
		failures.append("Guardian surface probe missed the relief")
	else:
		socket_depth = nose["position"].z - socket["position"].z
		if socket_depth < .12:
			failures.append("Guardian eye socket lacks real recessed depth")
	var vessel_origin: Vector3 = scene.room.position + Vector3(10.4,0,-5.8)
	var mouth = space.intersect_ray(PhysicsRayQueryParameters3D.create(vessel_origin + Vector3(0,1.6,0), vessel_origin + Vector3(0,.2,0)))
	var rim = space.intersect_ray(PhysicsRayQueryParameters3D.create(vessel_origin + Vector3(.255,1.6,0), vessel_origin + Vector3(.255,.2,0)))
	var mouth_depth = 0.0
	if mouth.is_empty() or rim.is_empty():
		failures.append("Vessel opening probe missed")
	else:
		mouth_depth = rim["position"].y - mouth["position"].y
		if mouth_depth < .15:
			failures.append("Vessel mouth is not physically hollow")
	for index in range(scene.VIEW_NAMES.size()):
		var key = InputEventKey.new()
		key.keycode = KEY_1 + index
		key.pressed = true
		root.push_input(key)
		await process_frame
		if scene.selected_view != scene.VIEW_NAMES[index]:
			failures.append("Keyboard view selection failed")
	for visible_state in [false,true]:
		var key = InputEventKey.new()
		key.keycode = KEY_H
		key.pressed = true
		root.push_input(key)
		await process_frame
		if scene.hud.visible != visible_state:
			failures.append("HUD toggle failed")
	var report = {"socket_depth":socket_depth, "vessel_mouth_depth":mouth_depth, "controls_checked":true, "passed": failures.is_empty(), "failures": failures, "triangles": triangles, "oblique_normals": oblique_normals, "route_samples": samples, "camera_views": scene.VIEW_NAMES.size(), "visual_geometry_collision_tested": true, "mesh_nodes": categories.size()}
	var file = FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Evidence/regression-approved07/acceptance.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("CARVED07_ACCEPTANCE ", JSON.stringify(report))
	scene.queue_free()
	await process_frame
	quit(0 if failures.is_empty() else 1)
