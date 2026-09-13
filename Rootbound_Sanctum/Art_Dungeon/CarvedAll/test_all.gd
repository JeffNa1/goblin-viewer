extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var path = "res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/dungeon.tscn"
	if not ResourceLoader.exists(path):
		printerr("FAIL: Art for all remaining rooms and their connected viewer is missing.")
		quit(1)
		return
	var scene = load(path).instantiate()
	if not scene.has_method("select_room"):
		printerr("FAIL: The all-room art viewer did not load.")
		quit(1)
		return
	root.add_child(scene)
	while not scene.built:
		if scene.loading_failed:
			printerr("FAIL: Loading did not complete")
			quit(1)
			return
		await process_frame
	await physics_frame
	await physics_frame
	var failures: Array[String] = []
	var records: Array = []
	await _check_visible_geometry(scene, failures)
	_check_carving_depth(scene,failures)
	_save("loading-trace.json",scene.loading_events)
	if scene.loading.visible or scene.loading.bar.value!=100 or not scene.world.visible:
		failures.append("Loading did not reveal the complete world")
	if scene.loading_events[0].world_visible or not scene.loading_events[0].overlay_visible:
		failures.append("Loading page did not precede scene construction")
	var expected: Array[String] = []
	for source in scene.plan.data["rooms"]:
		expected.append(source["id"])
	if scene.rooms.size() != expected.size():
		failures.append("Not all original rooms have art.")
	var space = scene.get_world_3d().direct_space_state
	var capsule = CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	for id in expected:
		if not scene.rooms.has(id):
			failures.append("Missing room: " + id)
			continue
		var room = scene.rooms[id]
		var poses: Array = []
		for view in ["shoulder", "eye_level", "overview", "detail"]:
			scene.select_room(id, view)
			await process_frame
			var sphere = SphereShape3D.new()
			sphere.radius = 0.15
			var query = PhysicsShapeQueryParameters3D.new()
			query.shape = sphere
			query.transform.origin = scene.camera.global_position
			if not space.intersect_shape(query).is_empty():
				failures.append("Camera in geometry: " + id + "/" + view)
			if id == "05" and view == "eye_level":
				var front_delta: Vector3 = scene.camera.global_position - (room.position + room.blocker_centers[0])
				if front_delta.z <= absf(front_delta.x) * 1.2:
					failures.append("Forge eye-level camera hides the open furnace mouth.")
			if id == "08" and view == "eye_level":
				var water_point: Vector3 = scene.plan.world_point([1022, 1134]) + Vector3.UP * 0.6
				var water_direction = (water_point - scene.camera.global_position).normalized()
				if water_direction.dot(-scene.camera.global_basis.z) < 0.8:
					failures.append("Archive eye-level capture does not frame the water court.")
				if not space.intersect_ray(PhysicsRayQueryParameters3D.create(scene.camera.global_position, water_point)).is_empty():
					failures.append("Archive eye-level water sight line is blocked by a prop: " + str(space.intersect_ray(PhysicsRayQueryParameters3D.create(scene.camera.global_position, water_point))))
			if id == "14" and view != "overview":
				if scene.camera.global_position.z >= scene.plan.world_point([1015, 408]).z - 0.8:
					failures.append("Ascent camera looks at the rear of the stairs: " + view)
			if view == "shoulder":
				var actor_point: Vector3 = scene.figure.global_position
				if not _floor_exists(space, actor_point):
					failures.append("No floor under shoulder figure: " + id)
				if _blocked(space, capsule, actor_point):
					failures.append("Shoulder figure intersects geometry: " + id)
				var ray = PhysicsRayQueryParameters3D.create(actor_point + Vector3.UP * 1.25, scene.camera.global_position)
				if not space.intersect_ray(ray).is_empty():
					failures.append("Shoulder sight line blocked: " + id)
			poses.append({"view": view, "camera": str(scene.camera.global_position)})
		if room.landmark_name.is_empty() or room.geometry_stats["block_instances"] < 20:
			failures.append("Room has no substantive art landmark: " + id)
		records.append({"id": id, "name": room.room_data["name"], "landmark": room.landmark_name, "floor_cells": room.room_cell_count, "geometry": room.geometry_stats.duplicate(), "views": poses})
		_save("rooms.json", records)
	var bank: Vector3 = scene.plan.world_point([944, 1160]) + Vector3.UP * 1.68
	var water: Vector3 = scene.plan.world_point([1022, 1160]) + Vector3.UP * 1.68
	if not space.intersect_ray(PhysicsRayQueryParameters3D.create(bank, water)).is_empty():
		failures.append("The archive shoreline blocks the eye-level view of the water court.")
	var corridor_samples = 0
	for link in scene.plan.data["links"]:
		for i in range(link["points"].size() - 1):
			var a: Vector3 = scene.plan.world_point(link["points"][i])
			var b: Vector3 = scene.plan.world_point(link["points"][i + 1])
			var steps = maxi(2, ceili(a.distance_to(b) / 0.6))
			for j in range(steps + 1):
				var point = a.lerp(b, float(j) / float(steps))
				if not _floor_exists(space, point):
					failures.append("Missing corridor floor %s-%s at %s" % [link["a"], link["b"], point])
				if _blocked(space, capsule, point):
					failures.append("Blocked original corridor %s-%s at %s" % [link["a"], link["b"], point])
				corridor_samples += 1
	scene.select_room("01", "shoulder")
	var next = InputEventKey.new()
	next.keycode = KEY_RIGHT
	next.pressed = true
	root.push_input(next)
	await process_frame
	if scene.selected_id != "02":
		failures.append("Next-room keyboard control failed.")
	var overview = InputEventKey.new()
	overview.keycode = KEY_3
	overview.pressed = true
	root.push_input(overview)
	await process_frame
	if scene.selected_view != "overview":
		failures.append("Overview keyboard control failed.")
	var controls = [
		{"key": KEY_1, "view": "shoulder", "room": "02"},
		{"key": KEY_2, "view": "eye_level", "room": "02"},
		{"key": KEY_M, "view": "map", "room": "02"},
		{"key": KEY_LEFT, "view": "shoulder", "room": "01"},
		{"key": KEY_LEFT, "view": "shoulder", "room": "14"},
		{"key": KEY_RIGHT, "view": "shoulder", "room": "01"},
	]
	for control in controls:
		var event = InputEventKey.new()
		event.keycode = control["key"]
		event.pressed = true
		root.push_input(event)
		await process_frame
		if scene.selected_id != control["room"] or scene.selected_view != control["view"]:
			failures.append("Review navigation failed: " + str(control))
		if control["view"] == "map":
			if not scene.passages.visible or scene.figure.visible:
				failures.append("Connected overview visibility is incorrect.")
			for room in scene.rooms.values():
				if not room.visible:
					failures.append("Connected overview hides a room.")
	for visible_state in [false, true]:
		var event = InputEventKey.new()
		event.keycode = KEY_H
		event.pressed = true
		root.push_input(event)
		await process_frame
		if scene.hud.visible != visible_state:
			failures.append("HUD toggle failed.")
	scene.picker.item_selected.emit(11)
	await process_frame
	if scene.selected_id != "12":
		failures.append("Room picker selection failed.")
	var report = {"passed": failures.is_empty(), "failures": failures, "room_count": records.size(), "camera_poses": records.size() * 4, "controls_checked": true, "link_count": scene.plan.data["links"].size(), "corridor_samples": corridor_samples, "room_ids": expected}
	_save("acceptance.json", report)
	print("DUNGEON_ACCEPTANCE ", JSON.stringify(report))
	scene.queue_free()
	await process_frame
	quit(0 if failures.is_empty() else 1)

