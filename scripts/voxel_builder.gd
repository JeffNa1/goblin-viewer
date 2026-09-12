class_name VoxelBuilder
extends RefCounted

const V_SCALE: float = 0.03 # 3cm per voxel cube

# Color Palette Constants (sRGB hex)
const C_SKIN: int = 0x477023
const C_SKIN_DARK: int = 0x2e4a16
const C_SKIN_LIGHT: int = 0x619830
const C_SKIN_PALE: int = 0x7fae4b
const C_EAR_INNER: int = 0x9a7b88
const C_TUNIC: int = 0x543e33
const C_TUNIC_DARK: int = 0x382820
const C_TUNIC_PATCH: int = 0x694e41
const C_STITCH: int = 0xc7b299
const C_LEATHER: int = 0x2e1b12
const C_LEATHER_DARK: int = 0x1a0f0a
const C_BUCKLE: int = 0xd97706
const C_ROPE: int = 0xa89689
const C_BONE: int = 0xe2e8f0
const C_WOOD: int = 0x4a2e1b
const C_WOOD_DARK: int = 0x24140b
const C_SPIKE: int = 0x64748b
const C_SPIKE_DARK: int = 0x334155
const C_TEETH: int = 0xe2e8f0
const C_CLAWS: int = 0x1e293b
const C_EYE_YELLOW: int = 0xf59e0b
const C_EYE_PUPIL: int = 0x0f172a
const C_HAIR: int = 0x0f172a
const C_MOUTH_DARK: int = 0x1c0b0b

# Dungeon Floor 1 Special Colors
const C_FEATHER_RED: int = 0xdc2626
const C_FEATHER_WHITE: int = 0xf8fafc
const C_STRING: int = 0xe2e8f0
const C_ARROW_TIP: int = 0x475569
const C_PURPLE_MAGIC: int = 0xa855f7
const C_PURPLE_DARK: int = 0x3b0764
const C_GLOW_CYAN: int = 0x06b6d4
const C_SKULL_BONE: int = 0xf1f5f9
const C_IRON: int = 0x64748b
const C_IRON_DARK: int = 0x334155
const C_STEEL_LIGHT: int = 0x94a3b8
const C_RUST: int = 0x9a3412
const C_GOLD: int = 0xf59e0b

# Heavy Warrior Regalia (Bộ đồ 2 Chiến Binh Thép)
const C_STEEL_BRIGHT: int = 0xcfd8dc
const C_WARRIOR_RED: int = 0x7f1d1d
const C_WARRIOR_RED_DARK: int = 0x450a0a
const C_CHAINMAIL: int = 0x475569
const C_BRONZE: int = 0xb45309
const C_SPIKE_STEEL: int = 0x94a3b8
const C_LAVA_HOT: int = 0xea580c
const C_LAVA_CORE: int = 0xfbbf24

# Shaman Witch-Doctor Regalia Colors
const C_SHAMAN_ROBE: int = 0x2b104c
const C_SHAMAN_ROBE_DARK: int = 0x1a0830
const C_SHAMAN_GOLD: int = 0xeab308
const C_POTION_CYAN: int = 0x22d3ee
const C_POTION_RED: int = 0xef4444
const C_WARPAINT_RED: int = 0xb91c1c

# Grand Arch-Shaman Magenta Regalia Colors (Bộ 2: Đại Pháp Sư)
const C_MAGENTA: int = 0x9d174d
const C_MAGENTA_DARK: int = 0x700c35
const C_MAGENTA_LIGHT: int = 0xbe185d
const C_MAGENTA_ROYAL: int = 0x580628
const C_MAGENTA_GLOW: int = 0xec4899

# Ranger & Archer Color Constants
const C_RANGER_GREEN: int = 0x2e4823
const C_RANGER_DARK: int = 0x1d3016
const C_RANGER_ACCENT: int = 0x436832
const C_LEATHER_WARM: int = 0x4a2e1b

# Primitive Hunter Outfit Colors (Bộ đồ 1 Thô Sơ)
const C_PELT_BASE: int = 0x694e3b
const C_PELT_DARK: int = 0x443022
const C_PELT_LIGHT: int = 0x8e6a50
const C_SINEW: int = 0xb59e7f

# Goblin Rogue Stealth Assassin Palette
const C_ROGUE_HOOD: int = 0x18191f
const C_ROGUE_HOOD_DARK: int = 0x101114
const C_ROGUE_HOOD_TRIM: int = 0x2c2e38
const C_ROGUE_MASK: int = 0x1e2029
const C_ROGUE_LEATHER: int = 0x241812
const C_ROGUE_LEATHER_DARK: int = 0x140c08
const C_VENOM_GREEN: int = 0x22c55e
const C_VENOM_DARK: int = 0x15803d
const C_EYE_AMBER: int = 0xfbbf24
const C_SMOKE_VIAL: int = 0x06b6d4

# Nature & Environment Color Constants
const C_GRASS: int = 0x388219
const C_GRASS_LIGHT: int = 0x5cb82b
const C_GRASS_DARK: int = 0x245811
const C_GRASS_OLIVE: int = 0x489e22
const C_DIRT: int = 0x452b1e
const C_DIRT_DARK: int = 0x2e1b12
const C_STONE: int = 0x64748b
const C_STONE_DARK: int = 0x475569
const C_STONE_LIGHT: int = 0x94a3b8
const C_FLOWER_YELLOW: int = 0xf59e0b
const C_FLOWER_RED: int = 0xef4444
const C_FLOWER_PURPLE: int = 0xa855f7
const C_FLOWER_WHITE: int = 0xf8fafc
const C_FLOWER_STEM: int = 0x2d6919
const C_BARK: int = 0x422613
const C_BARK_DARK: int = 0x2b170a
const C_LEAF_DARK: int = 0x1c4a0f
const C_LEAF_MID: int = 0x2a6616
const C_LEAF_LIGHT: int = 0x3e8a22
const C_LEAF_TOP: int = 0x56a632
const C_MUSHROOM_STEM: int = 0xf1f5f9
const C_MUSHROOM_CAP: int = 0xdc2626

static var _shared_material: StandardMaterial3D = null

static func get_material() -> StandardMaterial3D:
	if _shared_material == null:
		_shared_material = StandardMaterial3D.new()
		_shared_material.vertex_color_use_as_albedo = true
		_shared_material.roughness = 0.88 # Matte clay/plastic voxel finish (VoxEdit standard)
		_shared_material.metallic = 0.02
		_shared_material.cull_mode = BaseMaterial3D.CULL_DISABLED
		_shared_material.specular_mode = StandardMaterial3D.SPECULAR_SCHLICK_GGX
	return _shared_material

# Advanced Seamless Flat Mesh Builder with 100% Interior Face Culling & Clockwise Winding
static func build_seamless_mesh(voxel_array: Array) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(get_material())
	
	var grid: Dictionary = {}
	for v in voxel_array:
		grid[Vector3i(v[0], v[1], v[2])] = v[3]
		
	var s: float = V_SCALE * 0.5
	
	var directions = [
		{"dir": Vector3i(1, 0, 0),  "norm": Vector3(1, 0, 0),  "corners": [Vector3(s, -s, s), Vector3(s, -s, -s), Vector3(s, s, -s), Vector3(s, s, s)]},
		{"dir": Vector3i(-1, 0, 0), "norm": Vector3(-1, 0, 0), "corners": [Vector3(-s, -s, -s), Vector3(-s, -s, s), Vector3(-s, s, s), Vector3(-s, s, -s)]},
		{"dir": Vector3i(0, 1, 0),  "norm": Vector3(0, 1, 0),  "corners": [Vector3(-s, s, s), Vector3(s, s, s), Vector3(s, s, -s), Vector3(-s, s, -s)]},
		{"dir": Vector3i(0, -1, 0), "norm": Vector3(0, -1, 0), "corners": [Vector3(-s, -s, -s), Vector3(s, -s, -s), Vector3(s, -s, s), Vector3(-s, -s, s)]},
		{"dir": Vector3i(0, 0, 1),  "norm": Vector3(0, 0, 1),  "corners": [Vector3(-s, -s, s), Vector3(s, -s, s), Vector3(s, s, s), Vector3(-s, s, s)]},
		{"dir": Vector3i(0, 0, -1), "norm": Vector3(0, 0, -1), "corners": [Vector3(s, -s, -s), Vector3(-s, -s, -s), Vector3(-s, s, -s), Vector3(s, s, -s)]}
	]
	
	var quad_indices = [0, 2, 1, 0, 3, 2] # Clockwise order for Godot 4
	
	for v in voxel_array:
		var pos = Vector3i(v[0], v[1], v[2])
		var col_hex: int = v[3]
		var r: float = float((col_hex >> 16) & 0xff) / 255.0
		var g: float = float((col_hex >> 8) & 0xff) / 255.0
		var b: float = float(col_hex & 0xff) / 255.0
		var col = Color(r, g, b, 1.0)
		var center = Vector3(float(pos.x) * V_SCALE, float(pos.y) * V_SCALE, float(pos.z) * V_SCALE)
		
		for d in directions:
			var n_pos = pos + d["dir"]
			if grid.has(n_pos):
				continue # Hidden internal face culled
				
			var norm: Vector3 = d["norm"]
			var corners: Array = d["corners"]
			
			for idx in quad_indices:
				st.set_color(col)
				st.set_normal(norm)
				st.add_vertex(center + corners[idx])
				
	return st.commit()

# --- 1. HEAD & HELMET ---
static func build_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_head_mesh_outfit2()
	return build_head_mesh_outfit1()

# --- HEAD OUTFIT 1: BAREHEADED FERAL WARRIOR ---
static func build_head_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
				
	# Jaw & Deep Oral Cavity (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				if abs(x) == 4 and z == 6: continue
				var col = C_SKIN
				if y == 4: col = C_SKIN_DARK
				if y in [5, 6] and abs(x) <= 3 and z in [2, 3, 4]:
					col = C_MOUTH_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# Boar Tusks (Lower Jaw)
	voxels[Vector3i(-3, 6, 6)] = C_TEETH
	voxels[Vector3i(3, 6, 6)] = C_TEETH
	voxels[Vector3i(-3, 7, 7)] = C_TEETH
	voxels[Vector3i(3, 7, 7)] = C_TEETH
	voxels[Vector3i(-3, 8, 8)] = C_TEETH
	voxels[Vector3i(3, 8, 8)] = C_TEETH
	voxels[Vector3i(-3, 9, 8)] = C_TEETH
	voxels[Vector3i(3, 9, 8)] = C_TEETH
	voxels[Vector3i(-2, 6, 5)] = C_TEETH
	voxels[Vector3i(0, 6, 5)] = C_TEETH
	voxels[Vector3i(2, 6, 5)] = C_TEETH
	
	# Upper Teeth
	voxels[Vector3i(-3, 7, 5)] = C_TEETH
	voxels[Vector3i(3, 7, 5)] = C_TEETH
	voxels[Vector3i(-1, 7, 5)] = C_TEETH
	voxels[Vector3i(1, 7, 5)] = C_TEETH
	
	# Cranium Base & Rounded Bald Dome (y: 8..16) - NO HAT / NO TOPKNOT
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else (4 if y == 15 else 2))
		var rad_z = 5 if y < 15 else (3 if y == 15 else 2)
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				if (abs(x) == rad_x and abs(z) == rad_z) and (y in [8, 14, 15, 16]): continue
				var col = C_SKIN
				if y >= 15: col = C_SKIN_LIGHT
				elif z == -rad_z: col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# Heavy Brow Ridge & Eyes (y: 10..11)
	for x in range(-4, 5):
		voxels[Vector3i(x, 11, 6)] = C_SKIN_DARK
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_EYE_PUPIL
		
	# Big Chunky Hooked Nose
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
			voxels[Vector3i(x, y, 10)] = C_SKIN
	for x in range(-1, 2):
		voxels[Vector3i(x, 9, 11)] = C_SKIN_LIGHT
		voxels[Vector3i(x, 8, 11)] = C_SKIN
		voxels[Vector3i(x, 8, 12)] = C_SKIN_DARK
	voxels[Vector3i(0, 10, 10)] = C_SKIN_PALE # Wart
	voxels[Vector3i(-2, 8, 8)] = C_SKIN_DARK # Nostrils
	voxels[Vector3i(2, 8, 8)] = C_SKIN_DARK
	voxels[Vector3i(-2, 8, 7)] = C_SKIN_LIGHT
	voxels[Vector3i(2, 8, 7)] = C_SKIN_LIGHT
	
	# LONG SHARP POINTED GOBLIN EARS
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ez = 0 - int(float(s) * 0.4)
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 12
				y_high = 12
			elif s == 7:
				y_low = 11
				y_high = 13
				
			for ey in range(y_low, y_high + 1):
				if s == 5 and ey == y_high: continue
				var col = C_SKIN
				var is_inner = (s >= 1 and s <= 4 and ey >= y_low + 1 and ey <= y_high - 1)
				if is_inner:
					col = C_EAR_INNER
				elif ey == y_high or s == 8:
					col = C_SKIN_LIGHT
				elif ey == y_low:
					col = C_SKIN_DARK
				voxels[Vector3i(ex, ey, ez)] = col
				if s <= 4:
					voxels[Vector3i(ex, ey, ez - 1)] = C_SKIN_DARK
					
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- HEAD OUTFIT 2: IRONCLAD BATTLE-HELMET & CRESTED HORNS ---
static func build_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Neck with chainmail gorget & dark red gambeson lining (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_WARRIOR_RED_DARK if y == 0 else (C_CHAINMAIL if y in [1, 2] and (abs(x) == 3 or abs(z) == 3) else C_SKIN)
				voxels[Vector3i(x, y, z)] = col
				
	# 2. Jaw & Deep Oral Cavity (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				if abs(x) == 4 and z == 6: continue
				var col = C_SKIN
				if y == 4: col = C_SKIN_DARK
				if y in [5, 6] and abs(x) <= 3 and z in [2, 3, 4]:
					col = C_MOUTH_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# Boar Tusks (Lower Jaw)
	voxels[Vector3i(-3, 6, 6)] = C_TEETH
	voxels[Vector3i(3, 6, 6)] = C_TEETH
	voxels[Vector3i(-3, 7, 7)] = C_TEETH
	voxels[Vector3i(3, 7, 7)] = C_TEETH
	voxels[Vector3i(-3, 8, 8)] = C_TEETH
	voxels[Vector3i(3, 8, 8)] = C_TEETH
	voxels[Vector3i(-3, 9, 8)] = C_TEETH
	voxels[Vector3i(3, 9, 8)] = C_TEETH
	voxels[Vector3i(-2, 6, 5)] = C_TEETH
	voxels[Vector3i(0, 6, 5)] = C_TEETH
	voxels[Vector3i(2, 6, 5)] = C_TEETH
	
	# Upper Teeth
	voxels[Vector3i(-3, 7, 5)] = C_TEETH
	voxels[Vector3i(3, 7, 5)] = C_TEETH
	voxels[Vector3i(-1, 7, 5)] = C_TEETH
	voxels[Vector3i(1, 7, 5)] = C_TEETH
	
	# 3. Base Face & Eyes
	for y in range(8, 11):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 and abs(z) == 5: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if z == -5 else C_SKIN
				
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_EYE_PUPIL
		
	# Big Hooked Goblin Nose
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
			voxels[Vector3i(x, y, 10)] = C_SKIN
	for x in range(-1, 2):
		voxels[Vector3i(x, 9, 11)] = C_SKIN_LIGHT
		voxels[Vector3i(x, 8, 11)] = C_SKIN
		voxels[Vector3i(x, 8, 12)] = C_SKIN_DARK
	voxels[Vector3i(0, 10, 10)] = C_SKIN_PALE
	voxels[Vector3i(-2, 8, 8)] = C_SKIN_DARK
	voxels[Vector3i(2, 8, 8)] = C_SKIN_DARK
	
	# Long Goblin Ears
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ez = 0 - int(float(s) * 0.4)
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 12
				y_high = 12
			elif s == 7:
				y_low = 11
				y_high = 13
			for ey in range(y_low, y_high + 1):
				if s == 5 and ey == y_high: continue
				var col = C_SKIN
				var is_inner = (s >= 1 and s <= 4 and ey >= y_low + 1 and ey <= y_high - 1)
				if is_inner:
					col = C_EAR_INNER
				elif ey == y_high or s == 8:
					col = C_SKIN_LIGHT
				elif ey == y_low:
					col = C_SKIN_DARK
				voxels[Vector3i(ex, ey, ez)] = col
				if s <= 4:
					voxels[Vector3i(ex, ey, ez - 1)] = C_SKIN_DARK

	# 4. HEAVY FORGED IRON COMBAT HELMET
	# Forehead Brow Band & Rim (y: 11..12)
	for y in range(11, 13):
		for x in range(-6, 7):
			for z in range(-6, 7):
				if abs(x) > 5 and abs(z) > 5: continue
				if abs(x) == 6 and z in [-1, 0, 1] and y == 11: continue # Ear cutout
				var is_rim = (abs(x) >= 5 or abs(z) >= 5)
				if is_rim:
					var col = C_IRON
					if y == 12: col = C_STEEL_LIGHT
					if z >= 5 and abs(x) in [0, 2, 4]:
						col = C_GOLD
					elif y == 11:
						col = C_IRON_DARK
					voxels[Vector3i(x, y, z)] = col

	# Steel Nasal Guard (y: 8..11, z: 6..7)
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_STEEL_LIGHT if x == 0 else C_IRON
		voxels[Vector3i(0, y, 8)] = C_STEEL_BRIGHT

	# Cheek Guards (x: +-5, y: 5..8, z: 0..4)
	for side in [-1, 1]:
		for y in range(5, 9):
			for z in range(0, 5):
				if z == 0 and y < 7: continue
				voxels[Vector3i(side * 5, y, z)] = C_STEEL_LIGHT if y == 5 or z == 4 else C_IRON
				voxels[Vector3i(side * 5, y, z - 1)] = C_IRON_DARK if z == 1 else C_IRON

	# Helmet Skull Dome (y: 13..17)
	for y in range(13, 18):
		var rx = 6 if y == 13 else (5 if y == 14 else (4 if y == 15 else (3 if y == 16 else 2)))
		var rz = 5 if y <= 14 else (4 if y == 15 else (3 if y == 16 else 2))
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y >= 15: continue
				var col = C_IRON
				if abs(x) == rx or abs(z) == rz or y == 17:
					if y == 17 or abs(x) == 0:
						col = C_STEEL_LIGHT
					elif (x + y + z) % 4 == 0:
						col = C_STEEL_BRIGHT
					elif z == -rz:
						col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# Helmet Apex Thrust Spike (y: 17..22)
	for x in range(-1, 2):
		for z in range(-1, 2):
			voxels[Vector3i(x, 17, z)] = C_GOLD if (abs(x) == 1 and abs(z) == 1) else C_IRON_DARK
			if abs(x) + abs(z) <= 1:
				voxels[Vector3i(x, 18, z)] = C_IRON
	for y in range(19, 23):
		var col = C_STEEL_BRIGHT if y >= 21 else C_STEEL_LIGHT
		voxels[Vector3i(0, y, 0)] = col
		if y == 19:
			voxels[Vector3i(1, 19, 0)] = C_IRON
			voxels[Vector3i(-1, 19, 0)] = C_IRON
			voxels[Vector3i(0, 19, 1)] = C_IRON
			voxels[Vector3i(0, 19, -1)] = C_IRON

	# Barbarian Curved Iron Helmet Horns
	for side in [-1, 1]:
		voxels[Vector3i(side * 5, 14, 0)] = C_GOLD
		voxels[Vector3i(side * 6, 14, 0)] = C_IRON_DARK
		voxels[Vector3i(side * 6, 15, 0)] = C_IRON
		voxels[Vector3i(side * 7, 15, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 6, 16, -1)] = C_IRON
		voxels[Vector3i(side * 7, 16, -1)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 7, 17, -1)] = C_IRON
		voxels[Vector3i(side * 8, 17, -2)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 8, 18, -2)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 8, 19, -2)] = C_STEEL_BRIGHT
		voxels[Vector3i(side * 8, 20, -3)] = C_STEEL_BRIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 2. TORSO & ARMOR ---
static func build_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_torso_mesh_outfit2()
	return build_torso_mesh_outfit1()

# --- TORSO OUTFIT 1: TATTERED TUNIC & ROPES ---
static func build_torso_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				if y <= 1 and (x % 2 == 0 or z % 2 == 0): continue
				
				if (y == 3 or y == 4) and (abs(x) == rx or abs(z) == rz):
					voxels.append([x, y, z, C_ROPE])
					continue
				if y >= 1 and y <= 3 and x <= -rx and z >= 0 and z <= 2:
					voxels.append([x, y, z, C_LEATHER])
					continue
				if y == 2 and x >= rx - 1 and z >= 1 and z <= 2:
					voxels.append([x, y, z, C_BONE])
					continue
				var is_strap = (abs(float(y) - (-1.2 * float(x) + 10.0)) <= 1.2) and (z == rz or z == -rz)
				if is_strap:
					if (y == 10 or y == 11) and (x == 0 or x == 1) and z == rz:
						voxels.append([x, y, z, C_BUCKLE])
					else:
						voxels.append([x, y, z, C_LEATHER])
					continue
				if (y == 7 or y == 8) and (x == 3 or x == 4) and z == rz and (x + y) % 2 == 0:
					voxels.append([x, y, z, C_STITCH])
					continue
				if y >= 15 and abs(x) <= 3 and abs(z) <= 3:
					voxels.append([x, y, z, C_SKIN])
					continue
				if abs(x) <= 1 and z == -rz:
					voxels.append([x, y, z, C_SKIN_DARK if y % 3 == 0 else C_TUNIC])
					continue
				voxels.append([x, y, z, C_TUNIC_PATCH if (x + y) % 5 == 0 else C_TUNIC])
	return build_seamless_mesh(voxels)

# --- TORSO OUTFIT 2: IRON PLATE CUIRASS, WAR GAMBESON & HEAVY PAULDRONS ---
static func build_torso_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Neck opening / chainmail collar
				if y >= 16 and abs(x) <= 2 and abs(z) <= 2:
					voxels[Vector3i(x, y, z)] = C_SKIN
					continue
				if y == 15 and abs(x) <= 2 and abs(z) <= 2:
					voxels[Vector3i(x, y, z)] = C_CHAINMAIL
					continue

				# 1. Base Dark Crimson Gambeson
				var col = C_WARRIOR_RED if (x + y) % 2 == 0 else C_WARRIOR_RED_DARK
				if y <= 2:
					col = C_CHAINMAIL if y == 0 else C_WARRIOR_RED_DARK

				# 2. Front Steel Plate Cuirass (y: 5..15, z >= rz - 1)
				if z >= rz - 1 and y >= 5 and y <= 15:
					var is_keel = (x == 0)
					var is_rim = (y == 5 or y == 15 or abs(x) == 5 or (y >= 14 and abs(x) >= 4))
					if is_keel:
						col = C_STEEL_BRIGHT if y in [8, 9, 10, 11, 12, 13] else C_STEEL_LIGHT
					elif is_rim:
						col = C_STEEL_LIGHT if (y == 15 or abs(x) == 5) else C_IRON_DARK
					else:
						col = C_IRON if (y + x) % 3 != 0 else C_STEEL_LIGHT
					if is_rim and ((abs(x) in [2, 4] and y in [5, 15]) or (abs(x) == 5 and y in [8, 12])):
						col = C_GOLD

				# 3. Back Armor Plate (y: 5..14, z <= -rz + 1)
				if z <= -rz + 1 and y >= 5 and y <= 14:
					if abs(x) <= 4:
						col = C_IRON if (abs(x) < 4 and y < 14) else C_IRON_DARK
						if abs(x) == abs(y - 9):
							col = C_LEATHER_DARK

				# 4. Heavy Studded Combat War Belt (y: 3..4)
				if y in [3, 4] and (abs(x) == rx or abs(z) == rz):
					if z == rz and abs(x) <= 2:
						col = C_GOLD if (abs(x) <= 1 and y == 4) else C_BRONZE
					elif (abs(x) == rx or abs(z) == rz) and (x + z) % 3 == 0:
						col = C_STEEL_LIGHT
					else:
						col = C_LEATHER_DARK

				# 5. Armored Tassets (y: 0..2)
				if y <= 2 and z == rz and abs(x) <= 2:
					col = C_STEEL_LIGHT if (y == 1 and abs(x) == 0) else (C_IRON if y == 1 else C_IRON_DARK)
				if y <= 2 and abs(x) >= rx - 1 and abs(z) <= 2:
					col = C_STEEL_LIGHT if y == 0 else C_IRON

				# 6. Shoulders / Spaulders base (y: 14..17, abs(x) >= 5)
				if abs(x) >= 5 and y >= 14:
					var is_rim = (y == 17 or abs(x) == rx or abs(z) == rz)
					col = C_STEEL_LIGHT if is_rim else C_IRON
					if y == 16 and abs(z) == 1 and abs(x) == 6:
						col = C_GOLD

				voxels[Vector3i(x, y, z)] = col

	# 7. Heavy Tiered Shoulder Pauldrons with Steel Spikes
	for side in [-1, 1]:
		for py in range(15, 18):
			for pz in range(-3, 4):
				var px = side * (7 if py < 17 else 6)
				var is_edge = (py == 17 or abs(pz) == 3)
				voxels[Vector3i(px, py, pz)] = C_STEEL_LIGHT if is_edge else C_IRON
		voxels[Vector3i(side * 7, 18, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 7, 19, 0)] = C_STEEL_BRIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 3. UPPER ARM ---
static func build_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_upper_arm_mesh_outfit2()
	return build_upper_arm_mesh_outfit1()

# --- UPPER ARM OUTFIT 1: BARE MUSCULAR ARM ---
static func build_upper_arm_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -2 and (abs(x) == rx or abs(z) == rz): col = C_SKIN_LIGHT
				if y <= -8: col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

# --- UPPER ARM OUTFIT 2: STEEL REREBRACE & GAMBESON SLEEVE ---
static func build_upper_arm_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				var col = C_WARRIOR_RED if (x + y) % 2 == 0 else C_WARRIOR_RED_DARK
				var is_outer_plate = (y >= -6 and y <= -1) and (abs(x) == rx or abs(z) == rz)
				if is_outer_plate:
					if y == -1 or y == -6 or abs(x) == rx:
						col = C_STEEL_LIGHT if y == -1 else C_IRON
					else:
						col = C_IRON
					if y in [-3, -4] and abs(z) == rz:
						col = C_LEATHER_DARK
					if y == -3 and abs(x) == rx:
						col = C_GOLD
						
				elif y <= -8:
					col = C_CHAINMAIL
				voxels[Vector3i(x, y, z)] = col
				
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 4. FOREARMS & GAUNTLETS ---
static func build_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_forearm_mesh_outfit2(is_right)
	return build_forearm_mesh_outfit1(is_right)

