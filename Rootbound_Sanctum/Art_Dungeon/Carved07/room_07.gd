extends "res://Rootbound_Sanctum/Art_Dungeon/room_art.gd"

# Room-only replacement. Shared room definitions, original sample and characters stay untouched.
var sculpture: Node3D

func _build_surface() -> void:
	super._build_surface()
	for child in get_children():
		if child is MeshInstance3D and str(child.name).begins_with("Walls_07"):
			child.visible = false

func _build_architecture() -> void:
	var document = GLTFDocument.new()
	var state = GLTFState.new()
	var error = document.append_from_file("res://Rootbound_Sanctum/Art_Dungeon/Carved07/Assets/sanctuary.glb", state)
	if error != OK:
		push_error("Cannot load authored cubic sanctuary: " + str(error))
		return
	sculpture = document.generate_scene(state)
	sculpture.name = "AuthoredCubicSanctuary"
	add_child(sculpture)
	# glTF vertex colors contain linear RGB. Do not convert them a second time.
	for node in sculpture.find_children("*", "MeshInstance3D", true, false):
		for surface in range(node.mesh.get_surface_count()):
			var material = node.mesh.surface_get_material(surface)
			if material is StandardMaterial3D:
				material.vertex_color_is_srgb = false
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	for side in [-1, 1]:
		for z in [-6.9, 6.9]:
			_solid_box("Pillar", Vector3(float(side) * 10.6, 3.15, z), Vector3(1.2, 6.3, 1.2))
		for x in [-5.9, 5.9]:
			_solid_box("Pillar", Vector3(x, 3.15, float(side) * 9.0), Vector3(1.2, 6.3, 1.2))
	for p in [Vector3(0,0,-11.4), Vector3(0,0,11.4), Vector3(0,0,16.6), Vector3(-15,0,0), Vector3(15,0,0)]:
		var yaw = PI * 0.5 if absf(p.x) > 1 else 0.0
		for side in [-1, 1]:
			_solid_box("PortalJamb", p + Basis(Vector3.UP, yaw) * Vector3(float(side)*2.88,2.1,0), Vector3(.96,4.2,1.08), yaw)
	# Preserve the original corridor roof and its lighting, not a new light rig.
	for z in [12.4, 13.6, 14.8, 17.8]:
		_box(Vector3(0,5.85,z), Vector3(5.25,.36,.36), 0x8b947c)
	_box(Vector3(0,6.13,14.8), Vector3(5.28,.24,6.96), 0x415349)
	_solid_box("CorridorRoof", Vector3(0,6.13,14.8), Vector3(5.28,.24,6.96))
	for side in [-1, 1]:
		for z in [13.5, 17.5]:
			_light(Vector3(float(side)*2.24,2.9,z), 0xffbc70, 2, 6.5, true)
		_light(Vector3(float(side)*3.1,1.9,-8.8), 0xffc481, 2.4, 8, true)
		_solid_box("Brazier", Vector3(float(side)*3.1,.72,-8.8), Vector3(.84,1.44,.84))

func _build_shrine() -> void:
	_solid_box("ApprovedShrineBlocker", Vector3(0,.48,-4.32), Vector3(5.04,.96,4.08))
	_light(Vector3(.3,3,-2.92), 0x6ae0c4, 1.8, 9.5, true)

func _build_dressing() -> void:
	for side in [-1, 1]:
		for z in [-6.7, 6.7]:
			_light(Vector3(float(side)*9.4,1.9,z+1.2), 0xffc481, 2.4, 8, true)
			_solid_box("Brazier", Vector3(float(side)*9.4,.72,z+1.2), Vector3(.84,1.44,.84))