func _check_carving_depth(scene,failures: Array[String]) -> void:
	var records: Array = []
	var space = scene.get_world_3d().direct_space_state
	for id in scene.ids:
		if id=="07": continue
		var crest = scene.rooms[id].find_children("Heraldry_"+id+"*","MeshInstance3D",true,false)[0]
		var face = space.intersect_ray(PhysicsRayQueryParameters3D.create(crest.to_global(Vector3(-1.23,1.85,1.2)),crest.to_global(Vector3(-1.23,1.85,-.4))))
		var dent = space.intersect_ray(PhysicsRayQueryParameters3D.create(crest.to_global(Vector3(-1.23,1.40,1.2)),crest.to_global(Vector3(-1.23,1.40,-.4))))
		var depth = 0.0
		if not face.is_empty() and not dent.is_empty():depth=(face.position-dent.position).dot(crest.global_basis.z)
		if depth<.10:failures.append("Carved frame recess lacks depth: "+id+" "+str(depth))
		var tiles = 0
		for node in scene.rooms[id].find_children("*","MultiMeshInstance3D",true,false):
			for i in range(node.multimesh.instance_count):
				var t = node.multimesh.get_instance_transform(i)
				if t.basis.x.length()>.1 and t.basis.y.length()>.001 and t.origin.y+t.basis.y.length()*.5<=.065:tiles+=1
		if tiles<20:failures.append("Floor tiles lost in packed room "+id)
		records.append({"id":id,"carved_depth":depth,"floor_tiles":tiles})
	_save("carving-depth.json",records)

