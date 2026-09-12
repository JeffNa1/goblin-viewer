extends SceneTree

# Read mesh vertices at the existing scene scale. Never save monster resources.
const UNIT_SCENES = {
	"warrior": "res://scenes/goblin.tscn",
	"archer": "res://scenes/goblin_archer.tscn",
	"shaman": "res://scenes/goblin_shaman.tscn",
	"rogue": "res://scenes/goblin_rogue.tscn",
	"chieftain": "res://scenes/goblin_chieftain.tscn"
}

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var report: Dictionary = {}
	for key in UNIT_SCENES:
		var packed = load(UNIT_SCENES[key])
		if packed == null:
			printerr("Cannot load unit: ", key)
			quit(1)
			return
		var unit = packed.instantiate()
		root.add_child(unit)
		await process_frame
		await process_frame
		unit.set_process(false)
		unit.play_anim("idle")
		unit._process(0.0)
		var idle_body = _bounds(unit, true)
		var idle_full = _bounds(unit, false)
		var moving_body: AABB = idle_body
		unit.play_anim("walk")
		for sample in range(24):
			unit._process(1.0 / 24.0)
			moving_body = moving_body.merge(_bounds(unit, true))
		report[key] = {
			"scene": UNIT_SCENES[key],
			"idle_body": _record(idle_body),
			"idle_with_weapon": _record(idle_full),
			"walk_body_envelope": _record(moving_body)
		}
		unit.queue_free()
		await process_frame
	var out = "user://rootbound_unit_measurements.json"
	var file = FileAccess.open(out, FileAccess.WRITE)
	file.store_string(JSON.stringify(report, "\t"))
	file.close()
	print("ROOTBOUND_MEASUREMENTS ", JSON.stringify(report))
	print("MEASUREMENT_FILE ", ProjectSettings.globalize_path(out))
	quit(0)

func _bounds(unit: Node3D, body_only: bool) -> AABB:
	var bounds: AABB
	var started: bool = false
	for child in unit.get_node("VisualRoot").find_children("*", "MeshInstance3D", true, false):
		var mesh_node: MeshInstance3D = child
		if mesh_node.mesh == null or not mesh_node.is_visible_in_tree():
			continue
		var name_path = str(mesh_node.get_path()).to_lower()
		if body_only:
			var weapon: bool = false
			for word in ["club", "bow", "staff", "dagger", "hammer", "mace", "spear", "shield"]:
				if word in name_path:
					weapon = true
			if weapon:
				continue
		for surface in range(mesh_node.mesh.get_surface_count()):
			var arrays = mesh_node.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			for vertex in vertices:
				var point: Vector3 = mesh_node.global_transform * vertex
				if not started:
					bounds = AABB(point, Vector3.ZERO)
					started = true
				else:
					bounds = bounds.expand(point)
	return bounds

func _record(bounds: AABB) -> Dictionary:
	return {"min": [bounds.position.x, bounds.position.y, bounds.position.z], "size": [bounds.size.x, bounds.size.y, bounds.size.z]}