# --- FOREARM OUTFIT 1: LEATHER BRACER & CLAWED FIST ---
static func build_forearm_mesh_outfit1(is_right: bool) -> ArrayMesh:
	var voxels = []
	if not is_right:
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y == -4 or y == -5: col = C_LEATHER
					elif y <= -8:
						if (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_CLAWS if y == -9 else C_SKIN
					voxels.append([x, y, z, col])
	else:
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y == -4 or y == -5:
						col = C_LEATHER_DARK if y == -5 else C_LEATHER
					elif y == -6:
						col = C_SKIN if z >= 0 else C_SKIN_DARK
					elif y <= -7:
						if z == 2:
							col = C_SKIN_LIGHT if y == -7 else (C_CLAWS if y == -9 and abs(x) <= 1 else C_SKIN)
						elif x == 2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						elif x == -2:
							col = C_CLAWS if (y == -8 and z == 1) else C_SKIN_LIGHT
						elif z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						else:
							col = C_SKIN
					voxels.append([x, y, z, col])
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
	voxels.append([-1, -7, 2, C_SKIN_LIGHT])
	voxels.append([-1, -8, 2, C_CLAWS])
	voxels.append([0, -9, 2, C_CLAWS])
	voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

# --- FOREARM OUTFIT 2: HEAVY STEEL VAMBRACE & GAUNTLET ---
static func build_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}
	if not is_right:
		# Left Forearm: Heavy Vambrace & Armored Open Hand
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y in [-1, 0] and z == -2:
						col = C_STEEL_LIGHT # Elbow couter
					elif y >= -6 and y <= -2:
						var is_outer = (abs(x) == 2 or abs(z) == 2)
						if is_outer:
							if z == 2: col = C_STEEL_LIGHT
							elif y in [-2, -6]: col = C_IRON_DARK
							else: col = C_IRON
							if y == -4 and abs(x) == 2: col = C_GOLD
						else:
							col = C_WARRIOR_RED_DARK
					elif y <= -7:
						if z == 2:
							col = C_STEEL_LIGHT if y == -7 else C_IRON
						elif (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_STEEL_BRIGHT if y == -9 else C_IRON
						elif y == -7:
							col = C_LEATHER_DARK
					voxels[Vector3i(x, y, z)] = col
	else:
		# Right Forearm: Full Articulated Iron Gauntlet (Zero Holes)
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y in [-1, 0] and z == -2:
						col = C_STEEL_LIGHT # Elbow couter
					elif y >= -6 and y <= -2:
						var is_outer = (abs(x) == 2 or abs(z) == 2)
						if is_outer:
							if z == -2: col = C_STEEL_LIGHT
							elif y in [-2, -6]: col = C_IRON_DARK
							else: col = C_IRON
							if y == -4 and abs(x) == 2: col = C_GOLD
						else:
							col = C_WARRIOR_RED_DARK
					elif y <= -7:
						if z == 2:
							col = C_STEEL_LIGHT if y == -7 else (C_STEEL_BRIGHT if y == -9 and abs(x) <= 1 else C_IRON)
						elif x == 2:
							col = C_IRON_DARK if y == -9 else C_IRON
						elif x == -2:
							col = C_STEEL_LIGHT if (y == -8 and z == 1) else C_IRON
						elif z == -2:
							col = C_STEEL_LIGHT if y == -7 else C_IRON_DARK
						else:
							col = C_LEATHER_DARK
					voxels[Vector3i(x, y, z)] = col
					
		voxels[Vector3i(-2, -7, 1)] = C_STEEL_LIGHT
		voxels[Vector3i(-1, -7, 2)] = C_STEEL_LIGHT
		voxels[Vector3i(-1, -8, 2)] = C_STEEL_BRIGHT
		voxels[Vector3i(0, -9, 2)] = C_STEEL_BRIGHT
		voxels[Vector3i(1, -9, 2)] = C_STEEL_BRIGHT
		voxels[Vector3i(2, -6, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(-2, -6, 0)] = C_STEEL_LIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 5. LEGS & WAR BOOTS ---
static func build_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_thigh_mesh_outfit2()
	return build_thigh_mesh_outfit1()

# --- THIGH OUTFIT 1: TUNIC PANTS ---
static func build_thigh_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -4:
					col = C_TUNIC_DARK if y == -4 else C_TUNIC
				elif (y == -8 or y == -9) and z == rz and abs(x) <= 1:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

# --- THIGH OUTFIT 2: REINFORCED TROUSERS & STEEL KNEE COPS ---
static func build_thigh_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_WARRIOR_RED_DARK if (x + y) % 2 == 0 else C_LEATHER_DARK
				if y >= -3 and (abs(x) == rx or abs(z) == rz):
					col = C_CHAINMAIL
				# Steel Poleyn (Knee guard at front)
				if y in [-9, -8] and z == rz and abs(x) <= 2:
					if y == -8 and abs(x) == 0:
						col = C_STEEL_BRIGHT
					elif abs(x) == 2 or y == -9:
						col = C_IRON_DARK
					else:
						col = C_STEEL_LIGHT
				elif y in [-9, -8] and z == rz - 1 and abs(x) <= 2:
					col = C_IRON
				voxels[Vector3i(x, y, z)] = col
				
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

static func build_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shin_mesh_outfit2()
	return build_shin_mesh_outfit1()

# --- SHIN OUTFIT 1: BARE FEET & LEATHER WRAPS ---
static func build_shin_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_SKIN
				if z == 2: col = C_SKIN_LIGHT
				elif z == -3: col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_LEATHER_DARK if y == -6 else C_LEATHER
				voxels.append([x, y, z, col])
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_SKIN_DARK if abs(x) == 3 else C_SKIN
			voxels.append([x, -8, z, col])
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_SKIN
				if y == -10: col = C_SKIN_DARK
				elif z >= 0 and y == -8: col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SKIN_LIGHT if (ty == -9 and tz == 4) else C_SKIN
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_SKIN])
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
	return build_seamless_mesh(voxels)

# --- SHIN OUTFIT 2: STEEL GREAVES & SPIKED WAR SABATON BOOTS ---
static func build_shin_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Full Curved Steel Greaves (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_IRON
				if z == 2:
					col = C_STEEL_BRIGHT if y in [-4, -3] else C_STEEL_LIGHT
				elif z == -3:
					col = C_IRON_DARK
				elif abs(x) == 2 and y in [-2, -5]:
					col = C_GOLD
				voxels[Vector3i(x, y, z)] = col
				
	# 2. Ankle Joint Guard & Wrap (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_STEEL_LIGHT if z == 2 else (C_LEATHER_DARK if abs(x) == 2 else C_IRON_DARK)
				voxels[Vector3i(x, y, z)] = col
				
	# 3. Flared Ankle Armor Plate (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_STEEL_LIGHT if abs(x) == 3 or z == 2 else C_IRON
			voxels[Vector3i(x, -8, z)] = col
			
	# 4. HEAVY ARMORED WAR SABATONS (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_IRON
				if y == -10:
					col = C_IRON_DARK
				elif z >= 0 and y == -8:
					col = C_STEEL_LIGHT
				elif z == -3:
					col = C_STEEL_LIGHT
				voxels[Vector3i(x, y, z)] = col
				
	# 5. Articulated Steel Toe Caps & Forward Cleat Spikes (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_STEEL_LIGHT if (ty == -9 and tz == 4) else C_IRON
				voxels[Vector3i(tx, ty, tz)] = col
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels[Vector3i(side_x, -10, tz)] = C_IRON
						
		voxels[Vector3i(tx, -10, 6)] = C_STEEL_LIGHT
		voxels[Vector3i(tx, -10, 7)] = C_STEEL_BRIGHT
		voxels[Vector3i(tx, -9, 6)] = C_STEEL_BRIGHT
		
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 6. WEAPONS: CLUB (OUTFIT 1) & HEAVY FLANGED WAR MACE (OUTFIT 2) ---
static func build_club_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_club_mesh_outfit2()
	return build_club_mesh_outfit1()

# --- WEAPON OUTFIT 1: PRIMITIVE SPIKED WOODEN CLUB ---
static func build_club_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-8, -4):
		var rad = 2 if y == -8 else 1
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				voxels.append([x, y, z, C_WOOD_DARK])
	for y in range(-4, 7):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				voxels.append([x, y, z, C_LEATHER_DARK if y % 2 == 0 else C_LEATHER])
	for y in range(7, 14):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				voxels.append([x, y, z, C_WOOD])
	for y in range(13, 15):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 or abs(z) == 2:
					voxels.append([x, y, z, C_SPIKE if (x == 0 or z == 0) else C_SPIKE_DARK])
	for y in range(15, 29):
		var rad = 3 if y < 20 else (4 if y < 26 else 3)
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad: continue
				var col = C_WOOD_DARK if (y in [18, 22, 28]) else C_WOOD
				if (y == 24 or y == 25) and (abs(x) == rad or abs(z) == rad):
					col = C_SPIKE if (x == 0 or z == 0) else C_SPIKE_DARK
				voxels.append([x, y, z, col])
	for sy in [17, 20, 23, 26]:
		var srad = 3 if sy < 20 else 4
		for dir in [[1, 0], [-1, 0], [0, 1], [0, -1]]:
			voxels.append([dir[0] * (srad + 1), sy, dir[1] * (srad + 1), C_SPIKE])
			voxels.append([dir[0] * (srad + 2), sy, dir[1] * (srad + 2), C_SPIKE])
	return build_seamless_mesh(voxels)

# --- WEAPON OUTFIT 2: HEAVY FLANGED STEEL WAR MACE & APEX THRUST SPIKE ---
static func build_club_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Faceted Octagonal Pommel Counterweight (y: -8 to -5)
	for y in range(-8, -4):
		var rad = 2 if y in [-7, -6] else 1
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad and rad > 1: continue
				var col = C_STEEL_LIGHT
				if y == -8:
					col = C_GOLD
				elif y == -5:
					col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# 2. Grip Shaft: Dark Crimson Leather Wrap & Steel Wire (y: -4 to 7)
	for y in range(-4, 8):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				var is_wire = ((x + y + z) % 3 == 0)
				var col = C_STEEL_BRIGHT if is_wire else (C_WARRIOR_RED if y % 2 == 0 else C_LEATHER_DARK)
				voxels[Vector3i(x, y, z)] = col
				
	# 3. Flared Handguard Collar / Disc (y: 8 to 9)
	for y in range(8, 10):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				var is_edge = (abs(x) == 2 or abs(z) == 2)
				var col = C_STEEL_LIGHT if is_edge else C_GOLD
				voxels[Vector3i(x, y, z)] = col
				
	# 4. Upper Mace Haft: Forged Hexagonal Steel (y: 10 to 14)
	for y in range(10, 15):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				var col = C_STEEL_LIGHT if (x == 0 or z == 0) else C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# 5. Mace Head Core (y: 15 to 27)
	for y in range(15, 28):
		var rad = 2
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad: continue
				var col = C_IRON if (y in [18, 22, 26]) else C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col
				
	# 6. 4 Massive Forged Steel Flanges / Beveled War Blades (y: 16 to 27)
	for y in range(16, 28):
		var f_width = 3 if (y in [16, 27]) else (4 if (y in [17, 25, 26]) else 5)
		
		for x_sign in [-1, 1]:
			for d in range(2, f_width + 1):
				var fx = x_sign * d
				for fz in [-1, 0, 1]:
					if abs(fz) == 1 and d > 3: continue
					var col = C_IRON
					if d == f_width:
						col = C_STEEL_BRIGHT if y in [21, 22, 23] else C_STEEL_LIGHT
					elif abs(fz) == 1:
						col = C_STEEL_LIGHT
					voxels[Vector3i(fx, y, fz)] = col
					
		for z_sign in [-1, 1]:
			for d in range(2, f_width + 1):
				var fz = z_sign * d
				for fx in [-1, 0, 1]:
					if abs(fx) == 1 and d > 3: continue
					var col = C_IRON
					if d == f_width:
						col = C_STEEL_BRIGHT if y in [21, 22, 23] else C_STEEL_LIGHT
					elif abs(fx) == 1:
						col = C_STEEL_LIGHT
					voxels[Vector3i(fx, y, fz)] = col
					
	# 7. 4 Diagonal Corner Cleat Spikes (at 45 degrees)
	for sy in [18, 21, 24]:
		for cx in [-1, 1]:
			for cz in [-1, 1]:
				voxels[Vector3i(cx * 3, sy, cz * 3)] = C_STEEL_LIGHT
				if sy == 21:
					voxels[Vector3i(cx * 4, sy, cz * 4)] = C_STEEL_BRIGHT
					
	# 8. Golden Crown Reinforcement Ring (y: 27 to 28)
	for x in range(-2, 3):
		for z in range(-2, 3):
			if abs(x) == 2 or abs(z) == 2:
				if not (abs(x) == 2 and abs(z) == 2):
					voxels[Vector3i(x, 27, z)] = C_GOLD
					voxels[Vector3i(x, 28, z)] = C_BRONZE

	# 9. Piercing Apex Crown Spike (y: 28 to 31)
	for x in range(-1, 2):
		for z in range(-1, 2):
			voxels[Vector3i(x, 28, z)] = C_STEEL_LIGHT
	for x in range(-1, 2):
		for z in range(-1, 2):
			if abs(x) + abs(z) <= 1:
				voxels[Vector3i(x, 29, z)] = C_STEEL_LIGHT
	voxels[Vector3i(0, 30, 0)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, 31, 0)] = C_STEEL_BRIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 7. PEDESTAL & GLOW RING (VoxEdit Slate Minimalist) ---
static func build_pedestal_mesh() -> CylinderMesh:
	var cm = CylinderMesh.new()
	cm.top_radius = 1.25
	cm.bottom_radius = 1.35
	cm.height = 0.16
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.14, 0.16, 0.20, 1.0)
	mat.roughness = 0.85
	mat.metallic = 0.04
	cm.material = mat
	return cm

static func build_pedestal_ring_mesh() -> TorusMesh:
	var tm = TorusMesh.new()
	tm.inner_radius = 1.25
	tm.outer_radius = 1.28
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.35, 0.75, 0.95, 1.0)
	mat.emission_enabled = true
	mat.emission = Color(0.35, 0.75, 0.95, 1.0)
	mat.emission_energy_multiplier = 1.6
	tm.material = mat
	return tm


# --- 7. EXPANSIVE CONTINUOUS VOXEL TERRAIN (Đất Thật Trải Rộng, Không Phải Bàn Tròn!) ---
static func build_meadow_mesh() -> ArrayMesh:
	var voxels = []
	# Continuous rectangular terrain 110x110 voxels at scale 0.07m = 7.7m x 7.7m
	# Completely covers camera viewport to the horizon
	var x_min = -55
	var x_max = 55
	var z_min = -70
	var z_max = 40
	
	for x in range(x_min, x_max + 1):
		for z in range(z_min, z_max + 1):
			var h: int = abs((x * 374761393 ^ z * 668265263)) % 100
			
			# 1. Main grass terrain surface at y = 0
			var col: int = C_GRASS
			# Stepping stone pathway under goblin's feet (x in [-4, 4], z in [-6, 6])
			if abs(x) <= 4 and abs(z) <= 6 and h % 2 == 0:
				if h % 6 == 0: col = C_STONE_LIGHT
				elif h % 4 == 0: col = C_STONE_DARK
				else: col = C_STONE
			else:
				if h < 40: col = C_GRASS
				elif h < 66: col = C_GRASS_OLIVE
				elif h < 84: col = C_GRASS_LIGHT
				else: col = C_GRASS_DARK
				
			voxels.append([x, 0, z, col])
			
			# 2. Clustered Wildflowers & Grass Tufts across the landscape
			var d2_center = x * x + z * z
			if d2_center > 100: # outside immediate feet
				# Yellow buttercups (right glade: x in [8, 30], z in [-10, 25])
				var dy = (x - 18) * (x - 18) + (z - 10) * (z - 10)
				if dy < 120.0 and h % 3 == 0:
					voxels.append([x, 1, z, C_FLOWER_STEM])
					voxels.append([x, 2, z, C_FLOWER_YELLOW])
					
				# Red poppies (left glade: x in [-30, -8], z in [-10, 25])
				var dr = (x + 18) * (x + 18) + (z - 8) * (z - 8)
				if dr < 120.0 and h % 3 == 0:
					voxels.append([x, 1, z, C_FLOWER_STEM])
					voxels.append([x, 2, z, C_FLOWER_RED])
					
				# Purple lavender (deep background left: x in [-35, -10], z < -20)
				var dp = (x + 16) * (x + 16) + (z + 30) * (z + 30)
				if dp < 140.0 and h % 3 == 0:
					voxels.append([x, 1, z, C_FLOWER_STEM])
					voxels.append([x, 2, z, C_FLOWER_PURPLE])
					
				# White chamomile (deep background right: x in [10, 35], z < -20)
				var dw = (x - 18) * (x - 18) + (z + 28) * (z + 28)
				if dw < 120.0 and h % 3 == 0:
					voxels.append([x, 1, z, C_FLOWER_WHITE])
					
				# Raised voxel grass blades
				if h % 19 == 0 and h > 35:
					voxels.append([x, 1, z, C_GRASS_LIGHT])
					
	return build_seamless_mesh_scaled(voxels, 0.07)

# --- 8. GIANT VOXEL FOREST TREES (Rừng Cổ Thụ Đa Tầng Tán Lá Xum Xuê & Cao Vút) ---
static func build_forest_mesh() -> ArrayMesh:
	var voxels = []
	
	# Layered Forest Glade: Giant Sentinels & Pines pushed back to frame the clearing
	# Format: [tx, tz, th] (scale 0.10m per voxel)
	var trees = [
		# Mid-ground backdrop trees (Pushed back to keep clearing 100% open)
		Vector3i(0, 42, -42),      # Center deep backdrop tree (4.2m tall)
		Vector3i(-24, 42, -38),    # Left backdrop tree
		Vector3i(24, 42, -38),     # Right backdrop tree
		Vector3i(-44, 44, -28),    # Wide left flank tree
		Vector3i(44, 44, -28),     # Wide right flank tree
		
		# Towering Colossus Sentinels in the deep background (5.0m - 6.5m)
		Vector3i(-14, 65, -55),    # Deep giant sentinel
		Vector3i(14, 64, -55),     # Deep giant sentinel
		Vector3i(-32, 55, -48),    # Deep-left colossus
		Vector3i(32, 56, -48)      # Deep-right colossus
	]
	
	for t in trees:
		var tx: int = t.x
		var th: int = t.y
		var tz: int = t.z
		
		# 1. Solid Wood Trunk (3x3 core)
		for y in range(0, th - 10):
			for x in range(tx - 1, tx + 2):
				for z in range(tz - 1, tz + 2):
					var col = C_BARK if (x + y + z) % 2 == 0 else C_BARK_DARK
					voxels.append([x, y, z, col])
					
		# 2. Flared Buttress Roots (y: 0..3)
		for rx in [-2, 0, 2]:
			for rz in [-2, 0, 2]:
				if abs(rx) == 2 or abs(rz) == 2:
					voxels.append([tx + rx, 0, tz + rz, C_BARK_DARK])
					voxels.append([tx + rx, 1, tz + rz, C_BARK_DARK])
					if (rx == 0 or rz == 0):
						voxels.append([tx + rx, 2, tz + rz, C_BARK])
						
		# 3. 4-Tiered Sprawling Foliage Canopy
		# Lower trees have canopies starting lower down so leaves are prominently visible
		var c_low = max(10, th - 24)
		var tiers = [
			[c_low, c_low + 7, 9, C_LEAF_DARK, C_LEAF_MID],
			[c_low + 7, c_low + 13, 7, C_LEAF_MID, C_LEAF_LIGHT],
			[c_low + 13, c_low + 18, 5, C_LEAF_LIGHT, C_LEAF_TOP],
			[c_low + 18, th + 2, 2, C_LEAF_TOP, C_LEAF_TOP]
		]
		
		for tier in tiers:
			var y_min: int = tier[0]
			var y_max: int = tier[1]
			var rad: int = tier[2]
			var c_outer: int = tier[3]
			var c_inner: int = tier[4]
			var rad2: int = rad * rad
			var shell2: int = int((rad - 1.5) * (rad - 1.5))
			
			for y in range(y_min, y_max):
				var is_cap: bool = (y == y_min or y == y_max - 1)
				for x in range(tx - rad, tx + rad + 1):
					for z in range(tz - rad, tz + rad + 1):
						var d2: int = (x - tx) * (x - tx) + (z - tz) * (z - tz)
						if d2 <= rad2:
							if is_cap or d2 >= shell2:
								var col = c_outer if (x + y + z) % 3 == 0 else c_inner
								voxels.append([x, y, z, col])
								
		# 4. Forest Undergrowth: Red Mushrooms & Moss Boulders
		voxels.append([tx + 3, 1, tz + 2, C_MUSHROOM_STEM])
		voxels.append([tx + 3, 2, tz + 2, C_MUSHROOM_CAP])
		voxels.append([tx - 2, 1, tz + 3, C_STONE_DARK])
		voxels.append([tx - 2, 2, tz + 3, C_GRASS_DARK])
		
	# Add fallen mossy logs
	for lx in range(-8, 9):
		voxels.append([lx, 1, -22, C_BARK_DARK])
		voxels.append([lx, 1, -23, C_BARK if lx % 2 == 0 else C_GRASS_DARK])
		
	return build_seamless_mesh_scaled(voxels, 0.10)

# Scaled Seamless Mesh Builder
static func build_seamless_mesh_scaled(voxel_array: Array, voxel_scale: float) -> ArrayMesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(get_material())
	
	var grid: Dictionary = {}
	for v in voxel_array:
		grid[Vector3i(v[0], v[1], v[2])] = v[3]
		
	var s: float = voxel_scale * 0.5
	
	var directions = [
		{"dir": Vector3i(1, 0, 0),  "norm": Vector3(1, 0, 0),  "corners": [Vector3(s, -s, s), Vector3(s, -s, -s), Vector3(s, s, -s), Vector3(s, s, s)]},
		{"dir": Vector3i(-1, 0, 0), "norm": Vector3(-1, 0, 0), "corners": [Vector3(-s, -s, -s), Vector3(-s, -s, s), Vector3(-s, s, s), Vector3(-s, s, -s)]},
		{"dir": Vector3i(0, 1, 0),  "norm": Vector3(0, 1, 0),  "corners": [Vector3(-s, s, s), Vector3(s, s, s), Vector3(s, s, -s), Vector3(-s, s, -s)]},
		{"dir": Vector3i(0, -1, 0), "norm": Vector3(0, -1, 0), "corners": [Vector3(-s, -s, -s), Vector3(s, -s, -s), Vector3(s, -s, s), Vector3(-s, -s, s)]},
		{"dir": Vector3i(0, 0, 1),  "norm": Vector3(0, 0, 1),  "corners": [Vector3(-s, -s, s), Vector3(s, -s, s), Vector3(s, s, s), Vector3(-s, s, s)]},
		{"dir": Vector3i(0, 0, -1), "norm": Vector3(0, 0, -1), "corners": [Vector3(s, -s, -s), Vector3(-s, -s, -s), Vector3(-s, s, -s), Vector3(s, s, -s)]}
	]
	
	var quad_indices = [0, 2, 1, 0, 3, 2]
	
	for v in voxel_array:
		var pos = Vector3i(v[0], v[1], v[2])
		var col_hex: int = v[3]
		var r: float = float((col_hex >> 16) & 0xff) / 255.0
		var g: float = float((col_hex >> 8) & 0xff) / 255.0
		var b: float = float(col_hex & 0xff) / 255.0
		var col = Color(r, g, b, 1.0)
		var center = Vector3(float(pos.x) * voxel_scale, float(pos.y) * voxel_scale, float(pos.z) * voxel_scale)
		
		for d in directions:
			var n_pos = pos + d["dir"]
			if grid.has(n_pos):
				continue
				
			var norm: Vector3 = d["norm"]
			var corners: Array = d["corners"]
			
			for idx in quad_indices:
				st.set_color(col)
				st.set_normal(norm)
				st.add_vertex(center + corners[idx])
				
	return st.commit()

# =========================================================================
# DUNGEON FLOOR 1 MONSTER VOXEL MESH BUILDERS
# =========================================================================

# --- A. GOBLIN ARCHER (Cung & Bao Tên) ---

static func build_archer_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_head_mesh_outfit1()
	return build_archer_head_mesh_outfit2()

