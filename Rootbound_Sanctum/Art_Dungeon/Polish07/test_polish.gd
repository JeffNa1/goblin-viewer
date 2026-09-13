extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene = load("res://Rootbound_Sanctum/Art_Dungeon/dungeon.tscn").instantiate()
	root.add_child(scene)
	while not scene.built:
		await process_frame
	await physics_frame
	await physics_frame
	var room = scene.rooms["07"]
	var failures: Array[String] = []
	var categories: Dictionary = {}
	var triangles = 0
	for node in room.get_children():
		if not node is MeshInstance3D or not str(node.name).begins_with("Sculpt07_"):
			continue
		var category: String = str(node.name).split("_")[1]
		if not categories.has(category):
			categories[category] = {"vertices": 0, "oblique_normals": 0, "depth_levels": {}}
		var record: Dictionary = categories[category]
		for surface in range(node.mesh.get_surface_count()):
			var arrays: Array = node.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
			var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
			triangles += indices.size() / 3 if not indices.is_empty() else vertices.size() / 3
			for i in range(vertices.size()):
				var p = vertices[i]
				if not p.is_finite() or not normals[i].is_finite():
					failures.append("Non-finite sculpted geometry.")
				record["vertices"] += 1
				record["depth_levels"][roundi(p.z * 1000)] = true
				var n = normals[i].abs()
				if maxf(n.x, maxf(n.y, n.z)) < 0.995:
					record["oblique_normals"] += 1
				if category == "Fountain" and (absf(p.x) > 2.53 or absf(p.z + 4.32) > 2.05):
					failures.append("Fountain exceeds the approved blocker footprint.")
	for category in ["Carving", "Stonework", "Roots", "Fountain", "Vessels", "Foliage", "Weathering"]:
		if not categories.has(category) or categories[category]["vertices"] < 60:
			failures.append("Missing substantive sculpted " + category + " geometry.")
		elif categories[category]["oblique_normals"] < 30:
			failures.append("The " + category + " silhouette is still axis-aligned boxes.")
	if categories.has("Carving") and categories["Carving"]["depth_levels"].size() < 8:
		failures.append("The relief has no meaningful physical depth.")
	if triangles > 450000:
		failures.append("Room 07 sculpted detail exceeds the local triangle budget.")
	# Test visible sculptures too, not only the simplified production collision proxies.
	for node in room.get_children():
		if node is MeshInstance3D and str(node.name).begins_with("Sculpt07_"):
			node.create_trimesh_collision()
	await physics_frame
	await physics_frame
	var space = scene.get_world_3d().direct_space_state
	var sphere = SphereShape3D.new()
	sphere.radius = 0.15
	for view in scene.VIEW_NAMES:
		scene.select_room("07", view)
		var camera_query = PhysicsShapeQueryParameters3D.new()
		camera_query.shape = sphere
		camera_query.transform.origin = scene.camera.global_position
		if not space.intersect_shape(camera_query).is_empty():
			failures.append("Sculpture intersects the " + view + " camera.")
	for local_point in [Vector3(6.7, 2.6, -4.8), Vector3(3.6, 1.65, -0.7), Vector3(0.17, 1.704, 17.15)]:
		var camera_query = PhysicsShapeQueryParameters3D.new()
		camera_query.shape = sphere
		camera_query.transform.origin = room.position + local_point
		if not space.intersect_shape(camera_query).is_empty():
			failures.append("Sculpture intersects a close detail/corridor camera.")
	var capsule = CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	var samples = 0
	# The authored approach and ring remain open; this is not an exhaustive playtest.
	var routes = [
		[Vector3(0, 0, 10), Vector3(0, 0, 0)],
		[Vector3(-3.4, 0, -7), Vector3(-3.4, 0, 0)],
		[Vector3(3.4, 0, -7), Vector3(3.4, 0, 0)],
		[Vector3(-3.4, 0, -7), Vector3(3.4, 0, -7)],
		[Vector3(-3.4, 0, 0), Vector3(3.4, 0, 0)]
	]
	for route in routes:
		var count = ceili(route[0].distance_to(route[1]) / 0.3)
		for i in range(count + 1):
			var p: Vector3 = room.position + route[0].lerp(route[1], float(i) / float(count))
			if space.intersect_ray(PhysicsRayQueryParameters3D.create(p + Vector3.UP * 0.3, p - Vector3.UP * 0.3)).is_empty():
				failures.append("Missing floor at " + str(p))
			var query = PhysicsShapeQueryParameters3D.new()
			query.shape = capsule
			query.transform.origin = p + Vector3.UP * 0.98
			query.margin = 0.01
			if not space.intersect_shape(query).is_empty():
				failures.append("Blocked approach/ring at " + str(p))
			samples += 1
	for category in categories:
		categories[category]["depth_levels"] = categories[category]["depth_levels"].size()
	var report = {"passed": failures.is_empty(), "failures": failures, "categories": categories, "sculpted_triangles": triangles, "route_samples": samples, "camera_views": 6, "visual_collision_checked": true}
	var file = FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/Polish07/Evidence/sculpt-acceptance.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("SCULPT_ACCEPTANCE ", JSON.stringify(report))
	scene.queue_free()
	await process_frame
	quit(0 if failures.is_empty() else 1)
