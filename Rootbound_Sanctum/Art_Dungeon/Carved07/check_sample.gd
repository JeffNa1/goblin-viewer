extends SceneTree

# A real-physics acceptance check for the isolated room art sample.
func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var path = "res://Rootbound_Sanctum/Art_Sample/sanctuary.tscn"
	if not ResourceLoader.exists(path):
		printerr("FAIL: The close-camera sanctuary and corridor sample is missing.")
		quit(1)
		return
	var scene = load(path).instantiate()
	root.add_child(scene)
	await process_frame
	await physics_frame
	await physics_frame
	var failures: Array[String] = []
	var space = scene.get_world_3d().direct_space_state
	var capsule = CapsuleShape3D.new()
	capsule.radius = 0.48
	capsule.height = 1.8
	var path_points = [Vector3(0, 0, 16), Vector3(0, 0, 13), Vector3(0, 0, 10), Vector3(0, 0, 7), Vector3(0, 0, 4), Vector3(0, 0, 1), Vector3(3.6, 0, -1), Vector3(3.6, 0, -4.3), Vector3(3.6, 0, -7), Vector3(0, 0, -9), Vector3(0, 0, -12)]
	var samples = 0
	for i in range(path_points.size() - 1):
		for step in range(9):
			var point: Vector3 = path_points[i].lerp(path_points[i + 1], float(step) / 8.0)
			var floor_hit = space.intersect_ray(PhysicsRayQueryParameters3D.create(point + Vector3.UP * 0.4, point - Vector3.UP * 0.4))
			if floor_hit.is_empty():
				failures.append("Missing floor at %s" % point)
			var query = PhysicsShapeQueryParameters3D.new()
			query.shape = capsule
			query.transform.origin = point + Vector3.UP * 0.94
			query.margin = 0.01
			if not space.intersect_shape(query).is_empty():
				failures.append("Blocked walking sample at %s" % point)
			samples += 1
	for wall_point in [Vector3(0, 2, 16), Vector3(0, 2, -12)]:
		for direction in [-1, 1]:
			if space.intersect_ray(PhysicsRayQueryParameters3D.create(wall_point, wall_point + Vector3.RIGHT * float(direction) * 4.5)).is_empty():
				failures.append("Corridor wall collision is missing.")
	var shrine_hit = space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(0, 0.4, -1), Vector3(0, 0.4, -6)))
	if shrine_hit.is_empty():
		failures.append("The shrine blocker has no collision.")
	var view_index = 0
	for view in ["shoulder", "corridor", "eye_level", "overview", "detail"]:
		var key = InputEventKey.new()
		key.keycode = KEY_1 + view_index
		key.pressed = true
		root.push_input(key)
		await process_frame
		if not scene.view_label.text.ends_with(view.replace("_", " ").to_upper()):
			failures.append("Review keyboard control failed: " + view)
		view_index += 1
		if not scene.camera.current or not scene.camera.position.is_finite():
			failures.append("Invalid camera: " + view)
		var sphere = SphereShape3D.new()
		sphere.radius = 0.15
		var query = PhysicsShapeQueryParameters3D.new()
		query.shape = sphere
		query.transform.origin = scene.camera.global_position
		if not space.intersect_shape(query).is_empty():
			failures.append("Camera intersects geometry: " + view)
		if view in ["shoulder", "corridor"]:
			var shoulder: Vector3 = scene.actor.global_position + Vector3(0, 1.25, 0)
			if not space.intersect_ray(PhysicsRayQueryParameters3D.create(shoulder, scene.camera.global_position)).is_empty():
				failures.append("Wall blocks shoulder camera: " + view)
	if scene.source_room_id != "07" or scene.room_cell_count < 1000:
		failures.append("The approved sanctuary footprint is missing.")
	if scene.actor.scale != Vector3.ONE:
		failures.append("The scale figure was rescaled.")
	var toggle = InputEventKey.new()
	toggle.keycode = KEY_H
	toggle.pressed = true
	root.push_input(toggle)
	await process_frame
	if scene.hud.visible:
		failures.append("H did not hide the review UI.")
	root.push_input(toggle)
	await process_frame
	if not scene.hud.visible:
		failures.append("H did not restore the review UI.")
	var report = {"passed": failures.is_empty(), "failures": failures, "walking_samples": samples, "camera_views": 5, "room_id": scene.source_room_id, "room_cells": scene.room_cell_count, "geometry": scene.geometry_stats}
	var file = FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/Carved07/Evidence/baseline-sample/acceptance.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print(JSON.stringify(report))
	var code = 0 if failures.is_empty() else 1
	scene.queue_free()
	await process_frame
	quit(code)