static func build_archer_head_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Base head geometry identical for anatomical consistency
	# Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
	# Jaw (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				if abs(x) == 4 and z == 6: continue
				var col = C_SKIN
				if y == 4: col = C_SKIN_DARK
				if y in [5, 6] and abs(x) <= 3 and z in [2, 3, 4]: col = C_MOUTH_DARK
				voxels[Vector3i(x, y, z)] = col
	voxels[Vector3i(-3, 6, 6)] = C_TEETH
	voxels[Vector3i(3, 6, 6)] = C_TEETH
	voxels[Vector3i(-2, 6, 5)] = C_TEETH
	voxels[Vector3i(0, 6, 5)] = C_TEETH
	voxels[Vector3i(2, 6, 5)] = C_TEETH

	# Cranium (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else (4 if y == 15 else 2))
		var rad_z = 5 if y < 15 else (3 if y == 15 else 2)
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				if (abs(x) == rad_x and abs(z) == rad_z) and (y in [8, 14, 15, 16]): continue
				var col = C_SKIN
				if y >= 15: col = C_SKIN_LIGHT
				elif z == -rad_z: col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Big Nose
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
	for x in range(-1, 2):
		voxels[Vector3i(x, 9, 10)] = C_SKIN_LIGHT
		voxels[Vector3i(x, 8, 10)] = C_SKIN_DARK

	# Long Pointed Ears
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.4)
			var ez = -1 - int(float(s) * 0.75)
			var h_half = 2 if s < 3 else (1 if s < 6 else 0)
			for dy in range(-h_half, h_half + 1):
				voxels[Vector3i(ex, ey + dy, ez)] = C_SKIN
				if s >= 1 and s <= 4 and dy == 0:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER

	# OUTFIT 1: Rawhide Headband with Bone Beads & Aiming Eyepatch (No Feather)
	for x in range(-6, 7):
		for z in range(-5, 6):
			if abs(x) == 6 or abs(z) == 5:
				if not (abs(x) == 6 and abs(z) == 5):
					voxels[Vector3i(x, 12, z)] = C_LEATHER
	voxels[Vector3i(-6, 12, 0)] = C_BONE
	voxels[Vector3i(-6, 11, 0)] = C_TEETH # Prey canine tooth charm

	# Eyepatch over Right Eye (x > 0)
	for x in range(1, 4):
		for y in range(10, 12):
			voxels[Vector3i(x, y, 6)] = C_LEATHER_DARK
			voxels[Vector3i(x, y, 7)] = C_LEATHER_DARK
	# Left Eye: Sharp yellow eye with black slit pupil
	voxels[Vector3i(-2, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-3, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_archer_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Base head geometry identical to warrior for anatomical consistency
	# Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
	# Jaw (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				if abs(x) == 4 and z == 6: continue
				var col = C_SKIN
				if y == 4: col = C_SKIN_DARK
				if y in [5, 6] and abs(x) <= 3 and z in [2, 3, 4]: col = C_MOUTH_DARK
				voxels[Vector3i(x, y, z)] = col
	voxels[Vector3i(-3, 6, 6)] = C_TEETH
	voxels[Vector3i(3, 6, 6)] = C_TEETH
	voxels[Vector3i(-2, 6, 5)] = C_TEETH
	voxels[Vector3i(0, 6, 5)] = C_TEETH
	voxels[Vector3i(2, 6, 5)] = C_TEETH

	# Cranium (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else (4 if y == 15 else 2))
		var rad_z = 5 if y < 15 else (3 if y == 15 else 2)
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				if (abs(x) == rad_x and abs(z) == rad_z) and (y in [8, 14, 15, 16]): continue
				var col = C_SKIN
				if y >= 15: col = C_SKIN_LIGHT
				elif z == -rad_z: col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Big Nose
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
	for x in range(-1, 2):
		voxels[Vector3i(x, 9, 10)] = C_SKIN_LIGHT
		voxels[Vector3i(x, 8, 10)] = C_SKIN_DARK

	# Long Pointed Ears
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.4)
			var ez = -1 - int(float(s) * 0.75)
			var h_half = 2 if s < 3 else (1 if s < 6 else 0)
			for dy in range(-h_half, h_half + 1):
				voxels[Vector3i(ex, ey + dy, ez)] = C_SKIN
				if s >= 1 and s <= 4 and dy == 0:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER

	# ARCHER ACCESSORY: Leather Headband, Feather & Eyepatch
	# Headband circling head at y = 12
	for x in range(-6, 7):
		for z in range(-5, 6):
			if abs(x) == 6 or abs(z) == 5:
				if not (abs(x) == 6 and abs(z) == 5):
					voxels[Vector3i(x, 12, z)] = C_LEATHER
	# Scout Feather tucked behind left ear / headband (x: -6..-7, y: 13..18, z: -2..-6)
	for i in range(6):
		var fy = 13 + i
		var fz = -2 - int(float(i) * 0.75)
		voxels[Vector3i(-6, fy, fz)] = C_FEATHER_RED if i % 2 == 0 else C_FEATHER_WHITE
		voxels[Vector3i(-7, fy, fz)] = C_FEATHER_WHITE if i % 2 == 0 else C_FEATHER_RED

	# Eyepatch over Right Eye (x > 0)
	for x in range(1, 4):
		for y in range(10, 12):
			voxels[Vector3i(x, y, 6)] = C_LEATHER
			voxels[Vector3i(x, y, 7)] = C_LEATHER
	# Left Eye: Sharp yellow eye with black slit pupil
	voxels[Vector3i(-2, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-3, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# --- ARCHER OUTFITS: BỘ ĐỒ 1 (THÔ SƠ / HOANG DÃ) & BỘ ĐỒ 2 (RANGER XẠ THỦ) ---

static func build_archer_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_torso_mesh_outfit1()
	return build_archer_torso_mesh_outfit2()

# --- BỘ ĐỒ 1: THỢ SĂN NGUYÊN THỦY (Áo Da Thú Xé Rách, Dây Gân, Nanh Vuốt Săn Bắn) ---
static func build_archer_torso_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# 1. Exposed goblin chest & neck (Asymmetrical open fur vest)
				if y >= 15 and abs(x) <= 3 and abs(z) <= 3:
					voxels.append([x, y, z, C_SKIN])
					continue
				if z == rz and abs(x) <= 1 and y >= 9 and y <= 14:
					voxels.append([x, y, z, C_SKIN if y >= 12 else C_SKIN_DARK])
					continue
					
				# 2. Jagged Raw Pelt Hem (Tattered fur edges at y in [0, 1])
				if y <= 1:
					var is_fringe = (x + z * 2) % 3 == 0
					if is_fringe and (abs(x) == rx or abs(z) == rz):
						continue # Jagged notch
					if y == 0 and (x % 2 != 0):
						continue
						
				# 3. Base Animal Pelt Vest (Warm wild fur)
				var col = C_PELT_BASE
				if (abs(x) == rx or abs(z) == rz) and y <= 2:
					col = C_PELT_DARK # Shadowed ragged hem
					
				# 4. Slender Rawhide Cord Belt (y == 3)
				if y == 3 and (abs(x) == rx or abs(z) == rz):
					if abs(x) <= 1 and z == rz:
						col = C_BONE # Carved bone bead toggle clasp (distinct from warrior rope!)
					else:
						col = C_LEATHER_DARK
						
				# 5. Hunting Trophies hanging from belt (x == -rx, y in [1, 2], z in [0, 1])
				if x <= -rx and z in [0, 1]:
					if y == 2: col = C_SINEW
					elif y == 1: col = C_TEETH # Small prey canine trophy
					
				# 6. Diagonal Sinew Cross-Strap for Quiver
				var strap_y = -1.1 * float(x) + 9.5
				var is_front_strap = (abs(float(y) - strap_y) <= 0.8) and (z == rz)
				var is_back_strap = (abs(float(y) - strap_y) <= 0.8) and (z == -rz)
				if is_front_strap:
					if y == 10 and x == 0:
						col = C_TEETH # Beast fang toggle pinned to chest strap
					else:
						col = C_SINEW # Twisted sinew cord
				elif is_back_strap:
					col = C_LEATHER_DARK
					
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

# --- BỘ ĐỒ 2: RANGER GAMBESON, CHESTGUARD PLASTRON, PAULDRON & POUCH ---
static func build_archer_torso_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				# Slit scalloped tunic hem at hips (y in [0, 1])
				if y <= 1 and (abs(x) == rx or abs(z) == rz) and (x % 3 == 0 or z % 3 == 0): continue
				
				# 1. Base Hunter Ranger Gambeson
				var col = C_RANGER_GREEN
				if (abs(x) == rx or abs(z) == rz) and y in [0, 1]:
					col = C_LEATHER_DARK
				elif y >= 15 and abs(x) <= 3 and abs(z) <= 3:
					col = C_SKIN
					voxels.append([x, y, z, col])
					continue
					
				# 2. Wide Leather Utility Belt (y: 3..4)
				if (y == 3 or y == 4) and (abs(x) == rx or abs(z) == rz):
					if (y == 3 or y == 4) and abs(x) <= 1 and z == rz:
						col = C_BUCKLE # Brass Belt Buckle
					elif abs(x) == rx and z in [0, 1]:
						col = C_LEATHER_WARM
					else:
						col = C_LEATHER_DARK
						
				# 3. Left Hip Hunting Pouch
				if y >= 2 and y <= 5 and x <= -rx and z >= 0 and z <= 2:
					if y == 5 and z == 1:
						col = C_BONE
					elif (y == 3 or y == 4) and z == 1:
						col = C_BUCKLE
					else:
						col = C_LEATHER_WARM
						
				# 4. Asymmetrical Archer Chestguard (Plastron on Left Chest)
				var is_plastron = (x >= -5 and x <= -1) and (y >= 7 and y <= 13) and (z == rz)
				if is_plastron:
					if (x in [-5, -1] and y in [7, 13]):
						col = C_BUCKLE
					elif x == -5 or x == -1 or y == 7 or y == 13:
						col = C_LEATHER_DARK
					else:
						col = C_LEATHER_WARM
						
				# 5. Right Shoulder Leather Pauldron
				var is_pauldron = (x >= 4 and x <= rx) and (y >= 14 and y <= 16) and (abs(z) >= rz - 1)
				if is_pauldron:
					col = C_BUCKLE if (x == 5 and y == 15 and z == rz) else C_LEATHER_DARK
					
				# 6. Diagonal Quiver Cross-Strap across chest & back
				var strap_y = -1.1 * float(x) + 9.5
				var is_front_strap = (abs(float(y) - strap_y) <= 1.0) and (z == rz) and not is_plastron
				var is_back_strap = (abs(float(y) - strap_y) <= 1.0) and (z == -rz)
				if is_front_strap:
					if (y == 9 or y == 10) and (x == 0 or x == 1):
						col = C_BUCKLE
					else:
						col = C_LEATHER_DARK
				elif is_back_strap:
					col = C_LEATHER_DARK
					
				# 7. Front V-neck laced closure
				if z == rz and abs(x) <= 1 and y >= 11 and y <= 14:
					if abs(x) == 1 and y % 2 == 0:
						col = C_ROPE
					elif x == 0 and y >= 12:
						col = C_SKIN_DARK
						
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_upper_arm_mesh_outfit1()
	return build_archer_upper_arm_mesh_outfit2()

static func build_archer_upper_arm_mesh_outfit1() -> ArrayMesh:
	# Bare wiry green goblin arms, simple raw fur shoulder cap trim at top
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				# Small fur fringe at shoulder edge (y == 0, y == -1)
				if y >= -1 and (abs(x) == rx or abs(z) == rz):
					col = C_PELT_BASE
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_upper_arm_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -3:
					col = C_LEATHER_DARK if y == -3 else C_RANGER_GREEN
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_forearm_mesh_outfit1(is_right)
	return build_archer_forearm_mesh_outfit2(is_right)

static func build_archer_forearm_mesh_outfit1(is_right: bool) -> ArrayMesh:
	var voxels = []
	if not is_right:
		# LEFT FOREARM: Primitive rawhide / sinew wrist wraps
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y >= -6 and y <= -3:
						if abs(x) == 2 or abs(z) == 2:
							col = C_SINEW if y == -5 else C_LEATHER_DARK
					elif y <= -8:
						if (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_CLAWS if y == -9 else C_SKIN
					voxels.append([x, y, z, col])
	else:
		# RIGHT FOREARM: Drawing hand with sinew finger wraps
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y == -4 or y == -5:
						col = C_SINEW if y == -5 else C_LEATHER_DARK
					elif y <= -7:
						if z == 2:
							if y in [-7, -8]:
								col = C_LEATHER if abs(x) <= 1 else C_SKIN
							else:
								col = C_CLAWS if abs(x) <= 1 else C_SKIN
						elif x == 2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						elif x == -2:
							col = C_CLAWS if (y == -8 and z == 1) else C_SKIN_LIGHT
						elif z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
					voxels.append([x, y, z, col])
					
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
		voxels.append([-1, -7, 2, C_SKIN_LIGHT])
		voxels.append([-1, -8, 2, C_CLAWS])
		voxels.append([0, -9, 2, C_CLAWS])
		voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

static func build_archer_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:
	var voxels = []
	if not is_right:
		# LEFT FOREARM (BOW ARM): Archer's Vambrace / Armguard
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y >= -6 and y <= -1:
						if abs(x) == 2 or abs(z) == 2:
							if (y in [-2, -5]) and (x == -2 or z == 2):
								col = C_BUCKLE
							elif abs(x) == 2 or y in [-1, -6]:
								col = C_LEATHER_DARK
							else:
								col = C_LEATHER_WARM
						else:
							col = C_LEATHER
					elif y <= -8:
						if (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_CLAWS if y == -9 else C_SKIN
					voxels.append([x, y, z, col])
	else:
		# RIGHT FOREARM (DRAW HAND): Archer's Three-Finger Shooting Tab
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y == -4 or y == -5:
						col = C_LEATHER_DARK if y == -5 else C_LEATHER_WARM
					elif y == -6:
						col = C_SKIN if z >= 0 else C_SKIN_DARK
					elif y <= -7:
						if z == 2:
							if y in [-7, -8]:
								col = C_LEATHER_DARK if abs(x) <= 1 else C_SKIN
							else:
								col = C_CLAWS if abs(x) <= 1 else C_SKIN
						elif x == 2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						elif x == -2:
							col = C_CLAWS if (y == -8 and z == 1) else C_SKIN_LIGHT
						elif z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						else:
							col = C_SKIN
					voxels.append([x, y, z, col])
					
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
		voxels.append([-1, -7, 2, C_SKIN_LIGHT])
		voxels.append([-1, -8, 2, C_CLAWS])
		voxels.append([0, -9, 2, C_CLAWS])
		voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_thigh_mesh_outfit1()
	return build_archer_thigh_mesh_outfit2()

static func build_archer_thigh_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				# Primitive ragged pelt loincloth (y >= -4)
				if y >= -4:
					if abs(x) == rx and y <= -2:
						col = C_SKIN
					else:
						col = C_PELT_DARK if y == -4 else C_PELT_BASE
				elif (y == -8 or y == -9) and z == rz and abs(x) <= 1:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_thigh_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_RANGER_GREEN
				if y in [-7, -8, -9] and (abs(x) == rx or abs(z) == rz):
					if z == rz:
						col = C_LEATHER_WARM if y == -8 else C_LEATHER_DARK
					elif y == -9:
						col = C_ROPE
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_shin_mesh_outfit1()
	return build_archer_shin_mesh_outfit2()

static func build_archer_shin_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	# 1. Muscular Upper Shin (y: -6 to 0) - Green skin with sinew calf wrap
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_SKIN
				if z == 2:
					col = C_SKIN_LIGHT
				elif z == -3:
					col = C_SKIN_DARK
				if y == -3 and z == 2:
					col = C_LEATHER_DARK
				voxels.append([x, y, z, col])
				
	# 2. Ankle Rawhide & Sinew Wraps (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SINEW if y == -6 else C_LEATHER_DARK
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_SKIN_DARK if abs(x) == 3 else C_SKIN
			voxels.append([x, -8, z, col])
			
	# 4. Bare Feral Goblin Foot with Hardened Soles (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				
				var col = C_SKIN
				if y == -10:
					col = C_SKIN_DARK
				elif z >= 0 and y == -8:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
				
	# 5. 3 Chunky 3D Predatory Toes with Claws (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SKIN_LIGHT if (ty == -9 and tz == 4) else C_SKIN
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_SKIN])
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_archer_shin_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	# 1. Upper Boot Shaft & Calf (y: -6 to 0) - Supple Leather Hunting Boots
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_LEATHER_WARM
				if z == 2:
					col = C_BUCKLE if (y in [-2, -5]) else C_LEATHER_DARK
				elif z == -3 or abs(x) == 2:
					col = C_LEATHER_DARK
				voxels.append([x, y, z, col])
				
	# 2. Boot Ankle Lacing & Leather Cuffs (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_LEATHER_WARM if y == -5 else C_LEATHER_DARK
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle Leather (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_LEATHER_DARK if abs(x) == 3 else C_LEATHER
			voxels.append([x, -8, z, col])
			
	# 4. Solid Boot Sole & Arch (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				
				var col = C_LEATHER
				if y == -10:
					col = C_LEATHER_DARK
				elif z >= 0 and y == -8:
					col = C_LEATHER_WARM
				voxels.append([x, y, z, col])
				
	# 5. Predatory Claws protruding from reinforced boot toe-caps (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_LEATHER_DARK if ty == -10 else C_LEATHER_WARM
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_LEATHER_DARK])
						
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_bow_mesh(drawn: bool = false) -> ArrayMesh:
	var voxels: Dictionary = {}
	# Recurve Hunting Bow: height ~ 28 voxels (0.84m)
	# Center Grip (y: -2..2, z: 0..1, x: 0)
	for y in range(-2, 3):
		voxels[Vector3i(0, y, 0)] = C_LEATHER
		voxels[Vector3i(0, y, 1)] = C_BUCKLE if y == 0 else C_LEATHER
		voxels[Vector3i(1, y, 0)] = C_LEATHER
		voxels[Vector3i(-1, y, 0)] = C_LEATHER

	# Upper Limb (y: 3..14)
	for y in range(3, 15):
		var curve_z = int(sin(float(y - 2) / 12.0 * PI) * 3.0)
		if y >= 11: curve_z -= (y - 10) # Recurve tips backward
		if drawn and y >= 8: curve_z -= 1 # Limb flexes slightly under tension
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if (y == 3 or y == 10) else C_WOOD
		voxels[Vector3i(0, y, curve_z - 1)] = C_WOOD
		if y == 14:
			voxels[Vector3i(0, y, curve_z)] = C_BONE # Bone nock tip
			voxels[Vector3i(0, y + 1, curve_z - 1)] = C_BONE

	# Lower Limb (y: -3..-14)
	for y in range(-14, -2):
		var ay = abs(y)
		var curve_z = int(sin(float(ay - 2) / 12.0 * PI) * 3.0)
		if ay >= 11: curve_z -= (ay - 10)
		if drawn and ay >= 8: curve_z -= 1
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if (ay == 3 or ay == 10) else C_WOOD
		voxels[Vector3i(0, y, curve_z - 1)] = C_WOOD
		if y == -14:
			voxels[Vector3i(0, y, curve_z)] = C_BONE
			voxels[Vector3i(0, y - 1, curve_z - 1)] = C_BONE

	# Bowstring:
	# If drawn: forms a deep, taut V-shape pulling all the way back to z = -19 at y = 0
	# (reaching exactly to the archer's cheek anchor point and right fingers with 0 gap)
	# If rest: straight line at z = -2
	if drawn:
		for i in range(40):
			var t = float(i) / 39.0
			var sy = int(round(lerp(0.0, 14.0, t)))
			var sz = int(round(lerp(-19.0, -2.0, t)))
			voxels[Vector3i(0, sy, sz)] = C_STRING
			voxels[Vector3i(0, -sy, sz)] = C_STRING
	else:
		for y in range(-14, 15):
			voxels[Vector3i(0, y, -2)] = C_STRING

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_arrow_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Full hunting arrow: 28 voxels (~0.84m) along +Z
	# Nock (z: -19..-18) sits flush on drawn string apex and right hand fingers
	voxels[Vector3i(0, 0, -19)] = C_BONE
	voxels[Vector3i(0, 0, -18)] = C_BONE

	# Fletching Feathers (z: -17..-13)
	for z in range(-17, -12):
		var col = C_FEATHER_RED if z <= -15 else C_FEATHER_WHITE
		voxels[Vector3i(1, 0, z)] = col
		voxels[Vector3i(-1, 0, z)] = col
		voxels[Vector3i(0, 1, z)] = col
		voxels[Vector3i(0, -1, z)] = col

	# Wooden Shaft (z: -16..3)
	for z in range(-16, 4):
		voxels[Vector3i(0, 0, z)] = C_WOOD

	# Sinew binding behind head (z: 4)
	voxels[Vector3i(0, 0, 4)] = C_ROPE

	# Flint Arrowhead (z: 5..8)
	voxels[Vector3i(0, 0, 5)] = C_SPIKE_DARK
	voxels[Vector3i(1, 0, 5)] = C_SPIKE
	voxels[Vector3i(-1, 0, 5)] = C_SPIKE
	voxels[Vector3i(0, 1, 5)] = C_SPIKE
	voxels[Vector3i(0, -1, 5)] = C_SPIKE

	voxels[Vector3i(0, 0, 6)] = C_SPIKE
	voxels[Vector3i(1, 0, 6)] = C_SPIKE
	voxels[Vector3i(-1, 0, 6)] = C_SPIKE

	voxels[Vector3i(0, 0, 7)] = C_SPIKE
	voxels[Vector3i(0, 0, 8)] = C_SPIKE_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_quiver_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Quiver cylindrical pouch: height 16 voxels, radius 3
	for y in range(-8, 9):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var dist = abs(x) + abs(z)
				if dist <= 3:
					var is_outer = (abs(x) == 2 or abs(z) == 2)
					if is_outer or y == -8:
						voxels[Vector3i(x, y, z)] = C_LEATHER if y % 3 != 0 else C_LEATHER_DARK
	# Arrows poking out from quiver top (y: 9..14)
	var arrow_offsets = [Vector3i(0, 0, 0), Vector3i(1, 0, 1), Vector3i(-1, 0, 0), Vector3i(0, 0, -1)]
	for o in arrow_offsets:
		for dy in range(9, 14):
			voxels[Vector3i(o.x, dy, o.z)] = C_WOOD
		# Feathers on arrow tips
		var f_col = C_FEATHER_RED if o.x >= 0 else C_FEATHER_WHITE
		voxels[Vector3i(o.x + 1, 13, o.z)] = f_col
		voxels[Vector3i(o.x - 1, 13, o.z)] = f_col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- B. GOBLIN SHAMAN (Mặt Nạ Sọ Thú, Áo Choàng & Trượng Ma Thuật) ---

static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_head_mesh_outfit2()
	return build_shaman_head_mesh_outfit1()

static func build_shaman_head_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Base Goblin Head & Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
				
	# 2. Lower Jaw & Snarl (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN

	# Open Snarling Mouth Cavity (y: 5..6, z: 6)
	for y in range(5, 7):
		for x in range(-2, 3):
			voxels[Vector3i(x, y, 6)] = C_MOUTH_DARK
			
	# 3. PROMINENT PROTRUDING BOAR TUSKS & FANGS (Răng Nanh Khổng Lồ)
	# Massive upward-curving lower tusks (x: -3, 3) rising to y = 9!
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 5, 7)] = C_BONE
		voxels[Vector3i(side * 3, 6, 7)] = C_TEETH
		voxels[Vector3i(side * 3, 7, 7)] = C_TEETH
		voxels[Vector3i(side * 3, 8, 7)] = C_TEETH
		voxels[Vector3i(side * 3, 9, 6)] = C_TEETH # Sharp curved tip!
		# Upper fangs
		voxels[Vector3i(side * 2, 7, 7)] = C_TEETH
		voxels[Vector3i(side * 2, 6, 7)] = C_TEETH
	# Front jagged lower incisors
	voxels[Vector3i(-1, 5, 7)] = C_TEETH
	voxels[Vector3i(0, 5, 7)] = C_TEETH
	voxels[Vector3i(1, 5, 7)] = C_TEETH
	# Braided bone beard bead under chin (y: 2..4, z: 6)
	voxels[Vector3i(0, 4, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 3, 6)] = C_BONE
	voxels[Vector3i(0, 2, 6)] = C_BONE

	# 4. Goblin Cranium (y: 8..15)
	for y in range(8, 16):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 5. Hooked Goblin Nose (y: 8..11, z: 6..10)
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 9, 10)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 10, 9)] = C_SKIN_PALE # Shaman nose wart!
	voxels[Vector3i(-2, 8, 7)] = C_SKIN_DARK # Nostrils
	voxels[Vector3i(2, 8, 7)] = C_SKIN_DARK

	# 6. Predatory Yellow Goblin Eyes & Brow Ridge (y: 10..11)
	for x in range(-4, 5):
		voxels[Vector3i(x, 11, 6)] = C_SKIN_DARK # Heavy furrowed brow
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_EYE_PUPIL # Black slit pupil!
		# Crimson ritual warpaint slashes across cheekbones
		voxels[Vector3i(side * 4, 9, 6)] = C_WARPAINT_RED
		voxels[Vector3i(side * 4, 8, 6)] = C_WARPAINT_RED
		voxels[Vector3i(side * 3, 8, 7)] = C_WARPAINT_RED

	# 7. LONG SCULPTED BAT EARS WITH PIERCINGS (s = 0..8)
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ez = -1 - int(float(s) * 0.45) # Sweeps back naturally
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 11
				y_high = 11 # Sharp needle tip
			elif s == 7:
				y_low = 10
				y_high = 12
				
			for ey in range(y_low, y_high + 1):
				if s == 5 and ey == y_high: continue # Ear notch tear
				var col = C_SKIN
				var is_inner = (s >= 1 and s <= 4 and ey >= y_low + 1 and ey <= y_high - 1)
				if is_inner:
					col = C_EAR_INNER # Pink cartilage
				elif ey == y_high:
					col = C_SKIN_LIGHT
				elif ey == y_low:
					col = C_SKIN_DARK
				voxels[Vector3i(ex, ey, ez)] = col
				
		# Left Ear: Ritual Golden Hoop Piercing (side == -1)
		voxels[Vector3i(-13, 11, -4)] = C_SHAMAN_GOLD
		voxels[Vector3i(-14, 10, -4)] = C_SHAMAN_GOLD
		voxels[Vector3i(-13, 9, -4)] = C_SHAMAN_GOLD
		# Right Ear: Bone Needle Piercing (side == 1)
		voxels[Vector3i(11, 13, -3)] = C_BONE
		voxels[Vector3i(12, 12, -4)] = C_BONE
		voxels[Vector3i(13, 11, -4)] = C_BONE

	# 8. MẶT NẠ SỌ THÚ NGUYÊN THỦY (BEAST SKULL HEADDRESS CROWN, y: 12..18)
	# Cranium Bone Dome
	for y in range(12, 18):
		var rad_sx = 6 if y < 16 else 5
		for x in range(-rad_sx, rad_sx + 1):
			for z in range(-4, 7):
				var on_skull_shell = (abs(x) == rad_sx or z in [-4, 6] or y == 17)
				if on_skull_shell:
					voxels[Vector3i(x, y, z)] = C_SKULL_BONE

	# Skull Forehead Brow & Snout Canopy overhanging brow (y: 12..14, z: 6..8)
	for y in range(12, 14):
		for x in range(-4, 5):
			voxels[Vector3i(x, y, 7)] = C_SKULL_BONE
			if abs(x) <= 2:
				voxels[Vector3i(x, y, 8)] = C_SKULL_BONE
	# Beast Skull Upper Fangs dangling from skull brow over goblin face!
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 11, 8)] = C_TEETH
		voxels[Vector3i(side * 4, 11, 7)] = C_TEETH
		voxels[Vector3i(side * 1, 11, 8)] = C_TEETH

	# Hollow Beast Skull Sockets with Glowing Spirit Flame (y: 14..15, z: 6)
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 14, 6)] = C_GLOW_CYAN # Glowing Cyan Spirit Core
		voxels[Vector3i(side * 3, 14, 6)] = C_PURPLE_MAGIC
		voxels[Vector3i(side * 2, 15, 6)] = C_PURPLE_MAGIC
		voxels[Vector3i(side * 3, 15, 6)] = C_MOUTH_DARK

	# Blood Warpaint Third-Eye Rune on skull crown (x: 0, y: 15..17, z: 6)
	voxels[Vector3i(0, 17, 6)] = C_WARPAINT_RED
	voxels[Vector3i(-1, 16, 6)] = C_WARPAINT_RED
	voxels[Vector3i(0, 16, 6)] = C_GLOW_CYAN # Occult rune center
	voxels[Vector3i(1, 16, 6)] = C_WARPAINT_RED
	voxels[Vector3i(0, 15, 6)] = C_WARPAINT_RED

	# Great Curving Beast Horns (y: 15..21)
	for side in [-1, 1]:
		var horn_pts = [
			Vector3i(side * 6, 16, 1),
			Vector3i(side * 7, 17, 0),
			Vector3i(side * 8, 18, -1),
			Vector3i(side * 9, 19, -3),
			Vector3i(side * 10, 20, -5),
			Vector3i(side * 10, 21, -7),
			Vector3i(side * 9, 21, -9),  # Sharp curved horn tip
		]
		for hp in horn_pts:
			voxels[hp] = C_BONE
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK

	# Side Dangling Feathers tied behind ears (x: -6, 6)
	for side in [-1, 1]:
		voxels[Vector3i(side * 6, 10, 0)] = C_FEATHER_RED
		voxels[Vector3i(side * 6, 9, -1)] = C_PURPLE_MAGIC
		voxels[Vector3i(side * 6, 8, -2)] = C_GLOW_CYAN
		voxels[Vector3i(side * 6, 7, -2)] = C_BONE

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Base Goblin Head & Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
				
	# 2. Lower Jaw & Snarl (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN

	# Open Snarling Mouth Cavity (y: 5..6, z: 6)
	for y in range(5, 7):
		for x in range(-2, 3):
			voxels[Vector3i(x, y, 6)] = C_MOUTH_DARK
			
	# 3. PROMINENT PROTRUDING GOLD-TIPPED BOAR TUSKS & FANGS
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 5, 6)] = C_SHAMAN_GOLD # Gold root ring
		voxels[Vector3i(side * 3, 6, 6)] = C_TEETH
		voxels[Vector3i(side * 3, 7, 6)] = C_TEETH
		voxels[Vector3i(side * 3, 8, 6)] = C_TEETH
		voxels[Vector3i(side * 3, 9, 6)] = C_BONE
		# Upper fangs
		voxels[Vector3i(side * 2, 7, 7)] = C_TEETH
		voxels[Vector3i(side * 2, 6, 7)] = C_TEETH
	# Front jagged lower incisors
	voxels[Vector3i(-1, 5, 7)] = C_TEETH
	voxels[Vector3i(0, 5, 7)] = C_TEETH
	voxels[Vector3i(1, 5, 7)] = C_TEETH
	# Braided beard fetish under chin (y: 1..4, z: 6)
	voxels[Vector3i(0, 4, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 3, 6)] = C_BONE
	voxels[Vector3i(0, 2, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 1, 6)] = C_GLOW_CYAN # Hanging cyan soul bead

	# 4. Goblin Cranium (y: 8..15)
	for y in range(8, 16):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 5. Hooked Goblin Nose (y: 8..11, z: 6..10)
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 6)] = C_SKIN
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	for y in range(8, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 9)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 9, 10)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 10, 9)] = C_SKIN_PALE
	voxels[Vector3i(-2, 8, 7)] = C_SKIN_DARK
	voxels[Vector3i(2, 8, 7)] = C_SKIN_DARK

	# 6. Predatory Yellow Goblin Eyes & Brow Ridge (y: 10..11)
	for x in range(-4, 5):
		voxels[Vector3i(x, 11, 6)] = C_SKIN_DARK
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_EYE_PUPIL
		# Radiant Magenta & Gold Warpaint slashes across cheekbones!
		voxels[Vector3i(side * 4, 9, 6)] = C_MAGENTA_GLOW
		voxels[Vector3i(side * 4, 8, 6)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 3, 8, 7)] = C_MAGENTA_GLOW

	# 7. Bat Ears with Golden Hoops & Turquoise Teardrops
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ez = -1 - int(float(s) * 0.45)
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 11; y_high = 11
			elif s == 7:
				y_low = 10; y_high = 12
			for ey in range(y_low, y_high + 1):
				if s == 5 and ey == y_high: continue
				var col = C_SKIN
				var is_inner = (s >= 1 and s <= 4 and ey >= y_low + 1 and ey <= y_high - 1)
				if is_inner: col = C_EAR_INNER
				elif ey == y_high: col = C_SKIN_LIGHT
				elif ey == y_low: col = C_SKIN_DARK
				voxels[Vector3i(ex, ey, ez)] = col
				
		# Double Golden Hoop Piercings with Cyan Soul Drop
		voxels[Vector3i(side * 13, 11, -4)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 14, 10, -4)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 13, 9, -4)] = C_GLOW_CYAN
		voxels[Vector3i(side * 11, 13, -3)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 12, 12, -4)] = C_SHAMAN_GOLD

	# 8. MẶT NẠ SỌ QUỶ THƯỢNG CỔ & CẶP SỪNG RỒNG 3D HOÀNG GIA (y: 12..26)
	# Ancient Ivory Demon Skull Dome (y: 12..18)
	for y in range(12, 19):
		var rad_sx = 6 if y < 16 else 5
		for x in range(-rad_sx, rad_sx + 1):
			for z in range(-4, 7):
				var on_skull_shell = (abs(x) == rad_sx or z in [-4, 6] or y >= 17)
				if on_skull_shell:
					var col = C_SKULL_BONE
					if y == 18 and (abs(x) <= 2 or abs(z) <= 2):
						col = C_SHAMAN_GOLD # Gilded skull crown ridge
					elif y == 16 and (abs(x) == rad_sx or z == 6):
						col = C_MAGENTA_DARK # Magenta occult inlay
					voxels[Vector3i(x, y, z)] = col

	# Skull Forehead Brow & Snout Canopy (y: 12..14, z: 6..8)
	for y in range(12, 14):
		for x in range(-4, 5):
			voxels[Vector3i(x, y, 7)] = C_SKULL_BONE
			if abs(x) <= 2:
				voxels[Vector3i(x, y, 8)] = C_SKULL_BONE
	# Four Gilded Dragon Fangs dangling over goblin brow
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 11, 8)] = C_TEETH
		voxels[Vector3i(side * 2, 10, 8)] = C_BONE
		voxels[Vector3i(side * 4, 11, 7)] = C_TEETH
		voxels[Vector3i(side * 1, 11, 8)] = C_TEETH

	# Hollow Demon Eye Sockets with Blazing Cyan Spirit Core (y: 14..15, z: 6)
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 14, 6)] = C_GLOW_CYAN
		voxels[Vector3i(side * 3, 14, 6)] = C_GLOW_CYAN
		voxels[Vector3i(side * 2, 15, 6)] = C_PURPLE_MAGIC
		voxels[Vector3i(side * 3, 15, 6)] = C_MOUTH_DARK
		voxels[Vector3i(side * 2, 14, 5)] = C_GLOW_CYAN # Deep glowing core!

	# MẮT THỨ BA LINH HỒN (Third Eye of the Arch-Mage: x: 0, y: 15..17, z: 6..7)
	voxels[Vector3i(0, 16, 7)] = C_MAGENTA_GLOW # Radiant pulsing Magenta Soul Gem!
	voxels[Vector3i(0, 15, 7)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 17, 7)] = C_SHAMAN_GOLD
	voxels[Vector3i(-1, 16, 7)] = C_SHAMAN_GOLD
	voxels[Vector3i(1, 16, 7)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 18, 6)] = C_MAGENTA_GLOW

	# CẶP SỪNG RỒNG 3D VĨ ĐẠI (GRAND SWEPT DRAGON HORNS, y: 16..26)
	for side in [-1, 1]:
		var horn_pts = [
			Vector3i(side * 6, 16, 1),
			Vector3i(side * 7, 17, 0),
			Vector3i(side * 8, 18, -1),
			Vector3i(side * 9, 19, -2),
			Vector3i(side * 10, 20, -3),
			Vector3i(side * 11, 21, -4),
			Vector3i(side * 12, 23, -4),
			Vector3i(side * 12, 24, -3),
			Vector3i(side * 11, 25, -2),
			Vector3i(side * 10, 26, 0),
			Vector3i(side * 9, 26, 2), # Sharp needle tip curls forward!
		]
		for i in range(horn_pts.size()):
			var hp = horn_pts[i]
			var col = C_BONE
			if i in [2, 6]:
				col = C_SHAMAN_GOLD # Royal golden bands around horn!
			elif i >= horn_pts.size() - 2:
				col = C_CLAWS # Razor sharp dark obsidian tip
			voxels[hp] = col
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK
			voxels[hp + Vector3i(0, 0, 1)] = col
		
		# Secondary Forward Brow Hornlet
		voxels[Vector3i(side * 4, 16, 7)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 5, 17, 8)] = C_BONE
		voxels[Vector3i(side * 6, 18, 8)] = C_CLAWS

	# Dangling Cascading Feather Tassels (Magenta, Cyan, Ivory)
	for side in [-1, 1]:
		voxels[Vector3i(side * 6, 11, 0)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 6, 10, 0)] = C_MAGENTA_LIGHT
		voxels[Vector3i(side * 6, 9, -1)] = C_GLOW_CYAN
		voxels[Vector3i(side * 6, 8, -2)] = C_FEATHER_WHITE
		voxels[Vector3i(side * 6, 7, -2)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 6, 6, -2)] = C_MAGENTA_GLOW

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_torso_mesh_outfit2()
	return build_shaman_torso_mesh_outfit1()

