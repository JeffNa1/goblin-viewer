extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene = load("res://scenes/rootbound_sanctum.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	var space = scene.get_world_3d().direct_space_state
	var capsule = CapsuleShape3D.new()
	capsule.radius = 1.2
	capsule.height = 3.0
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = capsule
	query.margin = 0.02
	query.collision_mask = 1
	var samples: int = 0
	var link_results: Array = []
	for link in scene.layout["links"]:
		var count: int = 0
		var points: Array = link["points"]
		for i in range(points.size() - 1):
			var a: Vector3 = scene.builder.world_point(points[i])
			var b: Vector3 = scene.builder.world_point(points[i + 1])
			var steps = maxi(1, ceili(a.distance_to(b) / 0.6))
			for step in range(steps + 1):
				var p = a.lerp(b, float(step) / float(steps))
				query.transform = Transform3D(Basis.IDENTITY, p + Vector3.UP * 1.56)
				var hits = space.intersect_shape(query, 4)
				if not hits.is_empty():
					printerr("FAIL: 2.4 m wide, 3.0 m tall body hits corridor ", link["a"], "-", link["b"], " at ", p, " collider=", hits[0]["collider"].get_path())
					quit(1)
					return
				samples += 1
				count += 1
		link_results.append({"a": link["a"], "b": link["b"], "samples": count, "clear": true})
	scene.set_gate_flags({})
	await physics_frame
	await physics_frame
	for gate in scene.gates:
		query.transform = Transform3D(Basis.IDENTITY, gate.get_parent().global_position + Vector3.UP * 1.56)
		if space.intersect_shape(query, 4).is_empty():
			printerr("FAIL: Closed gate does not physically block a monster: ", gate.get_parent().name)
			quit(1)
			return
	for unit in get_nodes_in_group("rootbound_unit"):
		var key: String = unit.get_meta("archetype")
		var original = load(scene.layout["unit_measurements"][key]["scene"]).instantiate()
		var unchanged: bool = unit.scale.is_equal_approx(original.scale) and unit.get_node("VisualRoot").scale.is_equal_approx(original.get_node("VisualRoot").scale)
		original.free()
		if not unchanged:
			printerr("FAIL: A reference monster was resized: ", key)
			quit(1)
			return
	var rows: Array = []
	for cell in scene.builder.floor_cells:
		rows.append([cell.x, cell.y, scene.builder.floor_cells[cell], scene.builder.blocked_cells.has(cell)])
	var file = FileAccess.open("user://rootbound_clearance_grid.json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"cell_m": scene.builder.CELL, "pixel_scale": scene.builder.pixel_scale, "origin": [560, 930], "cells": rows, "rooms": scene.layout["rooms"], "links": scene.layout["links"]}))
	file.close()
	var report = {"capsule_width_m": 2.4, "capsule_height_m": 3.0, "margin_m": 0.02, "sample_spacing_m_max": 0.6, "samples": samples, "links": link_results, "closed_gates_blocking": scene.gates.size(), "unchanged_scale_units": get_nodes_in_group("rootbound_unit").size()}
	var result = FileAccess.open("user://rootbound_physics_checks.json", FileAccess.WRITE)
	result.store_string(JSON.stringify(report, "\t"))
	result.close()
	print("PASS: ", JSON.stringify(report))
	scene.queue_free()
	await process_frame
	quit(0)
