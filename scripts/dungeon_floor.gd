class_name DungeonFloor
extends Node3D

# =============================================================================
# DUNGEON FLOOR 1 - ROGUELIKE HACK & SLASH VOXEL MAP
# Assembles the 8 chambers, corridors, dynamic lighting, collisions & VFX
# =============================================================================

const DungeonVoxelBuilder = preload("res://scripts/dungeon_voxel_builder.gd")

# Room Nodes
var room_nodes: Dictionary = {}
var lights: Array[OmniLight3D] = []
var whirlpool_node: Node3D = null
var spike_traps_node: Node3D = null

# Room Center Coordinates in World Space (meters)
const ROOM_CENTERS: Dictionary = {
	"hub":         Vector3(0.0, 0.0, 0.0),
	"grotto":      Vector3(8.0, 0.0, -32.0),
	"scriptorium": Vector3(-26.0, 0.0, -26.0),
	"cosmic":      Vector3(-26.0, 0.0, 0.0),
	"crypt":       Vector3(-26.0, 0.0, 26.0),
	"dragon":      Vector3(32.0, 0.0, 0.0),
	"catacombs":   Vector3(0.0, 0.0, 26.0),
	"wharf":       Vector3(0.0, 0.0, 48.0)
}

const ROOM_NAMES: Dictionary = {
	"hub":         "Sảnh Điện Hoàng Gia (Spawn / Hub)",
	"grotto":      "Hang Nấm & Hồ Nước Ngầm (Fountain / Rest)",
	"scriptorium": "Điện Chiêm Tinh & Học Viện Cổ (Lore)",
	"cosmic":      "Điện Tinh Tú Bí Thuật (Combat Arena 1)",
	"crypt":       "Hầm Mộ Cổ Tử Thần (Elite / Key)",
	"dragon":      "Đại Điện Hỏa Long (Boss Arena)",
	"catacombs":   "Mê Cung Catacomb & Bẫy Chông",
	"wharf":       "Bến Thuyền Sông Ngầm & Cổng Tầng 2 (Shop / Exit)"
}

func _ready() -> void:
	_generate_dungeon()

func _generate_dungeon() -> void:
	# 1. Build & Add Room Voxel Meshes with Trimesh Collision
	var room_specs = [
		{"key": "hub",         "fn": Callable(DungeonVoxelBuilder, "build_hub_mesh")},
		{"key": "grotto",      "fn": Callable(DungeonVoxelBuilder, "build_grotto_mesh")},
		{"key": "scriptorium", "fn": Callable(DungeonVoxelBuilder, "build_scriptorium_mesh")},
		{"key": "cosmic",      "fn": Callable(DungeonVoxelBuilder, "build_cosmic_arena_mesh")},
		{"key": "crypt",       "fn": Callable(DungeonVoxelBuilder, "build_crypt_mesh")},
		{"key": "dragon",      "fn": Callable(DungeonVoxelBuilder, "build_dragon_arena_mesh")},
		{"key": "catacombs",   "fn": Callable(DungeonVoxelBuilder, "build_catacombs_mesh")},
		{"key": "wharf",       "fn": Callable(DungeonVoxelBuilder, "build_wharf_mesh")},
		{"key": "corridors",   "fn": Callable(DungeonVoxelBuilder, "build_corridors_mesh")}
	]
	
	for spec in room_specs:
		var key = spec["key"]
		var fn = spec["fn"]
		
		var mesh_inst = MeshInstance3D.new()
		mesh_inst.name = "Room_" + key.capitalize()
		mesh_inst.mesh = fn.call()
		
		# Material override: Vertex colors with subtle roughness
		var mat = StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		mat.vertex_color_use_as_albedo = true
		mat.roughness = 0.85
		mat.specular = 0.2
		mesh_inst.material_override = mat
		
		add_child(mesh_inst)
		mesh_inst.create_trimesh_collision()
		room_nodes[key] = mesh_inst
		
	# 2. Setup Atmospheric Dynamic Lighting
	_setup_dungeon_lighting()