static func build_shaman_torso_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Rich Mystical Shaman Robe (y: 0..17)
	for y in range(18):
		var rx = 6 if y < 5 else (7 if y < 14 else 6)
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Base Robe color
				var col = C_SHAMAN_ROBE
				# Shadowed bottom folds & tattered hem
				if y <= 1:
					col = C_SHAMAN_ROBE_DARK
				# Golden embroidery hem trim at bottom (y = 2)
				elif y == 2 and (abs(x) == rx or abs(z) == rz):
					col = C_SHAMAN_GOLD
				
				# Front mystical slit / center seam with golden trim (z == rz)
				if z == rz and y >= 3 and y <= 15:
					if abs(x) == 1:
						col = C_SHAMAN_GOLD
					elif x == 0:
						col = C_SHAMAN_ROBE_DARK
						
				voxels[Vector3i(x, y, z)] = col

	# 2. Animal Pelt Mantle over Shoulders & Upper Back (y: 12..17)
	for y in range(12, 18):
		var pelt_rx = 7 if y < 16 else 6
		for x in range(-pelt_rx, pelt_rx + 1):
			for z in range(-5, -2):
				var col = C_PELT_BASE if y >= 14 else C_PELT_DARK
				if abs(x) == pelt_rx or y == 17:
					col = C_PELT_LIGHT # Fur edge trim
				voxels[Vector3i(x, y, z)] = col
	# Fur shoulder caps
	for side in [-1, 1]:
		for dx in range(5, 8):
			for dz in range(-3, 4):
				voxels[Vector3i(side * dx, 16, dz)] = C_PELT_BASE
				voxels[Vector3i(side * dx, 17, dz)] = C_PELT_LIGHT

	# 3. Triple-Tier Bone & Soul Gem Fetish Necklace (y: 9..14, z: 5..6)
	# Upper bone finger bead arc (y = 13..14)
	for x in range(-4, 5):
		voxels[Vector3i(x, 14 - abs(x) / 2, 5)] = C_ROPE
		if abs(x) in [1, 3]:
			voxels[Vector3i(x, 13 - abs(x) / 2, 6)] = C_BONE
	# Hanging beast fangs
	voxels[Vector3i(-3, 11, 5)] = C_TEETH
	voxels[Vector3i(3, 11, 5)] = C_TEETH
	voxels[Vector3i(-2, 10, 5)] = C_TEETH
	voxels[Vector3i(2, 10, 5)] = C_TEETH

	# Centered Luminous Soul Gem Pendant (x: -1..1, y: 8..11, z: 5..6)
	# Golden casing
	for dy in range(8, 12):
		for dx in range(-1, 2):
			voxels[Vector3i(dx, dy, 5)] = C_SHAMAN_GOLD
	# Radiant Cyan Spirit Gem Core
	voxels[Vector3i(0, 10, 6)] = C_GLOW_CYAN
	voxels[Vector3i(0, 9, 6)] = C_GLOW_CYAN
	voxels[Vector3i(-1, 10, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(1, 10, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 11, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 8, 6)] = C_TEETH # Fang hanging below amulet!

	# 4. Witch-Doctor Belt & Alchemy Gear (y: 3..5)
	# Leather sash with gold buckle
	for x in range(-7, 8):
		for z in range(-5, 6):
			if abs(x) == 7 or abs(z) == 5:
				if abs(x) == 7 and abs(z) == 5: continue
				voxels[Vector3i(x, 4, z)] = C_LEATHER_DARK
				if z == 5 and abs(x) <= 1:
					voxels[Vector3i(x, 4, z)] = C_SHAMAN_GOLD # Large buckle
					voxels[Vector3i(x, 5, z)] = C_SHAMAN_GOLD

	# Left Hip: Glowing Cyan Potion Flask (x: -7..-6, y: 1..5, z: 0..2)
	voxels[Vector3i(-7, 1, 1)] = C_POTION_CYAN
	voxels[Vector3i(-7, 2, 1)] = C_POTION_CYAN
	voxels[Vector3i(-7, 2, 0)] = C_POTION_CYAN
	voxels[Vector3i(-7, 2, 2)] = C_POTION_CYAN
	voxels[Vector3i(-7, 3, 1)] = C_POTION_CYAN
	voxels[Vector3i(-7, 4, 1)] = C_LEATHER_DARK # Bottle neck
	voxels[Vector3i(-7, 5, 1)] = C_WOOD_DARK    # Cork stopper

	# Right Hip: Herbal Mojo Pouch with Skull bead (x: 6..7, y: 1..4, z: 0..2)
	for py in range(1, 5):
		for pz in range(0, 3):
			voxels[Vector3i(7, py, pz)] = C_LEATHER_WARM
	voxels[Vector3i(7, 2, 3)] = C_SKULL_BONE # Small skull fetish on pouch!

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_torso_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Royal Magenta Robe (y: 0..17)
	for y in range(18):
		var rx = 6 if y < 5 else (7 if y < 14 else 6)
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Base Robe color: Royal Magenta
				var col = C_MAGENTA
				# Shadowed bottom folds
				if y <= 1:
					col = C_MAGENTA_DARK
				# Golden embroidery hem trim at bottom (y = 2)
				elif y == 2 and (abs(x) == rx or abs(z) == rz):
					col = C_SHAMAN_GOLD
				elif y == 1 and (abs(x) == rx or abs(z) == rz):
					col = C_MAGENTA_ROYAL
				
				# Front mystical slit with golden Celtic knotwork & cyan gems (z == rz)
				if z == rz and y >= 3 and y <= 15:
					if abs(x) == 1:
						col = C_SHAMAN_GOLD
						if y in [6, 10, 14]: col = C_GLOW_CYAN # Embedded soul gems!
					elif x == 0:
						col = C_MAGENTA_ROYAL # Inner velvet fold
						
				voxels[Vector3i(x, y, z)] = col

	# 2. Dramatic High-Flared Arcane Collar (Cổ Áo Dựng Cao, y: 17..22, z: -4..-2)
	for y in range(17, 23):
		for x in range(-5, 6):
			var cz = -3 - int(float(y - 17) * 0.4)
			var on_edge = (abs(x) == 5 or y == 22)
			var col = C_SHAMAN_GOLD if on_edge else C_MAGENTA
			voxels[Vector3i(x, y, cz)] = col
			# Inner velvet lining
			voxels[Vector3i(x, y, cz + 1)] = C_MAGENTA_ROYAL

	# 3. Midnight Wolf Fur Mantle over Shoulders & Upper Back (y: 12..17)
	for y in range(12, 18):
		var pelt_rx = 7 if y < 16 else 6
		for x in range(-pelt_rx, pelt_rx + 1):
			for z in range(-5, -2):
				var col = C_PELT_DARK
				if abs(x) == pelt_rx or y == 17:
					col = 0x2e2520 # Fur edge highlight
				voxels[Vector3i(x, y, z)] = col
	# Fur shoulder caps with gold chains
	for side in [-1, 1]:
		for dx in range(5, 8):
			for dz in range(-3, 4):
				voxels[Vector3i(side * dx, 16, dz)] = C_PELT_DARK
				voxels[Vector3i(side * dx, 17, dz)] = 0x2e2520
		# Gold chain clasps across chest
		for cx in range(2, 5):
			voxels[Vector3i(side * cx, 15, 5)] = C_SHAMAN_GOLD

	# 4. Tailored Back Robe Surface (Lưng Áo Thụng Hoàng Gia, y: 0..14, z: -5..-4)
	for y in range(0, 15):
		var rx_b = 6 if y < 5 else (7 if y < 14 else 6)
		for x in range(-rx_b + 1, rx_b):
			var col = C_MAGENTA_DARK if (x + y) % 2 == 0 else C_MAGENTA_ROYAL
			if y in [3, 4] and abs(x) <= 2:
				col = C_SHAMAN_GOLD # Golden belt strap across back
			voxels[Vector3i(x, y, -4)] = col

	# 5. Grand Arch-Shaman Dragon Amulet & Reliquary Necklace (y: 9..14, z: 5..6)
	# Heavy gold torque necklace
	for x in range(-4, 5):
		voxels[Vector3i(x, 14 - abs(x) / 2, 5)] = C_SHAMAN_GOLD
		if abs(x) in [1, 3]:
			voxels[Vector3i(x, 13 - abs(x) / 2, 6)] = C_SHAMAN_GOLD
	# Massive Dragon Eye Soul Amulet center (x = 0, y = 11..12, z = 6)
	voxels[Vector3i(0, 12, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(-1, 11, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 11, 6)] = C_GLOW_CYAN # Blazing radiant Cyan Gem
	voxels[Vector3i(1, 11, 6)] = C_SHAMAN_GOLD
	voxels[Vector3i(0, 10, 6)] = C_MAGENTA_GLOW # Teardrop magenta jewel

	# 6. Alchemical Hip Reliquaries & Flasks (y: 3..6)
	# Left Hip: Glowing Cyan Spirit Mana Flask (x = -7, z = 1..2)
	voxels[Vector3i(-7, 5, 1)] = C_LEATHER_DARK
	voxels[Vector3i(-8, 4, 1)] = C_GLOW_CYAN
	voxels[Vector3i(-8, 3, 1)] = C_GLOW_CYAN
	voxels[Vector3i(-8, 5, 1)] = C_BONE # Stopper
	# Right Hip: Glowing Magenta Demon Blood Flask (x = +7, z = 1..2)
	voxels[Vector3i(7, 5, 1)] = C_LEATHER_DARK
	voxels[Vector3i(8, 4, 1)] = C_MAGENTA_GLOW
	voxels[Vector3i(8, 3, 1)] = C_MAGENTA_GLOW
	voxels[Vector3i(8, 5, 1)] = C_SHAMAN_GOLD # Golden stopper

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_cloak_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. GRAND GOLDEN BROOCHES & DRAGON SHOULDER CLASPS (y: 0..3, x: +-6..7, z: 0..6)
	# These wrap over the shoulders from z = 0 forward to z = 6, locking the cloak in place
	for side in [-1, 1]:
		for cy in range(0, 4):
			for cz in range(0, 7):
				var cx = side * 6
				var is_brooch = (cz >= 4 and cy in [1, 2])
				var col = C_SHAMAN_GOLD
				if is_brooch and cz == 6:
					col = C_GLOW_CYAN # Radiant soul gemstone clasp on chest
				elif cy == 3 and cz in [2, 3]:
					col = C_GOLD
				voxels[Vector3i(cx, cy, cz)] = col
				# Thick outer shoulder rim
				if cz in [1, 2, 3, 4]:
					voxels[Vector3i(cx + side * 1, cy, cz)] = C_SHAMAN_GOLD
					
		# Golden chain connector across upper back collar (y: 1..2, z: 1, x: -5..5)
		for lx in range(-5, 6):
			voxels[Vector3i(lx, 1, 1)] = C_SHAMAN_GOLD
			if abs(lx) in [0, 2, 4]:
				voxels[Vector3i(lx, 2, 1)] = C_GOLD

	# 2. HEAVY MIDNIGHT WOLF FUR COLLAR YOKE (y: 0..3, z: 0..3, x: -5..5)
	for y in range(0, 4):
		for x in range(-5, 6):
			for z in range(0, 4):
				var col = C_PELT_DARK
				if y == 3 or z == 0 or abs(x) == 5:
					col = 0x2e2520 # Highlighted fur edge
				voxels[Vector3i(x, y, z)] = col

	# 3. VOLUMETRIC 3D DRAPED CAPE (y: 0 down to -24, total length ~0.72m)
	# Folds undulate with a cosine wave in X: cos(x * 0.75) * 1.5
	# Width flares out as y drops: from rx = 7 at top to rx = 11 at hem!
	for y in range(0, -25, -1):
		var progress: float = float(-y) / 24.0 # 0.0 at top, 1.0 at bottom
		var rx: int = int(round(lerpf(7.0, 11.0, progress)))
		
		for x in range(-rx, rx + 1):
			# Scalloped bottom hem cutouts: 5 pointed tails at x = 0, +-5, +-9
			if y < -20:
				var is_tail_peak = (x == 0 or abs(x) == 5 or abs(x) == 9)
				var is_tail_mid = (abs(x) in [1, 4, 6, 8, 10])
				if y == -24 and not is_tail_peak:
					continue
				if y == -23 and not (is_tail_peak or is_tail_mid):
					continue
				if y == -22 and (abs(x) in [2, 3, 7]):
					continue
					
			# 3D Pleating wave in Z: creates physical ripples & deep shadows
			var pleat_wave: float = cos(float(x) * 0.75) * 1.4
			var sweep_back: float = progress * 2.2 # Cape naturally trails backward
			var base_z: int = -int(round(pleat_wave + sweep_back))
			
			# Outer Layer (Visible from back): Royal Magenta
			var col_outer = C_MAGENTA
			if pleat_wave < -0.4:
				col_outer = C_MAGENTA_DARK # Crevice shadow
			elif pleat_wave > 0.6:
				col_outer = C_MAGENTA_LIGHT # Raised fold highlight
				
			# Heavy 3D Gold Borders
			var on_edge = (abs(x) >= rx - 1 or y <= -21)
			if on_edge:
				col_outer = C_SHAMAN_GOLD
				if y in [-23, -24]:
					col_outer = C_GLOW_CYAN # Gemstone tipped pennants!
					
			voxels[Vector3i(x, y, base_z - 1)] = col_outer
			
			# Inner Velvet Lining (Visible from sides/underside): Deep Royal Plum
			var col_inner = C_MAGENTA_ROYAL
			if on_edge:
				col_inner = C_GOLD
			voxels[Vector3i(x, y, base_z)] = col_inner
			
			# Extra thickness for heavy cloth on the fold crests
			if pleat_wave > 0.5 and not on_edge:
				voxels[Vector3i(x, y, base_z - 2)] = C_MAGENTA_LIGHT
				
	# 4. EMBOSSED 3D DRAGON RUNIC SIGIL IN RELIEF (Back Centerpiece, y: -4..-16)
	for y in range(-16, -3):
		var progress_sigil = float(-y) / 24.0
		var pleat_center = 1.4 # cos(0) * 1.4
		var sweep_center = progress_sigil * 2.2
		var sz = -int(round(pleat_center + sweep_center)) - 2 # Raised relief!
		
		# Center spine
		voxels[Vector3i(0, y, sz)] = C_SHAMAN_GOLD
		if y in [-6, -11]:
			voxels[Vector3i(0, y, sz)] = C_GLOW_CYAN
			voxels[Vector3i(0, y, sz - 1)] = C_GLOW_CYAN # Raised jewel
			
		# Arcane diamond wings
		if y in [-5, -7]:
			voxels[Vector3i(-1, y, sz)] = C_MAGENTA_GLOW
			voxels[Vector3i(1, y, sz)] = C_MAGENTA_GLOW
		elif y == -6:
			voxels[Vector3i(-2, y, sz)] = C_SHAMAN_GOLD
			voxels[Vector3i(2, y, sz)] = C_SHAMAN_GOLD
			
		# Lower dragon eye sigil
		if y in [-10, -12]:
			voxels[Vector3i(-1, y, sz)] = C_SHAMAN_GOLD
			voxels[Vector3i(1, y, sz)] = C_SHAMAN_GOLD
		elif y == -11:
			voxels[Vector3i(-2, y, sz)] = C_GLOW_CYAN
			voxels[Vector3i(2, y, sz)] = C_GLOW_CYAN
			voxels[Vector3i(-3, y, sz)] = C_SHAMAN_GOLD
			voxels[Vector3i(3, y, sz)] = C_SHAMAN_GOLD

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_staff_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_staff_mesh_outfit2()
	return build_shaman_staff_mesh_outfit1()

static func build_shaman_staff_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Ancient Gnarled Petrified Ironwood Stave (y: -18..22)
	for y in range(-18, 23):
		var wobble_x = int(sin(float(y) * 0.35) * 1.5)
		var wobble_z = int(cos(float(y) * 0.28) * 1.2)
		var rad = 1
		if y in [-18, -17]: rad = 0 # Pointed iron ferrule base
		elif y in [-2, -1, 0, 1, 2, 3, 4]: rad = 1 # Hand grip zone
		
		for dx in range(-rad, rad + 1):
			for dz in range(-rad, rad + 1):
				if rad > 0 and abs(dx) == rad and abs(dz) == rad: continue
				var col = C_WOOD
				# Base iron spike
				if y <= -16:
					col = C_IRON
				# Hand grip wrapped in dark leather with gold rings
				elif y in [-2, -1, 0, 1, 2, 3, 4]:
					col = C_SHAMAN_GOLD if (y in [-2, 4]) else C_LEATHER_DARK
				# Ancient runic markings along stave
				elif y in [-10, 10] and (dx == 0 or dz == 0):
					col = C_GLOW_CYAN
				elif y % 6 == 0:
					col = C_WOOD_DARK
				voxels[Vector3i(wobble_x + dx, y, wobble_z + dz)] = col

	# 2. Dangling Ritual Fetishes & Charms from staff neck (y: 16..21)
	# Left dangling wolf fang
	voxels[Vector3i(-2, 19, 1)] = C_ROPE
	voxels[Vector3i(-3, 18, 2)] = C_ROPE
	voxels[Vector3i(-3, 17, 2)] = C_TEETH
	voxels[Vector3i(-3, 16, 2)] = C_TEETH
	# Right dangling feathers
	voxels[Vector3i(2, 19, -1)] = C_ROPE
	voxels[Vector3i(3, 18, -1)] = C_FEATHER_RED
	voxels[Vector3i(3, 17, -1)] = C_PURPLE_MAGIC
	voxels[Vector3i(3, 16, -1)] = C_GLOW_CYAN

	# 3. Staff Crown: Horned Demonic Skull (y: 22..30)
	# Skull cranium & snout
	for y in range(22, 29):
		var sw = 3 if y < 27 else 4
		for x in range(-sw, sw + 1):
			for z in range(-sw, sw + 1):
				if abs(x) + abs(z) <= sw + 2:
					var col = C_SKULL_BONE
					if y == 22: col = C_BONE # Jaw base
					voxels[Vector3i(x, y, z)] = col
	# Open jaw & wicked predator fangs on staff skull
	voxels[Vector3i(-2, 23, 4)] = C_TEETH
	voxels[Vector3i(2, 23, 4)] = C_TEETH
	voxels[Vector3i(0, 23, 4)] = C_TEETH
	voxels[Vector3i(-1, 22, 4)] = C_TEETH
	voxels[Vector3i(1, 22, 4)] = C_TEETH
	# Glowing occult eye sockets
	voxels[Vector3i(-2, 26, 4)] = C_GLOW_CYAN
	voxels[Vector3i(2, 26, 4)] = C_GLOW_CYAN
	voxels[Vector3i(-1, 26, 4)] = C_PURPLE_MAGIC
	voxels[Vector3i(1, 26, 4)] = C_PURPLE_MAGIC

	# 4. Colossal Swept Skull Horns forming a cradle for the orb (y: 27..38)
	for side in [-1, 1]:
		var staff_horn = [
			Vector3i(side * 4, 27, 0),
			Vector3i(side * 5, 28, 0),
			Vector3i(side * 6, 30, 1),
			Vector3i(side * 7, 32, 2),
			Vector3i(side * 7, 34, 1),
			Vector3i(side * 6, 36, 0),
			Vector3i(side * 5, 37, -1),
			Vector3i(side * 4, 38, -2), # Horn tip curls inward above orb
		]
		for hp in staff_horn:
			voxels[hp] = C_BONE
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK

	# 5. FLOATING ELDRITCH SOUL ORB & MYSTICAL AURA FLAME (y: 29..36)
	# Radiant Cyan Spirit Core (3x3x3 sphere centered at y: 32)
	for y in range(30, 35):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var d2 = x * x + z * z + (y - 32) * (y - 32)
				if d2 <= 4:
					voxels[Vector3i(x, y, z)] = C_GLOW_CYAN
				elif d2 <= 7:
					voxels[Vector3i(x, y, z)] = C_PURPLE_MAGIC
	# Dancing magical flame tongues rising above the orb
	voxels[Vector3i(0, 35, 0)] = C_PURPLE_MAGIC
	voxels[Vector3i(0, 36, 0)] = C_GLOW_CYAN
	voxels[Vector3i(1, 35, 1)] = C_PURPLE_MAGIC
	voxels[Vector3i(-1, 35, -1)] = C_PURPLE_MAGIC

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_staff_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Gilded Serpent Ironwood Stave (y: -18..22)
	for y in range(-18, 23):
		var wobble_x = int(sin(float(y) * 0.35) * 1.5)
		var wobble_z = int(cos(float(y) * 0.28) * 1.2)
		var rad = 1
		if y in [-18, -17]: rad = 0 # Ferrule point
		elif y in [-3, -2, -1, 0, 1, 2, 3, 4]: rad = 1 # Velvet grip
		
		# Gilded serpent twisting angle
		var snake_ang = float(y) * 0.7
		var snake_dx = int(cos(snake_ang) * 1.4)
		var snake_dz = int(sin(snake_ang) * 1.4)
		
		for dx in range(-rad, rad + 1):
			for dz in range(-rad, rad + 1):
				if rad > 0 and abs(dx) == rad and abs(dz) == rad: continue
				var col = C_WOOD_DARK
				if y <= -16:
					col = C_SHAMAN_GOLD if y == -16 else C_STEEL_LIGHT
				elif y in [-3, -2, -1, 0, 1, 2, 3, 4]:
					col = C_SHAMAN_GOLD if (y in [-3, 4]) else C_MAGENTA_ROYAL
				elif dx == snake_dx and dz == snake_dz:
					col = C_SHAMAN_GOLD # Gilded serpent body coiling up!
				elif (y == -10 or y == 10) and (dx == 0 or dz == 0):
					col = C_GLOW_CYAN # Floating cyan rune ring
				voxels[Vector3i(wobble_x + dx, y, wobble_z + dz)] = col

	# 2. Quadruple Cascading Ritual Fetishes & Charms (y: 16..21)
	# Left tassels: Gold chains & red dragon tooth
	voxels[Vector3i(-2, 19, 1)] = C_SHAMAN_GOLD
	voxels[Vector3i(-3, 18, 2)] = C_SHAMAN_GOLD
	voxels[Vector3i(-3, 17, 2)] = C_BONE
	voxels[Vector3i(-3, 16, 2)] = C_TEETH
	# Right tassels: Gold-capped magenta and cyan feathers
	voxels[Vector3i(2, 19, -1)] = C_SHAMAN_GOLD
	voxels[Vector3i(3, 18, -1)] = C_MAGENTA_LIGHT
	voxels[Vector3i(3, 17, -1)] = C_GLOW_CYAN
	voxels[Vector3i(3, 16, -1)] = C_FEATHER_WHITE

	# 3. Staff Crown: Golden Crowned Demon Skull (y: 22..29)
	for y in range(22, 29):
		var sw = 3 if y < 27 else 4
		for x in range(-sw, sw + 1):
			for z in range(-sw, sw + 1):
				if abs(x) + abs(z) <= sw + 2:
					var col = C_SKULL_BONE
					if y in [27, 28] and (abs(x) == sw or abs(z) == sw):
						col = C_SHAMAN_GOLD # Gilded skull crown
					elif y == 22:
						col = C_SHAMAN_GOLD
					voxels[Vector3i(x, y, z)] = col
	# Gold-plated fangs
	for fx in [-2, 0, 2]:
		voxels[Vector3i(fx, 23, 4)] = C_TEETH
		voxels[Vector3i(fx, 22, 4)] = C_SHAMAN_GOLD
	# Cavernous eye sockets blazing with Cyan Soul Fire
	voxels[Vector3i(-2, 26, 4)] = C_GLOW_CYAN
	voxels[Vector3i(2, 26, 4)] = C_GLOW_CYAN
	voxels[Vector3i(-1, 26, 4)] = C_MAGENTA_GLOW # Center brow gem
	voxels[Vector3i(1, 26, 4)] = C_MAGENTA_GLOW

	# 4. Four Swept Dragon Antler Horns forming an ornate cradle (y: 27..39)
	for side in [-1, 1]:
		# Primary swept rear horn
		var staff_horn = [
			Vector3i(side * 4, 27, 0),
			Vector3i(side * 5, 28, 0),
			Vector3i(side * 6, 30, 1),
			Vector3i(side * 7, 32, 2),
			Vector3i(side * 8, 34, 1),
			Vector3i(side * 8, 36, 0),
			Vector3i(side * 7, 38, -1),
			Vector3i(side * 5, 39, -2),
		]
		for i in range(staff_horn.size()):
			var hp = staff_horn[i]
			var col = C_SHAMAN_GOLD if (i in [2, 5]) else C_BONE
			voxels[hp] = col
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK
			voxels[hp + Vector3i(0, 0, -1)] = col
		# Forward tine
		voxels[Vector3i(side * 5, 31, 3)] = C_SHAMAN_GOLD
		voxels[Vector3i(side * 6, 33, 4)] = C_BONE
		voxels[Vector3i(side * 6, 35, 4)] = C_CLAWS

	# 5. DUAL-COLOR ELDRITCH SOUL STAR (Cyan Core + Swirling Magenta Mantle, y: 29..38)
	# Glowing Cyan Soul Core (sphere centered at y: 32)
	for y in range(30, 35):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var d2 = x * x + z * z + (y - 32) * (y - 32)
				if d2 <= 3:
					voxels[Vector3i(x, y, z)] = C_GLOW_CYAN
				elif d2 <= 6:
					voxels[Vector3i(x, y, z)] = C_MAGENTA_GLOW
				elif d2 <= 8:
					voxels[Vector3i(x, y, z)] = C_PURPLE_MAGIC
	# Dancing magical flame spires
	voxels[Vector3i(0, 35, 0)] = C_GLOW_CYAN
	voxels[Vector3i(0, 36, 0)] = C_MAGENTA_GLOW
	voxels[Vector3i(0, 37, 0)] = C_MAGENTA_LIGHT
	voxels[Vector3i(0, 38, 0)] = C_MAGENTA_GLOW
	voxels[Vector3i(1, 35, 1)] = C_MAGENTA_GLOW
	voxels[Vector3i(-1, 36, -1)] = C_MAGENTA_GLOW
	voxels[Vector3i(1, 36, -1)] = C_GLOW_CYAN
	voxels[Vector3i(-1, 35, 1)] = C_GLOW_CYAN

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# --- DEDICATED SHAMAN LIMBS (Tay Áo Choàng Tế Lễ, Vòng Bùa & Váy Phù Thủy) ---

static func build_shaman_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_upper_arm_mesh_outfit2()
	return build_shaman_upper_arm_mesh_outfit1()

static func build_shaman_upper_arm_mesh_outfit1() -> ArrayMesh:
	# Flowing wide purple robe sleeve with gold trim, wiry green goblin arm underneath
	var voxels = []
	for y in range(-9, 1):
		var is_sleeve = (y >= -6)
		var rx = 4 if is_sleeve else 2
		var rz = 4 if is_sleeve else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if is_sleeve:
					col = C_SHAMAN_ROBE
					if y == -6 and (abs(x) == rx or abs(z) == rz):
						col = C_SHAMAN_GOLD # Golden embroidered sleeve rim
					elif y >= -2 and abs(z) == rz:
						col = C_PELT_BASE # Fur shoulder seam
				elif (y == -8 or y == -9) and z == rz and abs(x) <= 1:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_shaman_upper_arm_mesh_outfit2() -> ArrayMesh:
	# Billowing wide royal magenta bell sleeve with double gold trim
	var voxels = []
	for y in range(-9, 1):
		var is_sleeve = (y >= -7)
		var rx = 5 if (y in [-5, -6]) else (4 if is_sleeve else 2)
		var rz = 5 if (y in [-5, -6]) else (4 if is_sleeve else 2)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if is_sleeve:
					col = C_MAGENTA
					if (y == -6 or y == -7) and (abs(x) == rx or abs(z) == rz):
						col = C_SHAMAN_GOLD # Golden embroidered sleeve rim
					elif y >= -2 and abs(z) == rz:
						col = C_PELT_DARK # Midnight fur shoulder seam
					elif y == -5 and (abs(x) == rx or abs(z) == rz):
						col = C_MAGENTA_LIGHT
				elif (y == -8 or y == -9) and z == rz and abs(x) <= 1:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_shaman_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_forearm_mesh_outfit2(is_right)
	return build_shaman_forearm_mesh_outfit1(is_right)

static func build_shaman_forearm_mesh_outfit1(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				# 1. Ritual cuffs & amulets on forearm (y: -4, -5)
				if y == -4:
					col = C_SHAMAN_GOLD # Golden runic bracelet
				elif y == -5:
					col = C_BONE if (abs(x) == 2 or abs(z) == 2) else C_LEATHER_DARK # Bone bead wrap
				elif y == -6:
					col = C_SKIN_DARK
				# 2. Witch-doctor hands & talons (y <= -7)
				elif y <= -7:
					if is_right:
						# Clenched gripping hand holding staff
						if z == 2:
							col = C_CLAWS if y == -9 and abs(x) <= 1 else C_SKIN_LIGHT
						elif abs(x) == 2 or z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						else:
							col = C_SKIN
					else:
						# Open splayed hex-casting claw hand
						if y == -9:
							col = C_CLAWS
						elif y == -8 and (z == 2 or abs(x) == 2):
							col = C_SKIN_LIGHT
						else:
							col = C_SKIN
				voxels.append([x, y, z, col])
				
	# Extra claw extensions for spellcasting witch-doctor hands
	if not is_right:
		for tx in [-1, 1]:
			voxels.append([tx, -9, 2, C_CLAWS])
			voxels.append([tx, -10, 2, C_CLAWS])
		voxels.append([0, -10, 1, C_CLAWS])
	else:
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
		voxels.append([-1, -8, 2, C_CLAWS])
		voxels.append([0, -9, 2, C_CLAWS])
		voxels.append([1, -9, 2, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_shaman_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				# Golden Runic Arch-Mage Bracer (y: -3..-6)
				if y in [-4, -5]:
					col = C_SHAMAN_GOLD
					if z == 2 and x == 0:
						col = C_GLOW_CYAN # Embedded cyan rune gem
				elif y in [-3, -6]:
					col = C_SHAMAN_GOLD if (abs(x) == 2 or abs(z) == 2) else C_LEATHER_DARK
				# Witch-Doctor Claws & Gold Rings (y <= -7)
				elif y <= -7:
					if is_right:
						if z == 2:
							col = C_CLAWS if y == -9 and abs(x) <= 1 else C_SKIN_LIGHT
						elif abs(x) == 2 or z == -2:
							col = C_SHAMAN_GOLD if y == -8 else C_SKIN
						else:
							col = C_SKIN
					else:
						# Open splayed mudra claw with glowing magenta tips
						if y == -9:
							col = C_MAGENTA_GLOW if abs(x) <= 1 else C_CLAWS
						elif y == -8 and (z == 2 or abs(x) == 2):
							col = C_SHAMAN_GOLD # Golden ring
						else:
							col = C_SKIN
				voxels.append([x, y, z, col])
				
	# Extended claw talons
	if not is_right:
		for tx in [-1, 1]:
			voxels.append([tx, -9, 2, C_MAGENTA_GLOW])
			voxels.append([tx, -10, 2, C_CLAWS])
		voxels.append([0, -10, 1, C_CLAWS])
	else:
		voxels.append([-2, -7, 1, C_SHAMAN_GOLD])
		voxels.append([-1, -8, 2, C_CLAWS])
		voxels.append([0, -9, 2, C_CLAWS])
		voxels.append([1, -9, 2, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_shaman_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_thigh_mesh_outfit2()
	return build_shaman_thigh_mesh_outfit1()

static func build_shaman_thigh_mesh_outfit1() -> ArrayMesh:
	# Long flowing ritual robe skirt draping down to knees
	var voxels = []
	for y in range(-9, 1):
		var rx = 4 if y > -7 else 3
		var rz = 4 if y > -7 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SHAMAN_ROBE
				if y == -8:
					col = C_SHAMAN_GOLD # Golden bottom hem
				elif y == -9:
					col = C_SKIN_DARK # Knees emerging under robe
				elif abs(x) == rx:
					col = C_SHAMAN_ROBE_DARK # Robe pleat/crease
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_shaman_thigh_mesh_outfit2() -> ArrayMesh:
	# Extended flowing royal magenta robe skirt draping down past knees
	var voxels = []
	for y in range(-10, 1):
		var rx = 4 if y > -8 else 5 # Flares outward at bottom hem!
		var rz = 4 if y > -8 else 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_MAGENTA
				if y in [-9, -10]:
					col = C_SHAMAN_GOLD # Wide golden bottom hem
				elif y == -8:
					col = C_MAGENTA_LIGHT # Accent band
				elif abs(x) == rx:
					col = C_MAGENTA_DARK # Robe pleat
				# Center slit showing gold knee greave at y = -9
				if z == rz and abs(x) <= 1 and y <= -8:
					col = C_SHAMAN_GOLD if y == -9 and x == 0 else C_LEATHER_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_shaman_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_shin_mesh_outfit2()
	return build_shaman_shin_mesh_outfit1()

static func build_shaman_shin_mesh_outfit1() -> ArrayMesh:
	# Sculpted Shaman Shins with bone ankle charm and bare clawed feet grounded at y = -10
	var voxels = []
	# 1. Muscular upper shin emerging from robe (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_SKIN
				if z == 2: col = C_SKIN_LIGHT
				elif z == -3: col = C_SKIN_DARK
				voxels.append([x, y, z, col])
				
	# 2. Ritual Ankle Wraps with Bone Fetish (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_LEATHER_DARK
				if y == -6 and (abs(x) == 2 or abs(z) == 2):
					col = C_BONE # Bone beads on ankle wrap!
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_SKIN_DARK if abs(x) == 3 else C_SKIN
			voxels.append([x, -8, z, col])
			
	# 4. Bare Feral Goblin Foot with Hardened Dark Soles (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_SKIN
				if y == -10:
					col = C_SKIN_DARK # Tough, completely flat grounded sole at y = -10
				elif z >= 0 and y == -8:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
				
	# 5. Chunky 3D Toes with Long Witch-Doctor Talons (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SKIN_LIGHT if (ty == -9 and tz == 4) else C_SKIN
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_SKIN])
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_shaman_shin_mesh_outfit2() -> ArrayMesh:
	# Sculpted Shaman Shins with gold chains, magenta wraps, and clawed sabatons
	var voxels = []
	# 1. Shin with criss-crossing gold bindings (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_LEATHER_DARK
				if (x + y + z) % 3 == 0:
					col = C_SHAMAN_GOLD # Criss-cross gold wire
				voxels.append([x, y, z, col])
				
	# 2. Ritual Ankle Wraps with Gold & Skull Beads (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_MAGENTA
				if y == -6 and (abs(x) == 2 or abs(z) == 2):
					col = C_SKULL_BONE if x == 0 or z == 0 else C_SHAMAN_GOLD
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_MAGENTA_DARK if abs(x) == 3 else C_LEATHER_DARK
			voxels.append([x, -8, z, col])
			
	# 4. Hardened Witch-Doctor Sabaton Foot grounded at y = -10 (z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_LEATHER_DARK
				if y == -10:
					col = 0x140d09 # Heavy dark grounded sole
				elif z >= 0 and y == -8:
					col = C_SHAMAN_GOLD # Golden foot strap
				voxels.append([x, y, z, col])
				
	# 5. Chunky Toes with Gold Rings & Long Obsidian Talons (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SHAMAN_GOLD if (ty == -9 and tz == 4) else C_LEATHER_DARK
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_LEATHER_DARK])
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_totem_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# ----------------------------------------------------
	# 1. BASE: OCTAGONAL ALTAR PLINTH & GNARLED ROOTS (y: 0..3)
	# ----------------------------------------------------
	for y in range(4):
		var rad = 7 if y == 0 else (6 if y < 3 else 5)
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) + abs(z) > rad + 3: continue
				var col = C_STONE
				if y == 0 or abs(x) + abs(z) >= rad + 2:
					col = C_STONE_DARK
				elif (x * 7 + z * 13 + y * 3) % 5 == 0:
					col = C_STONE_LIGHT
				# Glowing runic cross channels carved into the stone
				if y == 3 and (abs(x) == 0 or abs(z) == 0) and abs(x) + abs(z) <= 5:
					col = C_PURPLE_MAGIC
				voxels[Vector3i(x, y, z)] = col

	# Gnarled Tree Roots anchoring the pillar into the earth (y: 1..7)
	for corner in [Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]:
		for s in range(5):
			var rx = corner.x * (5 - s / 2)
			var rz = corner.y * (5 - s / 2)
			var ry = 1 + s
			voxels[Vector3i(rx, ry, rz)] = C_BARK_DARK
			voxels[Vector3i(rx + corner.x, ry - 1, rz)] = C_BARK

	# ----------------------------------------------------
	# 2. WEATHERED TIMBER TRUNK (y: 4..38)
	# ----------------------------------------------------
	for y in range(4, 38):
		var rad = 4
		if y in [4, 5]: rad = 5 # Bottom flare
		elif y in [18, 19]: rad = 5 # Mid torc flare
		elif y in [35, 36, 37]: rad = 5 # Crown rim flare
		elif y in [11, 12, 28, 29]: rad = 4
		
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad: continue
				var col = C_WOOD
				if (x + y * 2 + z) % 4 == 0:
					col = C_WOOD_DARK
				elif (x * 3 + z * 5 + y) % 7 == 0:
					col = C_BARK
				voxels[Vector3i(x, y, z)] = col

	# ----------------------------------------------------
	# 3. LOWER SECTION: LEATHER STRAPS & BEAST DEMON MASK (y: 6..18)
	# ----------------------------------------------------
	# Leather harness bands & bronze buckle (y: 6..7)
	for y in [6, 7]:
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					var col = C_LEATHER_DARK
					if abs(x) == 0 and z == 5: col = C_BUCKLE
					elif (x + z) % 2 == 0: col = C_ROPE
					voxels[Vector3i(x, y, z)] = col

	# 3D BEAST DEMON FACE (facing +Z, y: 8..17)
	# 3D Protruding Lower Jaw (y: 8..10, z: 4..5)
	for x in range(-3, 4):
		voxels[Vector3i(x, 8, 5)] = C_WOOD_DARK
		voxels[Vector3i(x, 9, 5)] = C_WOOD_DARK
	# Massive lower tusk fangs jutting upward (y: 9..12, x: -3, +3)
	for side in [-3, 3]:
		voxels[Vector3i(side, 9, 5)] = C_TEETH
		voxels[Vector3i(side, 10, 5)] = C_TEETH
		voxels[Vector3i(side, 11, 5)] = C_BONE
		voxels[Vector3i(side, 12, 5)] = C_BONE

	# Sunken Gaping Mouth Cavity (y: 9..11, z: 3..4)
	for x in range(-2, 3):
		for y in range(9, 12):
			voxels[Vector3i(x, y, 4)] = C_MOUTH_DARK
	voxels[Vector3i(0, 10, 4)] = C_WARPAINT_RED # Blood drop sacrifice

	# 3D Upper Snout & Incisors (y: 11..13)
	for x in range(-3, 4):
		voxels[Vector3i(x, 12, 5)] = C_WOOD
	for x in [-2, 0, 2]:
		voxels[Vector3i(x, 11, 5)] = C_TEETH

	# Glowing Evil Beast Eyes (y: 13..14, z: 4..5)
	for side in [-2, 2]:
		voxels[Vector3i(side, 14, 4)] = C_EYE_YELLOW
		voxels[Vector3i(side + (1 if side < 0 else -1), 14, 4)] = C_WARPAINT_RED
	# Overhanging Heavy Eyebrow Ridge (y: 15, z: 5..6)
	for x in range(-4, 5):
		voxels[Vector3i(x, 15, 5)] = C_WOOD_DARK
		if abs(x) in [2, 3]:
			voxels[Vector3i(x, 15, 6)] = C_BARK_DARK

	# Side Beast Hornlets (y: 14..17)
	for side in [-1, 1]:
		voxels[Vector3i(side * 5, 14, 1)] = C_BONE
		voxels[Vector3i(side * 6, 15, 1)] = C_BONE
		voxels[Vector3i(side * 6, 16, 0)] = C_BONE
		voxels[Vector3i(side * 5, 17, 0)] = C_WOOD_DARK

	# ----------------------------------------------------
	# 4. MIDDLE SECTION: GOLD TORC & DANGLING SPIRIT FETISHES (y: 18..24)
	# ----------------------------------------------------
	# Golden Runic Collar (y: 19..20)
	for y in [19, 20]:
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					var col = C_SHAMAN_GOLD
					if y == 20 and (x == 0 or z == 0):
						col = C_GLOW_CYAN # Embedded turquoise gem
					voxels[Vector3i(x, y, z)] = col

	# Left Flank: Dangling Shaman Feather Tassel (x = -5, y: 12..18)
	for dy in range(6):
		voxels[Vector3i(-5, 18 - dy, 0)] = C_ROPE
	voxels[Vector3i(-5, 14, 0)] = C_FEATHER_RED
	voxels[Vector3i(-5, 13, 0)] = C_FEATHER_WHITE
	voxels[Vector3i(-5, 12, 0)] = C_FEATHER_RED
	voxels[Vector3i(-5, 13, 1)] = C_FEATHER_WHITE

	# Right Flank: Dangling Bone Fetish Tassel (x = +5, y: 12..18)
	for dy in range(6):
		voxels[Vector3i(5, 18 - dy, 0)] = C_ROPE
	voxels[Vector3i(5, 14, 0)] = C_BONE
	voxels[Vector3i(5, 13, 0)] = C_SKULL_BONE
	voxels[Vector3i(5, 12, 0)] = C_BONE

	# Back Spine Spikes (z = -5, y: 10..34)
	for sy in range(10, 35, 3):
		voxels[Vector3i(0, sy, -5)] = C_BONE
		voxels[Vector3i(0, sy + 1, -5)] = C_WOOD_DARK

	# ----------------------------------------------------
	# 5. UPPER SECTION: GREAT WITCH-DOCTOR DEMON MASK (y: 24..35)
	# ----------------------------------------------------
	# 3D Sculpted Cheekbones & Snout (y: 25..32, z: 4..6)
	for y in range(25, 33):
		for x in range(-4, 5):
			voxels[Vector3i(x, y, 5)] = C_WOOD
	# Deep Grinning Mouth with Sharp 3D Teeth (y: 25..27)
	for x in range(-3, 4):
		voxels[Vector3i(x, 26, 5)] = C_MOUTH_DARK
	voxels[Vector3i(-2, 25, 5)] = C_TEETH
	voxels[Vector3i(0, 25, 5)] = C_TEETH
	voxels[Vector3i(2, 25, 5)] = C_TEETH
	voxels[Vector3i(-1, 27, 5)] = C_TEETH
	voxels[Vector3i(1, 27, 5)] = C_TEETH

	# Witch-Doctor Warpaint Stripes on Cheeks (y: 28..29)
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 28, 5)] = C_WARPAINT_RED
		voxels[Vector3i(side * 4, 28, 5)] = C_WARPAINT_RED
		voxels[Vector3i(side * 3, 29, 5)] = C_WARPAINT_RED

	# Cavernous Hypnotic Glowing Cyan Eye Sockets (y: 30..32, z: 4..5)
	for side in [-2, 2]:
		voxels[Vector3i(side, 31, 5)] = C_GLOW_CYAN # Radiant soul center
		voxels[Vector3i(side, 31, 4)] = C_PURPLE_MAGIC # Inner mystic aura
		voxels[Vector3i(side + (1 if side < 0 else -1), 31, 5)] = C_MOUTH_DARK # Dark socket rim
		voxels[Vector3i(side, 30, 5)] = C_MOUTH_DARK
		voxels[Vector3i(side, 32, 5)] = C_MOUTH_DARK

	# Overhanging Heavy Demon Brow & Forehead Horn Crest (y: 33..35, z: 5..6)
	for x in range(-4, 5):
		voxels[Vector3i(x, 34, 5)] = C_BARK_DARK
		if abs(x) <= 3:
			voxels[Vector3i(x, 34, 6)] = C_WOOD_DARK
	# Forehead Mystic Soul Gem (y = 34, x = 0, z = 6)
	voxels[Vector3i(0, 34, 6)] = C_GLOW_CYAN
	voxels[Vector3i(0, 35, 5)] = C_PURPLE_MAGIC

	# ----------------------------------------------------
	# 6. TOTEM CROWN: ELDRITCH HORNS & SACRED BRAZIER (y: 36..47)
	# ----------------------------------------------------
	# Crown Rim & Brazier (y: 36..38)
	for y in range(36, 39):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					var col = C_SHAMAN_GOLD if y == 37 else C_WOOD_DARK
					voxels[Vector3i(x, y, z)] = col

	# Grand Sweeping 3D Demon Horns (y: 37..47)
	for side in [-1, 1]:
		var horn_pts = [
			Vector3i(side * 5, 37, 0),
			Vector3i(side * 6, 38, 0),
			Vector3i(side * 7, 39, 0),
			Vector3i(side * 8, 41, 1),
			Vector3i(side * 8, 43, 1),
			Vector3i(side * 7, 45, 2),
			Vector3i(side * 6, 46, 2),
			Vector3i(side * 5, 47, 3), # Tip curls inward and forward!
		]
		for hp in horn_pts:
			voxels[hp] = C_BONE
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK
			voxels[hp + Vector3i(0, 0, -1)] = C_BONE

	# Central Dancing Spirit Soul Flame / Eldritch Orb (y: 38..46)
	for y in range(38, 43):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var d2 = x * x + z * z + (y - 40) * (y - 40)
				if d2 <= 3:
					voxels[Vector3i(x, y, z)] = C_GLOW_CYAN
				elif d2 <= 6:
					voxels[Vector3i(x, y, z)] = C_PURPLE_MAGIC
	# Flickering flame tongues rising from the soul orb
	voxels[Vector3i(0, 43, 0)] = C_GLOW_CYAN
	voxels[Vector3i(0, 44, 0)] = C_PURPLE_MAGIC
	voxels[Vector3i(1, 44, 1)] = C_GLOW_CYAN
	voxels[Vector3i(-1, 45, 0)] = C_PURPLE_MAGIC
	voxels[Vector3i(0, 46, 0)] = C_GLOW_CYAN

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)