func _check_visible_geometry(scene, failures: Array[String]) -> void:
	var mesh_records: Array = []
	var shapes: Dictionary = {}
	var checked_normals: Dictionary = {}
	for id in scene.ids:
		var room = scene.rooms[id]
		var triangles = 0
		var oblique = 0
		var nodes = 0
		for mesh_node in room.find_children("*","MeshInstance3D",true,false):
			if not mesh_node.is_visible_in_tree(): continue
			nodes += 1
			var mesh = mesh_node.mesh
			var rid = mesh.get_instance_id()
			for s in range(mesh.get_surface_count()):
				var arrays = mesh.surface_get_arrays(s)
				var index: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
				triangles += index.size()/3
				var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
				if not checked_normals.has(rid):
					for normal in normals:
						var n = (mesh_node.global_basis*normal).normalized().abs()
						if not n.is_finite() or maxf(n.x,maxf(n.y,n.z))<.9999: oblique+=1
					checked_normals[rid]=true
			if not shapes.has(rid): shapes[rid]=mesh.create_trimesh_shape()
			var body = StaticBody3D.new()
			var collision = CollisionShape3D.new()
			collision.shape = shapes[rid]
			body.add_child(collision)
			mesh_node.add_child(body)
		if oblique: failures.append("Non-cubic geometry in "+id+": "+str(oblique))
		if nodes<10: failures.append("Room has too few visible authored parts: "+id)
		if id!="07" and room.find_children("Heraldry_"+id+"*","MeshInstance3D",true,false).is_empty():
			failures.append("Missing room-specific carved crest: "+id)
		mesh_records.append({"id":id,"visible_meshes":nodes,"triangles":triangles,"oblique_normals":oblique})
	_save("visible-geometry.json",mesh_records)
	await physics_frame
	await physics_frame

func _floor_exists(space: PhysicsDirectSpaceState3D, point: Vector3) -> bool:
	return not space.intersect_ray(PhysicsRayQueryParameters3D.create(point + Vector3.UP * 0.3, point - Vector3.UP * 0.3)).is_empty()

func _blocked(space: PhysicsDirectSpaceState3D, capsule: CapsuleShape3D, point: Vector3) -> bool:
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = capsule
	query.transform.origin = point + Vector3.UP * 0.98
	query.margin = 0.01
	return not space.intersect_shape(query).is_empty()

func _save(name: String, value: Variant) -> void:
	var file = FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Evidence/" + name, FileAccess.WRITE)
	file.store_string(JSON.stringify(value, "\t"))
	file.close()