func _setup_dungeon_lighting() -> void:
	var light_root = Node3D.new()
	light_root.name = "DungeonLights"
	add_child(light_root)
	
	# Hub Warm Braziers
	_add_omni_light(light_root, Vector3(-2.8, 1.8, -2.4), Color(1.0, 0.72, 0.25), 2.2, 10.0)
	_add_omni_light(light_root, Vector3( 2.8, 1.8, -2.4), Color(1.0, 0.72, 0.25), 2.2, 10.0)
	_add_omni_light(light_root, Vector3(-2.8, 1.8,  2.4), Color(1.0, 0.72, 0.25), 2.2, 10.0)
	_add_omni_light(light_root, Vector3( 2.8, 1.8,  2.4), Color(1.0, 0.72, 0.25), 2.2, 10.0)
	
	# Grotto Glowing Pool & Luminous Spores
	_add_omni_light(light_root, Vector3(8.0, 2.5, -32.0), Color(0.2, 0.9, 1.0), 3.2, 14.0)
	_add_omni_light(light_root, Vector3(4.0, 1.5, -36.0), Color(0.1, 0.85, 0.8), 2.0, 8.0)
	_add_omni_light(light_root, Vector3(12.0, 1.5, -28.0), Color(1.0, 0.85, 0.2), 2.0, 8.0)
	
	# Scriptorium Warm Scholarly Glow
	_add_omni_light(light_root, Vector3(-26.0, 2.0, -26.0), Color(1.0, 0.9, 0.6), 2.0, 10.0)
	
	# Cosmic Arena Astral Pylons
	_add_omni_light(light_root, Vector3(-31.2, 2.2, -5.2), Color(0.1, 0.8, 1.0), 2.5, 9.0)
	_add_omni_light(light_root, Vector3(-20.8, 2.2, -5.2), Color(0.7, 0.2, 1.0), 2.5, 9.0)
	_add_omni_light(light_root, Vector3(-31.2, 2.2,  5.2), Color(0.7, 0.2, 1.0), 2.5, 9.0)
	_add_omni_light(light_root, Vector3(-20.8, 2.2,  5.2), Color(0.1, 0.8, 1.0), 2.5, 9.0)
	
	# Crypt Eerie Sarcophagus Mist
	_add_omni_light(light_root, Vector3(-26.0, 2.0, 26.0), Color(0.75, 0.3, 0.95), 2.8, 11.0)
	_add_omni_light(light_root, Vector3(-29.6, 1.6, 23.2), Color(0.5, 0.15, 0.8), 1.8, 8.0)
	_add_omni_light(light_root, Vector3(-22.4, 1.6, 28.8), Color(0.5, 0.15, 0.8), 1.8, 8.0)
	
	# Dragon Boss Arena - 6 Colossal Flaming Pillars
	for zp in [-10.0, 0.0, 10.0]:
		_add_omni_light(light_root, Vector3(23.0, 5.2, zp), Color(1.0, 0.45, 0.05), 3.8, 13.0)
		_add_omni_light(light_root, Vector3(41.0, 5.2, zp), Color(1.0, 0.45, 0.05), 3.8, 13.0)
	# Center Molten Dragon Core
	_add_omni_light(light_root, Vector3(32.0, 1.5, 0.0), Color(1.0, 0.3, 0.05), 4.2, 16.0)
	
	# Catacombs Flickering Choke Point Torches
	_add_omni_light(light_root, Vector3(-3.6, 1.8, 26.0), Color(1.0, 0.65, 0.2), 2.0, 8.0)
	_add_omni_light(light_root, Vector3( 3.6, 1.8, 26.0), Color(1.0, 0.65, 0.2), 2.0, 8.0)
	
	# Wharf Subterranean River & Boat
	_add_omni_light(light_root, Vector3( 7.6, 2.0, 48.6), Color(1.0, 0.75, 0.3), 2.2, 10.0) # Boat lantern
	_add_omni_light(light_root, Vector3(-15.0, 1.5, 49.2), Color(0.1, 0.85, 1.0), 3.5, 14.0) # Whirlpool portal
	_add_omni_light(light_root, Vector3( 0.0, 1.2, 48.0), Color(0.1, 0.75, 0.9), 2.5, 12.0) # River midpoint

func _add_omni_light(parent: Node, pos: Vector3, col: Color, energy: float, range_val: float) -> OmniLight3D:
	var l = OmniLight3D.new()
	l.position = pos
	l.light_color = col
	l.light_energy = energy
	l.omni_range = range_val
	l.shadow_enabled = true
	l.shadow_bias = 0.03
	parent.add_child(l)
	lights.append(l)
	return l

func _process(delta: float) -> void:
	# Subtle atmospheric torch flicker
	var t = Time.get_ticks_msec() * 0.005
	for i in range(mini(4, lights.size())):
		lights[i].light_energy = 2.2 + sin(t + float(i) * 1.5) * 0.25