# --- C. GOBLIN ROGUE (Sát Thủ: Bộ 1 Thô Sơ Dã Nhân & Bộ 2 Sát Thủ Ám Sát) ---

static func build_rogue_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_head_mesh_outfit1()
	return build_rogue_head_mesh_outfit2()

static func build_rogue_head_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Neck (y: 0..3) with raw twine cord
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_SKIN_DARK if y == 0 else C_SKIN
				if y == 2 and (abs(x) == 3 or abs(z) == 3):
					col = C_ROPE
				voxels[Vector3i(x, y, z)] = col

	# 2. Lower Jaw & Chin (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 3. Cranium Core (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN
				
	# Wild Feral Hair Tufts (y: 15..17)
	for y in range(15, 18):
		for x in [-2, 0, 2]:
			voxels[Vector3i(x, y, -3)] = C_HAIR
			voxels[Vector3i(x, y, -4)] = C_HAIR

	# 4. PRIMITIVE BURLAP / COARSE TUNIC FACE MASK (y: 4..8) - Strictly covers lower mouth/chin
	# Solid weathered brown cloth (matching Warrior & Archer outfit 1, zero checkerboard!)
	for y in range(4, 9):
		for x in range(-5, 6):
			for z in range(-4, 8):
				if abs(x) == 5 and (z < -2 or z > 5): continue
				var on_mask_surf = (abs(x) == 5 or z == 7 or abs(z) == 4 or y == 4)
				if on_mask_surf:
					var col = C_TUNIC
					if y == 8 and z == 7: col = C_TUNIC_DARK
					elif y == 4: col = C_TUNIC_DARK
					voxels[Vector3i(x, y, z)] = col

	# 5. MASK KNOT & FRAYED CORD ENDS (At back of head)
	for ky in [7, 8]:
		for kx in [-1, 0, 1]:
			voxels[Vector3i(kx, ky, -5)] = C_ROPE
			voxels[Vector3i(kx, ky, -6)] = C_LEATHER_DARK
	voxels[Vector3i(-2, 6, -6)] = C_ROPE
	voxels[Vector3i(-2, 5, -6)] = C_SINEW
	voxels[Vector3i(2, 6, -6)] = C_ROPE
	voxels[Vector3i(2, 5, -6)] = C_SINEW

	# 6. SHARP GOBLIN NOSE (y: 9..10, z: 7..9 - pokes out over bandana!)
	for y in range(9, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 9, 9)] = C_SKIN_LIGHT
	voxels[Vector3i(-1, 9, 7)] = C_SKIN_DARK
	voxels[Vector3i(1, 9, 7)] = C_SKIN_DARK

	# 7. PIERCING PREDATORY AMBER EYES (y: 10, z: 6..7 - FULLY VISIBLE & VIBRANT)
	voxels[Vector3i(-2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(-3, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(-3, 10, 7)] = C_FEATHER_WHITE
	voxels[Vector3i(2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(3, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(3, 10, 7)] = C_FEATHER_WHITE

	# Sinister Angled Brow (y: 11, z: 6..7)
	for x in range(-4, 5):
		var brow_col = C_SKIN_DARK
		voxels[Vector3i(x, 11, 6)] = brow_col
		if abs(x) <= 3:
			voxels[Vector3i(x, 11, 7)] = brow_col

	# 8. PRIMITIVE RAWHIDE HEADBAND WITH BONE BEAD (y: 12)
	for x in range(-6, 7):
		for z in range(-5, 6):
			if (abs(x) == 6 or abs(z) == 5) and (abs(x) + abs(z) < 11):
				voxels[Vector3i(x, 12, z)] = C_LEATHER_DARK
	voxels[Vector3i(0, 12, 6)] = C_TEETH # Small prey fang tied on forehead

	# 9. LONG POINTED GOBLIN EARS (11 voxels long, swept back, 3D cartilage)
	for side in [-1, 1]:
		for s in range(11):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.35)
			var ez = -int(float(s) * 0.7)
			var h_half = 2 if s < 4 else (1 if s < 8 else 0)
			
			if side == 1 and s in [7, 8] and h_half > 0:
				voxels[Vector3i(ex, ey, ez)] = C_SKIN_DARK # Battle nick
				continue
				
			for dy in range(-h_half, h_half + 1):
				var e_col = C_SKIN
				if dy == h_half: e_col = C_SKIN_LIGHT
				elif dy == -h_half: e_col = C_SKIN_DARK
				voxels[Vector3i(ex, ey + dy, ez)] = e_col
				
				if s >= 1 and s <= 5 and abs(dy) <= 1:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER
					
			# Primitive bone quill piercing on left ear
			if side == -1 and s == 3:
				voxels[Vector3i(ex, ey + h_half + 1, ez)] = C_BONE
				voxels[Vector3i(ex, ey - h_half - 1, ez)] = C_BONE

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_rogue_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Neck (y: 0..3) with high dark assassin cowl collar
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_SKIN_DARK if y == 0 else C_SKIN
				if abs(x) == 3 or abs(z) == 3:
					col = C_ROGUE_HOOD
				voxels[Vector3i(x, y, z)] = col

	# 2. Lower Jaw & Chin (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 3. Cranium Core (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 4. ASSASSIN BANDANA / FACE MASK (Covers mouth, jaw, chin y: 4..8)
	for y in range(4, 9):
		for x in range(-5, 6):
			for z in range(-4, 8):
				if abs(x) == 5 and (z < -2 or z > 5): continue
				var on_mask_surf = (abs(x) == 5 or z == 7 or abs(z) == 4 or y == 4)
				if on_mask_surf:
					var col = C_ROGUE_MASK
					if y == 8 and z == 7: col = C_ROGUE_HOOD_TRIM
					elif y == 4: col = C_ROGUE_HOOD_DARK
					voxels[Vector3i(x, y, z)] = col

	# 5. BANDANA KNOT & DYNAMIC FLUTTER TAILS (At back of head)
	for ky in [7, 8]:
		for kx in [-1, 0, 1]:
			voxels[Vector3i(kx, ky, -5)] = C_ROGUE_HOOD_TRIM
			voxels[Vector3i(kx, ky, -6)] = C_ROGUE_HOOD_DARK
	voxels[Vector3i(-2, 6, -6)] = C_ROGUE_HOOD
	voxels[Vector3i(-2, 5, -6)] = C_ROGUE_HOOD
	voxels[Vector3i(-2, 4, -7)] = C_ROGUE_HOOD
	voxels[Vector3i(-1, 3, -7)] = C_ROGUE_HOOD
	voxels[Vector3i(-2, 2, -8)] = C_ROGUE_HOOD_TRIM
	voxels[Vector3i(-1, 1, -8)] = C_ROGUE_HOOD_DARK
	voxels[Vector3i(2, 6, -6)] = C_ROGUE_HOOD
	voxels[Vector3i(2, 5, -6)] = C_ROGUE_HOOD
	voxels[Vector3i(3, 4, -7)] = C_ROGUE_HOOD
	voxels[Vector3i(2, 3, -7)] = C_ROGUE_HOOD
	voxels[Vector3i(3, 2, -8)] = C_ROGUE_HOOD_TRIM
	voxels[Vector3i(2, 2, -8)] = C_ROGUE_HOOD_DARK

	# 6. SHARP GOBLIN NOSE (y: 9..10, z: 7..9 - pokes out over bandana!)
	for y in range(9, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 9, 9)] = C_SKIN_LIGHT
	voxels[Vector3i(-1, 9, 7)] = C_SKIN_DARK
	voxels[Vector3i(1, 9, 7)] = C_SKIN_DARK

	# 7. PIERCING PREDATORY AMBER EYES (y: 10, z: 6..7 - FULLY VISIBLE & VIBRANT)
	voxels[Vector3i(-2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(-3, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(-3, 10, 7)] = C_FEATHER_WHITE
	voxels[Vector3i(2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(3, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(3, 10, 7)] = C_FEATHER_WHITE

	# Sinister Angled Assassin Brow (y: 11, z: 6..7)
	for x in range(-4, 5):
		var brow_col = C_ROGUE_HOOD_DARK if abs(x) >= 3 else C_SKIN_DARK
		voxels[Vector3i(x, 11, 6)] = brow_col
		if abs(x) <= 3:
			voxels[Vector3i(x, 11, 7)] = brow_col

	# 8. STEALTH COWL / HOOD (y: 12..17)
	for y in range(12, 18):
		var rx = 6 if y < 16 else 5
		var rz = 5 if y < 16 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				var on_hood = (abs(x) == rx or abs(z) == rz or y >= 16)
				if on_hood:
					var col = C_ROGUE_HOOD
					if y == 12 and z == rz: col = C_ROGUE_HOOD_TRIM
					elif y >= 16: col = C_ROGUE_HOOD_DARK
					voxels[Vector3i(x, y, z)] = col

	# 9. LONG POINTED GOBLIN EARS (11 voxels long, swept back, 3D cartilage & gold piercings)
	for side in [-1, 1]:
		for s in range(11):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.35)
			var ez = -int(float(s) * 0.7)
			var h_half = 2 if s < 4 else (1 if s < 8 else 0)
			
			if side == 1 and s in [6, 7] and h_half > 0:
				voxels[Vector3i(ex, ey, ez)] = C_SKIN_DARK
				continue
				
			for dy in range(-h_half, h_half + 1):
				var e_col = C_SKIN
				if dy == h_half: e_col = C_SKIN_LIGHT
				elif dy == -h_half: e_col = C_SKIN_DARK
				voxels[Vector3i(ex, ey + dy, ez)] = e_col
				
				if s >= 1 and s <= 5 and abs(dy) <= 1:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER
					
			if side == -1 and (s == 2 or s == 4):
				voxels[Vector3i(ex, ey + h_half, ez)] = C_GOLD
				voxels[Vector3i(ex, ey + h_half + 1, ez)] = C_GOLD
				voxels[Vector3i(ex, ey + h_half, ez - 1)] = C_GOLD

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_rogue_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_torso_mesh_outfit1()
	return build_rogue_torso_mesh_outfit2()

static func build_rogue_torso_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# 1. Tattered hem notches at the bottom (y <= 1)
				if y <= 1 and (x % 2 == 0 or z % 2 == 0):
					continue

				# 2. Exposed goblin neck (y >= 15 at center collar)
				if y >= 15 and abs(x) <= 3 and abs(z) <= 3:
					voxels.append([x, y, z, C_SKIN])
					continue
				if y == 14 and abs(x) <= 1 and z == rz:
					voxels.append([x, y, z, C_SKIN_DARK])
					continue

				# 3. Twisted Hemp Rope Belt (y == 3 or y == 4)
				if (y == 3 or y == 4) and (abs(x) == rx or abs(z) == rz):
					var belt_col = C_ROPE
					if y == 4 and abs(x) <= 1 and z == rz:
						belt_col = C_BONE # Carved bone toggle buckle
					voxels.append([x, y, z, belt_col])
					continue

				# 4. Right Hip: Dried hollow gourd poison flask (x == rx, y in [2, 3, 4], z in [0, 1])
				if x == rx and y in [2, 3, 4] and z in [0, 1]:
					var flask_col = C_WOOD_DARK
					if y == 4: flask_col = C_WOOD
					elif y == 2 and z == 1: flask_col = C_VENOM_DARK # Swamp venom seep
					voxels.append([x + 1, y, z, flask_col])

				# 5. Left Hip: Crude rawhide pouch (x == -rx, y in [2, 3, 4], z in [0, 1])
				if x == -rx and y in [2, 3, 4] and z in [0, 1]:
					voxels.append([x - 1, y, z, C_LEATHER_DARK])

				# 6. Diagonal Rawhide Cross-Bandolier (shoulder to hip)
				var is_bandolier = (abs(float(y) - (-1.1 * float(x) + 10.0)) <= 1.0) and (z == rz or z == -rz)
				if is_bandolier:
					voxels.append([x, y, z, C_LEATHER])
					continue

				# Crude carved bone shiv slotted on bandolier (left chest)
				if x in [-3, -2] and y in [11, 12, 13] and z == rz:
					var shiv_col = C_BONE if y == 13 else C_WOOD_DARK
					voxels.append([x, y, z + 1, shiv_col])

				# 7. Stitched Patch on front right ribcage (y: 7..9, x: 2..4)
				if z == rz and x in [2, 3, 4] and y in [7, 8, 9]:
					if (x == 2 or x == 4 or y == 7 or y == 9) and (x + y) % 2 == 1:
						voxels.append([x, y, z, C_STITCH])
					else:
						voxels.append([x, y, z, C_TUNIC_PATCH])
					continue

				# 8. Full Body Tattered Tunic / Hide Vest (Full coverage, solid natural tones)
				var col = C_TUNIC
				if y <= 2:
					col = C_TUNIC_DARK # Darker hem shading
				elif abs(x) == rx or abs(z) == rz:
					if y in [13, 14]:
						col = C_TUNIC_PATCH # Shoulder seam
					else:
						col = C_TUNIC
				voxels.append([x, y, z, col])

	return build_seamless_mesh(voxels)

static func build_rogue_torso_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				if y >= 15:
					if abs(x) <= 3 and abs(z) <= 3:
						voxels.append([x, y, z, C_SKIN_DARK])
					elif abs(x) <= 4 and abs(z) <= 4:
						voxels.append([x, y, z, C_ROGUE_HOOD])
					else:
						voxels.append([x, y, z, C_ROGUE_HOOD_DARK])
					continue
				
				if y >= 3 and y <= 5 and (abs(x) == rx or abs(z) == rz):
					var b_col = C_LEATHER_DARK
					if y == 4 and x == 0 and z == rz:
						b_col = C_STEEL_LIGHT
					elif y == 4 and (abs(x) in [2, 4]) and z == rz:
						b_col = C_SPIKE
					voxels.append([x, y, z, b_col])
					continue
					
				if x == rx and y in [3, 4, 5] and z in [0, 1]:
					var vial_col = C_VENOM_GREEN if y in [3, 4] else C_WOOD_DARK
					voxels.append([x + 1, y, z, vial_col])
					
				if x == -rx and y in [3, 4, 5] and z in [0, 1]:
					var pouch_col = C_BONE if (y == 4 and z == 1) else C_LEATHER_DARK
					voxels.append([x - 1, y, z, pouch_col])
				
				var is_bandolier1 = (abs(float(y) - (-1.1 * float(x) + 10.0)) <= 1.0) and (z == rz or z == -rz)
				var is_bandolier2 = (abs(float(y) - (1.1 * float(x) + 10.0)) <= 1.0) and (z == rz or z == -rz)
				if is_bandolier1 or is_bandolier2:
					if y == 10 and x == 0 and z == rz:
						voxels.append([x, y, z, C_STEEL_LIGHT])
					else:
						voxels.append([x, y, z, C_LEATHER])
					continue
					
				if x in [-3, -2] and y in [11, 12, 13] and z == rz:
					var dag_col = C_BONE if y == 13 else C_STEEL_LIGHT
					voxels.append([x, y, z + 1, dag_col])
					
				var col = C_ROGUE_LEATHER
				if (abs(x) == rx or abs(z) == rz):
					col = C_ROGUE_HOOD if y % 2 == 0 else C_ROGUE_LEATHER
				voxels.append([x, y, z, col])
				
	return build_seamless_mesh(voxels)

static func build_rogue_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_upper_arm_mesh_outfit1()
	return build_rogue_upper_arm_mesh_outfit2()

static func build_rogue_upper_arm_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if (y == -4 or y == -5) and (abs(x) == rx or abs(z) == rz):
					col = C_ROPE
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	voxels.append([0, -5, 3, C_TEETH])
	return build_seamless_mesh(voxels)

static func build_rogue_upper_arm_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -2 and (abs(x) == rx or abs(z) == rz):
					col = C_ROGUE_HOOD
				elif (y == -5 or y == -6) and (abs(x) == rx or abs(z) == rz):
					col = C_LEATHER_DARK
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_rogue_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_forearm_mesh_outfit1(is_right)
	return build_rogue_forearm_mesh_outfit2(is_right)

static func build_rogue_forearm_mesh_outfit1(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				if y >= -6 and y <= -2:
					if z == -2:
						col = C_BONE if x == 0 else C_ROPE
					elif abs(x) == 2 or z == 2:
						col = C_ROPE
				elif y == -7:
					col = C_ROPE
				elif y <= -8:
					if z == 2:
						col = C_CLAWS if y == -9 else C_SKIN_DARK
					elif z == -2:
						col = C_SKIN_DARK
					else:
						col = C_SKIN
				voxels.append([x, y, z, col])
				
	var thumb_x = 2 if not is_right else -2
	voxels.append([thumb_x, -7, 1, C_SKIN])
	voxels.append([thumb_x, -8, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

static func build_rogue_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				if y >= -6 and y <= -2:
					if z == -2:
						col = C_STEEL_LIGHT if x == 0 else C_ROGUE_LEATHER
					elif abs(x) == 2 or z == 2:
						col = C_ROGUE_LEATHER_DARK if y % 2 == 0 else C_ROGUE_LEATHER
				elif y == -7:
					col = C_LEATHER_DARK
				elif y <= -8:
					if z == 2:
						col = C_CLAWS if y == -9 else C_ROGUE_MASK
					elif z == -2:
						col = C_ROGUE_HOOD if y == -9 else C_SKIN_DARK
					else:
						col = C_ROGUE_MASK
				voxels.append([x, y, z, col])
				
	var thumb_x = 2 if not is_right else -2
	voxels.append([thumb_x, -7, 1, C_ROGUE_MASK])
	voxels.append([thumb_x, -8, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

static func build_rogue_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_thigh_mesh_outfit1()
	return build_rogue_thigh_mesh_outfit2()

static func build_rogue_thigh_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -2 and (abs(x) == rx or abs(z) == rz):
					col = C_TUNIC
				elif (y == -4 or y == -5) and (abs(x) == rx or abs(z) == rz):
					col = C_ROPE
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_rogue_thigh_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_ROGUE_HOOD if y >= -6 else C_ROGUE_HOOD_DARK
				if (y == -4 or y == -5) and (abs(x) == rx or abs(z) == rz):
					col = C_LEATHER_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_rogue_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_rogue_shin_mesh_outfit1()
	return build_rogue_shin_mesh_outfit2()

static func build_rogue_shin_mesh_outfit1() -> ArrayMesh:
	var voxels = []
	# 1. Muscular Upper Shin (y: -6 to 0) - Green skin
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_SKIN
				if z == 2: col = C_SKIN_LIGHT
				elif z == -3: col = C_SKIN_DARK
				voxels.append([x, y, z, col])
				
	# 2. Ankle Rawhide & Twine Wraps (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_ROPE if y == -6 else C_TUNIC_DARK
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_SKIN_DARK if abs(x) == 3 else C_SKIN
			voxels.append([x, -8, z, col])
			
	# 4. Bare Feral Goblin Foot (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_SKIN
				if y == -10: col = C_SKIN_DARK
				elif z >= 0 and y == -8: col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
				
	# 5. 3 Predatory Toes with Claws (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SKIN_LIGHT if (ty == -9 and tz == 4) else C_SKIN
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_SKIN])
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_rogue_shin_mesh_outfit2() -> ArrayMesh:
	var voxels = []
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_ROGUE_HOOD if y >= -3 else C_ROGUE_HOOD_DARK
				if y == -4 and z == 2 and x == 0: col = C_STEEL_LIGHT
				voxels.append([x, y, z, col])
				
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				voxels.append([x, y, z, C_LEATHER_DARK])
				
	for x in range(-3, 4):
		for z in range(-2, 3):
			voxels.append([x, -8, z, C_ROGUE_LEATHER])
			
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_ROGUE_LEATHER_DARK
				if y == -10: col = 0x120c08
				elif z == 3: col = C_ROGUE_LEATHER
				voxels.append([x, y, z, col])
				
	return build_seamless_mesh(voxels)

static func build_dagger_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_dagger_mesh_outfit1()
	return build_dagger_mesh_outfit2()

static func build_dagger_mesh_outfit1() -> ArrayMesh:
	# Primitive Bone Shiv & Knapped Flint Dagger (Dao Xương Nanh & Đá Đẽo Thô Sơ)
	var voxels: Dictionary = {}
	# 1. Gnarled Branch Pommel with Knotted Sinew (y: -6..-5)
	voxels[Vector3i(0, -6, 0)] = C_WOOD_DARK
	voxels[Vector3i(1, -6, 0)] = C_ROPE
	voxels[Vector3i(-1, -6, 0)] = C_SINEW
	voxels[Vector3i(0, -5, 0)] = C_WOOD_DARK

	# 2. Crude Branch Grip with Hemp Rope Lashing (y: -4..0)
	for y in range(-4, 1):
		var w_col = C_ROPE if (y % 2 == 0) else C_WOOD_DARK
		voxels[Vector3i(0, y, 0)] = w_col
		voxels[Vector3i(0, y, 1)] = C_SINEW
		voxels[Vector3i(0, y, -1)] = C_WOOD_DARK

	# 3. Lashed Animal Bone Crossbar (y: 1, x: -3..3)
	for x in range(-2, 3):
		voxels[Vector3i(x, 1, 0)] = C_BONE
		voxels[Vector3i(x, 1, 1)] = C_SINEW
	voxels[Vector3i(0, 1, 0)] = C_ROPE

	# 4. Jagged Chipped Flint Blade with Dripping Swamp Poison (y: 2..13)
	for y in range(2, 14):
		var curve_z = int(float(y - 2) * 0.35)
		voxels[Vector3i(0, y, curve_z)] = C_STONE_DARK if y % 2 == 0 else C_IRON_DARK
		voxels[Vector3i(0, y, curve_z - 1)] = C_STONE_DARK
		
		var is_tooth = (y % 2 == 1)
		var edge_col = C_VENOM_GREEN if is_tooth else C_VENOM_DARK
		voxels[Vector3i(0, y, curve_z + 1)] = edge_col
		if is_tooth and y < 12:
			voxels[Vector3i(0, y - 1, curve_z + 2)] = C_STONE_LIGHT
			voxels[Vector3i(0, y, curve_z + 2)] = C_VENOM_GREEN

	# 5. Razor Chipped Stone Piercing Tip (y: 14..15)
	voxels[Vector3i(0, 14, 4)] = C_STONE_LIGHT
	voxels[Vector3i(0, 14, 5)] = C_VENOM_GREEN
	voxels[Vector3i(0, 15, 5)] = C_STONE_LIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_dagger_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Carved Beast Tooth Pommel (y: -6..-5)
	voxels[Vector3i(0, -6, 0)] = C_BONE
	voxels[Vector3i(1, -6, 0)] = C_TEETH
	voxels[Vector3i(-1, -6, 0)] = C_TEETH
	voxels[Vector3i(0, -5, 0)] = C_BONE

	# 2. Leather Grip with Gold Wire Wrap (y: -4..0)
	for y in range(-4, 1):
		var w_col = C_GOLD if (y % 2 == 0) else C_LEATHER_DARK
		voxels[Vector3i(0, y, 0)] = w_col
		voxels[Vector3i(0, y, 1)] = C_LEATHER
		voxels[Vector3i(0, y, -1)] = C_LEATHER_DARK

	# 3. Gothic Curved Iron Crossguard with Forward Barbs (y: 1, x: -3..3)
	for x in range(-3, 4):
		var g_col = C_STEEL_LIGHT if x == 0 else C_IRON
		voxels[Vector3i(x, 1, 0)] = g_col
		voxels[Vector3i(x, 1, 1)] = C_IRON_DARK
	voxels[Vector3i(-3, 2, 0)] = C_STEEL_LIGHT
	voxels[Vector3i(3, 2, 0)] = C_STEEL_LIGHT

	# 4. Serrated Recurved Blade with Glowing Emerald Venom Edge (y: 2..13)
	for y in range(2, 14):
		var curve_z = int(float(y - 2) * 0.35)
		voxels[Vector3i(0, y, curve_z)] = C_STEEL_LIGHT if y % 2 == 0 else C_IRON
		voxels[Vector3i(0, y, curve_z - 1)] = C_IRON_DARK
		
		var is_tooth = (y % 2 == 1)
		var edge_col = C_VENOM_GREEN if is_tooth else C_VENOM_DARK
		voxels[Vector3i(0, y, curve_z + 1)] = edge_col
		if is_tooth and y < 12:
			voxels[Vector3i(0, y - 1, curve_z + 2)] = C_TEETH
			voxels[Vector3i(0, y, curve_z + 2)] = C_VENOM_GREEN

	# 5. Armor Piercing Needle Point Tip (y: 14..15)
	voxels[Vector3i(0, 14, 4)] = C_STEEL_LIGHT
	voxels[Vector3i(0, 14, 5)] = C_VENOM_GREEN
	voxels[Vector3i(0, 15, 5)] = C_FEATHER_WHITE

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# --- D. MACE OGRE (Boss Ogre Cầm Chùy Nguyên Thủy, Da Thú Xù Lông, Đại Chùy Đá Gai) ---

# =============================================================================
# MACE OGRE OUTFIT 2: THIẾT GIÁP MA THÚ (IRON JUGGERNAUT FULL HEAVY ARMOR)
# =============================================================================

static func build_ogre_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_head_mesh_outfit2()
	return build_ogre_head_mesh_outfit1()

static func build_ogre_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_torso_mesh_outfit2()
	return build_ogre_torso_mesh_outfit1()

static func build_ogre_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_upper_arm_mesh_outfit2()
	return build_ogre_upper_arm_mesh_outfit1()

static func build_ogre_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_forearm_mesh_outfit2(is_right)
	return build_ogre_forearm_mesh_outfit1(is_right)

static func build_ogre_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_thigh_mesh_outfit2()
	return build_ogre_thigh_mesh_outfit1()

static func build_ogre_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_shin_mesh_outfit2()
	return build_ogre_shin_mesh_outfit1()

static func build_ogre_mace_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_ogre_mace_mesh_outfit2()
	return build_ogre_mace_mesh_outfit1()

# --- OUTFIT 2 IMPLEMENTATION ---

static func build_ogre_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Muscular Neck with Heavy Chainmail Coif (y: 0..3)
	for y in range(4):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 and abs(z) == 5: continue
				var col = C_CHAINMAIL if (x + y + z) % 2 == 0 else C_IRON_DARK
				if y == 0: col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# 2. Brutal Jutting Iron Jaw & Reinforced Steel Tusk Guards (y: 4..8)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(-5, 9):
				if (abs(x) >= 5 and z <= -4) or (abs(x) >= 5 and z >= 7): continue
				if abs(x) == 6 and (z <= -2 or z >= 5): continue
				if y == 4 and abs(x) >= 5 and abs(z) >= 5: continue
				if y == 8 and z >= 7 and abs(x) >= 5: continue

				var col = C_IRON
				if y == 4:
					col = C_IRON_DARK
				elif abs(x) <= 3 and z in [3, 4, 5, 6] and y in [5, 6, 7]:
					col = C_MOUTH_DARK # Oral cavity
					if y == 5 and abs(x) <= 1 and z in [4, 5]: col = C_WARRIOR_RED_DARK
				elif z >= 6:
					# Heavy steel jaw plate with bronze studs
					col = C_STEEL_BRIGHT if (abs(x) in [1, 3] and y == 6) else C_STEEL_LIGHT
				elif abs(x) == 5:
					col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# Colossal Boar Tusks with Armored Iron Bands & Sharp Steel Caps
	for side in [-1, 1]:
		voxels[Vector3i(side * 4, 6, 7)] = C_IRON_DARK    # Base iron cuff
		voxels[Vector3i(side * 4, 7, 8)] = C_STEEL_LIGHT  # Steel sheath
		voxels[Vector3i(side * 4, 8, 8)] = C_STEEL_LIGHT  # Steel sheath
		voxels[Vector3i(side * 4, 9, 7)] = C_STEEL_BRIGHT # Razor sharp steel tip
		voxels[Vector3i(side * 4, 10, 6)] = C_STEEL_BRIGHT

	# Secondary teeth
	for tx in [-2, 0, 2]:
		voxels[Vector3i(tx, 6, 7)] = C_TEETH
	for tx in [-1, 1]:
		voxels[Vector3i(tx, 7, 7)] = C_TEETH
		voxels[Vector3i(tx * 3, 8, 6)] = C_TEETH

	# 3. Full Steel Gladiatorial War Helmet Visor & Glowing Amber Eyes (y: 9..12)
	for y in range(9, 13):
		var rx = 6 if y == 9 else 5
		var rz = 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 3):
				if abs(x) >= rx and abs(z) >= rz: continue
				if abs(x) == 6 and (z <= -3 or z >= 4): continue
				
				var col = C_IRON
				# Heavy visor brow plate at front
				if z >= 4:
					if y == 10 and abs(x) in [1, 2, 3]:
						# Narrow menacing visor slit with glowing fiery amber eyes!
						col = C_EYE_YELLOW if abs(x) == 2 else C_FEATHER_RED
					elif y == 11 and z >= 5:
						col = C_STEEL_BRIGHT # Brow reinforce rim
					elif y in [9, 10] and abs(x) in [4, 5]:
						col = C_STEEL_LIGHT # Cheek plate
					else:
						col = C_IRON_DARK
				elif z <= -3:
					col = C_CHAINMAIL if y <= 10 else C_IRON_DARK
				elif abs(x) == rx:
					col = C_STEEL_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# Nose guard with steel rivets
	for y in range(8, 12):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_STEEL_BRIGHT
			if y in [9, 11] and x == 0:
				voxels[Vector3i(x, y, 8)] = C_GOLD # Brass rivet

	# 4. Colossal Curved Iron Bull / Demon Horns (x: +-6..+-10, y: 12..19)
	for side in [-1, 1]:
		# Heavy gold/brass base mount ring
		for dx in range(2):
			for dz in range(2):
				voxels[Vector3i(side * (6 + dx), 12, 1 + dz)] = C_GOLD
		# Outward curving horn base
		voxels[Vector3i(side * 7, 13, 1)] = C_IRON_DARK
		voxels[Vector3i(side * 8, 14, 1)] = C_IRON_DARK
		voxels[Vector3i(side * 8, 14, 2)] = C_IRON
		voxels[Vector3i(side * 9, 15, 1)] = C_IRON
		voxels[Vector3i(side * 9, 16, 0)] = C_STEEL_LIGHT
		# Upward and forward tapering horn tip
		voxels[Vector3i(side * 9, 17, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 8, 18, -1)] = C_STEEL_BRIGHT
		voxels[Vector3i(side * 8, 19, -1)] = C_STEEL_BRIGHT # Sharp point

	# 5. Cranium Helmet Dome & Serrated Steel Mohawk Spikes (y: 13..19)
	for y in range(13, 17):
		var rad = 5 if y <= 14 else (4 if y == 15 else 3)
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if x * x + z * z <= rad * rad + 2:
					var col = C_IRON
					if (x + y + z) % 3 == 0: col = C_STEEL_LIGHT
					elif abs(x) == rad or abs(z) == rad: col = C_IRON_DARK
					voxels[Vector3i(x, y, z)] = col

	# Serrated Razor Mohawk Spine Crest (x = 0, z: -4..5, y: 16..20)
	for z in range(-4, 6):
		var spike_h = 19 if z in [-2, 0, 2] else (18 if z in [-3, -1, 1, 3] else 17)
		for y in range(16, spike_h + 1):
			var sc = C_STEEL_BRIGHT if y == spike_h else C_STEEL_LIGHT
			voxels[Vector3i(0, y, z)] = sc
		voxels[Vector3i(-1, 16, z)] = C_IRON_DARK
		voxels[Vector3i(1, 16, z)] = C_IRON_DARK

	# Chainmail aventail trailing onto upper shoulders at back
	for y in range(8, 13):
		for x in range(-5, 6):
			voxels[Vector3i(x, y, -5)] = C_CHAINMAIL if (x + y) % 2 == 0 else C_IRON_DARK
			if abs(x) == 5:
				voxels[Vector3i(x, y, -4)] = C_CHAINMAIL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_torso_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Heavy Full Steel Plate Cuirass Body (y: 0..17)
	for y in range(18):
		var rx = 7 if y <= 3 else (9 if y <= 13 else 8)
		var rz = 6 if y <= 3 else (7 if y <= 13 else 6)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				if abs(x) >= rx - 1 and abs(z) >= rz and y in [0, 1, 16, 17]: continue

				var col = C_IRON
				# Heavy Pectoral Steel Breastplate (y: 9..14, z >= rz - 1)
				if y in [9, 10, 11, 12, 13, 14] and z >= rz - 1:
					if x == 0:
						col = C_GOLD # Raised center gilded keel ridge
					elif abs(x) in [1, 2, 3, 4, 5]:
						col = C_STEEL_BRIGHT if (y in [11, 12] and abs(x) in [2, 3]) else C_STEEL_LIGHT
					else:
						col = C_IRON_DARK
				# Segmented Abdominal Armor Plates (y: 4..8, z >= rz - 1)
				elif y in [4, 5, 6, 7, 8] and z >= rz - 1:
					if y in [4, 6, 8]:
						col = C_STEEL_BRIGHT # Plate rim edges
					elif abs(x) == 0:
						col = C_GOLD # Center vertical crest
					else:
						col = C_STEEL_LIGHT
				# Backplate Spinal Armor & Hunch (z <= -rz + 1)
				elif z <= -rz + 1:
					if x == 0 and y in [6, 10, 14]:
						col = C_STEEL_BRIGHT # Steel spine spike
					elif abs(x) <= 2:
						col = C_STEEL_LIGHT
					else:
						col = C_IRON_DARK
				# Chainmail flanks under arms
				elif abs(x) >= rx - 1 and z in [-1, 0, 1]:
					col = C_CHAINMAIL if (x + y + z) % 2 == 0 else C_IRON_DARK
				elif abs(x) == rx or abs(z) == rz:
					col = C_IRON_DARK

				voxels[Vector3i(x, y, z)] = col

	# 2. Spinal Armor Spikes protruding from Backplate (-Z)
	for sp_y in [6, 10, 14]:
		voxels[Vector3i(0, sp_y, -7)] = C_STEEL_BRIGHT
		voxels[Vector3i(0, sp_y, -8)] = C_STEEL_BRIGHT

	# 3. Colossal Spiked Fortress Pauldrons (BOTH Shoulders: x = +-7..+-13)
	for side in [-1, 1]:
		# Tier 1 Base Shoulder Armor (y: 13..17, x: 7..10)
		for y in range(13, 18):
			for dx in range(7, 11):
				for z in range(-6, 7):
					var px = side * dx
					var col = C_STEEL_LIGHT if (dx + y) % 2 == 0 else C_STEEL_BRIGHT
					voxels[Vector3i(px, y, z)] = col

		# Tier 2 Flared Mid Shoulder Plate with Forward/Back Spikes (y: 15..19, x: 9..12)
		for y in range(15, 20):
			for dx in range(9, 13):
				for z in range(-5, 6):
					if abs(z) >= 5 and dx >= 11: continue
					var px = side * dx
					voxels[Vector3i(px, y, z)] = C_IRON
		# Heavy steel spike jutting forward from pauldron
		voxels[Vector3i(side * 11, 16, 6)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 11, 16, 7)] = C_STEEL_BRIGHT
		voxels[Vector3i(side * 11, 16, 8)] = C_STEEL_BRIGHT
		# Heavy steel spike jutting backward from pauldron
		voxels[Vector3i(side * 11, 16, -6)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 11, 16, -7)] = C_STEEL_BRIGHT
		voxels[Vector3i(side * 11, 16, -8)] = C_STEEL_BRIGHT

		# Tier 3 Massive Upward-Curved Apex Pauldron Spikes (y: 19..23, x: 11..14)
		for sy in range(19, 24):
			var sx = side * (12 + (sy - 19) / 2)
			voxels[Vector3i(sx, sy, 0)] = C_STEEL_BRIGHT
			voxels[Vector3i(sx, sy, 1)] = C_STEEL_LIGHT
			voxels[Vector3i(sx, sy, -1)] = C_STEEL_LIGHT

	# 4. Heavy Steel War Belt with Demon Skull Buckle (y: 2..5)
	for y in [2, 3, 4, 5]:
		for x in range(-8, 9):
			for z in range(-7, 8):
				if (abs(x) == 8 or abs(z) == 7) and (abs(x) >= 2 or abs(z) >= 2):
					var col = C_IRON_DARK
					if y in [2, 5]: col = C_GOLD # Gilded border rims
					elif (x + z) % 3 == 0: col = C_STEEL_BRIGHT # Steel rivets
					voxels[Vector3i(x, y, z)] = col

	# Massive Embossed Iron Skull / Demon Buckle at Belt Center
	for bx in range(-2, 3):
		for by in range(2, 6):
			voxels[Vector3i(bx, by, 8)] = C_STEEL_BRIGHT
	voxels[Vector3i(-1, 4, 9)] = C_FEATHER_RED # Glowing red eye
	voxels[Vector3i(1, 4, 9)] = C_FEATHER_RED  # Glowing red eye
	voxels[Vector3i(-1, 2, 9)] = C_BONE        # Fangs
	voxels[Vector3i(1, 2, 9)] = C_BONE

	# 5. Segmented Steel Plate Tassets & Armored Faulds (y: -4..2)
	# Hanging armored front tasset flaps
	for side in [-1, 1]:
		for y in range(-4, 3):
			for tx in range(1, 5):
				var px = side * tx
				var t_col = C_STEEL_LIGHT
				if y in [-4, -1, 2]: t_col = C_GOLD # Gold trimmed segment rims
				elif (px + y) % 2 == 0: t_col = C_STEEL_BRIGHT
				voxels[Vector3i(px, y, 7)] = t_col
				# Crimson cloth backing
				voxels[Vector3i(px, y, 6)] = C_WARRIOR_RED

	# Side hip tassets
	for side in [-1, 1]:
		for y in range(-3, 3):
			for tz in range(-3, 4):
				voxels[Vector3i(side * 8, y, tz)] = C_STEEL_LIGHT if (tz + y) % 2 == 0 else C_IRON

	# Back tasset flap
	for y in range(-3, 3):
		for bx in range(-4, 5):
			voxels[Vector3i(bx, y, -7)] = C_STEEL_LIGHT if (bx + y) % 2 == 0 else C_IRON_DARK
			voxels[Vector3i(bx, y, -6)] = C_WARRIOR_RED

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_upper_arm_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Heavy Steel Plate Rerebrace wrapped around muscular arm (y: -9..0)
	for y in range(-9, 1):
		var rx = 4 if y >= -5 else 3
		var rz = 4 if y >= -5 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_IRON
				# Full plate covering upper & outer arm
				if y in [-6, -5, -4, -3, -2, -1, 0]:
					if (abs(x) == rx or abs(z) == rz):
						if y in [0, -6]:
							col = C_GOLD # Gold trim rings
						elif (x + y + z) % 3 == 0:
							col = C_STEEL_BRIGHT
						else:
							col = C_STEEL_LIGHT
					else:
						col = C_IRON_DARK
				# Chainmail weave near elbow joint
				elif y <= -7:
					if (abs(x) == rx or abs(z) == rz):
						col = C_CHAINMAIL if (x + y + z) % 2 == 0 else C_IRON_DARK
					else:
						col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Protruding Outer Bicep Armor Spike
	voxels[Vector3i(5, -4, 0)] = C_STEEL_LIGHT
	voxels[Vector3i(6, -4, 0)] = C_STEEL_BRIGHT
	voxels[Vector3i(5, -4, 1)] = C_STEEL_LIGHT
	voxels[Vector3i(5, -4, -1)] = C_STEEL_LIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Heavy Segmented Steel Vambrace with Elbow Spike (y: -6..0)
	for y in range(-6, 1):
		var rx = 4 if y >= -3 else 3
		var rz = 4 if y >= -3 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue
				var col = C_IRON
				if abs(x) == rx or abs(z) == rz:
					if y in [0, -6]:
						col = C_GOLD # Gilded cuff rings
					elif (x + y + z) % 2 == 0:
						col = C_STEEL_BRIGHT
					else:
						col = C_STEEL_LIGHT
				else:
					col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# Rear Flared Elbow Spikes (-Z)
	voxels[Vector3i(0, -1, -5)] = C_STEEL_LIGHT
	voxels[Vector3i(0, -1, -6)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, -2, -5)] = C_STEEL_BRIGHT

	# Outer Vambrace Shield Fin
	var out_side = 1 if is_right else -1
	for y in [-4, -3, -2]:
		voxels[Vector3i(out_side * 5, y, 0)] = C_STEEL_BRIGHT
		voxels[Vector3i(out_side * 5, y, 1)] = C_STEEL_LIGHT

	# 2. Hand Sculpting (y: -9..-7)
	if is_right:
		# RIGHT HAND: Heavy Articulated Steel Plate Gauntlet Fist wrapped around Mace Shaft
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					if abs(x) <= 1 and abs(z) <= 1: continue
					var col = C_STEEL_LIGHT
					# Reinforced knuckle bar at front (+Z)
					if z == 2:
						col = C_STEEL_BRIGHT if (x in [-2, 0, 2]) else C_GOLD
					elif abs(x) == 3:
						col = C_IRON_DARK
					voxels[Vector3i(x, y, z)] = col
		# Spiked Iron Knuckle Blades
		voxels[Vector3i(-2, -8, 3)] = C_SPIKE_STEEL
		voxels[Vector3i(0, -8, 3)] = C_SPIKE_STEEL
		voxels[Vector3i(2, -8, 3)] = C_SPIKE_STEEL
	else:
		# LEFT HAND: Menacing Articulated Steel Claw Gauntlet
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					var col = C_STEEL_LIGHT
					if y == -7: col = C_STEEL_BRIGHT if z >= 1 else C_IRON
					voxels[Vector3i(x, y, z)] = col
		# 4 razor-sharp articulated steel talon claws extending down to y = -10!
		for fx in [-2, -1, 1, 2]:
			var fz = 2 if abs(fx) == 1 else 1
			voxels[Vector3i(fx, -8, fz)] = C_STEEL_LIGHT
			voxels[Vector3i(fx, -9, fz)] = C_STEEL_BRIGHT
			voxels[Vector3i(fx, -10, fz + 1)] = C_SPIKE_STEEL # Curving sharp talon tip
		# Thumb talon
		voxels[Vector3i(3, -8, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(4, -9, 0)] = C_SPIKE_STEEL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_thigh_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Heavy Steel Cuisse Plate Armor (y: -9..0)
	for y in range(-9, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_IRON
				if (abs(x) == rx or abs(z) == rz):
					if z >= 2: # Front heavy steel plate
						col = C_STEEL_BRIGHT if (x + y) % 2 == 0 else C_STEEL_LIGHT
					elif abs(x) == rx:
						col = C_STEEL_LIGHT
					elif z <= -rz + 1: # Chainmail rear thigh
						col = C_CHAINMAIL if (x + y + z) % 2 == 0 else C_IRON_DARK
				else:
					col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# Spiked Knee-Cop (Poleyn) Guard at y: -9, z: 4..6
	voxels[Vector3i(0, -9, 5)] = C_STEEL_LIGHT
	voxels[Vector3i(0, -9, 6)] = C_STEEL_BRIGHT # Upward angled knee spike
	voxels[Vector3i(0, -8, 5)] = C_STEEL_BRIGHT
	voxels[Vector3i(-1, -9, 5)] = C_GOLD
	voxels[Vector3i(1, -9, 5)] = C_GOLD

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_shin_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Fluted Steel Greaves Wrapping Shin & Calf (y: -7..0)
	for y in range(-7, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue
				var col = C_IRON
				if abs(x) == rx or abs(z) == rz:
					if z == rz: # Front reinforced fluted ridge
						col = C_STEEL_BRIGHT if x == 0 else C_STEEL_LIGHT
					elif y in [0, -7]:
						col = C_GOLD # Gold trim rings
					else:
						col = C_STEEL_LIGHT if (x + y + z) % 2 == 0 else C_IRON_DARK
				else:
					col = C_IRON_DARK
				voxels[Vector3i(x, y, z)] = col

	# 2. Heavy Armored Steel Sabatons (War Boots) (y: -9..-6, z: -3..6)
	for y in range(-9, -6):
		for x in range(-3, 4):
			for z in range(-3, 6):
				if (abs(x) == 3 and abs(z) == 3) or (abs(x) == 3 and z >= 4): continue
				var col = C_STEEL_LIGHT
				if y == -9:
					col = C_IRON_DARK # Sole
				elif z >= 2:
					col = C_STEEL_BRIGHT if (x + z) % 2 == 0 else C_STEEL_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# 4 Heavy Steel Toe Cleaver Spikes on Boots
	voxels[Vector3i(-3, -9, 6)] = C_SPIKE_STEEL
	voxels[Vector3i(-1, -9, 6)] = C_SPIKE_STEEL
	voxels[Vector3i(1, -9, 6)] = C_SPIKE_STEEL
	voxels[Vector3i(3, -9, 6)] = C_SPIKE_STEEL
	# Raised front boot spike
	voxels[Vector3i(0, -8, 5)] = C_STEEL_BRIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_mace_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}

	# =========================================================================
	# DREADNOUGHT ANNIHILATOR WAR MACE (ĐẠI THIẾT CHÙY HỦY DIỆT)
	# Monolithic Master-Forged 8-Flanged Black Iron with Molten Runes & Spikes
	# =========================================================================

	# 1. Blackened Iron Shaft with Steel Bands & Cross-Hatched Grip (y: -22..20)
	for y in range(-22, 21):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_IRON_DARK
				# Cross-hatched leather grip around handhold (y: -7..5)
				if y >= -7 and y <= 5 and (abs(x) == 1 or abs(z) == 1):
					col = C_LEATHER_DARK if (x + y + z) % 2 == 0 else C_LEATHER
					if (y in [-7, -1, 5]): col = C_GOLD # Gold wire binding
				# Steel reinforcing collars along shaft
				elif y in [-14, -13, 12, 13, 19, 20]:
					col = C_STEEL_BRIGHT if (abs(x) == 1 or abs(z) == 1) else C_GOLD
				elif (x + y + z) % 3 == 0:
					col = C_STEEL_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# Flared Heavy Steel Crossguards above/below grip
	for y_guard in [-8, 6]:
		for gx in range(-3, 4):
			for gz in range(-3, 4):
				if abs(gx) == 3 and abs(gz) == 3: continue
				voxels[Vector3i(gx, y_guard, gz)] = C_STEEL_BRIGHT if (abs(gx) == 3 or abs(gz) == 3) else C_GOLD

	# 2. Spiked Skull Pommel & Hanging Steel Chain Links (y: -28..-22)
	for y in range(-25, -21):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_STEEL_LIGHT
	# Heavy bottom armor-piercing pommel spike
	for py in range(-28, -25):
		voxels[Vector3i(0, py, 0)] = C_STEEL_BRIGHT
	# Hanging steel chain links
	voxels[Vector3i(1, -26, 1)] = C_CHAINMAIL
	voxels[Vector3i(1, -27, 1)] = C_CHAINMAIL
	voxels[Vector3i(2, -28, 1)] = C_STEEL_BRIGHT
	voxels[Vector3i(2, -29, 1)] = C_STEEL_BRIGHT

	# 3. Monolithic 8-Flanged Black Iron War Head (y: 19..33)
	# Octagonal core base
	for y in range(19, 34):
		var core_r = 5 if (y in [19, 33]) else 6
		for x in range(-core_r, core_r + 1):
			for z in range(-core_r, core_r + 1):
				if abs(x) + abs(z) >= core_r + 4: continue
				var col = C_IRON_DARK
				# Molten glowing core crevices
				if abs(x) <= 2 and abs(z) <= 2 and y in [24, 25, 26, 27]:
					col = C_LAVA_HOT if (x + y + z) % 2 == 0 else C_LAVA_CORE
				elif (abs(x) == core_r or abs(z) == core_r):
					col = C_STEEL_LIGHT if (x + y + z) % 3 == 0 else C_IRON
				voxels[Vector3i(x, y, z)] = col

	# 4. Eight Heavy Radial Flanged Blades with Serrated Steel Edges
	# Primary Cardinal Flanges: +Z, -Z, +X, -X (extend to dist 11 voxels)
	for y in range(21, 32):
		var is_mid = (y in [25, 26, 27])
		var f_dist = 11 if is_mid else 9
		
		# +Z Front Flange
		for dz in range(6, f_dist + 1):
			var sc = C_STEEL_BRIGHT if dz == f_dist else C_STEEL_LIGHT
			voxels[Vector3i(0, y, dz)] = sc
			voxels[Vector3i(-1, y, dz)] = C_IRON
			voxels[Vector3i(1, y, dz)] = C_IRON
			
		# -Z Rear Flange
		for dz in range(6, f_dist + 1):
			var sc = C_STEEL_BRIGHT if dz == f_dist else C_STEEL_LIGHT
			voxels[Vector3i(0, y, -dz)] = sc
			voxels[Vector3i(-1, y, -dz)] = C_IRON
			voxels[Vector3i(1, y, -dz)] = C_IRON

		# +X Right Flange
		for dx in range(6, f_dist + 1):
			var sc = C_STEEL_BRIGHT if dx == f_dist else C_STEEL_LIGHT
			voxels[Vector3i(dx, y, 0)] = sc
			voxels[Vector3i(dx, y, -1)] = C_IRON
			voxels[Vector3i(dx, y, 1)] = C_IRON

		# -X Left Flange
		for dx in range(6, f_dist + 1):
			var sc = C_STEEL_BRIGHT if dx == f_dist else C_STEEL_LIGHT
			voxels[Vector3i(-dx, y, 0)] = sc
			voxels[Vector3i(-dx, y, -1)] = C_IRON
			voxels[Vector3i(-dx, y, 1)] = C_IRON

	# Diagonal Secondary Flanges (4 corners at 45 degrees)
	for y in range(22, 31):
		for d in range(5, 9):
			var sc = C_STEEL_BRIGHT if d == 8 else C_STEEL_LIGHT
			voxels[Vector3i( d, y,  d)] = sc
			voxels[Vector3i(-d, y,  d)] = sc
			voxels[Vector3i( d, y, -d)] = sc
			voxels[Vector3i(-d, y, -d)] = sc

	# Heavy Steel Ramming Spikes jutting from Cardinal Flanges
	for side in [-1, 1]:
		# Lateral Ram Spikes (+-X)
		for dx in range(12, 16):
			voxels[Vector3i(side * dx, 26, 0)] = C_SPIKE_STEEL if dx >= 14 else C_STEEL_BRIGHT
		# Fore/Aft Ram Spikes (+-Z)
		for dz in range(12, 16):
			voxels[Vector3i(0, 26, side * dz)] = C_SPIKE_STEEL if dz >= 14 else C_STEEL_BRIGHT

	# Front Face Embossed Demonic Ram Skull Relief (+Z)
	voxels[Vector3i(-2, 27, 8)] = C_FEATHER_RED # Glowing demonic red eye
	voxels[Vector3i(2, 27, 8)] = C_FEATHER_RED  # Glowing demonic red eye
	voxels[Vector3i(-1, 24, 8)] = C_GOLD        # Golden skull tusk
	voxels[Vector3i(1, 24, 8)] = C_GOLD

	# 5. Colossal Apex Armor-Piercing Halberd Spearhead (+Y: 34..46)
	for y in range(34, 47):
		var sp_r = int(lerpf(4.0, 0.0, float(y - 34) / 12.0))
		for x in range(-sp_r, sp_r + 1):
			for z in range(-sp_r, sp_r + 1):
				if abs(x) + abs(z) <= sp_r + 1:
					var sc = C_STEEL_BRIGHT if (abs(x) + abs(z) == sp_r + 1 or y >= 44) else C_STEEL_LIGHT
					if y in [34, 35] and abs(x) == sp_r: sc = C_GOLD # Gold collar base
					voxels[Vector3i(x, y, z)] = sc

	# Flanking Barbed Crescent Blades on Spearhead base (y: 35..39, x: +-3..+-6)
	for side in [-1, 1]:
		for by in range(35, 40):
			var bx = side * (4 + (by - 35))
			voxels[Vector3i(bx, by, 0)] = C_STEEL_BRIGHT
			voxels[Vector3i(bx, by - 1, 0)] = C_SPIKE_STEEL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)



static func build_ogre_head_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Muscular Neck (y: 0..3)
	for y in range(4):
		for x in range(-4, 5):
			for z in range(-4, 5):
				if abs(x) == 4 and abs(z) == 4: continue
				var col = C_SKIN
				if z >= 2:
					col = C_SKIN_PALE if y <= 2 else C_SKIN
				elif z <= -3:
					col = C_HAIR if (x in [-1, 0, 1] and y >= 2) else C_SKIN_DARK
				elif abs(x) == 4:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# 2. Brutal Jutting Ogre Jaw with Underbite & Oral Cavity (y: 4..8)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(-5, 9):
				# Sculpt jawline curve (not a box!)
				if (abs(x) >= 5 and z <= -4) or (abs(x) >= 5 and z >= 7): continue
				if abs(x) == 6 and (z <= -2 or z >= 5): continue
				if y == 4 and abs(x) >= 5 and abs(z) >= 5: continue
				if y == 8 and z >= 7 and abs(x) >= 5: continue

				var col = C_SKIN
				if y == 4:
					col = C_SKIN_DARK
				elif abs(x) <= 3 and z in [3, 4, 5, 6] and y in [5, 6, 7]:
					# Deep oral cavity
					col = C_MOUTH_DARK
					if y == 5 and abs(x) <= 1 and z in [4, 5]:
						col = C_RUST # Tongue
				elif z >= 6:
					col = C_SKIN_LIGHT if (y == 7 or y == 8) else C_SKIN
				elif abs(x) == 5:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Massive Boar Tusks & Jagged Teeth
	# Giant upward-curving lower tusks
	for side in [-1, 1]:
		voxels[Vector3i(side * 4, 6, 7)] = C_BONE
		voxels[Vector3i(side * 4, 7, 8)] = C_TEETH
		voxels[Vector3i(side * 4, 8, 8)] = C_TEETH
		voxels[Vector3i(side * 4, 9, 7)] = C_TEETH # Inward curving tip
		voxels[Vector3i(side * 4, 10, 6)] = C_TEETH
	# Secondary lower teeth
	voxels[Vector3i(-2, 6, 7)] = C_TEETH
	voxels[Vector3i(0, 6, 7)] = C_TEETH
	voxels[Vector3i(2, 6, 7)] = C_TEETH
	voxels[Vector3i(-1, 7, 7)] = C_TEETH
	voxels[Vector3i(1, 7, 7)] = C_TEETH
	# Upper fangs hanging down
	voxels[Vector3i(-3, 8, 6)] = C_TEETH
	voxels[Vector3i(3, 8, 6)] = C_TEETH
	voxels[Vector3i(-1, 8, 6)] = C_TEETH
	voxels[Vector3i(1, 8, 6)] = C_TEETH

	# 2B. Mid-Face, Cheeks, Temples & Cranial Base (y: 9..11)
	# Bridges jaw (y=8) seamlessly to cranium dome (y=12) - 100% solid, zero gaping holes!
	for y in range(9, 12):
		var rx = 6 if y == 9 else 5
		var rz = 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 2): # z: -5..6
				if abs(x) >= rx and abs(z) >= rz: continue
				if abs(x) == 6 and (z <= -3 or z >= 4): continue
				if y == 10 and abs(x) in [2, 3] and z >= 6: continue # Eye socket recess
				if y == 11 and z >= 6: continue # Brow ridge recess
				
				var col = C_SKIN
				if z <= -4:
					col = C_SKIN_DARK # Shaded back of skull
				elif abs(x) >= 5:
					col = C_SKIN_DARK # Temples / jaw hinge
				elif z >= 4 and abs(x) <= 4:
					col = C_SKIN_LIGHT if y in [9, 10] else C_SKIN # Prominent muscular cheekbones
				voxels[Vector3i(x, y, z)] = col

	# 3. Flattened Broken Ogre Nose & Bone Piercing (y: 8..11)
	for y in range(8, 12):
		for x in range(-2, 3):
			for z in range(6, 9):
				if z == 8 and abs(x) == 2 and y >= 10: continue
				var col = C_SKIN
				if y == 8 and abs(x) == 1 and z == 8:
					col = C_MOUTH_DARK # Flared nostrils
				elif z == 8 and y in [9, 10]:
					col = C_SKIN_LIGHT # Nose bridge
				voxels[Vector3i(x, y, z)] = col
	# Crude carved bone septum ring
	for x in range(-3, 4):
		voxels[Vector3i(x, 7, 8)] = C_BONE
	voxels[Vector3i(-3, 6, 8)] = C_BONE
	voxels[Vector3i(3, 6, 8)] = C_BONE

	# 4. Sculpted Brow Ridge & Piercing Eyes (y: 10..12)
	# Heavy overhanging brow
	for x in range(-5, 6):
		voxels[Vector3i(x, 11, 6)] = C_SKIN_DARK
		voxels[Vector3i(x, 12, 6)] = C_SKIN_DARK
		if abs(x) <= 3:
			voxels[Vector3i(x, 12, 7)] = C_SKIN_DARK
	# Glowing amber/yellow vicious eyes
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_FEATHER_RED # Piercing bloodshot pupil
		voxels[Vector3i(side * 3, 10, 7)] = C_EYE_PUPIL

	# Deep Jagged War Scar slashing across right eye and jaw
	var scar_pts = [
		Vector3i(-3, 13, 5),
		Vector3i(-3, 12, 6),
		Vector3i(-4, 11, 6),
		Vector3i(-4, 10, 6),
		Vector3i(-5, 9, 6),
		Vector3i(-5, 8, 7),
		Vector3i(-5, 7, 7)
	]
	for p in scar_pts:
		voxels[p] = C_RUST

	# 5. Big Rugged Ogre Ears with Crude Bone Ring
	for side in [-1, 1]:
		for y in range(8, 12):
			for z in range(0, 3):
				voxels[Vector3i(side * 7, y, z)] = C_SKIN_DARK
				if y in [9, 10] and z in [0, 1]:
					voxels[Vector3i(side * 8, y, z)] = C_EAR_INNER
					voxels[Vector3i(side * 9, y, z)] = C_SKIN
	# Bone earring on left ear
	voxels[Vector3i(-9, 7, 1)] = C_BONE
	voxels[Vector3i(-9, 8, 1)] = C_BONE
	voxels[Vector3i(-8, 7, 1)] = C_BONE

	# 6. Rounded Cranium Dome (y: 12..18)
	for y in range(12, 19):
		var rx = 5 if y <= 14 else (4 if y <= 16 else 3)
		var rz = 5 if y <= 14 else (4 if y <= 16 else 3)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) >= rx - 1 and abs(z) >= rz - 1 and (abs(x) == rx or abs(z) == rz): continue
				var col = C_SKIN
				if y >= 17: col = C_SKIN_LIGHT
				elif z <= -rz + 1: col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# 7. Tribal Headband with Bone Trophy (y: 13..14)
	for y in [13, 14]:
		for x in range(-5, 6):
			for z in range(-5, 6):
				var on_edge = (abs(x) == 5 or abs(z) == 5)
				if on_edge:
					voxels[Vector3i(x, y, z)] = C_LEATHER_DARK
	# Central beast skull forehead plate
	for x in range(-2, 3):
		for y in range(13, 16):
			voxels[Vector3i(x, y, 6)] = C_BONE
			voxels[Vector3i(x, y, 5)] = C_BONE # Solid backing against cranium dome
	voxels[Vector3i(-1, 14, 6)] = C_HAIR # Eye socket 1
	voxels[Vector3i(1, 14, 6)] = C_HAIR  # Eye socket 2
	voxels[Vector3i(0, 15, 6)] = C_BONE
	voxels[Vector3i(-2, 16, 6)] = C_TEETH # Skull horn tip L
	voxels[Vector3i(2, 16, 6)] = C_TEETH  # Skull horn tip R
	voxels[Vector3i(-2, 16, 5)] = C_BONE  # Solid horn L backing
	voxels[Vector3i(2, 16, 5)] = C_BONE   # Solid horn R backing

	# 8. Wild Warrior Mohawk & Tied Topknot Plume (y: 15..23)
	# Mohawk ridge
	for z in range(-4, 5):
		for x in range(-1, 2):
			voxels[Vector3i(x, 18, z)] = C_HAIR
			if z in [-2, -1, 0, 1]:
				voxels[Vector3i(x, 19, z)] = C_HAIR
	# Bound Topknot
	for y in range(19, 24):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_HAIR
				if y == 20 and (abs(x) == 1 or abs(z) == 1):
					col = C_ROPE # Sinew tie cord
				voxels[Vector3i(x, y, z)] = col
	voxels[Vector3i(0, 24, 0)] = C_HAIR
	voxels[Vector3i(0, 24, -1)] = C_HAIR

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_torso_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Muscular Barrel Body Volume with Hunched Posture (y: 0..17)
	for y in range(18):
		var rx = 6 if y <= 3 else (8 if y <= 13 else 7)
		var rz = 5 if y <= 3 else (6 if y <= 13 else 5)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				# Round corners naturally
				if abs(x) == rx and abs(z) == rz: continue
				if abs(x) >= rx - 1 and abs(z) >= rz and y in [0, 1, 16, 17]: continue

				# Base muscular flesh with anatomical shading
				var col = C_SKIN
				# Hunched trapezius on back (y: 12..16, z <= -4)
				if y >= 12 and z <= -rz + 1:
					col = C_SKIN_DARK
				# Pectoral cleft and muscle highlights (y: 9..13)
				elif y in [9, 10, 11, 12, 13] and z >= rz - 1:
					if x == 0:
						col = C_SKIN_DARK # Sternum cleft
					elif abs(x) in [2, 3, 4] and y in [10, 11]:
						col = C_SKIN_LIGHT # Pec peak
					else:
						col = C_SKIN
				# Thick muscular abdominal belly (y: 4..8, z >= rz - 1)
				elif y in [4, 5, 6, 7, 8] and z >= rz - 1:
					if abs(x) <= 2:
						col = C_SKIN_PALE if y in [5, 6] else C_SKIN
					elif abs(x) == 3:
						col = C_SKIN_DARK # Ab furrow
				elif abs(x) == rx or abs(z) == rz:
					col = C_SKIN_DARK

				voxels[Vector3i(x, y, z)] = col

	# 2. Heavy Beast Fur Pelt (Vắt Vai Da Thú Xù Lông)
	# Draped over Left Shoulder (x: -9..-3, y: 11..17) and cascading diagonally across chest to right waist
	for y in range(11, 18):
		for x in range(-9, -2):
			for z in range(-6, 7):
				if abs(x) == 9 and abs(z) == 6: continue
				var is_fur_edge = (x == -9 or abs(z) == 6 or y == 17)
				var f_col = C_PELT_BASE
				if (x + y + z) % 3 == 0: f_col = C_PELT_LIGHT
				elif (x + y + z) % 4 == 0: f_col = C_PELT_DARK
				voxels[Vector3i(x, y, z)] = f_col

	# Diagonal Fur Sash across chest (y: 7..12, x: -5..2, z: 5..7)
	for y in range(7, 13):
		var center_x = int(lerpf(1.0, -4.0, float(y - 7) / 5.0))
		for dx in range(-2, 3):
			var x = center_x + dx
			var z = 6 if y <= 9 else 7
			var f_col = C_PELT_BASE if (x + y) % 2 == 0 else C_PELT_LIGHT
			voxels[Vector3i(x, y, z)] = f_col
			if (x + y) % 3 == 0:
				voxels[Vector3i(x, y, z + 1)] = C_PELT_LIGHT # 3D fur tuft spike

	# Pelt Draped Down Upper Back (y: 6..16, x: -8..0, z: -6..-7)
	for y in range(6, 17):
		for x in range(-8, 1):
			var f_col = C_PELT_DARK if (x + y) % 2 == 0 else C_PELT_BASE
			voxels[Vector3i(x, y, -6)] = f_col
			if (x + y) % 3 == 0 and x <= -2:
				voxels[Vector3i(x, y, -7)] = C_PELT_LIGHT

	# 3. Crude Leather & Sinew Harness (Dây Đai Da Thô Đan Chéo)
	# Opposite cross-strap from right shoulder (x: 5..7, y: 15) to left waist (x: -3..-1, y: 4)
	for y in range(4, 16):
		var st_x = int(lerpf(-2.0, 6.0, float(y - 4) / 11.0))
		for z in [6, 7]:
			if voxels.has(Vector3i(st_x, y, z - 1)) and not voxels.has(Vector3i(st_x, y, z)):
				var is_stitch = (y % 2 == 0)
				voxels[Vector3i(st_x, y, z)] = C_SINEW if is_stitch else C_LEATHER_DARK
	# Central carved bone buckle at chest intersection
	voxels[Vector3i(0, 9, 7)] = C_BONE
	voxels[Vector3i(0, 10, 7)] = C_BONE
	voxels[Vector3i(1, 9, 7)] = C_BONE
	voxels[Vector3i(1, 10, 7)] = C_BONE
	voxels[Vector3i(0, 9, 8)] = C_BONE

	# 4. Trophy Necklace of Beast Fangs & Bones (Vòng Cổ Nanh Vuốt)
	for x in range(-4, 5):
		voxels[Vector3i(x, 15, 6)] = C_SINEW
	# Hanging predator fangs
	voxels[Vector3i(-3, 14, 7)] = C_TEETH
	voxels[Vector3i(-3, 13, 7)] = C_TEETH
	voxels[Vector3i(-1, 14, 7)] = C_TEETH
	voxels[Vector3i(-1, 13, 7)] = C_TEETH
	voxels[Vector3i(2, 14, 7)] = C_TEETH
	voxels[Vector3i(2, 13, 7)] = C_TEETH
	voxels[Vector3i(4, 14, 7)] = C_TEETH

	# 5. Heavy Rawhide & Leather War Belt (Thắt Lưng Da Thô To Bản) (y: 2..4)
	for y in [2, 3, 4]:
		for x in range(-7, 8):
			for z in range(-6, 7):
				if (abs(x) == 7 or abs(z) == 6) and (abs(x) >= 2 or abs(z) >= 2):
					var col = C_LEATHER
					if y in [2, 4]:
						col = C_LEATHER_DARK
					elif (x + z) % 4 == 0:
						col = C_BUCKLE # Warm bronze stud
					voxels[Vector3i(x, y, z)] = col
	# Big carved stone/bone belt clasp
	for x in range(-1, 2):
		for y in range(2, 5):
			voxels[Vector3i(x, y, 7)] = C_STONE_LIGHT if y == 3 else C_STONE_DARK

	# Tattered Loincloth front apron (y: -3..3, x: -3..3, z: 6..7)
	for y in range(-3, 4):
		var w = 3 if y >= 0 else (2 if y >= -2 else 1)
		for x in range(-w, w + 1):
			var l_col = C_PELT_BASE if (x + y) % 2 == 0 else C_PELT_DARK
			if y in [-3, -2] and abs(x) == w:
				l_col = C_PELT_LIGHT # Frayed fringe tips
			voxels[Vector3i(x, y, 6)] = l_col
			if y <= 1 and abs(x) <= 1:
				voxels[Vector3i(x, y, 7)] = C_PELT_BASE
	# Back apron (y: -2..3, x: -3..3, z: -6)
	for y in range(-2, 4):
		for x in range(-2, 3):
			voxels[Vector3i(x, y, -6)] = C_PELT_DARK

	# 6. Fierce Crimson War Paint on Bare Right Shoulder
	voxels[Vector3i(6, 14, 4)] = C_WARPAINT_RED
	voxels[Vector3i(7, 13, 4)] = C_WARPAINT_RED
	voxels[Vector3i(6, 12, 5)] = C_WARPAINT_RED
	voxels[Vector3i(5, 11, 6)] = C_WARPAINT_RED

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_upper_arm_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Massive muscular Ogre arm (y: -9..0)
	for y in range(-9, 1):
		var rx = 4 if y >= -4 else 3
		var rz = 4 if y >= -4 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				# Bulging bicep in front (+Z)
				if z == rz and y in [-5, -4, -3]:
					col = C_SKIN_LIGHT
				# Tricep crevice in back (-Z)
				elif z == -rz and y in [-5, -4, -3]:
					col = C_SKIN_DARK
				# Fur pelt cap on upper shoulder (y: -2..0)
				elif y in [-2, -1, 0] and (abs(x) == rx or abs(z) == rz):
					col = C_PELT_LIGHT if (x + y + z) % 3 == 0 else C_PELT_BASE
				# Leather bicep wrap at y: -4
				elif y == -4 and (abs(x) == rx or abs(z) == rz):
					col = C_BONE if (x == 0 and z == rz) else C_LEATHER_DARK
				elif y <= -8:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_forearm_mesh_outfit1(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Forearm Muscle with Leather Bracers (y: -6..0)
	for y in range(-6, 1):
		var rx = 3
		var rz = 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue
				var col = C_SKIN
				# Solid leather bracer with dark trim
				if y in [-5, -4, -3, -2] and (abs(x) == rx or abs(z) == rz):
					col = C_LEATHER
					if y in [-2, -5]:
						col = C_LEATHER_DARK
					elif y == -3 and abs(z) == rz:
						col = C_SINEW # Single subtle tie cord
				elif y <= -5:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Spiked bone forearm guard on outer side
	var out_side = 1 if is_right else -1
	voxels[Vector3i(out_side * 4, -4, 0)] = C_BONE
	voxels[Vector3i(out_side * 4, -3, 0)] = C_BONE
	voxels[Vector3i(out_side * 4, -3, 1)] = C_TEETH

	# 2. Hand Sculpting (y: -9..-7)
	if is_right:
		# RIGHT HAND: Powerful clenched fist wrapped around mace shaft (shaft is at x:0, z:0)
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					# Leave room for shaft through the center
					if abs(x) <= 1 and abs(z) <= 1: continue
					var col = C_SKIN
					# Knuckle ridge at front (+Z)
					if z == 2 and y in [-8, -7]:
						col = C_SKIN_LIGHT
					# Gripping thumb
					elif x == -3 and y in [-8, -7]:
						col = C_SKIN_DARK
					voxels[Vector3i(x, y, z)] = col
		# Dirty sharp blunt claws on gripping fingers
		voxels[Vector3i(-2, -9, 2)] = C_CLAWS
		voxels[Vector3i(-1, -9, 2)] = C_CLAWS
		voxels[Vector3i(1, -9, 2)] = C_CLAWS
		voxels[Vector3i(2, -9, 2)] = C_CLAWS
	else:
		# LEFT HAND: Menacing wide open hand with sharp extended beast claws
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					var col = C_SKIN
					if y == -7:
						col = C_SKIN_LIGHT if z >= 1 else C_SKIN
					voxels[Vector3i(x, y, z)] = col
		# 4 splayed clawed fingers extending down to y = -9
		voxels[Vector3i(-2, -8, 1)] = C_SKIN
		voxels[Vector3i(-2, -9, 1)] = C_CLAWS
		voxels[Vector3i(-1, -8, 2)] = C_SKIN
		voxels[Vector3i(-1, -9, 2)] = C_CLAWS
		voxels[Vector3i(1, -8, 2)] = C_SKIN
		voxels[Vector3i(1, -9, 2)] = C_CLAWS
		voxels[Vector3i(2, -8, 1)] = C_SKIN
		voxels[Vector3i(2, -9, 1)] = C_CLAWS
		# Splayed thumb
		voxels[Vector3i(3, -8, 0)] = C_SKIN
		voxels[Vector3i(3, -8, -1)] = C_CLAWS

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_thigh_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Heavy muscular pillar leg (y: -9..0)
	for y in range(-9, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				# Upper thigh fur wrap & bindings (y: -4..0)
				if y in [-4, -3, -2, -1, 0] and (abs(x) == rx or abs(z) == rz):
					col = C_PELT_BASE
					if y in [0, -4]:
						col = C_PELT_DARK
					elif y == -2:
						col = C_LEATHER_DARK
				# Quadricep front bulge
				elif z >= 3 and y in [-7, -6, -5]:
					col = C_SKIN_LIGHT
				# Kneecap ridge at y: -9
				elif y == -9 and z >= 2 and abs(x) <= 1:
					col = C_SKIN_LIGHT
				elif abs(x) == rx or abs(z) == rz:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_shin_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Thick Muscular Calf & Rawhide Wraps (y: -7..0)
	for y in range(-7, 1):
		var rx = 3
		var rz = 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue
				var col = C_SKIN
				# Calf muscle bulge in back (-Z)
				if z == -rz and y in [-4, -3, -2]:
					col = C_SKIN_LIGHT
				# Weathered rawhide calf bindings (y: -6..-3)
				elif y in [-6, -5, -4, -3] and (abs(x) == rx or abs(z) == rz):
					col = C_LEATHER
					if y in [-3, -6]:
						col = C_LEATHER_DARK
					elif y == -4 and abs(z) == rz:
						col = C_PELT_DARK
				elif abs(x) == rx or abs(z) == rz:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# 2. Massive Broad Ogre Foot with Thick Claws (y: -9..-7, z: -3..5)
	for y in range(-9, -6):
		for x in range(-3, 4):
			for z in range(-3, 5):
				if (abs(x) == 3 and abs(z) == 3) or (abs(x) == 3 and z == 4): continue
				var col = C_SKIN
				if y == -9: col = C_SKIN_DARK
				elif z >= 2: col = C_SKIN_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# 4 Heavy blunt claws on toes
	voxels[Vector3i(-3, -9, 5)] = C_CLAWS
	voxels[Vector3i(-1, -9, 5)] = C_CLAWS
	voxels[Vector3i(1, -9, 5)] = C_CLAWS
	voxels[Vector3i(3, -9, 5)] = C_CLAWS

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_ogre_mace_mesh_outfit1() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Gnarled Hardwood Timber Shaft with Bark (y: -18..18)
	for y in range(-18, 19):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_WOOD_DARK
				# Bark variations & knots
				if (x + y + z) % 3 == 0:
					col = C_WOOD
				# Leather wrapped grip around hand position (y: -6..4)
				if y >= -6 and y <= 4 and (abs(x) == 1 or abs(z) == 1):
					var is_seam = ((y + x) % 3 == 0)
					col = C_LEATHER_DARK if is_seam else C_LEATHER
				# Heavy sinew lashings below mace head (y: 13..16)
				elif y >= 13 and y <= 16 and (abs(x) == 1 or abs(z) == 1):
					col = C_ROPE if y in [13, 16] else C_SINEW
				voxels[Vector3i(x, y, z)] = col

	# 2. Pommel Knot with Hanging Beast Talisman (y: -22..-18)
	for y in range(-18, -15):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_WOOD_DARK
	# Hanging rope cord & carved beast skull charm
	voxels[Vector3i(0, -19, 1)] = C_ROPE
	voxels[Vector3i(0, -20, 1)] = C_ROPE
	for dx in range(-1, 2):
		for dy in range(-23, -20):
			voxels[Vector3i(dx, dy, 2)] = C_BONE
	voxels[Vector3i(0, -22, 2)] = C_HAIR # Skull eye cavity
	voxels[Vector3i(0, -24, 2)] = C_TEETH # Skull tooth

	# 3. Colossal Chipped Basalt Stone Head (y: 17..27)
	# Faceted, irregular polygonal boulder - organic chipped stone (not a box!)
	for y in range(17, 28):
		var rad = 6
		if y in [17, 27]: rad = 5
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				# Chiseled corner bevels
				if abs(x) + abs(z) >= 9: continue
				if abs(x) == rad and abs(z) >= 3: continue
				if abs(z) == rad and abs(x) >= 3: continue

				# Realistic stone shading
				var col = C_STONE
				var is_surface = (abs(x) == rad or abs(z) == rad or y in [17, 27] or abs(x) + abs(z) == 8)
				if is_surface:
					if (x + y + z) % 4 == 0:
						col = C_STONE_LIGHT # Chipped impact ridge
					elif (x + y + z) % 3 == 0:
						col = C_STONE_DARK # Deep crevice / fracture
				else:
					col = C_STONE_DARK

				# Cross-lashed sinew & heavy ropes binding stone to shaft
				if is_surface:
					# Horizontal binding grooves
					if y in [19, 25]:
						col = C_ROPE
					# Diagonal criss-cross cords
					elif abs(x) == abs(y - 22) or abs(z) == abs(y - 22):
						col = C_SINEW
				voxels[Vector3i(x, y, z)] = col

	# 4. Brutal Jagged Stone Spikes & Mammoth Tusks
	# Front Heavy Ram Spikes (+Z)
	for dz in range(6, 12):
		voxels[Vector3i(0, 22, dz)] = C_STONE_LIGHT if dz >= 10 else C_STONE
		voxels[Vector3i(0, 23, dz)] = C_STONE_LIGHT if dz >= 10 else C_STONE
	# Flanking curved bone horns
	for dz in range(6, 9):
		voxels[Vector3i(-4, 22, dz)] = C_BONE
		voxels[Vector3i(4, 22, dz)] = C_BONE
	voxels[Vector3i(-4, 23, 9)] = C_TEETH
	voxels[Vector3i(4, 23, 9)] = C_TEETH

	# Back Ram Stone Spike (-Z)
	for dz in range(-11, -5):
		voxels[Vector3i(0, 22, dz)] = C_STONE_LIGHT if dz <= -10 else C_STONE
		voxels[Vector3i(0, 23, dz)] = C_STONE_LIGHT if dz <= -10 else C_STONE

	# Left Jagged Stone Spikes (-X)
	for dx in range(-11, -5):
		voxels[Vector3i(dx, 22, 0)] = C_STONE_LIGHT if dx <= -10 else C_STONE
		voxels[Vector3i(dx, 23, 0)] = C_STONE_LIGHT if dx <= -10 else C_STONE
	voxels[Vector3i(-8, 20, 2)] = C_STONE_LIGHT
	voxels[Vector3i(-8, 24, -2)] = C_STONE_LIGHT

	# Right Jagged Stone Spikes (+X)
	for dx in range(6, 12):
		voxels[Vector3i(dx, 22, 0)] = C_STONE_LIGHT if dx >= 10 else C_STONE
		voxels[Vector3i(dx, 23, 0)] = C_STONE_LIGHT if dx >= 10 else C_STONE
	voxels[Vector3i(8, 20, -2)] = C_STONE_LIGHT
	voxels[Vector3i(8, 24, 2)] = C_STONE_LIGHT

	# Apex Armor-Piercing Crown Spike (+Y: 28..34)
	for dy in range(28, 35):
		var sp_col = C_STONE_LIGHT if dy >= 32 else (C_STONE if dy >= 30 else C_STONE_DARK)
		voxels[Vector3i(0, dy, 0)] = sp_col
		if dy <= 30:
			voxels[Vector3i(1, dy, 0)] = sp_col
			voxels[Vector3i(-1, dy, 0)] = sp_col
			voxels[Vector3i(0, dy, 1)] = sp_col
			voxels[Vector3i(0, dy, -1)] = sp_col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# Compatibility Aliases
static func build_boss_head_mesh() -> ArrayMesh:
	return build_ogre_head_mesh()

static func build_boss_torso_mesh() -> ArrayMesh:
	return build_ogre_torso_mesh()

static func build_boss_warhammer_mesh() -> ArrayMesh:
	return build_ogre_mace_mesh()