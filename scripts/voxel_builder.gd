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
const C_BONE_WEATHERED: int = 0xc8c3b0 # Weathered aged bone
const C_BONE_SHADOW: int = 0x8a8474    # Deep rib shadow
const C_RUST_ORANGE: int = 0xb44414    # Flaked oxidised rust
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
const C_GOLD_BRIGHT: int = 0xfbbf24

# Heavy Warrior Regalia (Bộ đồ 2 Chiến Binh Thép)
const C_STEEL_BRIGHT: int = 0xcfd8dc
const C_WARRIOR_RED: int = 0x7f1d1d
const C_WARRIOR_RED_DARK: int = 0x450a0a
const C_CHAINMAIL: int = 0x475569
const C_BRONZE: int = 0xb45309
const C_SPIKE_STEEL: int = 0x94a3b8
const C_LAVA_HOT: int = 0xea580c
const C_LAVA_CORE: int = 0xfbbf24

# Imperial Sovereign Gold Regalia (Bộ đồ 3: Chiến Tướng Hoàng Kim)
const C_IMP_GOLD_GLEAM: int = 0xfff3a1   # Radiant mirror highlight / beveled edges
const C_IMP_GOLD_LIGHT: int = 0xfacc15   # High polished imperial gold
const C_IMP_GOLD: int = 0xeab308         # Pure royal imperial gold
const C_IMP_GOLD_DARK: int = 0xb45309    # Chased / engraved shadow gold
const C_IMP_GOLD_DEEP: int = 0x78350f    # Deep filigree crevice gold
const C_IMP_VELVET: int = 0x881337       # Imperial royal crimson velvet
const C_IMP_VELVET_DARK: int = 0x4c0519  # Deep shadowed velvet burgundy
const C_IMP_EBONY: int = 0x18181b        # Imperial polished black lacquer / obsidian trim
const C_IMP_EBONY_LIGHT: int = 0x27272a  # Charcoal ebony inlay bevel
const C_RUBY_GLEAM: int = 0xff7b9b       # Specular ruby glint
const C_RUBY: int = 0xf43f5e             # Radiant faceted imperial ruby
const C_RUBY_DARK: int = 0x9f1239        # Deep heart ruby
const C_WHITE_SILK: int = 0xf8fafc       # Regal white plume silk
const C_WHITE_SILK_SHADOW: int = 0xd5dce6# Plume shadow

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

# Archer & Shaman Additional Palette Constants
const C_GOLD_RICH: int = 0xf59e0b
const C_GOLD_DEEP: int = 0xd97706
const C_ROYAL_CRIMSON: int = 0x991b1b
const C_ROYAL_CRIMSON_DARK: int = 0x581010
const C_GEM_RUBY: int = 0xef4444
const C_FEATHER_GOLD: int = 0xfef08a
const C_GEM_SAPPHIRE: int = 0x0284c7


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

# Goblin Rogue Outfit 2: Imperial Grand Infiltrator Palette
const C_GEM_CYAN_GLOW: int = 0x22d3ee

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
	if outfit == 3:
		return build_head_mesh_outfit3()
	elif outfit == 2:
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

# --- WEAPON OUTFIT 3: SUNBURST DIVINE WAR MACE / HOÀNG KIM THẦN CHÙY ---
static func build_club_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Faceted Imperial Crown Pommel & Ruby Teardrop Pendant (y: -10 to -5)
	# Ruby Teardrop Pendant
	voxels[Vector3i(0, -10, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(0, -9, 0)] = C_RUBY
	for ox in [-1, 1]:
		voxels[Vector3i(ox, -9, 0)] = C_RUBY_DARK
		voxels[Vector3i(0, -9, ox)] = C_RUBY_DARK
		
	# Crown Pommel Base (y: -8 to -5)
	for y in range(-8, -4):
		var rad = 2 if y in [-7, -6] else 1
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad and rad > 1: continue
				var col = C_IMP_GOLD
				if y == -8:
					col = C_IMP_GOLD_GLEAM if abs(x) + abs(z) <= 1 else C_IMP_EBONY
				elif y in [-7, -6]:
					col = C_IMP_GOLD_LIGHT if (abs(x) == rad or abs(z) == rad) else C_IMP_GOLD
					if y == -7 and (abs(x) == rad or abs(z) == rad) and (x == 0 or z == 0):
						col = C_RUBY # Pommel rim ruby gems
				elif y == -5:
					col = C_IMP_EBONY
				voxels[Vector3i(x, y, z)] = col

	# 2. Grip Shaft: Royal Crimson Velvet Wrap & Braided Gold Bullion Filigree (y: -4 to 7)
	for y in range(-4, 8):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				var is_gold_wire = ((x + y * 2 + z) % 3 == 0)
				var col = C_IMP_GOLD_GLEAM if is_gold_wire else (C_IMP_VELVET if y % 2 == 0 else C_IMP_VELVET_DARK)
				voxels[Vector3i(x, y, z)] = col

	# 3. Imperial Sunburst Handguard Disc with 4 Cardinal Rubies (y: 8 to 9)
	for y in range(8, 10):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				if abs(x) + abs(z) > 4: continue
				var is_outer = (abs(x) == 3 or abs(z) == 3 or abs(x) + abs(z) == 4)
				var col = C_IMP_GOLD
				if is_outer:
					col = C_IMP_GOLD_LIGHT
					# 4 Cardinal Inset Rubies
					if (abs(x) == 3 and z == 0) or (abs(z) == 3 and x == 0):
						col = C_RUBY_GLEAM if y == 9 else C_RUBY
				elif y == 9:
					col = C_IMP_GOLD_GLEAM if (x == 0 or z == 0) else C_IMP_GOLD
				elif y == 8:
					col = C_IMP_EBONY
				voxels[Vector3i(x, y, z)] = col

	# 4. Upper Mace Haft: Quad-Fluted Golden Pillars with Obsidian Flutes (y: 10 to 14)
	for y in range(10, 15):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1:
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_LIGHT # Corner pillar
				else:
					var col = C_IMP_EBONY if (x == 0 and z == 0) else C_IMP_GOLD
					if y == 14: col = C_IMP_GOLD_GLEAM # Capital ring
					voxels[Vector3i(x, y, z)] = col

	# 5. Mace Head Inner Core: Radiant Celestial Sun / Heart Ruby Orb (y: 15 to 28)
	for y in range(15, 29):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				var is_orb = (y >= 18 and y <= 24 and abs(x) <= 1 and abs(z) <= 1)
				if is_orb:
					var col = C_RUBY_GLEAM if (x == 0 and z == 0 and y in [20, 21, 22]) else C_RUBY
					voxels[Vector3i(x, y, z)] = col
				else:
					var col = C_IMP_GOLD_DARK if (y in [16, 20, 24, 28]) else C_IMP_EBONY
					voxels[Vector3i(x, y, z)] = col

	# 6. 8-Way Imperial Sunburst Flanges (y: 16 to 28)
	for y in range(16, 29):
		# Cardinal flange reach (width up to 6 voxels!)
		var f_width = 4 if (y in [16, 28]) else (5 if (y in [17, 26, 27]) else 6)
		
		# --- 4 Massive Cardinal Blades (North, South, East, West) ---
		# X-axis Flanges (Left & Right)
		for x_sign in [-1, 1]:
			for d in range(2, f_width + 1):
				var fx = x_sign * d
				for fz in [-1, 0, 1]:
					if abs(fz) == 1 and d > 4: continue
					var col = C_IMP_GOLD
					if d == f_width:
						col = C_IMP_GOLD_GLEAM # Razor mirror gold cutting edge
					elif d == f_width - 1:
						col = C_IMP_GOLD_LIGHT
					elif abs(fz) == 1:
						col = C_IMP_GOLD_LIGHT if (y + d) % 2 == 0 else C_IMP_GOLD
					elif fz == 0 and d in [3, 4]:
						col = C_IMP_EBONY # Obsidian central fuller channel!
					voxels[Vector3i(fx, y, fz)] = col

		# Z-axis Flanges (Front & Back)
		for z_sign in [-1, 1]:
			for d in range(2, f_width + 1):
				var fz = z_sign * d
				for fx in [-1, 0, 1]:
					if abs(fx) == 1 and d > 4: continue
					var col = C_IMP_GOLD
					if d == f_width:
						col = C_IMP_GOLD_GLEAM # Razor mirror gold cutting edge
					elif d == f_width - 1:
						col = C_IMP_GOLD_LIGHT
					elif abs(fx) == 1:
						col = C_IMP_GOLD_LIGHT if (y + d) % 2 == 0 else C_IMP_GOLD
					elif fx == 0 and d in [3, 4]:
						col = C_IMP_EBONY # Obsidian central fuller channel!
					voxels[Vector3i(fx, y, fz)] = col

		# --- 4 Diagonal Starburst Flanges (NE, NW, SE, SW at 45 degrees) ---
		var diag_reach = 3 if (y in [17, 18, 25, 26]) else (4 if (y in [19, 20, 21, 22, 23, 24]) else 2)
		for cx in [-1, 1]:
			for cz in [-1, 1]:
				for dd in range(2, diag_reach + 1):
					var col = C_IMP_GOLD_LIGHT
					if dd == diag_reach:
						col = C_IMP_GOLD_GLEAM
						if y in [21, 22]:
							col = C_RUBY_GLEAM # Starburst tip ruby glint!
					voxels[Vector3i(cx * dd, y, cz * dd)] = col

	# 7. Upper Imperial Crown Capital & Ruby Battlements (y: 28 to 30)
	for x in range(-3, 4):
		for z in range(-3, 4):
			if abs(x) == 3 and abs(z) == 3: continue
			if abs(x) == 3 or abs(z) == 3:
				var is_battlement = (x == 0 or z == 0)
				voxels[Vector3i(x, 28, z)] = C_IMP_GOLD_GLEAM
				if is_battlement:
					voxels[Vector3i(x, 29, z)] = C_RUBY
					voxels[Vector3i(x, 30, z)] = C_IMP_GOLD_GLEAM

	# 8. Colossal Piercing Apex Sun Spire (y: 29 to 35)
	for y in range(29, 32):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1 and y > 29: continue
				voxels[Vector3i(x, y, z)] = C_IMP_GOLD_LIGHT if (x == 0 or z == 0) else C_IMP_GOLD
				
	# Diamond-Profile Lance Shaft (y: 32 to 33)
	for y in range(32, 34):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) + abs(z) <= 1:
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_LIGHT if (x == 0 and z == 0) else C_IMP_GOLD_GLEAM
					
	# Razor Needle-Sharp Solar Tip (y: 34 to 35)
	voxels[Vector3i(0, 34, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 35, 0)] = C_IMP_GOLD_GLEAM

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

# --- HEAD OUTFIT 3: IMPERIAL DRAGON DIADEM & GOLDEN CRESTED HELMET ---
static func build_head_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Neck with Imperial Velvet Gorget, Gold Mail & Gold Throat Plate (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_IMP_VELVET_DARK if y == 0 else C_SKIN
				if y in [1, 2] and (abs(x) == 3 or abs(z) == 3):
					col = C_IMP_GOLD_DARK if (x + z) % 2 == 0 else C_IMP_GOLD
				elif y == 3 and z == 3 and abs(x) <= 1:
					col = C_IMP_GOLD_LIGHT # Throat plate front
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
				
	# Massive Lower Tusks with Carved Gold Rings & Polished Gold Capping
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 6, 6)] = C_IMP_GOLD_DARK
		voxels[Vector3i(side * 3, 7, 7)] = C_IMP_GOLD
		voxels[Vector3i(side * 3, 8, 8)] = C_TEETH
		voxels[Vector3i(side * 3, 9, 8)] = C_IMP_GOLD_GLEAM
		
	voxels[Vector3i(-2, 6, 5)] = C_TEETH
	voxels[Vector3i(0, 6, 5)] = C_TEETH
	voxels[Vector3i(2, 6, 5)] = C_TEETH
	
	# Upper Teeth
	voxels[Vector3i(-3, 7, 5)] = C_TEETH
	voxels[Vector3i(3, 7, 5)] = C_TEETH
	voxels[Vector3i(-1, 7, 5)] = C_TEETH
	voxels[Vector3i(1, 7, 5)] = C_TEETH
	
	# 3. Base Face, Golden Warpaint & Fiery Eyes (y: 8..11)
	for y in range(8, 11):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 and abs(z) == 5: continue
				var col = C_SKIN_DARK if z == -5 else C_SKIN
				if z == 5 and y in [8, 9] and abs(x) in [2, 4]:
					col = C_IMP_GOLD_LIGHT
				voxels[Vector3i(x, y, z)] = col
				
	# Glowing Golden-Amber Eyes with Radiant Ruby Core Pupils
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 2, 10, 7)] = C_RUBY
		voxels[Vector3i(side * 3, 10, 7)] = C_RUBY_GLEAM
		
	# Hooked Goblin Nose with Imperial Gold Septum Stud
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
		voxels[Vector3i(x, 8, 12)] = C_IMP_GOLD
	voxels[Vector3i(0, 10, 10)] = C_SKIN_PALE
	voxels[Vector3i(-2, 8, 8)] = C_SKIN_DARK
	voxels[Vector3i(2, 8, 8)] = C_SKIN_DARK
	
	# Long Goblin Ears with Triple Golden Hoops & Ruby Studs
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ez = 0 - int(float(s) * 0.4)
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 12; y_high = 12
			elif s == 7:
				y_low = 11; y_high = 13
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
				if s in [2, 4, 6] and ey == y_high:
					col = C_IMP_GOLD_GLEAM if s != 4 else C_RUBY
				voxels[Vector3i(ex, ey, ez)] = col
				if s <= 4:
					voxels[Vector3i(ex, ey, ez - 1)] = C_SKIN_DARK

	# 4. IMPERIAL DRAGON DIADEM & GOLDEN COMBAT HELMET
	# Forehead Crown Circlet with Faceted Rubies (y: 11..12)
	for y in range(11, 13):
		for x in range(-6, 7):
			for z in range(-6, 7):
				if abs(x) > 5 and abs(z) > 5: continue
				if abs(x) == 6 and z in [-1, 0, 1] and y == 11: continue
				var is_rim = (abs(x) >= 5 or abs(z) >= 5)
				if is_rim:
					var col = C_IMP_GOLD
					if y == 12: col = C_IMP_GOLD_LIGHT
					if (z >= 5 and abs(x) in [0, 3]) or (abs(z) <= 1 and abs(x) == 6) or (z <= -5 and abs(x) in [0, 3]):
						col = C_RUBY_GLEAM if y == 12 else C_RUBY
					elif y == 11:
						col = C_IMP_EBONY
					voxels[Vector3i(x, y, z)] = col

	# Imperial Crown Battlements (y: 13, 4 triangular crenellations)
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 13, 6)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 4, 13, 5)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 5, 13, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 2, 13, -6)] = C_IMP_GOLD_GLEAM

	# Golden Nasal Guard & Dragon Crest (y: 8..12, z: 7..8)
	for y in range(8, 13):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_IMP_GOLD_LIGHT if x == 0 else C_IMP_GOLD
		voxels[Vector3i(0, y, 8)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 11, 8)] = C_RUBY

	# Imperial Cheek Guards with Obsidian Inlay (x: +-5, y: 5..8, z: 0..4)
	for side in [-1, 1]:
		for y in range(5, 9):
			for z in range(0, 5):
				if z == 0 and y < 7: continue
				var col = C_IMP_GOLD
				if y == 5 or z == 4:
					col = C_IMP_GOLD_LIGHT
				elif z == 2 and y in [6, 7]:
					col = C_IMP_EBONY
				voxels[Vector3i(side * 5, y, z)] = col
				voxels[Vector3i(side * 5, y, z - 1)] = C_IMP_GOLD_DARK if z == 1 else C_IMP_GOLD

	# Golden Skull Dome with Obsidian Fluting (y: 13..17)
	for y in range(13, 18):
		var rx = 6 if y == 13 else (5 if y == 14 else (4 if y == 15 else (3 if y == 16 else 2)))
		var rz = 5 if y <= 14 else (4 if y == 15 else (3 if y == 16 else 2))
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y >= 15: continue
				var col = C_IMP_GOLD
				if abs(x) == rx or abs(z) == rz or y == 17:
					if abs(x) == 1 and y in [14, 15, 16]:
						col = C_IMP_EBONY
					elif y == 17 or abs(x) == 0:
						col = C_IMP_GOLD_LIGHT
					elif (x + y + z) % 3 == 0:
						col = C_IMP_GOLD_GLEAM
					elif z == -rz:
						col = C_IMP_GOLD_DARK
				voxels[Vector3i(x, y, z)] = col

	# Swept Imperial Golden Dragon Horns (x: +-5..9, y: 14..22, z: -1..-5)
	for side in [-1, 1]:
		voxels[Vector3i(side * 5, 14, 0)] = C_RUBY
		voxels[Vector3i(side * 6, 14, 0)] = C_IMP_GOLD_DARK
		voxels[Vector3i(side * 6, 15, 0)] = C_IMP_GOLD
		voxels[Vector3i(side * 7, 15, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 7, 16, -1)] = C_IMP_EBONY
		voxels[Vector3i(side * 8, 16, -1)] = C_IMP_GOLD
		voxels[Vector3i(side * 8, 17, -2)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 8, 18, -2)] = C_IMP_EBONY
		voxels[Vector3i(side * 9, 18, -3)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 9, 19, -3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 9, 20, -4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 9, 21, -4)] = C_IMP_GOLD_GLEAM

	# Imperial Golden Suncrest & Flowing Royal Crimson / White Plume (y: 17..24, z: -5..4)
	for z in range(-3, 4):
		voxels[Vector3i(0, 18, z)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(0, 19, z)] = C_IMP_GOLD_GLEAM if z >= 0 else C_IMP_GOLD
	for y in range(19, 25):
		var pz_center = int(float(21 - y) * 0.8)
		for pz in range(pz_center - 1, pz_center + 2):
			for px in [-1, 0, 1]:
				var col = C_IMP_VELVET if abs(px) == 1 else C_WHITE_SILK
				if y >= 23 and px == 0: col = C_WHITE_SILK_SHADOW
				voxels[Vector3i(px, y, pz)] = col
	voxels[Vector3i(0, 24, -3)] = C_WHITE_SILK
	voxels[Vector3i(0, 23, -4)] = C_IMP_VELVET

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 2. TORSO & ARMOR ---
static func build_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_torso_mesh_outfit3()
	elif outfit == 2:
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

# --- TORSO OUTFIT 3: IMPERIAL SOVEREIGN GOLDEN CUIRASS & DRAGON PAULDRONS ---
static func build_torso_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Neck opening & gold mail collar
				if y >= 16 and abs(x) <= 2 and abs(z) <= 2:
					voxels[Vector3i(x, y, z)] = C_SKIN
					continue
				if y == 15 and abs(x) <= 2 and abs(z) <= 2:
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_DARK
					continue

				# 1. Base Imperial Quilted Velvet Gambeson
				var col = C_IMP_VELVET if (x + y) % 2 == 0 else C_IMP_VELVET_DARK
				if y <= 2:
					col = C_IMP_GOLD_DARK if y == 0 else C_IMP_VELVET_DARK

				# 2. Front Imperial Gold Sunburst Cuirass (y: 5..15, z >= rz - 1)
				if z >= rz - 1 and y >= 5 and y <= 15:
					var is_rim = (y == 5 or y == 15 or abs(x) == 5 or (y >= 14 and abs(x) >= 4))
					col = C_IMP_GOLD
					
					# Central Radiant Heart Ruby & Sunburst Emblems
					if y in [10, 11] and abs(x) <= 1:
						col = C_RUBY_GLEAM if (x == 0 and y == 11) else C_RUBY
					elif abs(x) in [2, 3] and y in [9, 10, 11, 12]:
						# Radiating solar rays
						col = C_IMP_GOLD_GLEAM if (x + y) % 2 == 0 else C_IMP_EBONY
					elif is_rim:
						col = C_IMP_GOLD_LIGHT if y in [5, 15] else C_IMP_EBONY
					elif x == 0:
						col = C_IMP_GOLD_LIGHT # Center breastplate keel ridge
					else:
						col = C_IMP_GOLD if (y + x) % 2 == 0 else C_IMP_GOLD_LIGHT

					# Corner ruby studs on breastplate rim
					if is_rim and ((abs(x) in [2, 4] and y in [5, 15]) or (abs(x) == 5 and y in [8, 12])):
						col = C_RUBY

				# 3. Back Armor Plate & Dragon Spine (y: 5..14, z <= -rz + 1)
				if z <= -rz + 1 and y >= 5 and y <= 14:
					if abs(x) <= 4:
						col = C_IMP_GOLD if abs(x) < 4 else C_IMP_GOLD_DARK
						if abs(x) == abs(y - 9):
							col = C_IMP_EBONY # Obsidian chevron inlay
						elif abs(x) == 0:
							col = C_IMP_GOLD_LIGHT # Dorsal spine ridge

				# 4. Imperial Faulds & Ceremonial War Belt with Dragon Buckle (y: 3..4)
				if y in [3, 4] and (abs(x) == rx or abs(z) == rz):
					if z == rz and abs(x) <= 2:
						# Sunburst dragon buckle with center ruby
						col = C_RUBY if (x == 0 and y == 4) else C_IMP_GOLD_GLEAM
					elif (abs(x) == rx or abs(z) == rz) and (x + z) % 3 == 0:
						col = C_IMP_GOLD_LIGHT
					elif (abs(x) == rx or abs(z) == rz):
						col = C_IMP_EBONY
					else:
						col = C_IMP_GOLD_DARK

				# 5. Armored Imperial Tassets (y: 0..2)
				if y <= 2 and z == rz and abs(x) <= 2:
					# Center front hanging tasset with ruby droplet
					if y == 0 and abs(x) == 0:
						col = C_RUBY
					elif y == 1:
						col = C_IMP_GOLD_GLEAM if abs(x) == 0 else C_IMP_GOLD_LIGHT
					else:
						col = C_IMP_GOLD
				if y <= 2 and abs(x) >= rx - 1 and abs(z) <= 2:
					# Flank hip tassets
					col = C_IMP_GOLD_LIGHT if y == 0 else (C_RUBY if y == 1 and abs(z) == 0 else C_IMP_GOLD)

				# 6. Shoulders / Spaulders Base (y: 14..17, abs(x) >= 5)
				if abs(x) >= 5 and y >= 14:
					var is_rim = (y == 17 or abs(x) == rx or abs(z) == rz)
					col = C_IMP_GOLD_LIGHT if is_rim else C_IMP_GOLD
					if y == 16 and abs(z) == 1 and abs(x) == 6:
						col = C_RUBY

				voxels[Vector3i(x, y, z)] = col

	# 7. Magnificent 3-Tiered Imperial Dragon Pauldrons with Gold Crests & Rubies
	for side in [-1, 1]:
		# Tier 1 (Lower flared wing plate)
		for py in range(15, 18):
			for pz in range(-3, 4):
				var px = side * (7 if py < 17 else 6)
				var is_edge = (py == 17 or abs(pz) == 3)
				var col = C_IMP_GOLD_LIGHT if is_edge else C_IMP_GOLD
				if abs(pz) == 1 and py == 16: col = C_IMP_EBONY
				voxels[Vector3i(px, py, pz)] = col
		# Tier 2 (Mid swept wing plate)
		for pz in range(-2, 3):
			voxels[Vector3i(side * 7, 18, pz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(side * 8, 18, pz)] = C_IMP_GOLD_GLEAM if abs(pz) == 0 else C_IMP_GOLD
		# Tier 3 (Dragon spine spike & ruby crown cap)
		voxels[Vector3i(side * 7, 19, 0)] = C_RUBY
		voxels[Vector3i(side * 8, 19, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 8, 20, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 7, 19, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 7, 19, -1)] = C_IMP_GOLD_LIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 3. UPPER ARM ---
static func build_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_upper_arm_mesh_outfit3()
	elif outfit == 2:
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

# --- UPPER ARM OUTFIT 3: IMPERIAL GOLDEN REREBRACE & SUN EMBLEM ---
static func build_upper_arm_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Base sleeve: royal velvet crimson
				var col = C_IMP_VELVET if (x + y) % 2 == 0 else C_IMP_VELVET_DARK
				var is_outer_plate = (y >= -6 and y <= -1) and (abs(x) == rx or abs(z) == rz)
				if is_outer_plate:
					col = C_IMP_GOLD
					if y == -1 or y == -6 or abs(x) == rx:
						col = C_IMP_GOLD_LIGHT if y == -1 else C_IMP_EBONY
					if y == -3 and abs(x) == rx:
						col = C_RUBY
					elif y in [-3, -4] and abs(z) == rz:
						col = C_IMP_GOLD_LIGHT
						
				elif y <= -8:
					col = C_IMP_GOLD_DARK
				voxels[Vector3i(x, y, z)] = col
				
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 4. FOREARMS & GAUNTLETS ---
static func build_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_forearm_mesh_outfit3(is_right)
	elif outfit == 2:
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

# --- FOREARM OUTFIT 3: IMPERIAL GOLDEN VAMBRACE & RUBY-STUDDED GAUNTLET ---
static func build_forearm_mesh_outfit3(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}
	if not is_right:
		# Left Forearm: Flared Imperial Gold Vambrace & Claw-Tipped Gold Hand
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y in [-1, 0] and z == -2:
						col = C_IMP_GOLD_GLEAM # Pointed gold elbow couter
					elif y >= -6 and y <= -2:
						var is_outer = (abs(x) == 2 or abs(z) == 2)
						if is_outer:
							if z == 2:
								col = C_RUBY if y == -4 else C_IMP_GOLD_LIGHT
							elif y in [-2, -6]:
								col = C_IMP_EBONY
							else:
								col = C_IMP_GOLD
							if y == -4 and abs(x) == 2:
								col = C_IMP_GOLD_GLEAM
						else:
							col = C_IMP_VELVET_DARK
					elif y <= -7:
						if z == 2:
							col = C_IMP_GOLD_LIGHT if y == -7 else C_IMP_GOLD
						elif (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_IMP_GOLD_GLEAM if y == -9 else C_IMP_GOLD
						elif y == -7:
							col = C_IMP_EBONY
					voxels[Vector3i(x, y, z)] = col
	else:
		# Right Forearm: Full Articulated Golden War Gauntlet with Ruby Knuckles
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y in [-1, 0] and z == -2:
						col = C_IMP_GOLD_GLEAM # Pointed gold elbow couter
					elif y >= -6 and y <= -2:
						var is_outer = (abs(x) == 2 or abs(z) == 2)
						if is_outer:
							if z == -2:
								col = C_IMP_GOLD_LIGHT
							elif y in [-2, -6]:
								col = C_IMP_EBONY
							else:
								col = C_IMP_GOLD
							if y == -4 and abs(x) == 2:
								col = C_RUBY # Outer wrist ruby stud
						else:
							col = C_IMP_VELVET_DARK
					elif y <= -7:
						if z == 2:
							col = C_IMP_GOLD_LIGHT if y == -7 else (C_IMP_GOLD_GLEAM if y == -9 and abs(x) <= 1 else C_IMP_GOLD)
						elif x == 2:
							col = C_IMP_GOLD_DARK if y == -9 else C_IMP_GOLD
						elif x == -2:
							col = C_IMP_GOLD_LIGHT if (y == -8 and z == 1) else C_IMP_GOLD
						elif z == -2:
							col = C_IMP_GOLD_LIGHT if y == -7 else C_IMP_GOLD_DARK
						else:
							col = C_IMP_EBONY
					voxels[Vector3i(x, y, z)] = col
					
		# Articulated golden knuckle plates with ruby studs
		voxels[Vector3i(-2, -7, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(-1, -7, 2)] = C_RUBY
		voxels[Vector3i(-1, -8, 2)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, -9, 2)] = C_RUBY
		voxels[Vector3i(1, -9, 2)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(2, -6, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(-2, -6, 0)] = C_IMP_GOLD_LIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 5. LEGS & WAR BOOTS ---
static func build_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_thigh_mesh_outfit3()
	elif outfit == 2:
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

# --- THIGH OUTFIT 3: ROYAL VELVET BREECHES & GOLDEN POLEYN KNEE COPS ---
static func build_thigh_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Royal crimson velvet breeches with golden pinstripe
				var col = C_IMP_VELVET if (x + y) % 2 == 0 else C_IMP_VELVET_DARK
				if x == 0 and z == rz and y >= -5:
					col = C_IMP_GOLD_LIGHT
				if y >= -3 and (abs(x) == rx or abs(z) == rz):
					col = C_IMP_GOLD_DARK
					
				# Imperial Golden Poleyn (Knee guard at front) with Ruby Center
				if y in [-9, -8] and z == rz and abs(x) <= 2:
					if y == -8 and abs(x) == 0:
						col = C_RUBY
					elif abs(x) == 0 and y == -9:
						col = C_IMP_GOLD_GLEAM
					elif abs(x) == 2 or y == -9:
						col = C_IMP_EBONY
					else:
						col = C_IMP_GOLD_LIGHT
				elif y in [-9, -8] and z == rz - 1 and abs(x) <= 2:
					col = C_IMP_GOLD
				voxels[Vector3i(x, y, z)] = col
				
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

static func build_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shin_mesh_outfit3()
	elif outfit == 2:
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

# --- SHIN OUTFIT 3: IMPERIAL GOLDEN GREAVES & ORNATE SUN-SABATONS ---
static func build_shin_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Full Curved Imperial Golden Greaves (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_IMP_GOLD
				if z == 2:
					col = C_IMP_GOLD_GLEAM if y in [-4, -3] else C_IMP_GOLD_LIGHT
				elif z == -3:
					col = C_IMP_EBONY
				elif abs(x) == 2 and y in [-2, -5]:
					col = C_RUBY # Lateral ruby studs
				voxels[Vector3i(x, y, z)] = col
				
	# 2. Ankle Joint Guard & Roundel (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_IMP_GOLD_LIGHT if z == 2 else (C_IMP_EBONY if abs(x) == 2 else C_IMP_GOLD_DARK)
				voxels[Vector3i(x, y, z)] = col
				
	# 3. Flared Ankle Armor Plate (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_IMP_GOLD_LIGHT if abs(x) == 3 or z == 2 else C_IMP_GOLD
			voxels[Vector3i(x, -8, z)] = col
			
	# 4. IMPERIAL ARMORED WAR SABATONS (y: -10 to -7, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_IMP_GOLD
				if y == -10:
					col = C_IMP_EBONY # Sole tread
				elif z >= 0 and y == -8:
					col = C_RUBY if (x == 0 and z == 1) else C_IMP_GOLD_LIGHT # Instep ruby!
				elif z == -3:
					col = C_IMP_GOLD_GLEAM if y == -9 and x == 0 else C_IMP_GOLD_LIGHT # Gilded heel spur!
				voxels[Vector3i(x, y, z)] = col
				
	# 5. Articulated Golden Toe Plates & Forward Cleat Spikes (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_IMP_GOLD_LIGHT if (ty == -9 and tz == 4) else C_IMP_GOLD
				voxels[Vector3i(tx, ty, tz)] = col
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels[Vector3i(side_x, -10, tz)] = C_IMP_GOLD
						
		voxels[Vector3i(tx, -10, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(tx, -10, 7)] = C_IMP_GOLD_GLEAM # Front razor gold cleats
		voxels[Vector3i(tx, -9, 6)] = C_IMP_GOLD_GLEAM
		
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 6. WEAPONS: CLUB (OUTFIT 1), HEAVY FLANGED WAR MACE (OUTFIT 2) & SUNBURST DIVINE WAR MACE (OUTFIT 3) ---
static func build_club_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_club_mesh_outfit3()
	elif outfit == 2:
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
	elif outfit == 3:
		return build_archer_head_mesh_outfit3()
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

# --- HEAD OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (VƯƠNG MIỆN CÁNH ĐẠI BÀNG, KÍNH NGẮM SAPPHIRE, LÔNG VŨ PHƯỢNG HOÀNG) ---
static func build_archer_head_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Neck (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN

	# 2. Jaw & Mouth (y: 4..7)
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

	# Ornate Golden Chin Guard & Beard Jewel (y: 3..5, z: 6)
	voxels[Vector3i(0, 3, 6)] = C_GOLD_RICH
	voxels[Vector3i(0, 4, 6)] = C_GEM_RUBY
	voxels[Vector3i(-1, 4, 6)] = C_GOLD_BRIGHT
	voxels[Vector3i(1, 4, 6)] = C_GOLD_BRIGHT

	# 3. Cranium (y: 8..16)
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

	# 4. Big Hooked Goblin Nose
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

	# 5. Pointed Goblin Ears with Imperial Golden Cuffs & Finials
	for side in [-1, 1]:
		for s in range(9):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.4)
			var ez = -1 - int(float(s) * 0.75)
			var h_half = 2 if s < 3 else (1 if s < 6 else 0)
			for dy in range(-h_half, h_half + 1):
				var e_col = C_SKIN
				if (s in [2, 3]) and (dy == h_half or dy == -h_half):
					e_col = C_GOLD_RICH
				elif s >= 7:
					e_col = C_GOLD_BRIGHT if s == 8 else C_GOLD_RICH
				voxels[Vector3i(ex, ey + dy, ez)] = e_col
				if s >= 1 and s <= 4 and dy == 0:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER

	# 6. IMPERIAL GOLDEN WINGED DIADEM / CROWN (y: 12..16)
	for x in range(-6, 7):
		for z in range(-5, 6):
			if abs(x) == 6 or abs(z) == 5:
				if not (abs(x) == 6 and abs(z) == 5):
					voxels[Vector3i(x, 12, z)] = C_GOLD_DEEP
					voxels[Vector3i(x, 13, z)] = C_GOLD_BRIGHT if (x + z) % 2 == 0 else C_GOLD_RICH

	# Falcon Brow Emblem & Ruby
	for fx in range(-2, 3):
		for fy in range(13, 16):
			voxels[Vector3i(fx, fy, 6)] = C_GOLD_RICH
	voxels[Vector3i(0, 14, 6)] = C_GEM_RUBY
	voxels[Vector3i(0, 15, 6)] = C_GOLD_BRIGHT
	voxels[Vector3i(-1, 15, 6)] = C_GOLD_RICH
	voxels[Vector3i(1, 15, 6)] = C_GOLD_RICH
	voxels[Vector3i(-2, 14, 6)] = C_GOLD_BRIGHT
	voxels[Vector3i(2, 14, 6)] = C_GOLD_BRIGHT

	# Swept Falcon Temple Wings
	for side in [-1, 1]:
		for step in range(5):
			var wx = side * (6 + (1 if step >= 2 else 0))
			var wy = 14 + int(step * 0.7)
			var wz = -1 - step
			voxels[Vector3i(wx, wy, wz)] = C_GOLD_BRIGHT if step % 2 == 0 else C_GOLD_RICH
			voxels[Vector3i(wx, wy + 1, wz)] = C_GOLD_RICH

	# 7. MAJESTIC PHOENIX PLUME (Left Crest x: -6..-7, y: 14..21, z: -2..-8)
	for i in range(8):
		var fy = 14 + i
		var fz = -2 - int(float(i) * 0.85)
		var col_crimson = C_GOLD_BRIGHT if i >= 6 else (C_ROYAL_CRIMSON if i % 2 == 0 else C_ROYAL_CRIMSON_DARK)
		voxels[Vector3i(-6, fy, fz)] = col_crimson
		var col_gold = C_GEM_RUBY if i == 0 else (C_FEATHER_GOLD if i % 2 == 0 else C_GOLD_RICH)
		voxels[Vector3i(-7, fy, fz)] = col_gold

	# 8. IMPERIAL OCULAR MONOCLE / TARGETING RETICLE (Right Eye x > 0)
	for ox in range(1, 5):
		for oy in range(9, 13):
			var is_border = (ox in [1, 4] or oy in [9, 12])
			if is_border:
				voxels[Vector3i(ox, oy, 6)] = C_GOLD_BRIGHT if (ox == 4 or oy == 12) else C_GOLD_RICH
				voxels[Vector3i(ox, oy, 7)] = C_GOLD_RICH
			elif ox in [2, 3] and oy in [10, 11]:
				voxels[Vector3i(ox, oy, 6)] = C_GEM_SAPPHIRE
				voxels[Vector3i(ox, oy, 7)] = C_GEM_CYAN_GLOW if (ox == 2 and oy == 10) else C_GEM_SAPPHIRE
	voxels[Vector3i(5, 11, 5)] = C_GOLD_RICH
	voxels[Vector3i(5, 11, 6)] = C_GOLD_BRIGHT

	# 9. Left Eye
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
	elif outfit == 3:
		return build_archer_torso_mesh_outfit3()
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

# --- TORSO OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (GIÁP NGỰC VÀNG RÒNG, ÁO GẤM ĐỎ, GIÁP VAI CÁNH CHIM, ĐAI ĐẠI BÀNG) ---
static func build_archer_torso_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# Slit scalloped tunic hem at hips (y in [0, 1])
				if y <= 1 and (abs(x) == rx or abs(z) == rz) and (x % 3 == 0 or z % 3 == 0): continue
				
				# 1. Base Imperial Quilted Crimson Gambeson
				var col = C_ROYAL_CRIMSON
				if (abs(x) + abs(z) + y) % 4 == 0 and (abs(x) == rx or abs(z) == rz) and y >= 2 and y <= 14:
					col = C_GOLD_BRIGHT
				elif (abs(x) == rx or abs(z) == rz) and y in [0, 1]:
					col = C_GOLD_RICH
				elif y >= 15 and abs(x) <= 3 and abs(z) <= 3:
					col = C_SKIN
					voxels.append([x, y, z, col])
					continue
					
				# 2. Wide Imperial Sash & Gold Eagle Belt (y: 3..4)
				if (y == 3 or y == 4) and (abs(x) == rx or abs(z) == rz):
					if abs(x) <= 2 and z == rz:
						if x == 0 and y == 4:
							col = C_GEM_RUBY
						elif abs(x) <= 1:
							col = C_GOLD_BRIGHT
						else:
							col = C_GOLD_RICH
					else:
						col = C_GOLD_DEEP if y == 3 else C_GOLD_RICH
						
				# 3. Flared Lamellar Tassets (Hip Armor Scales y: 0..2)
				if y <= 2 and (abs(x) >= 4 or (abs(z) == rz and abs(x) >= 2)):
					col = C_GOLD_BRIGHT if y == 1 else C_GOLD_RICH
					
				# 4. Asymmetrical Imperial Golden Plastron & Gorget (Left Chest & Neck)
				var is_plastron = (x >= -5 and x <= -1) and (y >= 6 and y <= 13) and (z == rz)
				if is_plastron:
					if x == -3 and y == 10:
						col = C_GEM_RUBY
					elif (x in [-4, -2] and y == 10) or (x == -3 and y in [9, 11]):
						col = C_GOLD_BRIGHT
					elif x in [-5, -1] or y in [6, 13]:
						col = C_GOLD_BRIGHT
					else:
						col = C_GOLD_RICH
						
				# High Golden Throat Gorget (y: 14..15, z in [rz - 1, rz], abs(x) <= 4)
				if (y in [14, 15]) and (z >= rz - 1) and (abs(x) >= 2 and abs(x) <= 4):
					col = C_GOLD_RICH
					
				# 5. Imperial Wing Pauldron (Left Shoulder x: -rx to -4, y: 14..17, abs(z) >= rz - 2)
				var is_left_pauldron = (x <= -4) and (y >= 14 and y <= 17) and (abs(z) >= rz - 2)
				if is_left_pauldron:
					if y == 17 or abs(z) == rz:
						col = C_GOLD_BRIGHT
					elif y == 16:
						col = C_GOLD_RICH
					else:
						col = C_GOLD_DEEP
						
				# 6. Right Shoulder Archery Guard (x: 4..rx, y: 14..16, abs(z) >= rz - 1)
				var is_right_guard = (x >= 4) and (y >= 14 and y <= 16) and (abs(z) >= rz - 1)
				if is_right_guard:
					col = C_GOLD_RICH if (y == 15 and z == rz) else C_ROYAL_CRIMSON_DARK
					
				# 7. Diagonal Imperial Bandolier Cross-Strap
				var strap_y = -1.1 * float(x) + 9.5
				var is_front_strap = (abs(float(y) - strap_y) <= 1.0) and (z == rz) and not is_plastron
				var is_back_strap = (abs(float(y) - strap_y) <= 1.0) and (z == -rz)
				if is_front_strap:
					if (y in [9, 10]) and (x in [0, 1]):
						col = C_GEM_RUBY
					elif (x + y) % 2 == 0:
						col = C_GOLD_BRIGHT
					else:
						col = C_ROYAL_CRIMSON_DARK
				elif is_back_strap:
					col = C_GOLD_RICH if (x + y) % 2 == 0 else C_GOLD_DEEP
					
				# 8. Front V-neck gold frogging & cord closure
				if z == rz and abs(x) <= 1 and y >= 11 and y <= 14:
					if abs(x) == 1 and y % 2 == 0:
						col = C_GOLD_BRIGHT
					elif x == 0 and y >= 13:
						col = C_SKIN_DARK
						
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_upper_arm_mesh_outfit1()
	elif outfit == 3:
		return build_archer_upper_arm_mesh_outfit3()
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

static func build_archer_upper_arm_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -5:
					col = C_ROYAL_CRIMSON
					if y in [-2, -3] and (abs(x) == rx or abs(z) == rz):
						col = C_GOLD_BRIGHT if y == -2 else C_GOLD_RICH
					elif y == -5 and (abs(x) == rx or abs(z) == rz):
						col = C_GOLD_DEEP
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_forearm_mesh_outfit1(is_right)
	elif outfit == 3:
		return build_archer_forearm_mesh_outfit3(is_right)
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

static func build_archer_forearm_mesh_outfit3(is_right: bool) -> ArrayMesh:
	var voxels = []
	if not is_right:
		# LEFT FOREARM (BOW ARM): Imperial Masterwork Golden Vambrace
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y >= -6 and y <= -1:
						if abs(x) == 2 or abs(z) == 2:
							if y == -3 and z == 2 and x == 0:
								col = C_GEM_RUBY
							elif y in [-2, -4] and z == 2 and x == 0:
								col = C_GOLD_BRIGHT
							elif y in [-1, -6]:
								col = C_GOLD_BRIGHT
							elif abs(x) == 2 or abs(z) == 2:
								col = C_GOLD_RICH if (y + x) % 2 == 0 else C_GOLD_DEEP
						else:
							col = C_ROYAL_CRIMSON_DARK
					elif y <= -8:
						if (abs(x) == 1 or abs(x) == 2) and z >= 1:
							col = C_GOLD_BRIGHT if y == -9 else C_GOLD_RICH
					voxels.append([x, y, z, col])
	else:
		# RIGHT FOREARM (DRAW HAND): Imperial Golden Shooting Gauntlet
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					if y in [-4, -5]:
						if abs(x) == 2 or abs(z) == 2:
							col = C_GOLD_BRIGHT if y == -4 else C_GOLD_RICH
						else:
							col = C_ROYAL_CRIMSON
					elif y == -6:
						col = C_SKIN if z >= 0 else C_SKIN_DARK
					elif y <= -7:
						if z == 2:
							if y in [-7, -8]:
								col = C_GOLD_RICH if abs(x) <= 1 else C_SKIN
							else:
								col = C_GOLD_BRIGHT if abs(x) <= 1 else C_SKIN
						elif x == 2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						elif x == -2:
							col = C_GOLD_BRIGHT if (y == -8 and z == 1) else C_SKIN_LIGHT
						elif z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						else:
							col = C_SKIN
					voxels.append([x, y, z, col])
					
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
		voxels.append([-1, -7, 2, C_GOLD_RICH])
		voxels.append([-1, -8, 2, C_GOLD_BRIGHT])
		voxels.append([0, -9, 2, C_GOLD_BRIGHT])
		voxels.append([1, -9, 2, C_GOLD_BRIGHT])
	return build_seamless_mesh(voxels)

static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_thigh_mesh_outfit1()
	elif outfit == 3:
		return build_archer_thigh_mesh_outfit3()
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

static func build_archer_thigh_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_ROYAL_CRIMSON
				if (abs(x) == rx and z == 0):
					col = C_GOLD_BRIGHT
				elif y >= -3 and (abs(x) == rx or abs(z) == rz):
					col = C_GOLD_RICH if y == -3 else C_GOLD_BRIGHT
				elif y in [-7, -8, -9] and (abs(x) == rx or abs(z) == rz):
					if z == rz:
						col = C_GOLD_BRIGHT if (y == -8 and abs(x) <= 1) else C_GOLD_RICH
					elif y == -9:
						col = C_GOLD_DEEP
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_shin_mesh_outfit1()
	elif outfit == 3:
		return build_archer_shin_mesh_outfit3()
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

static func build_archer_shin_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	# 1. Upper Boot & Greaves (y: -6 to 0) - Fluted Golden Greaves
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_GOLD_RICH
				if z == 2:
					if y == 0 and x == 0:
						col = C_GEM_RUBY
					elif x == 0:
						col = C_GOLD_BRIGHT
					else:
						col = C_GOLD_RICH
				elif z == -3 or abs(x) == 2:
					col = C_GOLD_DEEP
				voxels.append([x, y, z, col])
				
	# 2. Ankle Wing Spurs & Articulation (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_GOLD_RICH if y == -5 else C_GOLD_DEEP
				voxels.append([x, y, z, col])
				
	# 3. Flared Winged Sabaton Ankle Armor (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_GOLD_BRIGHT if abs(x) == 3 else C_GOLD_RICH
			voxels.append([x, -8, z, col])
			
	# 4. Solid Boot Sole & Arch (y: -10 to -7, z: -3 to 3) - EXACT GROUND LOCK AT y = -10!
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				
				var col = C_GOLD_DEEP
				if y == -10:
					col = C_LEATHER_DARK
				elif z >= 0 and y == -8:
					col = C_GOLD_BRIGHT
				voxels.append([x, y, z, col])
				
	# 5. Predatory Gold Claws & Sabaton Caps (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_GOLD_DEEP if ty == -10 else C_GOLD_RICH
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_GOLD_DEEP])
						
		voxels.append([tx, -10, 6, C_GOLD_BRIGHT])
		voxels.append([tx, -10, 7, C_GOLD_BRIGHT])
		voxels.append([tx, -9, 6, C_GOLD_RICH])
		
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

static func build_imperial_bow_mesh(drawn: bool = false) -> ArrayMesh:
	var voxels: Dictionary = {}
	# Imperial Golden Sunburst Recurve Bow: height ~ 30 voxels
	# Center Grip & Sunburst Sigil (y: -2..2, z: 0..1, x: 0)
	for y in range(-2, 3):
		voxels[Vector3i(0, y, 0)] = C_IMP_GOLD_DARK
		voxels[Vector3i(0, y, 1)] = C_IMP_GOLD_GLEAM if y == 0 else C_IMP_GOLD_LIGHT
		voxels[Vector3i(1, y, 0)] = C_IMP_GOLD
		voxels[Vector3i(-1, y, 0)] = C_IMP_GOLD
	voxels[Vector3i(0, 0, 2)] = C_RUBY_GLEAM # Royal center ruby

	# Upper Wing Limb (y: 3..15)
	for y in range(3, 16):
		var curve_z = int(sin(float(y - 2) / 13.0 * PI) * 3.5)
		if y >= 12: curve_z -= (y - 11)
		if drawn and y >= 8: curve_z -= 1
		var col = C_IMP_GOLD_LIGHT if y % 2 == 0 else C_IMP_GOLD
		if y in [5, 10]: col = C_RUBY
		voxels[Vector3i(0, y, curve_z)] = col
		voxels[Vector3i(0, y, curve_z - 1)] = C_IMP_GOLD
		if y >= 14:
			voxels[Vector3i(0, y, curve_z)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(0, y + 1, curve_z - 1)] = C_IMP_GOLD_GLEAM

	# Lower Wing Limb (y: -3..-15)
	for y in range(-15, -2):
		var ay = abs(y)
		var curve_z = int(sin(float(ay - 2) / 13.0 * PI) * 3.5)
		if ay >= 12: curve_z -= (ay - 11)
		if drawn and ay >= 8: curve_z -= 1
		var col = C_IMP_GOLD_LIGHT if ay % 2 == 0 else C_IMP_GOLD
		if ay in [5, 10]: col = C_RUBY
		voxels[Vector3i(0, y, curve_z)] = col
		voxels[Vector3i(0, y, curve_z - 1)] = C_IMP_GOLD
		if y <= -14:
			voxels[Vector3i(0, y, curve_z)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(0, y - 1, curve_z - 1)] = C_IMP_GOLD_GLEAM

	# Radiant Golden Bowstring:
	if drawn:
		for i in range(40):
			var t = float(i) / 39.0
			var sy = int(round(lerp(0.0, 15.0, t)))
			var sz = int(round(lerp(-19.0, -2.0, t)))
			voxels[Vector3i(0, sy, sz)] = C_GOLD_BRIGHT
			voxels[Vector3i(0, -sy, sz)] = C_GOLD_BRIGHT
	else:
		for y in range(-15, 16):
			voxels[Vector3i(0, y, -2)] = C_GOLD_BRIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_imperial_arrow_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Imperial Solar Arrow (z: -19..8)
	voxels[Vector3i(0, 0, -19)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 0, -18)] = C_IMP_GOLD_LIGHT

	# Golden Eagle Fletching (z: -17..-13)
	for z in range(-17, -12):
		var col = C_IMP_GOLD_GLEAM if z <= -15 else C_RUBY_GLEAM
		voxels[Vector3i(1, 0, z)] = col
		voxels[Vector3i(-1, 0, z)] = col
		voxels[Vector3i(0, 1, z)] = col
		voxels[Vector3i(0, -1, z)] = col

	# Polished Golden Shaft (z: -16..3)
	for z in range(-16, 4):
		voxels[Vector3i(0, 0, z)] = C_IMP_GOLD if z % 2 == 0 else C_IMP_GOLD_LIGHT

	# Ruby Studded Collar (z: 4)
	voxels[Vector3i(0, 0, 4)] = C_RUBY

	# Broadhead Golden Broad Arrowhead with Ruby Edge (z: 5..8)
	for z in range(5, 7):
		voxels[Vector3i(0, 0, z)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(1, 0, z)] = C_RUBY_GLEAM
		voxels[Vector3i(-1, 0, z)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 0, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 0, 8)] = C_IMP_GOLD_LIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_imperial_quiver_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	for y in range(-8, 9):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var dist = abs(x) + abs(z)
				if dist <= 3:
					var is_outer = (abs(x) == 2 or abs(z) == 2)
					if is_outer or y == -8:
						var col = C_IMP_VELVET if y % 2 == 0 else C_IMP_VELVET_DARK
						if y in [-8, -4, 0, 4, 8]: col = C_IMP_GOLD_GLEAM
						voxels[Vector3i(x, y, z)] = col
	# Golden Arrows poking out (y: 9..14)
	var arrow_offsets = [Vector3i(0, 0, 0), Vector3i(1, 0, 1), Vector3i(-1, 0, 0), Vector3i(0, 0, -1)]
	for o in arrow_offsets:
		for dy in range(9, 14):
			voxels[Vector3i(o.x, dy, o.z)] = C_IMP_GOLD
		voxels[Vector3i(o.x + 1, 13, o.z)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(o.x - 1, 13, o.z)] = C_RUBY_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)



# --- B. GOBLIN SHAMAN (Mặt Nạ Sọ Thú, Áo Choàng & Trượng Ma Thuật) ---

static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_head_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_head_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Base Goblin Head & Neck with Imperial Gorget (y: 0..3)
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_IMP_VELVET_DARK if y == 0 else C_SKIN
				# Golden gorget collar ring
				if y in [1, 2] and (abs(x) == 3 or abs(z) == 3):
					col = C_IMP_GOLD_LIGHT if (x + z) % 2 == 0 else C_IMP_GOLD
				elif y == 3 and z == 3 and abs(x) <= 1:
					col = C_IMP_GOLD_GLEAM # Front throat plate
				voxels[Vector3i(x, y, z)] = col
				
	# 2. Lower Jaw & Snarl with Golden Boar Tusks (y: 4..7)
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 4 else C_SKIN

	# Open Snarling Mouth Cavity (y: 5..6, z: 6)
	for y in range(5, 7):
		for x in range(-2, 3):
			voxels[Vector3i(x, y, 6)] = C_MOUTH_DARK
			
	# Colossal Lower Boar Tusks with Imperial Gold Cuffs & Gilded Tips (y: 5..9)
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 5, 6)] = C_IMP_GOLD_DEEP # Carved root band
		voxels[Vector3i(side * 3, 6, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 3, 7, 6)] = C_TEETH
		voxels[Vector3i(side * 3, 8, 6)] = C_TEETH
		voxels[Vector3i(side * 3, 9, 6)] = C_IMP_GOLD_GLEAM # Gilded razor tip
		# Upper fangs
		voxels[Vector3i(side * 2, 7, 7)] = C_TEETH
		voxels[Vector3i(side * 2, 6, 7)] = C_IMP_GOLD_LIGHT
	# Front jagged lower incisors
	voxels[Vector3i(-1, 5, 7)] = C_TEETH
	voxels[Vector3i(0, 5, 7)] = C_IMP_GOLD_LIGHT # Golden center incisor
	voxels[Vector3i(1, 5, 7)] = C_TEETH
	# Braided Imperial Beard Fetish with Ruby Gem under chin (y: 0..4, z: 6)
	voxels[Vector3i(0, 4, 6)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, 3, 6)] = C_IMP_GOLD
	voxels[Vector3i(0, 2, 6)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 1, 6)] = C_RUBY
	voxels[Vector3i(0, 0, 6)] = C_RUBY_GLEAM # Radiant hanging ruby drop!

	# 3. Goblin Cranium (y: 8..15)
	for y in range(8, 16):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# 4. Hooked Goblin Nose with Golden Septum Ring (y: 8..11, z: 6..10)
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
	# Golden septum stud
	voxels[Vector3i(0, 8, 9)] = C_IMP_GOLD_GLEAM

	# 5. Predatory Eyes & Radiant Imperial Warpaint (y: 10..11)
	for x in range(-4, 5):
		voxels[Vector3i(x, 11, 6)] = C_SKIN_DARK
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_EYE_PUPIL
		# Imperial Golden & Crimson Warpaint slashes across cheeks
		voxels[Vector3i(side * 4, 9, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 4, 8, 6)] = C_RUBY
		voxels[Vector3i(side * 3, 8, 7)] = C_IMP_GOLD_GLEAM

	# 6. Bat Ears with Triple Golden Hoops & Ruby Teardrops
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
				
		# Triple Golden Hoop Piercings with Ruby & Solar Drops
		voxels[Vector3i(side * 13, 11, -4)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 14, 10, -4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 13, 9, -4)] = C_RUBY # Hanging ruby drop
		voxels[Vector3i(side * 11, 13, -3)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 12, 12, -4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 9, 14, -2)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 9, 13, -2)] = C_GOLD_BRIGHT

	# 7. ENLARGED ANCIENT DRAGON SKULL MASK (MẶT NẠ ĐẠI ĐẾ LONG THƯỢNG CỔ, y: 12..21, x: -7..7, z: -5..9)
	# Volumetric Massive Dragon Skull Shell
	for y in range(12, 22):
		var rad_sx = 7 if y in [13, 14, 15, 16] else (6 if y < 19 else 5)
		var z_front = 8 if y in [13, 14, 15, 16] else (7 if y < 19 else 5)
		for x in range(-rad_sx, rad_sx + 1):
			for z in range(-5, z_front + 1):
				var on_skull_shell = (abs(x) == rad_sx or z in [-5, z_front] or y >= 19)
				if on_skull_shell:
					var col = C_SKULL_BONE
					# Imperial Golden Crown Ridge & Filigree
					if y in [18, 19, 20] and (abs(x) <= 3 or abs(z) <= 3):
						col = C_IMP_GOLD_GLEAM if (x + y + z) % 2 == 0 else C_IMP_GOLD_LIGHT
					elif y in [16, 17] and (abs(x) == rad_sx or z == z_front):
						col = C_IMP_GOLD_LIGHT # Gilded temple and brow band
					elif y == 21:
						col = C_IMP_GOLD_GLEAM # Apex crown spikes
					voxels[Vector3i(x, y, z)] = col

	# Grand Dragon Snout & Brow Overhang (y: 12..15, z: 7..9)
	for y in range(12, 16):
		for x in range(-5, 6):
			voxels[Vector3i(x, y, 7)] = C_SKULL_BONE
			voxels[Vector3i(x, y, 8)] = C_SKULL_BONE
			if abs(x) <= 3:
				voxels[Vector3i(x, y, 9)] = C_IMP_GOLD_LIGHT if y in [14, 15] else C_SKULL_BONE

	# Six Prominent Gilded Dragon Fangs jutting downward over goblin brow
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 11, 9)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 3, 10, 9)] = C_TEETH
		voxels[Vector3i(side * 3, 9, 8)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 5, 11, 8)] = C_TEETH
		voxels[Vector3i(side * 5, 10, 8)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 1, 11, 9)] = C_TEETH

	# Cavernous Dragon Eye Sockets with Dual-Layer Blazing Solar Core (y: 14..16, z: 7)
	for side in [-1, 1]:
		for ey in range(14, 17):
			for ex in range(2, 5):
				voxels[Vector3i(side * ex, ey, 7)] = C_GOLD_BRIGHT # Radiant blazing solar flame
				voxels[Vector3i(side * ex, ey, 6)] = C_LAVA_CORE   # Deep molten core
				voxels[Vector3i(side * ex, ey, 8)] = C_RUBY_GLEAM  # Outer coronal flare
		# Eye socket dark rim
		voxels[Vector3i(side * 1, 15, 7)] = C_IMP_GOLD_DARK
		voxels[Vector3i(side * 5, 15, 7)] = C_IMP_GOLD_DARK

	# THIRD EYE OF THE SUN EMPEROR (MẮT THÁI DƯƠNG ĐẾ VƯƠNG: x: 0, y: 16..19, z: 8..9)
	voxels[Vector3i(0, 17, 9)] = C_RUBY_GLEAM # Faceted radiant ruby center!
	voxels[Vector3i(0, 16, 9)] = C_RUBY
	voxels[Vector3i(0, 18, 9)] = C_RUBY
	voxels[Vector3i(-1, 17, 9)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 17, 9)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 19, 8)] = C_IMP_GOLD_GLEAM # Golden sunburst crown ray
	voxels[Vector3i(0, 15, 8)] = C_IMP_GOLD_LIGHT

	# 8. THICK MAJESTIC 3D DRAGON HORNS (CẶP ĐẠI NGUYÊN SỪNG 3D VĨ ĐẠI, y: 16..29)
	# Volumetric thick cross-sections (2x2 to 3x3), sweeping up, out, and curling inward
	for side in [-1, 1]:
		var horn_path = [
			Vector3i(side * 6, 16, 1),
			Vector3i(side * 7, 17, 0),
			Vector3i(side * 8, 18, -1),
			Vector3i(side * 9, 20, -2),
			Vector3i(side * 10, 22, -3),
			Vector3i(side * 11, 24, -3),
			Vector3i(side * 11, 26, -2),
			Vector3i(side * 10, 27, 0),
			Vector3i(side * 9, 28, 2),
			Vector3i(side * 8, 29, 4), # Curled forward-inward majestic tip
		]
		for i in range(horn_path.size()):
			var hp = horn_path[i]
			var is_gold_band = (i in [2, 5, 7])
			var is_tip = (i >= horn_path.size() - 2)
			
			var base_col = C_IMP_GOLD_LIGHT if is_gold_band else (C_IMP_EBONY if is_tip else C_SKULL_BONE)
			var highlight_col = C_IMP_GOLD_GLEAM if is_gold_band else (C_IMP_GOLD_LIGHT if is_tip else C_BONE)
			
			# Thick volumetric cross-section (multi-voxel body)
			var rad_offsets = [
				Vector3i(0, 0, 0),
				Vector3i(0, -1, 0),
				Vector3i(0, 0, 1),
				Vector3i(side * -1, 0, 0)
			]
			if i <= 4:
				# Even thicker base and mid sections!
				rad_offsets.append(Vector3i(0, 1, 0))
				rad_offsets.append(Vector3i(side * 1, 0, 0))
				rad_offsets.append(Vector3i(0, 0, -1))
				
			for off in rad_offsets:
				var c = base_col
				if is_gold_band and off.y == 0:
					c = C_IMP_GOLD_GLEAM
				voxels[hp + off] = c
				
			# Dorsal spine spike along horn ridge
			if i in [1, 3, 4, 6]:
				voxels[hp + Vector3i(0, 1, -1)] = C_IMP_GOLD_LIGHT
				
		# Secondary Forward Brow Hornlets (side * 4..6, y: 16..19, z: 8..10)
		voxels[Vector3i(side * 4, 16, 8)] = C_IMP_GOLD_DEEP
		voxels[Vector3i(side * 5, 17, 9)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 5, 18, 9)] = C_SKULL_BONE
		voxels[Vector3i(side * 6, 19, 10)] = C_IMP_GOLD_GLEAM # Forward razor tip!
		voxels[Vector3i(side * 5, 17, 10)] = C_IMP_GOLD_LIGHT

		# Cascading Gold Chains & Ruby Charms dangling from horn base
		voxels[Vector3i(side * 7, 14, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 7, 13, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 7, 12, 0)] = C_RUBY
		voxels[Vector3i(side * 7, 11, 0)] = C_RUBY_GLEAM
		voxels[Vector3i(side * 7, 10, -1)] = C_WHITE_SILK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_shaman_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_torso_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_torso_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Base Imperial Velvet Robe / Gambeson (y: 0..18)
	for y in range(19):
		var rx = 6 if y < 5 else (7 if y < 14 else 6)
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_IMP_VELVET
				if y <= 1:
					col = C_IMP_VELVET_DARK
				elif y == 2 and (abs(x) == rx or abs(z) == rz):
					col = C_IMP_GOLD_LIGHT # Gold embroidered hem
				voxels[Vector3i(x, y, z)] = col

	# 2. Solid Imperial Golden Cuirass / Breastplate (y: 5..17, z: 4..6, x: -6..6)
	for y in range(5, 18):
		var prx = 6 if y in [8, 9, 10, 11, 12, 13] else 5
		for x in range(-prx, prx + 1):
			for z in range(3, 7):
				if abs(x) == prx and z == 6: continue
				var col = C_IMP_GOLD
				var is_rim = (abs(x) == prx or z == 6 or y in [5, 17])
				if is_rim:
					col = C_IMP_GOLD_LIGHT if (x + y + z) % 2 == 0 else C_IMP_GOLD_GLEAM
				# Central Keel Ridge
				if x == 0 and z == 6:
					col = C_IMP_GOLD_GLEAM
				# Chased filigree groove
				elif abs(x) in [1, 4] and z == 5:
					col = C_IMP_GOLD_DARK
				voxels[Vector3i(x, y, z)] = col

	# 3. Imperial Sunburst Medallion with Radiant Heart Ruby (x: 0, y: 11..13, z: 6..7)
	for my in range(10, 15):
		for mx in range(-2, 3):
			if abs(mx) + abs(my - 12) <= 2:
				voxels[Vector3i(mx, my, 6)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 12, 7)] = C_RUBY_GLEAM # Blazing heart ruby core!
	voxels[Vector3i(-1, 12, 7)] = C_RUBY
	voxels[Vector3i(1, 12, 7)] = C_RUBY
	voxels[Vector3i(0, 11, 7)] = C_RUBY
	voxels[Vector3i(0, 13, 7)] = C_RUBY

	# 4. Flared Imperial Golden Gorget Collar (y: 17..23, z: -4..-2)
	for y in range(17, 24):
		for x in range(-5, 6):
			var cz = -3 - int(float(y - 17) * 0.4)
			var on_edge = (abs(x) == 5 or y == 23)
			var col = C_IMP_GOLD_GLEAM if on_edge else C_IMP_GOLD_LIGHT
			voxels[Vector3i(x, y, cz)] = col
			voxels[Vector3i(x, y, cz + 1)] = C_IMP_VELVET # Velvet inner lining

	# 5. Tiered Imperial Golden Pauldrons (y: 15..18, x: +-5..8)
	for side in [-1, 1]:
		for px in range(5, 9):
			for pz in range(-4, 4):
				for py in range(15, 19):
					var is_plate = (py == 18 or abs(px) == 8 or pz in [-4, 3])
					if is_plate:
						var col = C_IMP_GOLD_LIGHT
						if py == 18 and pz == 0 and px == 7:
							col = C_RUBY_GLEAM # Pauldron ruby gem!
						elif py == 18 and abs(px) in [6, 8]:
							col = C_IMP_GOLD_GLEAM
						voxels[Vector3i(side * px, py, pz)] = col
		# Golden chain clasps across chest
		for cx in range(2, 5):
			voxels[Vector3i(side * cx, 15, 6)] = C_IMP_GOLD_GLEAM

	# 6. Gilded Back Plating with Sun Sigil (y: 4..16, z: -5..-4)
	for y in range(4, 17):
		var rx_b = 6 if y < 14 else 5
		for x in range(-rx_b + 1, rx_b):
			var col = C_IMP_GOLD_DARK if (x + y) % 2 == 0 else C_IMP_GOLD
			if x == 0 and y in [8, 9, 10, 11, 12]:
				col = C_IMP_GOLD_GLEAM # Center spine ridge
			voxels[Vector3i(x, y, -4)] = col

	# 7. Imperial War Belt & Alchemical Reliquaries (y: 2..5)
	# Heavy golden belt band
	for y in range(3, 5):
		for x in range(-7, 8):
			for z in range(-5, 7):
				if abs(x) == 7 or abs(z) == (6 if z > 0 else 5):
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_LIGHT
	# Imperial Lion Buckle (x = -2..2, y = 3..5, z = 6..7)
	for bx in range(-2, 3):
		for by in range(2, 6):
			voxels[Vector3i(bx, by, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 4, 8)] = C_RUBY_GLEAM # Buckle center ruby!
	
	# Left Hip: Imperial Golden Dragon Elixir Urn (x = -8, y = 3..6, z = 1..2)
	voxels[Vector3i(-8, 5, 1)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(-9, 4, 1)] = C_GLOW_CYAN # Cyan soul essence fluid
	voxels[Vector3i(-9, 3, 1)] = C_GLOW_CYAN
	voxels[Vector3i(-9, 5, 1)] = C_RUBY_GLEAM # Ruby stopper
	# Right Hip: Imperial Golden Solar Mana Urn (x = +8, y = 3..6, z = 1..2)
	voxels[Vector3i(8, 5, 1)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(9, 4, 1)] = C_LAVA_CORE # Molten solar core fluid
	voxels[Vector3i(9, 3, 1)] = C_GOLD_BRIGHT
	voxels[Vector3i(9, 5, 1)] = C_IMP_GOLD_GLEAM # Gilded stopper

	# Segmented Gold Mail Faulds / Tassets hanging over velvet skirt (y: 0..2, z: 5)
	for tx in [-4, -3, -2, 2, 3, 4]:
		for ty in range(0, 3):
			voxels[Vector3i(tx, ty, 5)] = C_IMP_GOLD_LIGHT if (tx + ty) % 2 == 0 else C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_shaman_cloak_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_cloak_mesh_outfit3()
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

static func build_shaman_cloak_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. GRAND GOLDEN DRAGON SHOULDER CLASPS WITH FACETED RUBIES (y: 0..3, x: +-6..7, z: 0..6)
	for side in [-1, 1]:
		for cy in range(0, 4):
			for cz in range(0, 7):
				var cx = side * 6
				var is_brooch = (cz >= 4 and cy in [1, 2])
				var col = C_IMP_GOLD_LIGHT
				if is_brooch and cz == 6:
					col = C_RUBY_GLEAM # Radiant imperial ruby clasp!
				elif cy == 3 and cz in [2, 3]:
					col = C_IMP_GOLD_GLEAM
				voxels[Vector3i(cx, cy, cz)] = col
				if cz in [1, 2, 3, 4]:
					voxels[Vector3i(cx + side * 1, cy, cz)] = C_IMP_GOLD_GLEAM
					
		# Golden chain connector across upper back collar (y: 1..2, z: 1, x: -5..5)
		for lx in range(-5, 6):
			voxels[Vector3i(lx, 1, 1)] = C_IMP_GOLD_LIGHT
			if abs(lx) in [0, 2, 4]:
				voxels[Vector3i(lx, 2, 1)] = C_IMP_GOLD_GLEAM

	# 2. LUXURIOUS WHITE ERMINE SILK FUR COLLAR YOKE (y: 0..3, z: 0..4, x: -5..5)
	for y in range(0, 4):
		for x in range(-5, 6):
			for z in range(0, 4):
				var col = C_WHITE_SILK
				if y == 3 or z == 0 or abs(x) == 5:
					col = C_WHITE_SILK_SHADOW
				# Occasional royal ermine dark tip
				if (x * 3 + y * 5 + z) % 7 == 0:
					col = C_IMP_EBONY
				voxels[Vector3i(x, y, z)] = col

	# 3. VOLUMETRIC 3D DRAPED CAPE IN ROYAL CRIMSON VELVET (y: 0 down to -24)
	for y in range(-24, 1):
		var prog = float(-y) / 24.0
		var cape_width = int(6.0 + prog * 4.5)
		var sweep_back = prog * 2.5
		
		for x in range(-cape_width, cape_width + 1):
			var pleat_wave = cos(float(x) * 0.75) * 1.5
			var base_z = -int(round(pleat_wave + sweep_back))
			var on_edge = (abs(x) >= cape_width - 1 or y <= -23)
			
			# Outer velvet surface
			var col_outer = C_IMP_VELVET
			if on_edge:
				col_outer = C_IMP_GOLD_LIGHT # Solid gold border hem
				if y <= -23 and (x % 2 == 0):
					col_outer = C_IMP_GOLD_GLEAM # Bullion gold fringe!
			elif y < -10 and (abs(x) == cape_width - 2):
				col_outer = C_IMP_GOLD_DARK
			voxels[Vector3i(x, y, base_z - 1)] = col_outer
			
			# Inner velvet lining
			var col_inner = C_IMP_VELVET_DARK
			if on_edge:
				col_inner = C_IMP_GOLD_LIGHT
			voxels[Vector3i(x, y, base_z)] = col_inner
			
			if pleat_wave > 0.5 and not on_edge:
				voxels[Vector3i(x, y, base_z - 2)] = C_IMP_VELVET

	# 4. COLOSSAL EMBOSSED 3D IMPERIAL SUN & DRAGON SIGIL (Back Centerpiece, y: -4..-16)
	for y in range(-16, -3):
		var progress_sigil = float(-y) / 24.0
		var pleat_center = 1.4
		var sweep_center = progress_sigil * 2.2
		var sz = -int(round(pleat_center + sweep_center)) - 2
		
		# Center golden solar spine
		voxels[Vector3i(0, y, sz)] = C_IMP_GOLD_GLEAM
		if y in [-6, -11]:
			voxels[Vector3i(0, y, sz)] = C_RUBY_GLEAM # Faceted ruby!
			voxels[Vector3i(0, y, sz - 1)] = C_RUBY
			
		# Arcane solar rays & diamond wings
		if y in [-5, -7]:
			voxels[Vector3i(-1, y, sz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(1, y, sz)] = C_IMP_GOLD_LIGHT
		elif y == -6:
			voxels[Vector3i(-2, y, sz)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(2, y, sz)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(-3, y, sz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(3, y, sz)] = C_IMP_GOLD_LIGHT
			
		# Lower dragon sigil
		if y in [-10, -12]:
			voxels[Vector3i(-1, y, sz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(1, y, sz)] = C_IMP_GOLD_LIGHT
		elif y == -11:
			voxels[Vector3i(-2, y, sz)] = C_RUBY
			voxels[Vector3i(2, y, sz)] = C_RUBY
			voxels[Vector3i(-3, y, sz)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(3, y, sz)] = C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_shaman_staff_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_staff_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_staff_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. Imperial Polished Gold Stave with Helical Twin Dragons (y: -18..22)
	for y in range(-18, 23):
		var wobble_x = int(sin(float(y) * 0.35) * 1.5)
		var wobble_z = int(cos(float(y) * 0.28) * 1.2)
		var rad = 1
		if y in [-18, -17]: rad = 0 # Faceted spear ferrule
		elif y in [-3, -2, -1, 0, 1, 2, 3, 4]: rad = 1 # Velvet grip
		
		# Twin Golden Dragons winding up in opposing spirals
		var dragon1_ang = float(y) * 0.7
		var d1_x = int(cos(dragon1_ang) * 1.4)
		var d1_z = int(sin(dragon1_ang) * 1.4)
		var dragon2_ang = float(y) * 0.7 + PI
		var d2_x = int(cos(dragon2_ang) * 1.4)
		var d2_z = int(sin(dragon2_ang) * 1.4)
		
		for dx in range(-rad, rad + 1):
			for dz in range(-rad, rad + 1):
				if rad > 0 and abs(dx) == rad and abs(dz) == rad: continue
				var col = C_IMP_GOLD
				if y <= -16:
					col = C_IMP_GOLD_GLEAM if y == -16 else C_STEEL_LIGHT
				elif y in [-3, -2, -1, 0, 1, 2, 3, 4]:
					col = C_IMP_GOLD_GLEAM if (y in [-3, 4]) else C_IMP_VELVET
				elif (dx == d1_x and dz == d1_z) or (dx == d2_x and dz == d2_z):
					col = C_IMP_GOLD_GLEAM # Coiling dragon body!
					if y in [-10, 0, 10]: col = C_RUBY_GLEAM # Embedded ruby dragon scales
				elif (y == -10 or y == 10) and (dx == 0 or dz == 0):
					col = C_GOLD_BRIGHT # Floating solar rune ring
				voxels[Vector3i(wobble_x + dx, y, wobble_z + dz)] = col

	# 2. Quadruple Cascading Imperial Reliquaries & Tassels (y: 16..21)
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 19, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 3, 18, 2)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 3, 17, 2)] = C_RUBY
		voxels[Vector3i(side * 3, 16, 2)] = C_RUBY_GLEAM # Faceted hanging ruby drop!
		voxels[Vector3i(side * 2, 19, -1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 3, 18, -1)] = C_WHITE_SILK
		voxels[Vector3i(side * 3, 17, -1)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 3, 16, -1)] = C_WHITE_SILK

	# 3. Staff Crown: Imperial Crowned Golden Dragon Skull (y: 22..29)
	for y in range(22, 29):
		var sw = 3 if y < 27 else 4
		for x in range(-sw, sw + 1):
			for z in range(-sw, sw + 1):
				if abs(x) + abs(z) <= sw + 2:
					var col = C_IMP_GOLD_LIGHT
					if y in [27, 28] and (abs(x) == sw or abs(z) == sw):
						col = C_IMP_GOLD_GLEAM # Crown spikes
					elif y == 22:
						col = C_IMP_GOLD_DEEP
					voxels[Vector3i(x, y, z)] = col
	# Gold fangs
	for fx in [-2, 0, 2]:
		voxels[Vector3i(fx, 23, 4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(fx, 22, 4)] = C_IMP_GOLD_DEEP
	# Blazing Ruby Eye Sockets
	voxels[Vector3i(-2, 26, 4)] = C_RUBY_GLEAM
	voxels[Vector3i(2, 26, 4)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 26, 4)] = C_GOLD_BRIGHT # Forehead solar jewel

	# 4. Four Swept Thick Dragon Horns forming an Ornate Sun Cradle (y: 27..40)
	for side in [-1, 1]:
		var staff_horn = [
			Vector3i(side * 4, 27, 0),
			Vector3i(side * 5, 28, 0),
			Vector3i(side * 6, 30, 1),
			Vector3i(side * 7, 32, 2),
			Vector3i(side * 8, 34, 1),
			Vector3i(side * 8, 36, 0),
			Vector3i(side * 7, 38, -1),
			Vector3i(side * 5, 40, -2), # Curled inward above the star!
		]
		for i in range(staff_horn.size()):
			var hp = staff_horn[i]
			var is_band = (i in [2, 5])
			var col = C_IMP_GOLD_GLEAM if is_band else C_IMP_GOLD_LIGHT
			voxels[hp] = col
			voxels[hp + Vector3i(0, -1, 0)] = C_IMP_GOLD_DARK
			voxels[hp + Vector3i(0, 0, -1)] = col
			# Thickness voxel for 3D body
			voxels[hp + Vector3i(side * -1, 0, 0)] = col
		# Forward antler tine
		voxels[Vector3i(side * 5, 31, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 6, 33, 4)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 6, 35, 4)] = C_RUBY_GLEAM

	# 5. THE GRAND SOLAR STAR CORE (Thái Dương Tinh Thể Khổng Lồ, y: 29..42)
	# Multi-layer radiant celestial orb (5x5x5 sphere centered at y: 33)
	for y in range(31, 36):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var d2 = x * x + z * z + (y - 33) * (y - 33)
				if d2 <= 2:
					voxels[Vector3i(x, y, z)] = C_GOLD_BRIGHT # Pure diamond solar core
				elif d2 <= 5:
					voxels[Vector3i(x, y, z)] = C_LAVA_CORE   # Molten solar flare
				elif d2 <= 8:
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_LIGHT # Coronal halo
	# Orbiting Celestial Golden Rings & Ruby Stars
	for a in range(8):
		var rang = float(a) / 8.0 * TAU
		var rx = int(round(cos(rang) * 3.2))
		var rz = int(round(sin(rang) * 3.2))
		voxels[Vector3i(rx, 33, rz)] = C_IMP_GOLD_GLEAM if a % 2 == 0 else C_RUBY_GLEAM
	# Dancing solar flame tongues rising high
	voxels[Vector3i(0, 36, 0)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 37, 0)] = C_LAVA_CORE
	voxels[Vector3i(0, 38, 0)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 39, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 40, 0)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 41, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 37, 1)] = C_LAVA_CORE
	voxels[Vector3i(-1, 38, -1)] = C_GOLD_BRIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- DEDICATED SHAMAN LIMBS (Tay Áo Choàng Tế Lễ, Vòng Bùa & Váy Phù Thủy) ---

static func build_shaman_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_upper_arm_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_upper_arm_mesh_outfit3() -> ArrayMesh:
	# Heavy imperial gold rerebrace plates over royal crimson velvet sleeve
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
					col = C_IMP_VELVET
					# Segmented gold plates on upper arm
					if abs(x) == rx or abs(z) == rz:
						col = C_IMP_GOLD_LIGHT
						if (y == -6 or y == -7):
							col = C_IMP_GOLD_GLEAM # Lower plate rim
						elif y in [-3, -4] and (x == 0 or z == 0):
							col = C_RUBY # Embedded ruby stud
					elif y >= -2 and abs(z) == rz:
						col = C_IMP_GOLD_DEEP
				elif (y == -8 or y == -9) and z == rz and abs(x) <= 1:
					col = C_SKIN_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)


static func build_shaman_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_forearm_mesh_outfit3(is_right)
	elif outfit == 2:
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

static func build_shaman_forearm_mesh_outfit3(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				# Solid Imperial Gold Vambrace (y: -3..-6)
				if y in [-4, -5]:
					col = C_IMP_GOLD_LIGHT
					if z == 2 and x == 0:
						col = C_RUBY_GLEAM # Embedded ruby gem
					elif abs(x) == 2 or abs(z) == 2:
						col = C_IMP_GOLD_GLEAM
				elif y in [-3, -6]:
					col = C_IMP_GOLD_DEEP if (abs(x) == 2 or abs(z) == 2) else C_IMP_VELVET
				# Gilded Gauntlet & Claws (y <= -7)
				elif y <= -7:
					if is_right:
						# Clenched gold gauntlet gripping staff
						if z == 2:
							col = C_IMP_GOLD_GLEAM if y == -9 and abs(x) <= 1 else C_IMP_GOLD_LIGHT
						elif abs(x) == 2 or z == -2:
							col = C_IMP_GOLD_LIGHT if y == -8 else C_SKIN
						else:
							col = C_IMP_GOLD
					else:
						# Open splayed mudra spellcasting gauntlet with blazing solar tips
						if y == -9:
							col = C_GOLD_BRIGHT if abs(x) <= 1 else C_RUBY_GLEAM
						elif y == -8 and (z == 2 or abs(x) == 2):
							col = C_IMP_GOLD_GLEAM # Golden finger ring
						else:
							col = C_IMP_GOLD
				voxels.append([x, y, z, col])
				
	# Extended claws/talons
	if not is_right:
		for tx in [-1, 1]:
			voxels.append([tx, -9, 2, C_GOLD_BRIGHT])
			voxels.append([tx, -10, 2, C_RUBY_GLEAM])
		voxels.append([0, -10, 1, C_GOLD_BRIGHT])
	else:
		voxels.append([-2, -7, 1, C_IMP_GOLD_GLEAM])
		voxels.append([-1, -8, 2, C_IMP_GOLD_LIGHT])
		voxels.append([0, -9, 2, C_IMP_GOLD_GLEAM])
		voxels.append([1, -9, 2, C_IMP_GOLD_LIGHT])
		
	return build_seamless_mesh(voxels)


static func build_shaman_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_thigh_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_thigh_mesh_outfit3() -> ArrayMesh:
	# Segmented gold tassets over royal crimson velvet pleated skirt
	var voxels = []
	for y in range(-10, 1):
		var rx = 4 if y > -8 else 5 # Flares outward at bottom hem
		var rz = 4 if y > -8 else 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_IMP_VELVET
				if y in [-9, -10]:
					col = C_IMP_GOLD_LIGHT # Wide golden bottom hem
					if (x + z) % 2 == 0: col = C_IMP_GOLD_GLEAM
				elif y == -8:
					col = C_IMP_GOLD_DARK # Accent band
				elif abs(x) == rx:
					col = C_IMP_GOLD_LIGHT if y in [-5, -6] else C_IMP_VELVET_DARK
				# Center slit showing gold knee greave at y = -9
				if z == rz and abs(x) <= 1 and y <= -8:
					col = C_IMP_GOLD_GLEAM if y == -9 and x == 0 else C_IMP_GOLD_LIGHT
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)


static func build_shaman_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_shin_mesh_outfit3()
	elif outfit == 2:
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

static func build_shaman_shin_mesh_outfit3() -> ArrayMesh:
	# Imperial Golden Greaves with Lion Poleyns and Spiked War Sabatons
	var voxels = []
	# 1. Shin with solid golden greave plate (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_IMP_GOLD_LIGHT
				if z == 2:
					col = C_IMP_GOLD_GLEAM # Front shin ridge
				elif (x + y + z) % 3 == 0:
					col = C_IMP_GOLD_DARK
				voxels.append([x, y, z, col])
				
	# 2. Lion Poleyn Knee Guard & Ruby Cabochons (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_IMP_GOLD_LIGHT
				if y == -6 and (abs(x) == 2 or abs(z) == 2):
					col = C_RUBY if x == 0 or z == 0 else C_IMP_GOLD_GLEAM
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_IMP_GOLD_DEEP if abs(x) == 3 else C_IMP_GOLD_LIGHT
			voxels.append([x, -8, z, col])
			
	# 4. Spiked Golden Sabaton Foot grounded at y = -10 (z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_IMP_GOLD_LIGHT
				if y == -10:
					col = 0x140d09 # Heavy dark steel grounded sole at y = -10 (zero floor clipping!)
				elif z >= 0 and y == -8:
					col = C_IMP_GOLD_GLEAM # Golden articulated instep strap
				voxels.append([x, y, z, col])
				
	# 5. Chunky Toes with Gilded Claws (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_IMP_GOLD_GLEAM if (ty == -9 and tz == 4) else C_IMP_GOLD_LIGHT
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_IMP_GOLD_LIGHT])
		voxels.append([tx, -10, 6, C_IMP_GOLD_GLEAM])
		voxels.append([tx, -10, 7, C_IMP_GOLD_GLEAM])
		voxels.append([tx, -9, 6, C_IMP_GOLD_GLEAM])
		
	return build_seamless_mesh(voxels)


static func build_totem_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_totem_mesh_outfit3()
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

static func build_totem_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# ----------------------------------------------------
	# 1. BASE: OCTAGONAL STEPPED OBSIDIAN & GOLD PLINTH (y: 0..4)
	# ----------------------------------------------------
	for y in range(5):
		var rad = 8 if y == 0 else (7 if y < 3 else (6 if y == 3 else 5))
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) + abs(z) > rad + 3: continue
				var col = C_IMP_EBONY
				if y in [0, 2, 4] or abs(x) + abs(z) >= rad + 2:
					col = C_IMP_GOLD_LIGHT # Polished gold steps
				elif (x * 7 + z * 13 + y * 3) % 5 == 0:
					col = C_IMP_EBONY_LIGHT
				# Glowing solar runic cross channels
				if y == 4 and (abs(x) == 0 or abs(z) == 0) and abs(x) + abs(z) <= 5:
					col = C_GOLD_BRIGHT
				voxels[Vector3i(x, y, z)] = col

	# Four Corner Golden Dragon Talons clutching Ruby Orbs (y: 1..7)
	for corner in [Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1)]:
		for s in range(5):
			var rx = corner.x * (6 - s / 2)
			var rz = corner.y * (6 - s / 2)
			var ry = 1 + s
			voxels[Vector3i(rx, ry, rz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(rx + corner.x, ry - 1, rz)] = C_IMP_GOLD_GLEAM
		# Corner ruby sphere
		voxels[Vector3i(corner.x * 6, 2, corner.y * 6)] = C_RUBY_GLEAM

	# ----------------------------------------------------
	# 2. GILDED OBELISK PILLAR WITH DRAGON RELIEFS (y: 5..38)
	# ----------------------------------------------------
	for y in range(5, 38):
		var rad = 4
		if y in [5, 6]: rad = 5 # Bottom flare
		elif y in [18, 19]: rad = 5 # Mid torc flare
		elif y in [35, 36, 37]: rad = 5 # Crown rim flare
		
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad: continue
				var col = C_IMP_GOLD
				if (x + y * 2 + z) % 4 == 0:
					col = C_IMP_GOLD_LIGHT
				elif (x * 3 + z * 5 + y) % 7 == 0:
					col = C_IMP_GOLD_DARK
				# Center column solar runes
				if (abs(x) == 0 or abs(z) == 0) and y % 3 == 0:
					col = C_GOLD_BRIGHT
				voxels[Vector3i(x, y, z)] = col

	# ----------------------------------------------------
	# 3. LOWER SECTION: GILDED DRAGON MASK & RUBY EYES (y: 8..18)
	# ----------------------------------------------------
	for y in [7, 8]:
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					voxels[Vector3i(x, y, z)] = C_IMP_GOLD_GLEAM

	# 3D Gilded Dragon Face
	for x in range(-3, 4):
		voxels[Vector3i(x, 8, 5)] = C_IMP_GOLD_DARK
		voxels[Vector3i(x, 9, 5)] = C_IMP_GOLD_LIGHT
	# Massive gold tusks
	for side in [-3, 3]:
		voxels[Vector3i(side, 9, 5)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side, 10, 5)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side, 11, 5)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side, 12, 5)] = C_IMP_GOLD_GLEAM

	# Gaping mouth cavity with molten gold core
	for x in range(-2, 3):
		for y in range(9, 12):
			voxels[Vector3i(x, y, 4)] = C_IMP_EBONY
	voxels[Vector3i(0, 10, 4)] = C_GOLD_BRIGHT

	# Upper Snout & Gold Incisors
	for x in range(-3, 4):
		voxels[Vector3i(x, 12, 5)] = C_IMP_GOLD_LIGHT
	for x in [-2, 0, 2]:
		voxels[Vector3i(x, 11, 5)] = C_IMP_GOLD_GLEAM

	# Burning Ruby Eyes
	for side in [-2, 2]:
		voxels[Vector3i(side, 14, 4)] = C_RUBY_GLEAM
		voxels[Vector3i(side + (1 if side < 0 else -1), 14, 4)] = C_RUBY
	# Overhanging Brow
	for x in range(-4, 5):
		voxels[Vector3i(x, 15, 5)] = C_IMP_GOLD_LIGHT
		if abs(x) in [2, 3]:
			voxels[Vector3i(x, 15, 6)] = C_IMP_GOLD_GLEAM

	# Side Gilded Hornlets
	for side in [-1, 1]:
		voxels[Vector3i(side * 5, 14, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 6, 15, 1)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 6, 16, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 5, 17, 0)] = C_IMP_GOLD_LIGHT

	# ----------------------------------------------------
	# 4. MIDDLE SECTION: TIERED GOLD RELIQUARY & RUBY BANNERS (y: 18..24)
	# ----------------------------------------------------
	for y in [19, 20]:
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					var col = C_IMP_GOLD_GLEAM
					if y == 20 and (x == 0 or z == 0):
						col = C_RUBY_GLEAM
					voxels[Vector3i(x, y, z)] = col

	# Left Flank: Dangling Imperial Silk Banner (x = -5, y: 12..18)
	for dy in range(6):
		voxels[Vector3i(-5, 18 - dy, 0)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(-5, 14, 0)] = C_IMP_VELVET
	voxels[Vector3i(-5, 13, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-5, 12, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(-5, 13, 1)] = C_WHITE_SILK

	# Right Flank: Dangling Gold Relic Chains (x = +5, y: 12..18)
	for dy in range(6):
		voxels[Vector3i(5, 18 - dy, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, 14, 0)] = C_RUBY
	voxels[Vector3i(5, 13, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(5, 12, 0)] = C_IMP_GOLD_GLEAM

	# Back Gold Spines
	for sy in range(10, 35, 3):
		voxels[Vector3i(0, sy, -5)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, sy + 1, -5)] = C_IMP_GOLD_LIGHT

	# ----------------------------------------------------
	# 5. UPPER SECTION: GREAT IMPERIAL SUN DEMON SKULL (y: 24..35)
	# ----------------------------------------------------
	for y in range(25, 33):
		for x in range(-4, 5):
			voxels[Vector3i(x, y, 5)] = C_IMP_GOLD_LIGHT
	# Grinning Maw with Gilded Teeth
	for x in range(-3, 4):
		voxels[Vector3i(x, 26, 5)] = C_IMP_EBONY
	voxels[Vector3i(-2, 25, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 25, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(2, 25, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-1, 27, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 27, 5)] = C_IMP_GOLD_GLEAM

	# Cavernous Radiant Solar Eye Sockets (y: 30..32, z: 4..5)
	for side in [-2, 2]:
		voxels[Vector3i(side, 31, 5)] = C_GOLD_BRIGHT
		voxels[Vector3i(side, 31, 4)] = C_LAVA_CORE
		voxels[Vector3i(side + (1 if side < 0 else -1), 31, 5)] = C_IMP_GOLD_DARK
		voxels[Vector3i(side, 30, 5)] = C_IMP_GOLD_DARK
		voxels[Vector3i(side, 32, 5)] = C_IMP_GOLD_DARK

	# Forehead Mystic Ruby Sun (y = 34, x = 0, z = 6)
	voxels[Vector3i(0, 34, 6)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 35, 5)] = C_GOLD_BRIGHT

	# ----------------------------------------------------
	# 6. TOTEM CROWN: IMPERIAL BRAZIER & THICK GOLDEN HORNS (y: 36..48)
	# ----------------------------------------------------
	# Imperial Gold Brazier Rim
	for y in range(36, 39):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 or abs(z) == 5:
					if abs(x) == 5 and abs(z) == 5: continue
					var col = C_IMP_GOLD_GLEAM if y == 37 else C_IMP_GOLD_LIGHT
					voxels[Vector3i(x, y, z)] = col

	# THICK MAJESTIC 3D GOLDEN HORNS (y: 37..48, volumetric 2x2)
	for side in [-1, 1]:
		var horn_pts = [
			Vector3i(side * 5, 37, 0),
			Vector3i(side * 6, 38, 0),
			Vector3i(side * 7, 39, 0),
			Vector3i(side * 8, 41, 1),
			Vector3i(side * 8, 43, 1),
			Vector3i(side * 7, 45, 2),
			Vector3i(side * 6, 46, 2),
			Vector3i(side * 5, 48, 3), # Inward sweeping crown tip!
		]
		for i in range(horn_pts.size()):
			var hp = horn_pts[i]
			var is_band = (i in [2, 5])
			var col = C_IMP_GOLD_GLEAM if is_band else C_IMP_GOLD_LIGHT
			voxels[hp] = col
			voxels[hp + Vector3i(0, -1, 0)] = C_IMP_GOLD_DARK
			voxels[hp + Vector3i(0, 0, -1)] = col
			# Volumetric thickness
			voxels[hp + Vector3i(side * -1, 0, 0)] = col
			if is_band:
				voxels[hp + Vector3i(0, 1, 0)] = C_RUBY_GLEAM

	# COLOSSAL SOLAR SOUL FLAME (Thái Dương Thần Hỏa, y: 38..48)
	for y in range(38, 44):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var d2 = x * x + z * z + (y - 40) * (y - 40)
				if d2 <= 3:
					voxels[Vector3i(x, y, z)] = C_GOLD_BRIGHT # Brilliant core
				elif d2 <= 6:
					voxels[Vector3i(x, y, z)] = C_LAVA_CORE   # Molten mantle
				elif d2 <= 8:
					voxels[Vector3i(x, y, z)] = C_RUBY_GLEAM  # Coronal flare
	# Flickering flame tongues rising high
	voxels[Vector3i(0, 44, 0)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 45, 0)] = C_LAVA_CORE
	voxels[Vector3i(1, 45, 1)] = C_GOLD_BRIGHT
	voxels[Vector3i(-1, 46, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 47, 0)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 48, 0)] = C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)




# --- C. GOBLIN ROGUE (Sát Thủ: Bộ 1 Thô Sơ Dã Nhân & Bộ 2 Sát Thủ Ám Sát) ---

static func build_rogue_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_head_mesh_outfit3()
	elif outfit == 1:
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

# --- HEAD OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (VƯƠNG MIỆN CÁNH ĐẠI BÀNG, MẶT NẠ CỔ NGỮ VÀNG, KHĂN TRÙM NHUNG ĐỎ & DẢI LỤA HOÀNG GIA) ---
static func build_rogue_head_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	# 1. Neck (y: 0..3) with royal crimson velvet gorget & gold mesh
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				var col = C_IMP_VELVET_DARK if y == 0 else C_SKIN
				if y in [1, 2] and (abs(x) == 3 or abs(z) == 3):
					col = C_IMP_GOLD_DARK if (x + z) % 2 == 0 else C_IMP_GOLD
				elif y == 3 and z == 3 and abs(x) <= 1:
					col = C_IMP_GOLD_LIGHT # Throat plate
				elif abs(x) == 3 or abs(z) == 3:
					col = C_IMP_VELVET
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

	# 4. GILDED IMPERIAL VEIL / ASSASSIN FACEPLATE (y: 4..8) - Ebony lacquer with gold runic inlays
	for y in range(4, 9):
		for x in range(-5, 6):
			for z in range(-4, 8):
				if abs(x) == 5 and (z < -2 or z > 5): continue
				var on_mask_surf = (abs(x) == 5 or z == 7 or abs(z) == 4 or y == 4)
				if on_mask_surf:
					var col = C_IMP_EBONY
					# Gold runic filigree and border
					if y == 8 and z == 7:
						col = C_IMP_GOLD_LIGHT # Top rim of mask
					elif y == 4:
						col = C_IMP_GOLD_DARK  # Bottom chin rim
					elif z == 7:
						if x == 0:
							col = C_IMP_GOLD_GLEAM # Center vertical gilded breath-ridge
						elif abs(x) == 2 and y in [5, 6]:
							col = C_IMP_GOLD_LIGHT # Side runic accents
					elif abs(x) == 5 and y in [6, 7]:
						col = C_IMP_GOLD_DARK # Cheek clasp
					voxels[Vector3i(x, y, z)] = col

	# 5. DUAL IMPERIAL VELVET TASSELS & GOLD TEARDROP WEIGHTS (At back of head)
	for ky in [7, 8]:
		for kx in [-1, 0, 1]:
			voxels[Vector3i(kx, ky, -5)] = C_IMP_GOLD_DARK
			voxels[Vector3i(kx, ky, -6)] = C_IMP_VELVET
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 6, -6)] = C_IMP_VELVET
		voxels[Vector3i(side * 2, 5, -6)] = C_IMP_VELVET
		voxels[Vector3i(side * 3, 4, -7)] = C_IMP_VELVET
		voxels[Vector3i(side * 2, 3, -7)] = C_IMP_VELVET_DARK
		voxels[Vector3i(side * 3, 2, -8)] = C_IMP_VELVET
		voxels[Vector3i(side * 2, 1, -8)] = C_IMP_GOLD_LIGHT # Gold tassel collar
		voxels[Vector3i(side * 2, 0, -8)] = C_IMP_GOLD_GLEAM # Gold teardrop bell

	# 6. SHARP GOBLIN NOSE (y: 9..10, z: 7..9)
	for y in range(9, 11):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 7)] = C_SKIN
			voxels[Vector3i(x, y, 8)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 9, 9)] = C_SKIN_LIGHT
	voxels[Vector3i(-1, 9, 7)] = C_SKIN_DARK
	voxels[Vector3i(1, 9, 7)] = C_SKIN_DARK

	# 7. PIERCING PREDATORY RUBY-AMBER EYES (y: 10, z: 6..7)
	voxels[Vector3i(-2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(-3, 10, 6)] = C_RUBY
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(-3, 10, 7)] = C_FEATHER_WHITE
	voxels[Vector3i(2, 10, 6)] = C_EYE_AMBER
	voxels[Vector3i(3, 10, 6)] = C_RUBY
	voxels[Vector3i(2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(3, 10, 7)] = C_FEATHER_WHITE

	# 8. IMPERIAL FALCON DIADEM / ASSASSIN CROWN & COWL (y: 11..18)
	for x in range(-5, 6):
		var b_col = C_IMP_GOLD_LIGHT if abs(x) <= 2 else C_IMP_GOLD
		voxels[Vector3i(x, 11, 6)] = b_col
		if abs(x) <= 4:
			voxels[Vector3i(x, 11, 7)] = b_col
	voxels[Vector3i(0, 11, 8)] = C_IMP_GOLD_GLEAM

	# Imperial Falcon Crest & Forehead Heart Ruby (y: 12..15)
	voxels[Vector3i(0, 12, 7)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, 12, 8)] = C_RUBY_DARK
	voxels[Vector3i(0, 13, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 13, 8)] = C_RUBY
	voxels[Vector3i(0, 13, 9)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 14, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 14, 8)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, 15, 7)] = C_IMP_GOLD_GLEAM

	# Swept Falcon Wings over temples
	for side in [-1, 1]:
		voxels[Vector3i(side * 1, 13, 7)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 2, 13, 7)] = C_IMP_GOLD
		voxels[Vector3i(side * 3, 13, 6)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 4, 14, 5)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 5, 14, 4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 4, 15, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 5, 15, 2)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 6, 16, 1)] = C_IMP_GOLD_GLEAM

	# Imperial Velvet Assassin Hood / Cowl (y: 12..18)
	for y in range(12, 19):
		var rx = 6 if y < 16 else (5 if y < 18 else 4)
		var rz = 5 if y < 16 else (4 if y < 18 else 3)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				var on_hood = (abs(x) == rx or abs(z) == rz or y >= 17)
				if on_hood:
					if voxels.has(Vector3i(x, y, z)): continue
					var col = C_IMP_EBONY
					if y == 12 and z == rz:
						col = C_IMP_GOLD_LIGHT
					elif y >= 17 and abs(x) <= 1:
						col = C_IMP_GOLD_DARK
					elif y % 2 == 0 and abs(z) == rz:
						col = C_IMP_VELVET
					voxels[Vector3i(x, y, z)] = col

	# 9. LONG POINTED GOBLIN EARS WITH CASCADING IMPERIAL GOLD HOOPS
	for side in [-1, 1]:
		for s in range(11):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.35)
			var ez = -int(float(s) * 0.7)
			var h_half = 2 if s < 4 else (1 if s < 8 else 0)
			
			for dy in range(-h_half, h_half + 1):
				var e_col = C_SKIN
				if dy == h_half: e_col = C_SKIN_LIGHT
				elif dy == -h_half: e_col = C_SKIN_DARK
				voxels[Vector3i(ex, ey + dy, ez)] = e_col
				
				if s >= 1 and s <= 5 and abs(dy) <= 1:
					voxels[Vector3i(ex, ey + dy, ez + 1)] = C_EAR_INNER
					
			if s == 2 or s == 4 or s == 6:
				voxels[Vector3i(ex, ey + h_half, ez)] = C_IMP_GOLD_LIGHT
				voxels[Vector3i(ex, ey + h_half + 1, ez)] = C_IMP_GOLD_GLEAM
				voxels[Vector3i(ex, ey + h_half, ez - 1)] = C_IMP_GOLD_DARK
				if s == 4:
					voxels[Vector3i(ex, ey + h_half + 2, ez)] = C_RUBY

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_rogue_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_torso_mesh_outfit3()
	elif outfit == 1:
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

# --- TORSO OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (GIÁP NGỰC VÀNG RÒNG ĐA TẦNG, GIÁP VAI CÁNH ƯNG, DẢI LỤA HOÀNG GIA & BÌNH ĐỘC DƯỢC THIÊN THỂ) ---
static func build_rogue_torso_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(18):
		var rx = 7 if y < 14 else 6
		var rz = 5 if y < 14 else 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				
				# 1. High Neck Gorget & Velvet Collar (y >= 15)
				if y >= 15:
					if abs(x) <= 3 and abs(z) <= 3:
						voxels.append([x, y, z, C_SKIN_DARK])
					elif abs(x) <= 4 and abs(z) <= 4:
						voxels.append([x, y, z, C_IMP_VELVET])
					else:
						voxels.append([x, y, z, C_IMP_GOLD_LIGHT])
					continue
				
				# 2. Imperial Sash & Sunburst Belt (y: 3..5)
				if y >= 3 and y <= 5 and (abs(x) == rx or abs(z) == rz):
					var b_col = C_IMP_VELVET
					if y == 4 and x == 0 and z == rz:
						b_col = C_IMP_GOLD_GLEAM # Sunburst buckle
					elif y == 4 and abs(x) == 1 and z == rz:
						b_col = C_IMP_GOLD_LIGHT # Buckle wing
					elif y == 4 and abs(x) == 2 and z == rz:
						b_col = C_RUBY           # Ruby gem in belt
					elif y == 3 and z == rz and abs(x) <= 2:
						b_col = C_IMP_GOLD_DARK  # Hanging gold chains
					voxels.append([x, y, z, b_col])
					continue
					
				# 3. Right Hip: Twin Celestial Alchemy Phials in Gilded Cages (x == rx)
				if x == rx and y in [3, 4, 5] and z in [0, 1]:
					var vial_col = C_GEM_CYAN_GLOW if (y in [3, 4] and z == 1) else C_IMP_GOLD_LIGHT
					voxels.append([x + 1, y, z, vial_col])
					if y == 5:
						voxels.append([x + 1, y + 1, z, C_IMP_GOLD_GLEAM]) # Gold stopper
					continue
					
				# 4. Left Hip: Ornate Royal Velvet Lockpick Pouch (x == -rx)
				if x == -rx and y in [3, 4, 5] and z in [0, 1]:
					var pouch_col = C_RUBY if (y == 4 and z == 1) else (C_IMP_GOLD_LIGHT if y == 5 else C_IMP_VELVET)
					voxels.append([x - 1, y, z, pouch_col])
					continue
				
				# 5. Crossed Imperial Gilded Bandoliers with Throwing Daggers (y: 6..14)
				var is_bandolier1 = (abs(float(y) - (-1.1 * float(x) + 10.0)) <= 1.0) and (z == rz or z == -rz)
				var is_bandolier2 = (abs(float(y) - (1.1 * float(x) + 10.0)) <= 1.0) and (z == rz or z == -rz)
				if is_bandolier1 or is_bandolier2:
					if y == 10 and x == 0 and z == rz:
						voxels.append([x, y, z, C_RUBY]) # Central crossing ruby medallion
					elif abs(x) in [2, 4] and y in [8, 12] and z == rz:
						voxels.append([x, y, z, C_IMP_GOLD_GLEAM]) # Gold rivets
					else:
						voxels.append([x, y, z, C_IMP_GOLD_LIGHT])
					continue
					
				# Mounted Gilded Throwing Daggers on chest
				if x in [-3, -2] and y in [11, 12, 13] and z == rz:
					var dag_col = C_RUBY if y == 13 else C_IMP_GOLD_GLEAM
					voxels.append([x, y, z + 1, dag_col])
					continue
				if x in [2, 3] and y in [11, 12, 13] and z == rz:
					var dag_col2 = C_RUBY if y == 13 else C_IMP_GOLD_GLEAM
					voxels.append([x, y, z + 1, dag_col2])
					continue
					
				# 6. Imperial Golden Shadow Cuirass & Falcon Wing Pauldrons
				var col = C_IMP_GOLD
				if z == rz: # Front Chest
					if y in [12, 13] and abs(x) <= 2:
						col = C_IMP_GOLD_GLEAM # Upper pectoral gold highlight
					elif y in [10, 11] and abs(x) <= 1:
						col = C_IMP_GOLD_LIGHT
					elif y in [6, 7, 8, 9]:
						# Segmented abdominal lobster-plates
						col = C_IMP_GOLD_LIGHT if y % 2 == 0 else C_IMP_GOLD_DARK
					else:
						col = C_IMP_GOLD
				elif z == -rz: # Back plate
					col = C_IMP_GOLD_DARK if y % 2 == 1 else C_IMP_GOLD
				elif abs(x) == rx: # Flanks
					col = C_IMP_VELVET if y in [6, 7, 8, 9] else C_IMP_GOLD
				else:
					col = C_IMP_GOLD
					
				voxels.append([x, y, z, col])
				
	# 7. Layered Golden Falcon Wing Pauldrons (x: ±(7..9), y: 13..16, z: -2..3)
	for side in [-1, 1]:
		for py in range(13, 17):
			for pz in range(-2, 4):
				var px = side * 7
				var p_col = C_IMP_GOLD_LIGHT
				if py == 16: p_col = C_IMP_GOLD_GLEAM
				elif py == 14 and pz == 1: p_col = C_RUBY
				voxels.append([px, py, pz, p_col])
				if py in [14, 15] and pz in [0, 1, 2]:
					voxels.append([side * 8, py, pz, C_IMP_GOLD_GLEAM])
				if py == 15 and pz in [0, 1]:
					voxels.append([side * 9, py, pz, C_IMP_GOLD_GLEAM])
					
	return build_seamless_mesh(voxels)

static func build_rogue_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_upper_arm_mesh_outfit3()
	elif outfit == 1:
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

# --- UPPER ARM OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (GIÁP BẮP TAY VÀNG RÒNG & ỐNG TAY ÁO NHUNG HOÀNG GIA) ---
static func build_rogue_upper_arm_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -4 else 2
		var rz = 3 if y > -4 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_SKIN
				if y >= -2 and (abs(x) == rx or abs(z) == rz):
					col = C_IMP_VELVET
				elif (y in [-6, -5, -4, -3]) and (abs(x) == rx or abs(z) == rz):
					if y == -4 and (abs(x) == rx or z == rz):
						col = C_IMP_GOLD_GLEAM
					elif y % 2 == 0:
						col = C_IMP_GOLD_LIGHT
					else:
						col = C_IMP_GOLD
				elif y == -7 and (abs(x) == rx or abs(z) == rz):
					col = C_IMP_GOLD_DARK
				elif y <= -8:
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_rogue_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_forearm_mesh_outfit3(is_right)
	elif outfit == 1:
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

# --- FOREARM OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (HỘ THỦ VÀNG NẠM HỒNG NGỌC & GĂNG TAY THÍCH KHÁCH BỌC VUỐT VÀNG) ---
static func build_rogue_forearm_mesh_outfit3(is_right: bool) -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_SKIN
				# Articulated Vambrace (y: -6..-2)
				if y >= -6 and y <= -2:
					if z == -2:
						if y == -4 and x == 0:
							col = C_RUBY # Outer wrist ruby gem
						elif abs(x) == 1 and y == -4:
							col = C_IMP_GOLD_GLEAM # Gem socket
						elif x == 0:
							col = C_IMP_EBONY # Hidden blade channel track
						else:
							col = C_IMP_GOLD_LIGHT
					elif abs(x) == 2 or z == 2:
						col = C_IMP_GOLD if y % 2 == 0 else C_IMP_GOLD_LIGHT
				elif y == -7:
					col = C_IMP_GOLD_LIGHT # Wrist cuff ring
				elif y <= -8:
					if z == 2:
						col = C_IMP_GOLD_GLEAM if y == -9 else C_IMP_GOLD_LIGHT
					elif z == -2:
						col = C_IMP_EBONY if y == -9 else C_IMP_VELVET
					else:
						col = C_IMP_EBONY
				voxels.append([x, y, z, col])
				
	var thumb_x = 2 if not is_right else -2
	voxels.append([thumb_x, -7, 1, C_IMP_EBONY])
	voxels.append([thumb_x, -8, 2, C_IMP_GOLD_GLEAM])
	return build_seamless_mesh(voxels)

static func build_rogue_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_thigh_mesh_outfit3()
	elif outfit == 1:
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

# --- THIGH OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (QUẦN NHUNG ĐỎ ĐÍNH VIỀN VÀNG & GIÁP GỐI VÀNG RÒNG) ---
static func build_rogue_thigh_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	for y in range(-9, 1):
		var rx = 3 if y > -5 else 2
		var rz = 3 if y > -5 else 2
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var col = C_IMP_VELVET if y >= -6 else C_IMP_VELVET_DARK
				if abs(x) == rx and z == 0 and y >= -5:
					col = C_IMP_GOLD_LIGHT
				if y in [-8, -7] and (abs(x) == rx or abs(z) == rz):
					if z == rz:
						col = C_IMP_GOLD_GLEAM if (y == -7 and x == 0) else C_IMP_GOLD_LIGHT
					else:
						col = C_IMP_GOLD_DARK
				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_rogue_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_rogue_shin_mesh_outfit3()
	elif outfit == 1:
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

# --- SHIN OUTFIT 3: HOÀNG KIM ĐẾ QUỐC (XÀ CẠP VÀNG RÒNG, ỦNG THÍCH KHÁCH MŨI VÀNG CÓ CỰA LEO TRÈO) ---
static func build_rogue_shin_mesh_outfit3() -> ArrayMesh:
	var voxels = []
	# 1. Muscular Shin with Golden Greave (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_IMP_VELVET_DARK
				if z in [1, 2]:
					if z == 2 and x == 0:
						col = C_IMP_GOLD_GLEAM
					elif y == -4 and z == 2 and abs(x) == 1:
						col = C_RUBY
					else:
						col = C_IMP_GOLD_LIGHT if y % 2 == 0 else C_IMP_GOLD
				elif abs(x) == 2:
					col = C_IMP_GOLD_DARK
				voxels.append([x, y, z, col])
				
	# 2. Articulated Ankle Guard (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var a_col = C_IMP_GOLD_LIGHT if y == -6 else C_IMP_GOLD_DARK
				voxels.append([x, y, z, a_col])
				
	# 3. Flared Ankle (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			voxels.append([x, -8, z, C_IMP_EBONY])
			
	# 4. Gilded Assassin Boot Body (y: -10 to -7)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue
				var col = C_IMP_EBONY
				if y == -10:
					col = 0x120c08
				elif z >= 1 and y == -9:
					col = C_IMP_GOLD_LIGHT
				elif z == -3 and y == -10:
					col = C_IMP_GOLD_GLEAM
				voxels.append([x, y, z, col])
				
	# 5. Gilded Eagle-Talon Pointed Toe Caps (z: 4 to 7)
	for tx in [-2, 0, 2]:
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_IMP_GOLD_LIGHT if (ty == -9 and tz == 4) else C_IMP_EBONY
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_IMP_EBONY])
		voxels.append([tx, -10, 6, C_IMP_GOLD_GLEAM])
		voxels.append([tx, -10, 7, C_IMP_GOLD_GLEAM])
		voxels.append([tx, -9, 6, C_IMP_GOLD_LIGHT])
		
	return build_seamless_mesh(voxels)

static func build_dagger_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_dagger_mesh_outfit3()
	elif outfit == 1:
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

# --- WEAPON OUTFIT 3: HOÀNG KIM THẦN ĐOẢN KIẾM / IMPERIAL DRAGON-WING SOVEREIGN DAGGERS ---
static func build_dagger_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}
	
	# 1. SCULPTED DRAGON/EAGLE HEAD GOLDEN POMMEL WITH RUBY EYE (y: -7..-5)
	voxels[Vector3i(0, -7, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -7, 1)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, -7, -1)] = C_IMP_GOLD_LIGHT
	
	for y in range(-6, -4):
		voxels[Vector3i(0, y, 0)] = C_IMP_GOLD
		voxels[Vector3i(1, y, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(-1, y, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(0, y, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(0, y, -1)] = C_IMP_GOLD_DARK
		
	# Piercing glowing ruby eye in pommel!
	voxels[Vector3i(1, -5, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(-1, -5, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(0, -5, 2)] = C_IMP_GOLD_GLEAM

	# 2. SPIRAL EBONY WOOD GRIP WITH TWISTED GOLD WIRE WRAP (y: -4..0)
	for y in range(-4, 1):
		var is_wire = (y % 2 == 0)
		var w_col = C_IMP_GOLD_LIGHT if is_wire else C_IMP_EBONY
		var side_col = C_IMP_GOLD_GLEAM if is_wire else C_IMP_EBONY_LIGHT
		voxels[Vector3i(0, y, 0)] = w_col
		voxels[Vector3i(0, y, 1)] = side_col
		voxels[Vector3i(0, y, -1)] = C_IMP_EBONY
		voxels[Vector3i(1, y, 0)] = side_col if is_wire else C_IMP_EBONY
		voxels[Vector3i(-1, y, 0)] = side_col if is_wire else C_IMP_EBONY

	# 3. SWEPT-FORWARD FALCON-WING CROSSGUARD WITH FACETED HEART RUBY (y: 1..2, x: -4..4)
	voxels[Vector3i(0, 1, 0)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, 1, 1)] = C_RUBY
	voxels[Vector3i(0, 1, 2)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 1, -1)] = C_IMP_GOLD_DARK
	voxels[Vector3i(0, 2, 0)] = C_IMP_GOLD_GLEAM
	
	for x in [-3, -2, -1, 1, 2, 3]:
		voxels[Vector3i(x, 1, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(x, 1, 1)] = C_IMP_GOLD
		voxels[Vector3i(x, 1, -1)] = C_IMP_GOLD_DARK
		
	for side in [-1, 1]:
		voxels[Vector3i(side * 4, 1, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 4, 2, 1)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 3, 2, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 4, 3, 2)] = C_IMP_GOLD_GLEAM

	# 4. SERRATED RECURVED IMPERIAL DAMASCUS BLADE WITH GLOWING SOUL-ENERGY FULLER (y: 2..15)
	for y in range(2, 16):
		var curve_z = int(float(y - 2) * 0.35)
		
		voxels[Vector3i(0, y, curve_z)] = C_IMP_GOLD_LIGHT if y % 2 == 0 else C_IMP_GOLD
		voxels[Vector3i(0, y, curve_z - 1)] = C_IMP_GOLD_DARK
		
		if y >= 3 and y <= 13:
			voxels[Vector3i(0, y, curve_z)] = C_GEM_CYAN_GLOW
			
		var is_barb = (y in [3, 5, 7, 9, 11, 13])
		var edge_col = C_IMP_GOLD_GLEAM if is_barb else C_STEEL_BRIGHT
		voxels[Vector3i(0, y, curve_z + 1)] = edge_col
		
		if is_barb and y < 14:
			voxels[Vector3i(0, y - 1, curve_z + 2)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(0, y, curve_z + 2)] = C_IMP_GOLD_GLEAM

	# 5. DIAMOND-HONED NEEDLE APEX & CELESTIAL PIERCING TIP (y: 15..17)
	voxels[Vector3i(0, 15, 4)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, 15, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 16, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 16, 6)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 17, 6)] = C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# --- D. MACE OGRE (Boss Ogre Cầm Chùy Nguyên Thủy, Da Thú Xù Lông, Đại Chùy Đá Gai) ---

# =============================================================================
# MACE OGRE OUTFIT 2: THIẾT GIÁP MA THÚ (IRON JUGGERNAUT FULL HEAVY ARMOR)
# =============================================================================

static func build_ogre_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_head_mesh_outfit3()
	if outfit == 2:
		return build_ogre_head_mesh_outfit2()
	return build_ogre_head_mesh_outfit1()

static func build_ogre_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_torso_mesh_outfit3()
	if outfit == 2:
		return build_ogre_torso_mesh_outfit2()
	return build_ogre_torso_mesh_outfit1()

static func build_ogre_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_upper_arm_mesh_outfit3()
	if outfit == 2:
		return build_ogre_upper_arm_mesh_outfit2()
	return build_ogre_upper_arm_mesh_outfit1()

static func build_ogre_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_forearm_mesh_outfit3(is_right)
	if outfit == 2:
		return build_ogre_forearm_mesh_outfit2(is_right)
	return build_ogre_forearm_mesh_outfit1(is_right)

static func build_ogre_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_thigh_mesh_outfit3()
	if outfit == 2:
		return build_ogre_thigh_mesh_outfit2()
	return build_ogre_thigh_mesh_outfit1()

static func build_ogre_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_shin_mesh_outfit3()
	if outfit == 2:
		return build_ogre_shin_mesh_outfit2()
	return build_ogre_shin_mesh_outfit1()

static func build_ogre_mace_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_mace_mesh_outfit3()
	if outfit == 2:
		return build_ogre_mace_mesh_outfit2()
	return build_ogre_mace_mesh_outfit1()

static func build_ogre_cape_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_ogre_cape_mesh_outfit3()
	return null

# =============================================================================
# MACE OGRE OUTFIT 3: ĐẠI CHIẾN TƯỚNG HOÀNG KIM (IMPERIAL GOLDEN TITAN OGRE)
# =============================================================================

static func build_ogre_head_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Muscular Neck with Imperial Gorget & White Ermine Fur Collar (y: 0..3)
	for y in range(4):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 and abs(z) == 5: continue
				var col = C_SKIN
				if y in [0, 1]:
					# Solid Imperial Gold gorget base with polished obsidian trim
					if abs(x) == 5 or abs(z) == 5:
						col = C_IMP_EBONY if y == 0 else C_IMP_GOLD_GLEAM
					elif abs(x) in [3, 4] and y == 1:
						col = C_WHITE_SILK # Ermine fur lining peeking out
					else:
						col = C_IMP_GOLD_LIGHT
				else:
					# Muscular green ogre neck
					if z >= 2:
						col = C_SKIN_PALE if y == 2 else C_SKIN
					elif z <= -3:
						col = C_IMP_GOLD_DARK # Rear golden neckplate
					elif abs(x) >= 4:
						col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Center Throat Radiant Ruby Medallion
	voxels[Vector3i(0, 1, 5)] = C_RUBY_GLEAM
	voxels[Vector3i(-1, 1, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 1, 5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 0, 5)] = C_RUBY_DARK

	# 2. Brutal Jutting Ogre Jaw & Underbite with Solid Gold Imperial Cheekplates (y: 4..8)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(-5, 9):
				if (abs(x) >= 5 and z <= -4) or (abs(x) >= 5 and z >= 7): continue
				if abs(x) == 6 and (z <= -2 or z >= 5): continue
				if y == 4 and abs(x) >= 5 and abs(z) >= 5: continue
				if y == 8 and z >= 7 and abs(x) >= 5: continue

				# Open snarling mouth gap
				if y in [6, 7] and abs(x) <= 3 and z >= 8: continue
				if y == 7 and abs(x) <= 2 and z == 7:
					voxels[Vector3i(x, y, z)] = C_MOUTH_DARK
					continue

				var col = C_SKIN
				if y == 4:
					col = C_SKIN_DARK
				elif abs(x) <= 3 and z in [3, 4, 5, 6] and y in [5, 6, 7]:
					col = C_MOUTH_DARK
					if y == 5 and abs(x) <= 1 and z in [4, 5]:
						col = C_WARRIOR_RED_DARK # Tongue
				elif z >= 6:
					col = C_SKIN_LIGHT if (y == 5 or y == 6) else C_SKIN
				# Flared Imperial Golden Dragon Cheekplates
				elif abs(x) in [5, 6] and z in [-1, 0, 1, 2, 3]:
					if abs(x) == 6 and z in [-1, 3]:
						col = C_IMP_EBONY
					elif y in [4, 8]:
						col = C_IMP_GOLD_GLEAM
					else:
						col = C_IMP_GOLD_LIGHT
					if z == 1 and y == 6: col = C_RUBY_GLEAM # Ruby stud
				elif abs(x) == 5:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# Colossal Gold-Capped Lower Boar Tusks (y: 6..11, x: +-3, z: 8..9)
	for side in [-1, 1]:
		voxels[Vector3i(side * 3, 6, 8)] = C_IMP_GOLD_DARK # Gold socket collar
		voxels[Vector3i(side * 3, 7, 8)] = C_BONE
		voxels[Vector3i(side * 3, 8, 8)] = C_BONE
		voxels[Vector3i(side * 3, 9, 8)] = C_IMP_GOLD_LIGHT # Solid Gold ferrule
		voxels[Vector3i(side * 3, 10, 8)] = C_IMP_GOLD_GLEAM # Radiant diamond tip
		voxels[Vector3i(side * 3, 11, 8)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 2, 6, 8)] = C_TEETH
		voxels[Vector3i(side * 1, 6, 8)] = C_TEETH

	# 3. Mid-Face, Snout & Fierce Burning Eyes (y: 9..11)
	for y in range(9, 12):
		var rx = 6 if y == 9 else 5
		var rz = 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 2):
				if abs(x) >= rx and abs(z) >= rz: continue
				if abs(x) == 6 and (z <= -3 or z >= 4): continue
				if y == 10 and abs(x) in [2, 3] and z >= 6: continue
				if y == 11 and z >= 6: continue

				var col = C_SKIN
				if z >= 4:
					col = C_SKIN_DARK if y == 9 else C_SKIN
				elif abs(x) == rx:
					col = C_IMP_GOLD_LIGHT # Temple plate
				voxels[Vector3i(x, y, z)] = col

	# Snout & Gold War-Markings
	for z in range(6, 9):
		voxels[Vector3i(-1, 9, z)] = C_SKIN_LIGHT
		voxels[Vector3i(0, 9, z)] = C_IMP_GOLD_LIGHT # Golden war stripe down snout
		voxels[Vector3i(1, 9, z)] = C_SKIN_LIGHT
	voxels[Vector3i(0, 10, 6)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-1, 9, 8)] = C_SKIN_DARK
	voxels[Vector3i(1, 9, 8)] = C_SKIN_DARK

	# Burning Radiant Amber/Lava Eyes under heavy golden brow
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 5)] = C_EYE_PUPIL
		voxels[Vector3i(side * 3, 10, 5)] = C_LAVA_HOT
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_LAVA_HOT

	# 4. IMPERIAL DRAGON TITAN WAR CROWN (VƯƠNG MIỆN LONG VƯƠNG HOÀNG KIM) (y: 12..26)
	# Brow Armor Visor (y: 11..13, z: 6..8) - Solid Imperial Gold with Obsidian & Ruby
	for x in range(-5, 6):
		voxels[Vector3i(x, 12, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(x, 12, 7)] = C_IMP_GOLD_GLEAM if abs(x) <= 3 else C_IMP_EBONY
		voxels[Vector3i(x, 13, 6)] = C_IMP_GOLD_LIGHT
	# Center Crown Royal Gem on Forehead
	voxels[Vector3i(0, 13, 7)] = C_RUBY_GLEAM
	voxels[Vector3i(-1, 13, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 13, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 14, 7)] = C_RUBY
	voxels[Vector3i(0, 15, 7)] = C_IMP_GOLD_GLEAM

	# Crown Circlet & Helmet Skull Carapace (y: 12..18)
	for y in range(12, 19):
		var hrx = 6 if y <= 15 else (5 if y <= 17 else 4)
		var hrz = 5 if y <= 16 else 4
		for x in range(-hrx, hrx + 1):
			for z in range(-hrz, hrz + 1):
				if abs(x) == hrx and abs(z) == hrz: continue
				var col = C_IMP_GOLD
				if abs(x) == 0:
					col = C_IMP_GOLD_GLEAM # Center golden spine
				elif abs(x) in [2, 4] and z in [-2, 0, 2]:
					col = C_IMP_EBONY # Contrasting obsidian inlay
				elif y in [12, 18]:
					col = C_IMP_GOLD_GLEAM
				else:
					col = C_IMP_GOLD_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# 5 TOWERING DRAGON CROWN SPIRES (Rising from y: 16 to 24)
	# Central Spire (Highest, x: 0, z: 5..6, y: 16..24)
	for cy in range(16, 25):
		voxels[Vector3i(0, cy, 6)] = C_IMP_GOLD_GLEAM if cy >= 22 else C_IMP_GOLD_LIGHT
		if cy in [18, 19, 20]:
			voxels[Vector3i(0, cy, 7)] = C_RUBY_GLEAM
		else:
			voxels[Vector3i(0, cy, 7)] = C_IMP_GOLD_GLEAM
	# Flanking Mid Spires (x: +-2, z: 5..6, y: 16..21)
	for side in [-1, 1]:
		for cy in range(16, 22):
			voxels[Vector3i(side * 2, cy, 6)] = C_IMP_GOLD_GLEAM if cy >= 20 else C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 2, 18, 6)] = C_RUBY_GLEAM
	# Outer Spires (x: +-4, z: 4..5, y: 15..19)
	for side in [-1, 1]:
		for cy in range(15, 20):
			voxels[Vector3i(side * 4, cy, 5)] = C_IMP_GOLD_GLEAM if cy >= 18 else C_IMP_GOLD_LIGHT

	# Spiked Dorsal Mohawk Crest running down back of helmet
	for y in range(13, 21):
		voxels[Vector3i(0, y, -6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(0, y, -7)] = C_IMP_GOLD_GLEAM
		if y in [14, 16, 18, 20]:
			voxels[Vector3i(0, y, -8)] = C_IMP_GOLD_GLEAM # Extended crest spikes
			voxels[Vector3i(0, y, -9)] = C_IMP_GOLD_GLEAM

	# COLOSSAL SWEPT-BACK DRAGON HORNS (y: 13..27, x: +-6..+-14, z: 2..-8)
	for side in [-1, 1]:
		# Horn Root Crown Cuffs with Inlaid Rubies
		for hy in [13, 14, 15]:
			voxels[Vector3i(side * 6, hy, 2)] = C_IMP_EBONY
			voxels[Vector3i(side * 7, hy, 2)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(side * 7, hy, 1)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(side * 7, hy, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 8, 14, 2)] = C_RUBY_GLEAM

		# Swept Dragon Horn Arching Back and Up
		for hy in range(16, 27):
			var step = hy - 16
			var hx = side * (8 + int(step * 0.55))
			var hz = 2 - int(step * 0.95)
			voxels[Vector3i(hx, hy, hz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(hx, hy, hz + 1)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(hx - side, hy, hz)] = C_IMP_EBONY if hy < 21 else C_IMP_GOLD_LIGHT
			# Serrated Dragon Horn Spikes along top edge
			if hy in [17, 19, 21, 23, 25]:
				voxels[Vector3i(hx, hy + 1, hz)] = C_IMP_GOLD_GLEAM
			if hy >= 25:
				voxels[Vector3i(hx, hy, hz)] = C_IMP_GOLD_GLEAM
				voxels[Vector3i(hx, hy + 1, hz - 1)] = C_IMP_GOLD_GLEAM # Razor needle tip

	# Imperial Warlord War-Braids (x: +-4, y: 0..8, z: -5)
	for side in [-1, 1]:
		for by in range(0, 9):
			var col = C_HAIR
			if by in [2, 5, 8]: col = C_IMP_GOLD_GLEAM # Golden braid clasps!
			voxels[Vector3i(side * 4, by, -5)] = col
			voxels[Vector3i(side * 4, by, -6)] = col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_torso_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Muscular Body Core (y: 0..17, rx: 7..9, rz: 6..7)
	for y in range(18):
		var rx = 7 if y <= 3 else (9 if y <= 13 else 8)
		var rz = 6 if y <= 3 else (7 if y <= 13 else 6)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue

				var col = C_SKIN
				if abs(x) == rx and z in [-2, -1, 0, 1, 2] and y in range(4, 15):
					if y in [5, 8, 11, 14]:
						col = C_IMP_VELVET
						if abs(x) == rx and z == 0: col = C_IMP_GOLD_GLEAM
					else:
						col = C_SKIN_DARK
				elif z <= -rz + 1:
					col = C_IMP_EBONY # Dread iron back frame
				elif y <= 3:
					col = C_IMP_EBONY
				elif z >= 2:
					col = C_SKIN
				else:
					col = C_IMP_EBONY
				voxels[Vector3i(x, y, z)] = col

	# 2. FORTRESS GORGET & HIGH RAISED NECK COLLAR WITH ERMINE FUR LINING (y: 16..21, z: 3..8)
	for y in range(16, 22):
		for x in range(-6, 7):
			for z in range(3, 9):
				if abs(x) >= 5 and z <= 4: continue
				var col = C_IMP_GOLD_LIGHT
				if y in [20, 21] and z >= 7:
					col = C_IMP_GOLD_GLEAM # Golden rim
				elif abs(x) in [3, 4] and y in [18, 19] and z >= 6:
					col = C_WHITE_SILK # Luxurious ermine fur peeking over gorget
				elif abs(x) == 0 and z >= 6:
					col = C_IMP_GOLD_GLEAM # Center keel
				voxels[Vector3i(x, y, z)] = col

	# 3. VOLUMETRIC IMPERIAL GOLDEN CUIRASS (Thick 3D relief jutting forward to z: 8..11!)
	for y in range(8, 16):
		for x in range(-8, 9):
			for z in range(7, 11):
				if abs(x) >= 7 and z >= 9: continue
				if y in [8, 15] and z >= 10: continue

				var col = C_IMP_GOLD_LIGHT
				# Outer frame: Polished Obsidian with Gold Corner Studs
				var is_frame = (abs(x) >= 6 or y in [8, 15] or z == 7)
				if is_frame:
					if abs(x) == 6 or y in [8, 15]:
						col = C_IMP_EBONY
					else:
						col = C_IMP_GOLD_DARK
					# Gold Rivets
					if (abs(x) == 6 and y in [9, 14] and z == 8):
						col = C_IMP_GOLD_GLEAM
				else:
					# Sculpted Radiant Golden Pectoral Plates
					if x == 0:
						col = C_IMP_GOLD_GLEAM # Center keel ridge
					elif abs(x) in [1, 2, 3]:
						col = C_IMP_GOLD_GLEAM if z >= 10 else C_IMP_GOLD_LIGHT
					else:
						col = C_IMP_GOLD
				voxels[Vector3i(x, y, z)] = col

	# 4. COLOSSAL SUNBURST HEART OF THE EMPIRE RUBY (z: 11, y: 12..14)
	voxels[Vector3i(0, 13, 11)] = C_RUBY_GLEAM
	voxels[Vector3i(-1, 13, 11)] = C_RUBY
	voxels[Vector3i(1, 13, 11)] = C_RUBY
	voxels[Vector3i(0, 14, 11)] = C_RUBY_DARK
	voxels[Vector3i(0, 12, 11)] = C_RUBY_DARK
	# 8 Radiating Golden Sun Claws around ruby in high relief
	voxels[Vector3i(-2, 13, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(2, 13, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 15, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, 11, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-1, 14, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 14, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-1, 12, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 12, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-3, 13, 11)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(3, 13, 11)] = C_IMP_GOLD_LIGHT

	# 5. ARTICULATED ABDOMINAL PLATES (y: 4..8, z: 8..10)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(8, 10):
				if abs(x) >= 5 and z >= 9: continue
				var col = C_IMP_GOLD
				if y in [4, 6, 8]:
					col = C_IMP_EBONY # Shadow separation grooves
				elif abs(x) <= 3:
					col = C_IMP_GOLD_LIGHT if z == 9 else C_IMP_GOLD_GLEAM
				else:
					col = C_IMP_GOLD
				voxels[Vector3i(x, y, z)] = col

	# 6. MANTLE FUR COLLAR & TWIN IMPERIAL DRAGON CLASPS (y: 15..19, z: -9..-6)
	# Upper Mantle Ermine Fur Trim across shoulders (y: 15..18, z: -7..-9)
	for y in range(15, 19):
		for x in range(-7, 8):
			for z in range(-9, -6):
				if abs(x) >= 6 and z <= -8: continue
				var fur_col = C_WHITE_SILK if (x + y + z) % 3 != 0 else C_WHITE_SILK_SHADOW
				voxels[Vector3i(x, y, z)] = fur_col

	# Twin Imperial Dragon Shoulder Brooches / Clasps (Where the cape is mounted!)
	for side in [-1, 1]:
		for bx in range(3, 6):
			for by in range(15, 18):
				voxels[Vector3i(side * bx, by, -7)] = C_IMP_GOLD_LIGHT
				voxels[Vector3i(side * bx, by, -8)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 4, 16, -9)] = C_RUBY_GLEAM # Ruby gem in center of clasp
		voxels[Vector3i(side * 4, 15, -8)] = C_IMP_GOLD_GLEAM # Mounting ring hook

	# Heavy Ornamental Golden Chain connecting the two clasps
	for cx in range(-3, 4):
		voxels[Vector3i(cx, 16, -7)] = C_IMP_GOLD_LIGHT
		if abs(cx) in [0, 2]:
			voxels[Vector3i(cx, 16, -8)] = C_IMP_GOLD_GLEAM

	# Segmented Back Plates & Spine Armor (visible beneath the suspended cape)
	for y in range(4, 15):
		for x in range(-5, 6):
			if abs(x) == 5 and y in [4, 14]: continue
			var col = C_IMP_EBONY
			if x == 0:
				col = C_IMP_GOLD_GLEAM # Raised spinal keel
			elif abs(x) in [1, 2] and y in [6, 9, 12]:
				col = C_IMP_GOLD_LIGHT # Riveted reinforcement bands
			elif abs(x) == 4:
				col = C_IMP_GOLD_DARK
			voxels[Vector3i(x, y, -7)] = col

	# 7. COLOSSAL DRAGON FORTRESS PAULDRONS (BOTH Shoulders: x = +-8..+-16, y: 12..26)
	for side in [-1, 1]:
		# Tier 1 Base Under-Pauldron of Polished Obsidian (y: 12..17, x: 8..11)
		for y in range(12, 18):
			for dx in range(8, 12):
				for z in range(-6, 7):
					voxels[Vector3i(side * dx, y, z)] = C_IMP_EBONY

		# Tier 2 Flared Mid Fortress Wing with Gold Plates & Rubies (y: 15..21, x: 10..15)
		for y in range(15, 22):
			for dx in range(10, 16):
				for z in range(-6, 7):
					if abs(z) >= 5 and dx >= 14: continue
					var col = C_IMP_GOLD_LIGHT
					if dx in [10, 15] or abs(z) in [5, 6] or y in [15, 21]:
						col = C_IMP_EBONY # Contrasting frame
					elif dx == 14 and abs(z) <= 3:
						col = C_IMP_GOLD_GLEAM # Beveled wing ridge
					voxels[Vector3i(side * dx, y, z)] = col

		# Giant Inlaid Ruby & Gold Sunburst on Pauldron Face
		voxels[Vector3i(side * 15, 18, 0)] = C_RUBY_GLEAM
		voxels[Vector3i(side * 15, 18, -1)] = C_RUBY
		voxels[Vector3i(side * 15, 18, 1)] = C_RUBY
		voxels[Vector3i(side * 15, 19, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 15, 17, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 14, 18, 0)] = C_IMP_GOLD_GLEAM

		# Fore/Aft Battering Ram Spikes on Pauldron (+-Z)
		for sz in [-1, 1]:
			for dz in range(7, 11):
				voxels[Vector3i(side * 12, 17, sz * dz)] = C_IMP_GOLD_GLEAM if dz >= 9 else C_IMP_GOLD_LIGHT

		# Tier 3 COLOSSAL UPWARD-CURVING TITAN HORNS ON SHOULDER (y: 20..27, x: 12..16)
		for sy in range(20, 28):
			var sx = side * (12 + (sy - 20) / 2)
			var sz = (sy - 20) / 3
			voxels[Vector3i(sx, sy, sz)] = C_IMP_GOLD_GLEAM if sy >= 25 else C_IMP_GOLD_LIGHT
			voxels[Vector3i(sx, sy, sz + 1)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(sx, sy, sz - 1)] = C_IMP_GOLD_LIGHT
			if sy in [22, 25]:
				voxels[Vector3i(sx + side, sy, sz)] = C_IMP_GOLD_GLEAM # Barb spike

	# 8. HEAVY WAR BELT & DEMONIC BEAST SKULL BUCKLE (y: 1..5)
	for y in range(1, 6):
		for x in range(-9, 10):
			for z in range(-8, 9):
				if abs(x) == 9 or abs(z) == 8:
					var col = C_IMP_GOLD_LIGHT
					if y in [1, 5]: col = C_IMP_GOLD_GLEAM # Polished gold rail
					elif abs(x) in [4, 8]: col = C_RUBY_GLEAM # Ruby stud
					voxels[Vector3i(x, y, z)] = col

	# Demonic Beast Skull Buckle (z: 9..11, y: 2..6, x: -3..3)
	for bx in range(-3, 4):
		for by in range(2, 7):
			for bz in range(9, 11):
				voxels[Vector3i(bx, by, bz)] = C_IMP_GOLD_LIGHT
	# Glowing Ruby Eyes in Belt Skull
	voxels[Vector3i(-2, 5, 11)] = C_RUBY_GLEAM
	voxels[Vector3i(2, 5, 11)] = C_RUBY_GLEAM
	voxels[Vector3i(0, 4, 11)] = C_IMP_EBONY
	# Golden Fangs
	voxels[Vector3i(-2, 2, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(2, 2, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(-1, 3, 11)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, 3, 11)] = C_IMP_GOLD_GLEAM

	# 9. FRONT HANGING CEREMONIAL VELVET TABARD (x: -3..3, y: -7..1, z: 9..10)
	for ty in range(-7, 2):
		var width = 3 if ty >= -4 else (2 if ty >= -6 else 1)
		for tx in range(-width, width + 1):
			var col = C_IMP_VELVET
			if abs(tx) == width or ty == -7:
				col = C_IMP_GOLD_GLEAM # Gilded border
			elif tx == 0 and ty in [-4, -2, 0]:
				col = C_IMP_GOLD_LIGHT # Center embroidered golden line
			voxels[Vector3i(tx, ty, 9)] = col
			voxels[Vector3i(tx, ty, 10)] = col if abs(tx) <= width - 1 else C_IMP_GOLD_LIGHT

	# 10. SEGMENTED JUGGERNAUT TASSETS (Armored skirts: y: -5..1, x: +-4..+-8)
	for side in [-1, 1]:
		for y in range(-5, 2):
			for tx in range(4, 9):
				var px = side * tx
				for tz in range(6, 9):
					var col = C_IMP_GOLD_LIGHT
					if tx in [4, 8] or y in [-5, 1]:
						col = C_IMP_GOLD_GLEAM
					voxels[Vector3i(px, y, tz)] = col
		# Spear tips at bottom of tassets
		voxels[Vector3i(side * 6, -6, 7)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(side * 6, -6, 8)] = C_IMP_GOLD_GLEAM

	# Side Hip Plates (x: +-9..+-10, y: -3..3, z: -4..4)
	for side in [-1, 1]:
		for y in range(-3, 4):
			for tz in range(-4, 5):
				var col = C_IMP_GOLD_LIGHT if (abs(tz) != 4 and y not in [-3, 3]) else C_IMP_GOLD_GLEAM
				voxels[Vector3i(side * 9, y, tz)] = col
				voxels[Vector3i(side * 10, y, tz)] = col

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_cape_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Top Mounting Clasps & Fur Trim (y = 0..-1, attaches to torso shoulder clasps)
	for side in [-1, 1]:
		for rx in range(3, 6):
			voxels[Vector3i(side * rx, 0, 0)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(side * rx, 0, 1)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(side * rx, -1, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(side * 4, 0, -1)] = C_RUBY_GLEAM

	# White Ermine Fur Collar Hem at top of cape (y: -1..0, x: -6..6)
	for x in range(-6, 7):
		var fur = C_WHITE_SILK if x % 2 == 0 else C_WHITE_SILK_SHADOW
		voxels[Vector3i(x, 0, 0)] = fur
		voxels[Vector3i(x, -1, 0)] = fur

	# 2. Cascading 3D Royal Crimson Velvet Cape with Natural Folds (y: -2..-25)
	for y in range(-25, 0):
		var progress: float = float(-y) / 25.0 # 0.0 at top, 1.0 at bottom hem
		var cape_rx: int = int(round(lerpf(7.0, 12.0, progress)))

		for x in range(-cape_rx, cape_rx + 1):
			# Natural 3D Cloth Drapery Folds: undulating wave across width & subtle backward flare
			var fold_z: int = int(round(sin(float(x) * 0.75) * 0.8 - progress * 1.5))

			var col = C_IMP_VELVET

			# Golden Embroidered Filigree Border along outer edges
			if abs(x) >= cape_rx - 1:
				col = C_IMP_GOLD_GLEAM if abs(x) == cape_rx else C_IMP_GOLD_LIGHT
			# Scalloped bottom hem with gold tassels & rubies (y: -24, -25)
			elif y <= -24:
				if y == -25:
					if abs(x) % 3 == 0:
						col = C_RUBY_GLEAM # Ruby tassel drop
					else:
						col = C_IMP_GOLD_GLEAM # Gold fringe
				else:
					col = C_IMP_GOLD_LIGHT
			# Central Imperial Golden Dragon Sigil
			elif abs(x) == 0 and y in range(-22, -3):
				col = C_IMP_GOLD_GLEAM # Dragon spine
			elif abs(x) in [1, 2] and y in [-5, -6, -10, -11, -15, -16]:
				col = C_IMP_GOLD_LIGHT # Dragon ribs / sun rays
			elif abs(x) in [2, 3] and y in [-7, -8, -12, -13, -17, -18]:
				col = C_IMP_GOLD_LIGHT
			elif abs(x) == 1 and y in [-8, -9, -13, -14]:
				col = C_RUBY_GLEAM if y == -13 else C_IMP_GOLD_GLEAM
			elif abs(x) == 0 and y == -13:
				col = C_RUBY_GLEAM # Heart ruby in center of cape sigil

			# Outer velvet face
			voxels[Vector3i(x, y, fold_z)] = col
			# Inner velvet face (dark shadow velvet lining)
			voxels[Vector3i(x, y, fold_z + 1)] = C_IMP_VELVET_DARK if abs(x) < cape_rx - 1 else C_IMP_GOLD_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_upper_arm_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Muscular Upper Arm with Royal Velvet Arming Sleeve (y: -9..0)
	for y in range(-9, 1):
		var rx = 4 if y >= -5 else 3
		var rz = 4 if y >= -5 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue

				var col = C_SKIN
				# Inner arm / shadow side
				if x <= -2:
					col = C_SKIN_DARK if z <= 0 else C_SKIN
				# Royal Crimson Velvet Arm Sleeve on inner & upper bicep
				if y in [0, -1, -2] and x < 2:
					if abs(x) == rx or abs(z) == rz:
						col = C_IMP_VELVET if y != 0 else C_IMP_GOLD_GLEAM
				# Outer Heavy Golden Rerebrace
				elif x >= 1:
					if y in [0, -9] or abs(z) == rz:
						col = C_IMP_EBONY # Dark obsidian structural chamfer
					elif y in [-3, -4, -5]:
						col = C_IMP_GOLD_GLEAM if (x >= 3 and abs(z) <= 1) else C_IMP_GOLD_LIGHT
					else:
						col = C_IMP_GOLD
				voxels[Vector3i(x, y, z)] = col

	# 2. Dual Leather Straps with Gold Buckles (y: -2 and y: -8)
	for strap_y in [-2, -8]:
		for z in range(-4, 5):
			for x in range(-4, 5):
				if (abs(x) == 4 or abs(z) == 4) and not (x >= 2 and strap_y == -2):
					if abs(x) <= 3 and abs(z) <= 4:
						voxels[Vector3i(x, strap_y, z)] = C_IMP_EBONY
		# Gold Buckles on outer and front
		voxels[Vector3i(0, strap_y, 4)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, strap_y, -4)] = C_IMP_GOLD_GLEAM

	# 3. Sculpted Imperial Golden Rerebrace Shield & Diamond Ruby Emblem (x: 4..6, y: -6..-2)
	for y in range(-6, -1):
		var h_len = 2 if y in [-4, -3] else 1
		for z in range(-h_len, h_len + 1):
			voxels[Vector3i(5, y, z)] = C_IMP_GOLD_LIGHT
			if abs(z) == h_len or y in [-6, -2]:
				voxels[Vector3i(5, y, z)] = C_IMP_GOLD_GLEAM
	# Inset Royal Ruby Bezel in center of rerebrace
	voxels[Vector3i(5, -4, 0)] = C_RUBY
	voxels[Vector3i(5, -3, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(6, -4, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(6, -3, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, -3, 1)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, -3, -1)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, -4, 1)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, -4, -1)] = C_IMP_GOLD_GLEAM

	# 4. Articulated Elbow Joint Cuffs (y: -9)
	for x in range(1, 5):
		for z in range(-2, 3):
			voxels[Vector3i(x, -9, z)] = C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_forearm_mesh_outfit3(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Heavy Imperial Golden Vambrace (y: -6..0)
	for y in range(-6, 1):
		var rx = 4 if y >= -3 else 3
		var rz = 4 if y >= -3 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue

				var col = C_IMP_GOLD
				if y == 0:
					col = C_SKIN if z >= 0 else C_SKIN_DARK
				elif y in [-1, -6] or abs(x) == rx:
					col = C_IMP_EBONY # Dark obsidian trim
				elif abs(z) == rz:
					col = C_IMP_GOLD_LIGHT
				else:
					col = C_IMP_GOLD
				voxels[Vector3i(x, y, z)] = col

	# 2. Spiked Dragon Elbow Cleaver Fin Arching Backwards (z: -5..-8, y: -3..-1)
	for y in [-3, -2, -1]:
		voxels[Vector3i(0, y, -5)] = C_IMP_EBONY
		voxels[Vector3i(0, y, -6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(1, y, -5)] = C_IMP_GOLD_DARK
		voxels[Vector3i(-1, y, -5)] = C_IMP_GOLD_DARK
	# Razor steel cleaver edge and gold spine
	voxels[Vector3i(0, -2, -6)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, -2, -7)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, -2, -8)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -3, -7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -1, -6)] = C_IMP_GOLD_LIGHT

	# 3. Outer Lateral Sun Medallion with Radiant Ruby (x = out_side * 5)
	var out_side = 1 if is_right else -1
	for y in [-4, -3, -2]:
		voxels[Vector3i(out_side * 5, y, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(out_side * 5, y, 1)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(out_side * 5, y, -1)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(out_side * 5, -3, 0)] = C_RUBY_GLEAM
	voxels[Vector3i(out_side * 5, -2, 0)] = C_RUBY
	voxels[Vector3i(out_side * 6, -3, 0)] = C_IMP_GOLD_GLEAM

	# 4. Hands & Gauntlets (y: -10..-7)
	if is_right:
		# RIGHT HAND: Segmented Heavy Golden War-Gauntlet clutching the mace
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					if abs(x) <= 1 and abs(z) <= 1: continue # Hole for mace grip
					var col = C_IMP_EBONY
					if z == 2:
						col = C_IMP_GOLD_LIGHT if abs(x) <= 2 else C_IMP_EBONY
					elif abs(x) == 3:
						col = C_IMP_GOLD
					voxels[Vector3i(x, y, z)] = col
		# Golden Knuckle Guards & Claws
		voxels[Vector3i(-2, -8, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, -8, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(2, -8, 3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(-2, -7, 3)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(0, -7, 3)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(2, -7, 3)] = C_IMP_GOLD_LIGHT
		# Thumb wrapping around
		voxels[Vector3i(3, -8, 1)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(3, -9, 0)] = C_IMP_GOLD_LIGHT
	else:
		# LEFT HAND: Open Predatory Dragon-Claw Gauntlet
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					var col = C_IMP_GOLD
					if z <= 0:
						col = C_SKIN if y >= -8 else C_SKIN_DARK
					elif y == -7:
						col = C_IMP_EBONY
					voxels[Vector3i(x, y, z)] = col
		# 4 Menacing Curved Golden Dragon Claws
		for fx in [-2, -1, 1, 2]:
			var fz = 2 if abs(fx) == 1 else 1
			voxels[Vector3i(fx, -7, fz)] = C_IMP_EBONY
			voxels[Vector3i(fx, -8, fz)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(fx, -9, fz + 1)] = C_IMP_GOLD_LIGHT
			voxels[Vector3i(fx, -10, fz + 1)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(fx, -10, fz + 2)] = C_STEEL_BRIGHT # Razor sharp talon tip
		# Predatory Thumb Claw
		voxels[Vector3i(3, -7, 0)] = C_SKIN
		voxels[Vector3i(3, -8, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(4, -9, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(4, -10, 1)] = C_STEEL_BRIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_thigh_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Muscular Thigh Core with Velvet Arming Breeches (y: -9..0, rx: 4, rz: 4)
	for y in range(-9, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue

				var col = C_SKIN
				if z <= -2:
					col = C_SKIN_DARK
				elif abs(x) == rx and z <= 0:
					col = C_SKIN_DARK
				elif z >= 1 and abs(x) <= 2:
					col = C_SKIN_LIGHT

				# Heavy Golden Cuisses on front and outer side
				if z >= 2:
					if y in [0, -8] or abs(x) == rx:
						col = C_IMP_EBONY # Frame
					elif x == 0:
						col = C_IMP_GOLD_GLEAM # Front keel ridge
					else:
						col = C_IMP_GOLD_LIGHT
				elif abs(x) == rx and z >= 0:
					col = C_IMP_GOLD

				# Velvet breeches & gilded strapping
				if y in [-2, -6]:
					if z < 2 and (abs(x) == rx or abs(z) == rz):
						col = C_IMP_VELVET
						if z == -rz: col = C_IMP_GOLD_GLEAM

				voxels[Vector3i(x, y, z)] = col

	# 2. Outer Hip Guard & Radiant Ruby Stud (x: 4..5, y: -4..-2)
	for y in [-4, -3, -2]:
		voxels[Vector3i(5, y, 0)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(5, y, 1)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(5, y, -1)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(5, -3, 0)] = C_RUBY_GLEAM

	# 3. Flared Golden Knee Articulation Bell (y: -9, z: 4..6)
	voxels[Vector3i(0, -9, 5)] = C_IMP_EBONY
	voxels[Vector3i(0, -9, 6)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -8, 5)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(-1, -9, 5)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(1, -9, 5)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(-2, -9, 4)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(2, -9, 4)] = C_IMP_GOLD_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_shin_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Imperial Golden Greaves (y: -7..0, rx: 4, rz: 4)
	for y in range(-7, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue

				var col = C_IMP_EBONY
				if y in [0, -1] and z <= 0 and abs(x) <= rx - 1:
					col = C_SKIN if z == 0 else C_SKIN_DARK
				elif abs(x) == rx:
					col = C_IMP_EBONY
				elif z == rz:
					col = C_IMP_GOLD_GLEAM if x == 0 else C_IMP_GOLD_LIGHT
				elif y in [0, -7]:
					col = C_IMP_EBONY
				else:
					col = C_IMP_GOLD_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# 2. Roaring Beast Dragon Knee Poleyn (y: -2..1, z: 5..8)
	for y in [-2, -1, 0]:
		voxels[Vector3i(0, y, 5)] = C_IMP_EBONY
		voxels[Vector3i(0, y, 6)] = C_IMP_GOLD_LIGHT
		voxels[Vector3i(-1, y, 5)] = C_IMP_GOLD
		voxels[Vector3i(1, y, 5)] = C_IMP_GOLD
	# Piercing Horn Spike
	voxels[Vector3i(0, -1, 7)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -1, 8)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -1, 5)] = C_RUBY_GLEAM
	# Dragon Eyes on Knee
	voxels[Vector3i(-2, 0, 5)] = C_RUBY_GLEAM
	voxels[Vector3i(2, 0, 5)] = C_RUBY_GLEAM

	# Mid-shin Solar Ruby Medallion
	voxels[Vector3i(0, -4, 4)] = C_RUBY_GLEAM
	voxels[Vector3i(0, -3, 4)] = C_RUBY
	voxels[Vector3i(-1, -4, 4)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(1, -4, 4)] = C_IMP_GOLD_GLEAM

	# 3. Imperial Dragon Sabatons (Armored War Boots: y: -9..-7)
	for y in range(-9, -6):
		for x in range(-3, 4):
			for z in range(-3, 6):
				if (abs(x) == 3 and abs(z) == 3) or (abs(x) == 3 and z >= 4): continue
				var col = C_IMP_EBONY
				if y == -9:
					col = C_IMP_EBONY
				elif z >= 2:
					col = C_IMP_GOLD_LIGHT
				voxels[Vector3i(x, y, z)] = col

	# 4 Articulated Dragon Talons on Boots (z = 6, y: -9..-8)
	for tx in [-3, -1, 1, 3]:
		voxels[Vector3i(tx, -9, 6)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(tx, -9, 7)] = C_STEEL_BRIGHT # Razor tip
		voxels[Vector3i(tx, -8, 5)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(0, -8, 5)] = C_IMP_GOLD_GLEAM

	# Armored Heel Spur
	voxels[Vector3i(0, -8, -4)] = C_IMP_EBONY
	voxels[Vector3i(0, -8, -5)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -8, -6)] = C_STEEL_BRIGHT

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_mace_mesh_outfit3() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Octagonal Dread Iron Shaft (y: -28..20)
	for y in range(-28, 21):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_IMP_EBONY
				# Handgrip: Royal Crimson Velvet with Gold wire coils (y: -7..5)
				if y >= -7 and y <= 5 and (abs(x) == 1 or abs(z) == 1):
					col = C_IMP_VELVET
					if y in [-7, -3, 1, 5]: col = C_IMP_GOLD_GLEAM
				elif y in [-14, -13, 12, 13, 17, 18]:
					col = C_IMP_GOLD_LIGHT if (abs(x) == 1 or abs(z) == 1) else C_IMP_EBONY
				voxels[Vector3i(x, y, z)] = col

	# Spiked Crossguards above and below handgrip (y_guard: -8, 6)
	for y_guard in [-8, 6]:
		for gx in range(-3, 4):
			for gz in range(-3, 4):
				if abs(gx) == 3 and abs(gz) == 3: continue
				var gc = C_IMP_EBONY if (abs(gx) == 3 or abs(gz) == 3) else C_IMP_GOLD_LIGHT
				if (abs(gx) == 2 and gz == 0) or (abs(gz) == 2 and gx == 0):
					gc = C_RUBY_GLEAM
				voxels[Vector3i(gx, y_guard, gz)] = gc
		voxels[Vector3i(-3, y_guard, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(3, y_guard, 0)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, y_guard, -3)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(0, y_guard, 3)] = C_IMP_GOLD_GLEAM

	# 2. Spiked Dread Iron Sphere Pommel & Dragon Talons (y: -33..-25)
	for y in range(-29, -24):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				var col = C_IMP_EBONY
				if (x == 0 or z == 0) and y == -26: col = C_IMP_GOLD_LIGHT
				voxels[Vector3i(x, y, z)] = col
	voxels[Vector3i(-3, -26, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(3, -26, 0)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -26, -3)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(0, -26, 3)] = C_IMP_GOLD_GLEAM
	# Hanging Imperial Gold Chain & Ruby Seal
	voxels[Vector3i(1, -29, 1)] = C_IMP_EBONY
	voxels[Vector3i(1, -30, 1)] = C_IMP_GOLD_LIGHT
	voxels[Vector3i(2, -31, 1)] = C_IMP_GOLD_GLEAM
	voxels[Vector3i(2, -32, 1)] = C_RUBY_GLEAM
	voxels[Vector3i(2, -33, 1)] = C_RUBY

	# 3. MONOLITHIC DREAD IRON CORE WITH GLOWING MAGMA RIFTS (y: 19..33)
	for y in range(19, 34):
		var core_r = 5 if (y in [19, 33]) else 6
		for x in range(-core_r, core_r + 1):
			for z in range(-core_r, core_r + 1):
				if abs(x) + abs(z) >= core_r + 4: continue
				var col = C_IMP_EBONY
				# Molten Magma Core
				if abs(x) <= 2 and abs(z) <= 2 and y in range(23, 29):
					col = C_LAVA_CORE
					if abs(x) == 0 and abs(z) == 0: col = C_RUBY_GLEAM
				# Glowing Runic Rifts on faces
				elif (abs(x) == 0 or abs(z) == 0) and y in [24, 25, 26, 27]:
					col = C_LAVA_HOT
				voxels[Vector3i(x, y, z)] = col

	# 4. EIGHT CRUSHING WAR FLANGES WITH SOLID GOLD PLATES & RAZOR STEEL EDGES
	for y in range(21, 32):
		var is_mid = (y in [25, 26, 27])
		var f_dist = 13 if is_mid else 11

		# +Z Flange
		for dz in range(6, f_dist + 1):
			var col = C_IMP_GOLD_LIGHT
			if dz <= 7:
				col = C_IMP_EBONY # Dread iron root
			elif dz == f_dist:
				col = C_STEEL_BRIGHT # Razor steel edge!
			elif is_mid and dz in [9, 10]:
				col = C_IMP_GOLD_GLEAM
			voxels[Vector3i(0, y, dz)] = col
			voxels[Vector3i(-1, y, dz)] = C_IMP_EBONY if dz <= 8 else C_IMP_GOLD_DARK
			voxels[Vector3i(1, y, dz)] = C_IMP_EBONY if dz <= 8 else C_IMP_GOLD_DARK

		# -Z Flange
		for dz in range(6, f_dist + 1):
			var col = C_IMP_GOLD_LIGHT
			if dz <= 7:
				col = C_IMP_EBONY
			elif dz == f_dist:
				col = C_STEEL_BRIGHT
			elif is_mid and dz in [9, 10]:
				col = C_IMP_GOLD_GLEAM
			voxels[Vector3i(0, y, -dz)] = col
			voxels[Vector3i(-1, y, -dz)] = C_IMP_EBONY if dz <= 8 else C_IMP_GOLD_DARK
			voxels[Vector3i(1, y, -dz)] = C_IMP_EBONY if dz <= 8 else C_IMP_GOLD_DARK

		# +X Flange
		for dx in range(6, f_dist + 1):
			var col = C_IMP_GOLD_LIGHT
			if dx <= 7:
				col = C_IMP_EBONY
			elif dx == f_dist:
				col = C_STEEL_BRIGHT
			elif is_mid and dx in [9, 10]:
				col = C_IMP_GOLD_GLEAM
			voxels[Vector3i(dx, y, 0)] = col
			voxels[Vector3i(dx, y, -1)] = C_IMP_EBONY if dx <= 8 else C_IMP_GOLD_DARK
			voxels[Vector3i(dx, y, 1)] = C_IMP_EBONY if dx <= 8 else C_IMP_GOLD_DARK

		# -X Flange
		for dx in range(6, f_dist + 1):
			var col = C_IMP_GOLD_LIGHT
			if dx <= 7:
				col = C_IMP_EBONY
			elif dx == f_dist:
				col = C_STEEL_BRIGHT
			elif is_mid and dx in [9, 10]:
				col = C_IMP_GOLD_GLEAM
			voxels[Vector3i(-dx, y, 0)] = col
			voxels[Vector3i(-dx, y, -1)] = C_IMP_EBONY if dx <= 8 else C_IMP_GOLD_DARK
			voxels[Vector3i(-dx, y, 1)] = C_IMP_EBONY if dx <= 8 else C_IMP_GOLD_DARK

	# 4 Diagonal Corner Flanges (at 45 degrees, extend to distance 9)
	for y in range(22, 31):
		for d in range(5, 10):
			var col = C_IMP_EBONY if d <= 6 else (C_STEEL_BRIGHT if d == 9 else C_IMP_GOLD_LIGHT)
			voxels[Vector3i( d, y,  d)] = col
			voxels[Vector3i(-d, y,  d)] = col
			voxels[Vector3i( d, y, -d)] = col
			voxels[Vector3i(-d, y, -d)] = col

	# 2x2 THICK CONICAL ARMOR-PIERCING SPIKES JUTTING OUT FROM CARDINAL FLANGES!
	for side in [-1, 1]:
		for dx in range(14, 18):
			var sc = C_IMP_GOLD_GLEAM if dx >= 16 else C_IMP_EBONY
			voxels[Vector3i(side * dx, 26, 0)] = sc
			voxels[Vector3i(side * dx, 26, 1)] = C_IMP_EBONY if dx < 16 else C_IMP_GOLD_LIGHT
			voxels[Vector3i(side * dx, 26, -1)] = C_IMP_EBONY if dx < 16 else C_IMP_GOLD_LIGHT
		for dz in range(14, 18):
			var sc = C_IMP_GOLD_GLEAM if dz >= 16 else C_IMP_EBONY
			voxels[Vector3i(0, 26, side * dz)] = sc
			voxels[Vector3i(1, 26, side * dz)] = C_IMP_EBONY if dz < 16 else C_IMP_GOLD_LIGHT
			voxels[Vector3i(-1, 26, side * dz)] = C_IMP_EBONY if dz < 16 else C_IMP_GOLD_LIGHT

	# Demonic Beast Skull Relief Medallions on Front & Rear Face
	for fz in [7, -7]:
		voxels[Vector3i(-2, 27, fz)] = C_RUBY_GLEAM
		voxels[Vector3i(2, 27, fz)] = C_RUBY_GLEAM
		voxels[Vector3i(0, 26, fz)] = C_IMP_EBONY
		voxels[Vector3i(-1, 24, fz)] = C_IMP_GOLD_GLEAM
		voxels[Vector3i(1, 24, fz)] = C_IMP_GOLD_GLEAM

	# Heavy Golden Chains wrapped around the neck (y: 17..19)
	for cy in [17, 18, 19]:
		for angle in range(-4, 5):
			var col = C_IMP_EBONY if cy == 18 else C_IMP_GOLD_LIGHT
			voxels[Vector3i(angle, cy, 5)] = col
			voxels[Vector3i(angle, cy, -5)] = col
			voxels[Vector3i(5, cy, angle)] = col
			voxels[Vector3i(-5, cy, angle)] = col

	# 5. COLOSSAL APEX WAR-PICK SPEARHEAD (+Y: 34..50)
	for y in range(34, 51):
		var sp_r = int(lerpf(5.0, 0.0, float(y - 34) / 16.0))
		for x in range(-sp_r, sp_r + 1):
			for z in range(-sp_r, sp_r + 1):
				if abs(x) + abs(z) <= sp_r + 1:
					var sc = C_IMP_EBONY
					if abs(x) + abs(z) == sp_r + 1:
						sc = C_STEEL_BRIGHT if y >= 45 else C_IMP_GOLD_GLEAM
					voxels[Vector3i(x, y, z)] = sc

	# 4 Flanking Barbed Crescent Solar Wings on Spearhead base (y: 35..42)
	for side in [-1, 1]:
		for by in range(35, 43):
			var bx = side * (4 + (by - 35) / 2)
			voxels[Vector3i(bx, by, 0)] = C_IMP_GOLD_GLEAM
			voxels[Vector3i(bx, by - 1, 0)] = C_IMP_EBONY
			if by == 38: voxels[Vector3i(bx, by, 0)] = C_RUBY_GLEAM

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- OUTFIT 2 IMPLEMENTATION ---

static func build_ogre_head_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 1. Thick Muscular Neck with Iron Gorget Base (y: 0..3)
	for y in range(4):
		for x in range(-5, 6):
			for z in range(-5, 6):
				if abs(x) == 5 and abs(z) == 5: continue
				var col = C_SKIN
				if y in [0, 1]:
					# Heavy iron gorget collar with gold rivets at base of neck
					if abs(x) == 5 or abs(z) == 5:
						col = C_GOLD if (x + z) % 3 == 0 else C_IRON_DARK
					else:
						col = C_CHAINMAIL if (x + y + z) % 2 == 0 else C_IRON_DARK
				else:
					# Exposed muscular green ogre neck flesh
					if z >= 2:
						col = C_SKIN_PALE if y == 2 else C_SKIN # Lighter throat
					elif z <= -3:
						col = C_SKIN_DARK # Shaded nape
					elif abs(x) >= 4:
						col = C_SKIN_DARK # Neck muscular flanks
				voxels[Vector3i(x, y, z)] = col

	# 2. Brutal Jutting Ogre Jaw & Underbite with Side Steel Cheekguards (y: 4..8)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(-5, 9):
				if (abs(x) >= 5 and z <= -4) or (abs(x) >= 5 and z >= 7): continue
				if abs(x) == 6 and (z <= -2 or z >= 5): continue
				if y == 4 and abs(x) >= 5 and abs(z) >= 5: continue
				if y == 8 and z >= 7 and abs(x) >= 5: continue

				# Carve open the snarling mouth gap at front (y in [6, 7], abs(x) <= 3, z >= 7)
				if y in [6, 7] and abs(x) <= 3 and z >= 8: continue
				if y == 7 and abs(x) <= 2 and z == 7:
					voxels[Vector3i(x, y, z)] = C_MOUTH_DARK # Open mouth slit
					continue

				var col = C_SKIN
				if y == 4:
					col = C_SKIN_DARK
				elif abs(x) <= 3 and z in [3, 4, 5, 6] and y in [5, 6, 7]:
					# Deep oral cavity with dark throat and bloody tongue
					col = C_MOUTH_DARK
					if y == 5 and abs(x) <= 1 and z in [4, 5]:
						col = C_WARRIOR_RED_DARK
				elif z >= 6:
					# Massive ogre chin with green flesh
					col = C_SKIN_LIGHT if (y == 5 or y == 6) else C_SKIN
				elif abs(x) in [5, 6] and z in [-1, 0, 1, 2, 3]:
					# Heavy steel gladiatorial cheekguard protecting jaw hinge
					col = C_STEEL_LIGHT if (x + y + z) % 2 == 0 else C_IRON_DARK
					if z == 1 and y in [6, 7]: col = C_GOLD # Brass rivet on cheek plate
				elif abs(x) == 5:
					col = C_SKIN_DARK
				voxels[Vector3i(x, y, z)] = col

	# 3. Mid-Face, Muscular Cheeks & Temples (y: 9..11)
	for y in range(9, 12):
		var rx = 6 if y == 9 else 5
		var rz = 5
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 2):
				if abs(x) >= rx and abs(z) >= rz: continue
				if abs(x) == 6 and (z <= -3 or z >= 4): continue
				if y == 10 and abs(x) in [2, 3] and z >= 6: continue # Eye socket
				if y == 11 and z >= 6: continue

				var col = C_SKIN
				if z <= -4:
					col = C_IRON_DARK if y >= 10 else C_CHAINMAIL # Coif / back of helmet
				elif abs(x) >= 5:
					col = C_STEEL_LIGHT if (y == 9 or y == 10) else C_IRON_DARK # Helmet cheek flank
				elif z >= 4 and abs(x) <= 4:
					col = C_SKIN_LIGHT if y in [9, 10] else C_SKIN # Muscular green cheekbones!
				voxels[Vector3i(x, y, z)] = col

	# 4. Flattened Broken Ogre Nose & Snout (y: 8..11)
	for y in range(8, 12):
		for x in range(-2, 3):
			for z in range(6, 9):
				if z == 8 and abs(x) == 2 and y >= 10: continue
				var col = C_SKIN
				if y == 8 and abs(x) == 1 and z == 8:
					col = C_MOUTH_DARK # Flared nostrils
				elif z == 8 and y in [9, 10]:
					col = C_SKIN_LIGHT # Green nose bridge
				voxels[Vector3i(x, y, z)] = col

	# 5. Sleek Steel Nasal Guard descending from helmet brow over nose bridge (y: 9..11)
	for y in range(9, 12):
		voxels[Vector3i(0, y, 8)] = C_STEEL_BRIGHT
	voxels[Vector3i(0, 11, 9)] = C_GOLD # Gold nasal stud

	# 6. Colossal Ivory Boar Tusks & Savage Teeth (PLACED AFTER FACE & NOSE)
	for side in [-1, 1]:
		voxels[Vector3i(side * 4, 6, 7)] = C_BONE         # Ivory tusk root
		voxels[Vector3i(side * 5, 6, 7)] = C_IRON_DARK    # Outer iron root collar
		voxels[Vector3i(side * 4, 7, 8)] = C_TEETH        # Rising ivory tusk
		voxels[Vector3i(side * 5, 7, 8)] = C_GOLD         # Gold band ring
		voxels[Vector3i(side * 4, 8, 8)] = C_TEETH        # Massive white ivory
		voxels[Vector3i(side * 4, 9, 8)] = C_TEETH        # Rising ivory body
		voxels[Vector3i(side * 4, 10, 7)] = C_TEETH       # Inward curving razor tip
		voxels[Vector3i(side * 4, 11, 6)] = C_BONE        # Sharp ivory point

	# Vicious lower underbite teeth protruding up in front of mouth
	voxels[Vector3i(-3, 6, 8)] = C_TEETH
	voxels[Vector3i(-2, 7, 8)] = C_TEETH
	voxels[Vector3i(0, 6, 8)] = C_TEETH
	voxels[Vector3i(2, 7, 8)] = C_TEETH
	voxels[Vector3i(3, 6, 8)] = C_TEETH
	voxels[Vector3i(-1, 7, 8)] = C_TEETH
	voxels[Vector3i(1, 7, 8)] = C_TEETH

	# Upper fangs hanging down from upper snout
	voxels[Vector3i(-2, 7, 7)] = C_TEETH
	voxels[Vector3i(2, 7, 7)] = C_TEETH
	voxels[Vector3i(-3, 8, 6)] = C_TEETH
	voxels[Vector3i(3, 8, 6)] = C_TEETH

	# Heavy Steel Septum Ring clamped through snout
	voxels[Vector3i(0, 7, 8)] = C_GOLD
	voxels[Vector3i(-1, 7, 8)] = C_STEEL_BRIGHT
	voxels[Vector3i(1, 7, 8)] = C_STEEL_BRIGHT

	# Jagged War Scar slashing across right eye and jaw
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
		voxels[p] = C_WARRIOR_RED

	# Big Rugged Ogre Ears with Iron War Rings
	for side in [-1, 1]:
		for y in range(8, 12):
			for z in range(0, 3):
				voxels[Vector3i(side * 7, y, z)] = C_SKIN_DARK
				if y in [9, 10] and z in [0, 1]:
					voxels[Vector3i(side * 8, y, z)] = C_EAR_INNER
					voxels[Vector3i(side * 9, y, z)] = C_SKIN
		# Heavy iron & gold earring hoops
		voxels[Vector3i(side * 9, 7, 1)] = C_GOLD
		voxels[Vector3i(side * 8, 7, 1)] = C_IRON_DARK

	# 4. Heavy Gladiator Brow Band & Glowing Amber/Red Eyes (y: 10..12)
	# Glowing fierce ogre eyes under the brow
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 3, 10, 6)] = C_EYE_YELLOW
		voxels[Vector3i(side * 2, 10, 7)] = C_FEATHER_RED # Fiery bloodshot pupil
		voxels[Vector3i(side * 3, 10, 7)] = C_EYE_PUPIL

	# Overhanging heavy steel helmet visor brow
	for x in range(-5, 6):
		voxels[Vector3i(x, 11, 6)] = C_STEEL_LIGHT
		voxels[Vector3i(x, 12, 6)] = C_STEEL_BRIGHT
		if abs(x) <= 3:
			voxels[Vector3i(x, 12, 7)] = C_STEEL_BRIGHT
		if abs(x) in [2, 4]:
			voxels[Vector3i(x, 11, 7)] = C_GOLD # Brass rivets along brow

	# 5. Colossal Curved Iron Bull / Demon Horns (x: +-6..+-10, y: 12..19)
	for side in [-1, 1]:
		for dx in range(2):
			for dz in range(2):
				voxels[Vector3i(side * (6 + dx), 12, 1 + dz)] = C_GOLD
		voxels[Vector3i(side * 7, 13, 1)] = C_IRON_DARK
		voxels[Vector3i(side * 8, 14, 1)] = C_IRON_DARK
		voxels[Vector3i(side * 8, 14, 2)] = C_IRON
		voxels[Vector3i(side * 9, 15, 1)] = C_IRON
		voxels[Vector3i(side * 9, 16, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 9, 17, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(side * 8, 18, -1)] = C_STEEL_BRIGHT
		voxels[Vector3i(side * 8, 19, -1)] = C_STEEL_BRIGHT

	# 6. Cranium Helmet Dome & Serrated Steel Mohawk Spikes (y: 13..19)
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

	# 1. Muscular Torso Body with Heavy Half-Plate Cuirass (y: 0..17)
	for y in range(18):
		var rx = 7 if y <= 3 else (9 if y <= 13 else 8)
		var rz = 6 if y <= 3 else (7 if y <= 13 else 6)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				if abs(x) >= rx - 1 and abs(z) >= rz and y in [0, 1, 16, 17]: continue

				var col = C_SKIN

				# A. Exposed Muscular Upper Chest, Trapezius & Clavicle (y: 15..17, z >= 2)
				if y in [15, 16, 17] and z >= 2:
					if x == 0:
						col = C_SKIN_DARK # Sternum cleft
					elif abs(x) <= 3:
						col = C_SKIN_LIGHT # Pectoral highlight
					else:
						col = C_SKIN
				# B. Heavy Pectoral Steel Breastplate (y: 9..14, z >= rz - 1)
				elif y in [9, 10, 11, 12, 13, 14] and z >= rz - 1:
					if x == 0:
						col = C_GOLD # Raised center gilded keel ridge
					elif abs(x) in [1, 2, 3, 4, 5]:
						col = C_STEEL_BRIGHT if (y in [11, 12] and abs(x) in [2, 3]) else C_STEEL_LIGHT
					else:
						col = C_IRON_DARK # Outer breastplate rim
				# C. Cuirass Lower Rim (y == 8, z >= rz - 1)
				elif y == 8 and z >= rz - 1:
					col = C_GOLD if abs(x) <= 4 else C_IRON_DARK
				# D. Exposed Muscular Green Abdominal Core (Six-Pack) (y: 5..7, z >= rz - 1)
				elif y in [5, 6, 7] and z >= rz - 1:
					if x == 0 or y == 6:
						col = C_SKIN_DARK # Linea alba & rectus abdominis furrow cuts
					elif abs(x) in [1, 2, 3]:
						col = C_SKIN_LIGHT # Powerful ab muscle blocks!
					else:
						col = C_SKIN_DARK # Oblique definition
				# E. Segmented Waist Rim / Belt Top (y == 4, z >= rz - 1)
				elif y == 4 and z >= rz - 1:
					col = C_STEEL_BRIGHT if (x % 2 == 0) else C_IRON_DARK
				# D. Exposed Green Flesh Flanks & Lats with Heavy Leather Straps (abs(x) >= rx - 2, y: 4..14)
				elif abs(x) >= rx - 2 and z in [-2, -1, 0, 1, 2] and y in range(4, 15):
					if y in [5, 8, 11, 14]:
						# Heavy dark leather armor harness straps strapping the cuirass
						col = C_LEATHER_DARK
						if abs(x) == rx and z == 0: col = C_STEEL_BRIGHT # Steel buckle rivet
					elif abs(x) == rx:
						col = C_SKIN_DARK # Muscular flank definition
					else:
						col = C_SKIN # Raw green ogre muscle
				# E. Backplate Spinal Armor & Hunch (z <= -rz + 1)
				elif z <= -rz + 1:
					if abs(x) <= 3:
						col = C_STEEL_LIGHT if (x + y) % 2 == 0 else C_IRON
					else:
						col = C_IRON_DARK
				# F. Inner body core
				else:
					if y <= 3:
						col = C_LEATHER_DARK
					elif z >= 2:
						col = C_SKIN
					else:
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

	# Side hip tassets with leather strapping
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
	# Bulging Muscular Green Ogre Arm with Strapped Steel Rerebrace (y: -9..0)
	for y in range(-9, 1):
		var rx = 4 if y >= -5 else 3
		var rz = 4 if y >= -5 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue

				# Core: Muscular green ogre arm
				var col = C_SKIN
				if z >= 2 and abs(x) <= 2:
					col = C_SKIN_LIGHT # Bicep peak muscle highlight
				elif z <= -2:
					col = C_SKIN_DARK # Tricep shade
				elif abs(x) == rx:
					col = C_SKIN_DARK # Outer/inner arm contour

				# Heavy Forged Steel Rerebrace Plate on Outer Arm (x >= rx - 1, y: -6..0)
				if x >= rx - 1 and y in range(-6, 1):
					if y in [0, -6]:
						col = C_GOLD # Gold trimmed rims
					elif (x + y + z) % 2 == 0:
						col = C_STEEL_BRIGHT
					else:
						col = C_STEEL_LIGHT

				# Heavy Leather Harness Straps holding rerebrace plate (wrapped around inner arm)
				if y in [-2, -5]:
					if x < rx - 1 and (abs(x) == rx or abs(z) == rz):
						col = C_LEATHER_DARK # Leather strap
						if x == -rx: col = C_STEEL_BRIGHT # Steel buckle on inner arm

				# Chainmail / bracer cuff near elbow joint
				if y == -8 and (abs(x) == rx or abs(z) == rz):
					col = C_IRON_DARK

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

	# 1. Muscular Forearm wrapped in Heavy Segmented Steel Vambrace (y: -6..0)
	for y in range(-6, 1):
		var rx = 4 if y >= -3 else 3
		var rz = 4 if y >= -3 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue

				var col = C_IRON
				if y == 0:
					# Exposed muscular green arm entering the bracer
					col = C_SKIN if z >= 0 else C_SKIN_DARK
				elif abs(x) == rx or abs(z) == rz:
					if y in [-1, -6]:
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

	# 2. Hand Sculpting with Exposed Ogre Skin & Savage Weapon Grip (y: -9..-7)
	if is_right:
		# RIGHT HAND: Heavy Steel Spiked Gauntlet Fist gripping Mace Shaft
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					if abs(x) <= 1 and abs(z) <= 1: continue
					var col = C_STEEL_LIGHT
					# Green skin exposed at wrist articulation joint
					if y == -7 and z <= 0:
						col = C_SKIN
					# Reinforced knuckle bar at front (+Z)
					elif z == 2:
						col = C_STEEL_BRIGHT if (x in [-2, 0, 2]) else C_GOLD
					elif abs(x) == 3:
						col = C_IRON_DARK
					voxels[Vector3i(x, y, z)] = col
		# Spiked Iron Knuckle Blades
		voxels[Vector3i(-2, -8, 3)] = C_SPIKE_STEEL
		voxels[Vector3i(0, -8, 3)] = C_SPIKE_STEEL
		voxels[Vector3i(2, -8, 3)] = C_SPIKE_STEEL
	else:
		# LEFT HAND: Articulated Steel Claw Gauntlet with Exposed Green Palm & Fingers
		for y in range(-9, -6):
			for x in range(-3, 4):
				for z in range(-2, 3):
					var col = C_STEEL_LIGHT
					# Exposed green skin on palm / inner wrist
					if z <= 0:
						col = C_SKIN if y >= -8 else C_SKIN_DARK
					elif y == -7:
						col = C_STEEL_BRIGHT if z >= 1 else C_IRON
					voxels[Vector3i(x, y, z)] = col
		# 4 razor-sharp articulated steel talon claws extending down to y = -10
		for fx in [-2, -1, 1, 2]:
			var fz = 2 if abs(fx) == 1 else 1
			voxels[Vector3i(fx, -8, fz)] = C_STEEL_LIGHT
			voxels[Vector3i(fx, -9, fz)] = C_STEEL_BRIGHT
			voxels[Vector3i(fx, -10, fz + 1)] = C_SPIKE_STEEL # Curving sharp talon tip
		# Thumb talon with green thumb base
		voxels[Vector3i(3, -7, 0)] = C_SKIN
		voxels[Vector3i(3, -8, 0)] = C_STEEL_LIGHT
		voxels[Vector3i(4, -9, 0)] = C_SPIKE_STEEL

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


static func build_ogre_thigh_mesh_outfit2() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Muscular Green Ogre Thigh with Front Heavy Steel Cuisse & Strapping (y: -9..0)
	for y in range(-9, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue

				# Core: Muscular green ogre thigh
				var col = C_SKIN
				if z <= -2:
					col = C_SKIN_DARK # Hamstring shadow
				elif abs(x) == rx and z <= 0:
					col = C_SKIN_DARK # Inner/rear thigh definition
				elif z >= 1 and abs(x) <= 2:
					col = C_SKIN_LIGHT # Quad muscle highlight

				# Heavy Forged Steel Cuisse Plate on Front Thigh (z >= 2)
				if z >= 2:
					if y in [0, -8]:
						col = C_GOLD # Gold trimmed rim edges
					elif (x + y) % 2 == 0:
						col = C_STEEL_BRIGHT
					else:
						col = C_STEEL_LIGHT
				# Outer flank plate
				elif abs(x) == rx and z >= 1:
					col = C_STEEL_LIGHT

				# Heavy Dark Leather Harness Straps holding cuisse around green muscle
				if y in [-2, -6]:
					if z < 2 and (abs(x) == rx or abs(z) == rz):
						col = C_LEATHER_DARK
						if z == -rz: col = C_STEEL_BRIGHT # Steel buckle rivet at back

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

	# 1. Heavy Fluted Steel Greaves wrapping Muscular Calf (y: -7..0)
	for y in range(-7, 1):
		var rx = 4
		var rz = 4
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz and y == 0: continue

				var col = C_IRON
				# Exposed calf muscle at top knee/joint opening (y: 0..-1, z <= 0)
				if y in [0, -1] and z <= 0 and abs(x) <= rx - 1:
					col = C_SKIN if z == 0 else C_SKIN_DARK
				elif abs(x) == rx or abs(z) == rz:
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

# ==============================================================================
# --- SKELETON WARRIOR: VOXEL MESH BUILDERS (HIGH QUALITY DARK FANTASY) ---

# =============================================================================
# SKELETON WARRIOR VOXEL GENERATORS (DARK FANTASY OVERHAUL)
# Mastercrafted Volumetric Anatomy, Weathered Bone Shading & Primitive Gear

# =============================================================================
# SKELETON WARRIOR VOXEL GENERATORS (DARK FANTASY OVERHAUL - SOLID VOLUME)
# Mastercrafted Volumetric Anatomy, Weathered Bone Shading & Primitive Gear

# =============================================================================
# SKELETON WARRIOR VOXEL GENERATORS (COMPLETE GROUND-UP MASTERPIECE REMAKE)
# Imposing Dark Fantasy Undead Berserker — Solid Volume, Battered Spangenhelm,
# Piercing Soul Flame, Pitted Broadsword & Splintered War Shield

# =============================================================================
# SKELETON WARRIOR VOXEL GENERATORS (COMPLETE GROUND-UP MASTERPIECE REMAKE)
# Imposing Dark Fantasy Undead Berserker — Sculpted Skull, Piercing Soul Flame,
# Solid Volume, Battered Spangenhelm, Pitted Broadsword & Splintered War Shield

# =============================================================================
# SKELETON WARRIOR VOXEL GENERATORS (AUTHENTIC CURVED BONE ANATOMY)
# True Skeletal Silhouette: Sweeping Curved Rib Arches (Mảng Xương Cong Cong),
# Hollow Thoracic Cavity, Lumbar Vertebrae, 1-Voxel Razor Broadsword & Shield
# =============================================================================

# 1. ANCIENT WARRIOR SKULL & BATTERED IRON SPANGENHELM
static func build_skeleton_head_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# --- A. Cervical Spine / Neck (y: 0..3, 3x3 to 4x4 vertebrae with dorsal spur) ---
	for y in range(4):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
		# Lateral transverse processes & dorsal spur
		voxels[Vector3i(2, y, 0)] = C_BONE_WEATHERED
		voxels[Vector3i(-2, y, 0)] = C_BONE_WEATHERED
		voxels[Vector3i(0, y, -2)] = C_BONE_SHADOW

	# --- B. Sculpted Mandible (Lower Jaw, y: 4..7) ---
	# Deep posterior ramus at x: +-4 tapering forward to a square warrior chin at x: -2..2, z: 5
	for y in range(4, 8):
		# Jaw hinge angles at back
		for side in [-1, 1]:
			for z in range(-1, 3):
				voxels[Vector3i(side * 4, y, z)] = C_BONE if y > 4 else C_BONE_WEATHERED
		# Curved jawline to chin
		for x in range(-3, 4):
			for z in range(2, 6):
				var is_jaw = (z == 5 and abs(x) <= 2) or (abs(x) == 3 and z in [3, 4]) or (y == 4 and z == 4)
				if is_jaw:
					var col = C_BONE
					if y == 4: col = C_BONE_WEATHERED
					elif z == 5 and y == 4: col = C_BONE_SHADOW
					voxels[Vector3i(x, y, z)] = col

	# Dark Deep Oral Cavity / Mouth Void Interior
	for y in range(4, 8):
		for x in range(-2, 3):
			for z in range(0, 4):
				if not voxels.has(Vector3i(x, y, z)):
					voxels[Vector3i(x, y, z)] = C_IMP_EBONY

	# Menacing Lower Teeth & Fearsome Upward Canines (y: 7)
	for tx in [-2, -1, 1, 2]: # tx = 0 has a battle-chipped missing tooth gap!
		var is_fang = (abs(tx) == 2)
		voxels[Vector3i(tx, 7, 4)] = C_TEETH
		if is_fang:
			voxels[Vector3i(tx, 8, 4)] = C_TEETH # Lower fang extending up!
			voxels[Vector3i(tx, 7, 4)] = C_BONE_WEATHERED

	# --- C. Maxilla & Upper Skull Base (y: 7..10) ---
	for y in range(7, 11):
		for x in range(-4, 5):
			for z in range(-3, 5):
				if abs(x) == 4 and (z < -1 or z > 2): continue
				var col = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
				if y == 7 and z <= 1: col = C_BONE_SHADOW # Roof of mouth
				voxels[Vector3i(x, y, z)] = col

	# Upper Teeth Row (y: 8, z: 4)
	for tx in [-2, 0, 1]: # tx = -1 chipped out!
		voxels[Vector3i(tx, 8, 4)] = C_TEETH
	# Upper Canine Fangs
	voxels[Vector3i(-3, 7, 3)] = C_TEETH
	voxels[Vector3i(3, 7, 3)] = C_TEETH

	# Flared Zygomatic Arches (Cheekbones, y: 8..10)
	for side in [-1, 1]:
		for zy in range(8, 11):
			voxels[Vector3i(side * 4, zy, 1)] = C_BONE
			voxels[Vector3i(side * 5, zy, 1)] = C_BONE_WEATHERED # Flared cheek crest
			voxels[Vector3i(side * 4, zy, 2)] = C_BONE
		# Sunken cheek hollow below eye socket
		voxels[Vector3i(side * 3, 9, 3)] = C_BONE_SHADOW

	# Inverted Teardrop Nasal Cavity (y: 8..9, z: 4)
	voxels[Vector3i(0, 8, 4)] = C_IMP_EBONY
	voxels[Vector3i(0, 9, 4)] = C_IMP_EBONY
	# Nasal bone bridge between eyes
	voxels[Vector3i(0, 10, 4)] = C_BONE
	voxels[Vector3i(0, 11, 4)] = C_BONE

	# --- D. Sunken 3D Eye Sockets & Piercing Cyan Soul Flame (y: 10..11) ---
	for side in [-1, 1]:
		for ey in [10, 11]:
			for ex in [2, 3]:
				# Carve deep hollow socket cavity into skull
				voxels[Vector3i(side * ex, ey, 2)] = C_IMP_EBONY
				voxels[Vector3i(side * ex, ey, 3)] = C_IMP_EBONY
				voxels.erase(Vector3i(side * ex, ey, 4)) # Front opening
		
		# Piercing supernatural cyan soul flame inside socket depth
		voxels[Vector3i(side * 2, 10, 2)] = C_GLOW_CYAN # Radiant cyan core
		voxels[Vector3i(side * 2, 10, 3)] = 0xbae6fd    # Brilliant specular soul spark!
		voxels[Vector3i(side * 3, 10, 2)] = 0x0284c7    # Ghostly blue soul aura
		voxels[Vector3i(side * 2, 11, 2)] = 0x0284c7

	# Furrowed Supraorbital Brow Ridge (Angry V-shaped scowl over eyes)
	for x in range(-4, 5):
		var bz = 4 if abs(x) <= 1 else 3
		var by = 11 if abs(x) <= 1 else 12
		voxels[Vector3i(x, by, bz + 1)] = C_BONE # Overhangs eyes by 1 voxel forward
		voxels[Vector3i(x, by, bz)] = C_BONE_WEATHERED
	voxels[Vector3i(0, 11, 5)] = C_BONE_SHADOW

	# --- E. Cranium Dome Shell (y: 10..15, x: -4..4, z: -4..3) ---
	for y in range(10, 16):
		var rx = 4 if y < 14 else 3
		var rz = 4 if y < 14 else 3
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				# Leave face front open for eyes and nose
				if z >= 2 and y in [10, 11] and abs(x) in [2, 3]: continue
				if z >= 3 and y in [8, 9] and x == 0: continue
				
				var col = C_BONE
				if y == 15 or z == -rz: col = C_BONE_WEATHERED
				elif x == 0 and z <= 0 and y >= 12: col = C_BONE_SHADOW
				voxels[Vector3i(x, y, z)] = col

	# --- F. Ancient Battered Iron Spangenhelm / Conical Warrior Helmet (y: 12..18) ---
	for y in range(12, 18):
		var rx = 4 if y < 15 else (3 if y < 17 else 2)
		var rz = 4 if y < 15 else (3 if y < 17 else 2)
		for x in range(-rx, rx + 1):
			for z in range(-rz, rz + 1):
				if abs(x) == rx and abs(z) == rz: continue
				var is_helm = (y >= 14) or (y in [12, 13] and (z <= -1 or abs(x) == rx))
				if is_helm:
					var col = C_IRON_DARK
					if (x == 0 or z == 0) and y >= 13: col = C_BRONZE # Cross bands
					elif y == 13 and (abs(x) == rx or z in [-rz, rz]): col = C_BRONZE # Brow rim
					elif y == 14 and abs(x) == 2 and z == rz: col = C_STEEL_LIGHT # Forged rivet
					voxels[Vector3i(x, y, z)] = col

	# Conical Helmet Apex Spike Boss (y: 17..18)
	voxels[Vector3i(0, 17, 0)] = C_IRON
	voxels[Vector3i(0, 18, 0)] = C_STEEL_LIGHT

	# Heavy Forged Iron Nasal Bar Guard extending down between eyes (z: 5)
	voxels[Vector3i(0, 13, 5)] = C_IRON_DARK
	voxels[Vector3i(0, 12, 5)] = C_IRON
	voxels[Vector3i(0, 11, 5)] = C_IRON_DARK
	voxels[Vector3i(0, 10, 5)] = C_IRON_DARK
	voxels[Vector3i(0, 12, 4)] = C_BRONZE

	# Battle Crack on Left Cranium with chipped dent
	voxels[Vector3i(-3, 14, 0)] = C_BONE_SHADOW
	voxels.erase(Vector3i(-4, 14, 0))

	# Ancient Scalemail Neck Aventail at rear (y: 4..9, z: -4)
	for my in range(4, 10):
		for mx in range(-3, 4):
			var col = C_CHAINMAIL if (mx + my) % 2 == 0 else C_IRON_DARK
			if mx in [-1, 1] and my == 6: col = C_RUST
			voxels[Vector3i(mx, my, -4)] = col

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 2. TRUE SKELETAL TORSO: CURVED RIB ARCHES (MẢNG XƯƠNG CONG CONG) & HOLLOW CAVITY
static func build_skeleton_torso_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# --- A. Central Spinal Column (Vertebrae running from Pelvis y=0 to Neck y=18) ---
	for y in range(19):
		for x in range(-1, 2):
			for z in range(-2, 1):
				var col = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
		# Prominent Dorsal Spinous Process jutting straight out the back
		voxels[Vector3i(0, y, -3)] = C_BONE_SHADOW
		if y % 2 == 0:
			voxels[Vector3i(0, y, -4)] = C_BONE_WEATHERED

	# --- B. Lumbar Spine (y: 1..5) — Hollow Waist! ---
	# Open space between pelvis and ribcage gives the unmistakable skeletal silhouette!
	for y in range(1, 6):
		# Lateral transverse processes on lumbar vertebrae
		voxels[Vector3i(2, y, -1)] = C_BONE_WEATHERED
		voxels[Vector3i(-2, y, -1)] = C_BONE_WEATHERED

	# --- C. Sweeping 3D Curved Rib Arches (Mảng Xương Cong Cong, y: 6..15) ---
	# 5 distinct, anatomical curved rib tiers: y = 7, 9, 11, 13, 15
	# Each rib arch is a sweeping 3D spline that curves back from spine, flares out wide, and curves forward!
	var rib_configs = [
		{"y": 7,  "rx": 5, "rz_front": 3, "rz_back": -2}, # False ribs (lower flare)
		{"y": 9,  "rx": 6, "rz_front": 4, "rz_back": -2}, # Broad mid-chest rib
		{"y": 11, "rx": 6, "rz_front": 4, "rz_back": -2}, # Broad mid-chest rib
		{"y": 13, "rx": 5, "rz_front": 4, "rz_back": -2}, # Upper rib arch
		{"y": 15, "rx": 4, "rz_front": 3, "rz_back": -1}, # Top rib under collarbones
	]

	for cfg in rib_configs:
		var ry = cfg["y"]
		var rx = cfg["rx"]
		var rz_front = cfg["rz_front"]
		var rz_back = cfg["rz_back"]

		# Left & Right bilateral curved bone plates (Mảng xương cong cong)
		for side in [-1, 1]:
			# 1. Posterior curve sweeping back and outward from spine
			for px in range(1, 4):
				var pz = rz_back
				voxels[Vector3i(side * px, ry, pz)] = C_BONE
				voxels[Vector3i(side * px, ry, pz - 1)] = C_BONE_SHADOW # Underside rib shadow
				
			# 2. Lateral barrel curve wrapping around the flank (x = rx)
			for lz in range(rz_back + 1, rz_front):
				voxels[Vector3i(side * rx, ry, lz)] = C_BONE if ry % 2 != 0 else C_BONE_WEATHERED
				voxels[Vector3i(side * (rx - 1), ry, lz)] = C_BONE_WEATHERED # Rib plate thickness!
				
			# 3. Anterior sweep curving inward toward the sternum
			for ax in range(2, rx):
				voxels[Vector3i(side * ax, ry, rz_front)] = C_BONE
				voxels[Vector3i(side * ax, ry - 1, rz_front)] = C_BONE_SHADOW # Costal groove shadow
				
			# 4. Floating rib tips on lower tier (y = 7)
			if ry == 7:
				voxels[Vector3i(side * 2, ry, rz_front - 1)] = C_BONE_WEATHERED

	# Floating 11th & 12th ribs (y = 6) jutting laterally
	for side in [-1, 1]:
		voxels[Vector3i(side * 2, 6, -2)] = C_BONE
		voxels[Vector3i(side * 3, 6, -2)] = C_BONE
		voxels[Vector3i(side * 4, 6, -1)] = C_BONE_WEATHERED # Pointed floating rib tip

	# --- D. Sculpted Central Sternum & Xiphoid Process (y: 8..16, z: 4) ---
	# Manubrium & Gladiolus running down the center chest
	for sy in range(9, 17):
		voxels[Vector3i(0, sy, 4)] = C_BONE
		voxels[Vector3i(-1, sy, 4)] = C_BONE_WEATHERED if sy % 2 == 0 else C_BONE
		voxels[Vector3i(1, sy, 4)] = C_BONE_WEATHERED if sy % 2 == 0 else C_BONE
		voxels[Vector3i(0, sy, 3)] = C_BONE_SHADOW # Depth backing
	# Pointed Xiphoid Process at bottom of breastbone
	voxels[Vector3i(0, 8, 4)] = C_BONE_SHADOW
	voxels[Vector3i(0, 7, 3)] = C_BONE_SHADOW

	# --- E. Clavicles (Collarbones, y: 16..17) ---
	# S-curved collarbones bridging sternum to shoulder sockets
	for x in range(-6, 7):
		if abs(x) <= 1: continue
		var cz = 3 if abs(x) <= 4 else 2
		voxels[Vector3i(x, 16, cz)] = C_BONE
		voxels[Vector3i(x, 17, cz)] = C_BONE_WEATHERED

	# --- F. Broad Scapulae (Shoulder Blades, y: 11..16, z: -3) ---
	# Triangular bone plates covering the upper back
	for side in [-1, 1]:
		for sy in range(11, 17):
			var sw = 5 if sy >= 14 else (4 if sy >= 12 else 3)
			for sx in range(2, sw + 1):
				voxels[Vector3i(side * sx, sy, -3)] = C_BONE if sy % 2 == 0 else C_BONE_WEATHERED
			# Scapular spine ridge on back
			if sy in [14, 15]:
				voxels[Vector3i(side * 4, sy, -4)] = C_BONE

	# --- G. Pelvic Basin (Sacrum & Flared Iliac Wings, y: 0..4) ---
	# Sacrum & Coccyx at center back
	for py in range(5):
		voxels[Vector3i(0, py, -1)] = C_BONE_WEATHERED
		voxels[Vector3i(0, py, -2)] = C_BONE_SHADOW
	# Flared Iliac Wings curving outward and forward
	for side in [-1, 1]:
		for py in range(5):
			for px in range(2, 6):
				var pz = 1 if px <= 3 else (0 if py <= 2 else 2)
				var col = C_BONE if py == 4 else C_BONE_WEATHERED
				voxels[Vector3i(side * px, py, pz)] = col
		# Crest of Ilium (top rim of hip bone)
		for px in range(3, 6):
			voxels[Vector3i(side * px, 4, 1)] = C_BONE
			voxels[Vector3i(side * px, 4, 2)] = C_BONE_WEATHERED
		# Hollow acetabulum (hip socket for femur)
		voxels[Vector3i(side * 3, 1, 0)] = C_BONE_SHADOW

	# --- H. Unholy Soul Core (Lich Heart Ember suspended inside the hollow ribcage) ---
	# Suspended deep in the hollow chest cavity at y: 10..12, z: 0..1 (visible through the rib cage!)
	voxels[Vector3i(0, 11, 0)] = C_GLOW_CYAN # Glowing cyan soul core
	voxels[Vector3i(0, 11, 1)] = 0xbae6fd    # Brilliant soul spark glint!
	voxels[Vector3i(0, 10, 0)] = 0x0284c7    # Ghostly aura
	voxels[Vector3i(0, 12, 0)] = 0x0284c7

	# --- I. Primitive Gear: Scrap Iron Pauldron on Right Shoulder (y: 15..19) ---
	for py in range(15, 20):
		for px in range(5, 8):
			for pz in range(-2, 3):
				if px == 7 or py == 19 or pz in [-2, 2]:
					var col = C_IRON_DARK
					if py == 18 and px == 6 and pz == 0: col = C_BRONZE # Rivet
					elif px == 7 and py == 16: col = C_RUST # Flaked rust
					voxels[Vector3i(px, py, pz)] = col
	# Forged Pauldron Spike
	voxels[Vector3i(7, 20, 0)] = C_IRON
	voxels[Vector3i(7, 21, 0)] = C_STEEL_LIGHT
	# Pauldron Rawhide Lashings tied to right clavicle
	for x in range(3, 6):
		voxels[Vector3i(x, 16, 2)] = C_ROPE
		voxels[Vector3i(x, 16, -2)] = C_ROPE

	# --- J. Diagonal Rawhide Trophy Strap & Predator Fang ---
	for i in range(10):
		var t = float(i) / 9.0
		var hx = int(round(lerp(4.0, -3.0, t)))
		var hy = int(round(lerp(15.0, 4.0, t)))
		var hz = int(round(lerp(3.0, 3.0, t)))
		voxels[Vector3i(hx, hy, hz + 1)] = C_LEATHER
		if i == 4:
			voxels[Vector3i(hx, hy, hz + 1)] = C_BRONZE # Forged iron buckle
		elif i == 7:
			voxels[Vector3i(hx, hy - 1, hz + 1)] = C_ROPE
			voxels[Vector3i(hx, hy - 2, hz + 1)] = C_TEETH # Hanging beast canine fang!

	# --- K. Tattered Burlap War Kilt & Knotted Hemp Rope Belt (y: -3..3) ---
	# Hemp Rope Belt around Pelvis (y = 3)
	for x in range(-5, 6):
		for z in range(-3, 4):
			if abs(x) == 5 or abs(z) == 3:
				if abs(x) == 5 and abs(z) == 3: continue
				voxels[Vector3i(x, 3, z)] = C_ROPE if x % 2 == 0 else C_LEATHER_DARK
	# Knotted Hanging Cords
	voxels[Vector3i(-2, 2, 4)] = C_ROPE
	voxels[Vector3i(-2, 1, 4)] = C_ROPE
	voxels[Vector3i(-2, 0, 4)] = C_ROPE

	# Layered Tattered Burlap Kilt Rags (y: -3..2)
	for y in range(-3, 3):
		var w = 5 if y >= 0 else 4
		for x in range(-w, w + 1):
			for z in range(-3, 4):
				if abs(x) == w or z == 3 or z == -3:
					if y == -3 and (x % 2 != 0): continue # Frayed ragged hem
					var col = C_TUNIC if (x + y) % 2 == 0 else C_TUNIC_DARK
					voxels[Vector3i(x, y, z)] = col

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 3. SOLID SKELETAL UPPER ARM (Humeral Ball Head, Bone Shaft, Rawhide Bracer, Elbow Hinge)
static func build_skeleton_upper_arm_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# Humeral Head Ball Joint (y: -1..0, x: -2..2, z: -2..2)
	for y in range(-1, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_BONE

	# Solid 3x3 Humeral Bone Shaft (y: -7..-2)
	for y in range(-7, -1):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
		# Anatomical Deltoid Tuberosity ridge
		voxels[Vector3i(0, y, 2)] = C_BONE_WEATHERED

	# Primitive Rawhide Armband Wrap with Bone Splint (y: -5..-4)
	for y in [-5, -4]:
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 or abs(z) == 2:
					if abs(x) == 2 and abs(z) == 2: continue
					voxels[Vector3i(x, y, z)] = C_LEATHER_DARK if y == -5 else C_LEATHER
	voxels[Vector3i(2, -4, 0)] = C_BONE # Bone splint needle

	# Distal Elbow Condyles (y: -9..-8, flared hinge joint)
	for y in range(-9, -7):
		for x in range(-2, 3):
			for z in range(-2, 2):
				if abs(x) == 2 and z == -2: continue
				voxels[Vector3i(x, y, z)] = C_BONE_WEATHERED if y == -9 else C_BONE

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 4. SOLID SKELETAL FOREARM & CLENCHED FIST (Radius/Ulna, Studded Bracer, Tight Hand Grip)
static func build_skeleton_forearm_mesh(is_right: bool) -> ArrayMesh:
	var voxels: Dictionary = {}

	# Proximal Elbow Joint (y: -1..0, x: -2..2, z: -2..2)
	for y in range(-1, 1):
		for x in range(-2, 3):
			for z in range(-2, 2):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_BONE

	# Dual Forearm Bones: Radius & Ulna (y: -6..-2)
	for y in range(-6, -1):
		# Ulna bone
		for x in range(-2, 0):
			voxels[Vector3i(x, y, 0)] = C_BONE
			voxels[Vector3i(x, y, 1)] = C_BONE_WEATHERED
		# Radius bone
		for x in range(1, 3):
			voxels[Vector3i(x, y, 0)] = C_BONE_WEATHERED
			voxels[Vector3i(x, y, 1)] = C_BONE
		# Interosseous dark groove
		voxels[Vector3i(0, y, 0)] = C_BONE_SHADOW

	# Primitive Studded Leather Bracer (y: -6..-4)
	for y in range(-6, -3):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 or abs(z) == 2:
					if abs(x) == 2 and abs(z) == 2: continue
					var col = C_LEATHER_DARK if y == -6 else C_LEATHER
					if y == -5 and abs(x) == 2 and z == 0: col = C_BRONZE
					voxels[Vector3i(x, y, z)] = col

	# Clenched Skeletal Fist / Hand Grip (y: -9..-7)
	# Wraps around the weapon/shield grip with solid knuckles
	for y in range(-9, -6):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				var col = C_BONE
				if y == -9: col = C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
	# White Knuckle Highlights on front of fist
	for fx in [-1, 0, 1]:
		voxels[Vector3i(fx, -8, 2)] = C_TEETH
		voxels[Vector3i(fx, -9, 2)] = C_BONE

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 5. SOLID SKELETAL THIGH (Femur, Condyles & Rawhide Bandage)
static func build_skeleton_thigh_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# Femoral Ball Head (y: -1..0, x: -2..2, z: -2..2)
	for y in range(-1, 1):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_BONE

	# Solid 3x3 Femur Shaft with posterior ridge (y: -7..-2)
	for y in range(-7, -1):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
		# Linea aspera crest on back
		voxels[Vector3i(0, y, -2)] = C_BONE_SHADOW

	# Primitive Rawhide Thigh Wrap (y: -5..-4)
	for y in [-5, -4]:
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 or abs(z) == 2:
					if abs(x) == 2 and abs(z) == 2: continue
					voxels[Vector3i(x, y, z)] = C_LEATHER_DARK if y == -5 else C_LEATHER

	# Distal Knee Condyles (y: -9..-8, flared hinge)
	for y in range(-9, -7):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_BONE if y == -8 else C_BONE_WEATHERED

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 6. SOLID SKELETAL SHIN & SKELETAL CLAWED FOOT (Patella, Tibia, 5 Claws, y: -10 flat)
static func build_skeleton_shin_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# Massive Patella (Kneecap) jutting forward (y: -1..1, z: 2..3)
	for y in range(-1, 2):
		for x in range(-1, 2):
			voxels[Vector3i(x, y, 2)] = C_BONE
	voxels[Vector3i(0, 0, 3)] = C_BONE # Prominent kneecap apex

	# Knee Plateau Joint (y: -1..0, x: -2..2, z: -2..2)
	for y in range(-1, 1):
		for x in range(-2, 3):
			for z in range(-2, 2):
				if abs(x) == 2 and abs(z) == 2: continue
				voxels[Vector3i(x, y, z)] = C_BONE_WEATHERED

	# Solid 3x3 Tibia Shaft & Lateral Fibula (y: -7..-2)
	for y in range(-7, -1):
		for x in range(-1, 2):
			for z in range(-1, 2):
				voxels[Vector3i(x, y, z)] = C_BONE if y % 2 == 0 else C_BONE_WEATHERED
		# Anterior sharp tibial shin crest
		voxels[Vector3i(0, y, 2)] = C_BONE
		# Lateral fibula bone
		voxels[Vector3i(2, y, 0)] = C_BONE_WEATHERED

	# Primitive Ankle Rawhide Wrap (y: -7..-6)
	for y in [-7, -6]:
		for x in range(-2, 3):
			for z in range(-2, 2):
				if abs(x) == 2 or abs(z) == 2:
					voxels[Vector3i(x, y, z)] = C_LEATHER_DARK

	# Articulated Skeletal Foot (Tarsals, Metatarsals, 5 Claws)
	# Flat sole strictly at y = -10 (zero floor clipping at ground_hips_y = 0.64)
	for y in range(-10, -7):
		for x in range(-2, 3):
			for z in range(-3, 3):
				if abs(x) == 2 and z == -3: continue
				var col = C_BONE if y > -10 else C_BONE_WEATHERED
				voxels[Vector3i(x, y, z)] = col
	# Distinct Calcaneus (Heel bone spur)
	voxels[Vector3i(0, -9, -4)] = C_BONE
	voxels[Vector3i(0, -10, -4)] = C_BONE_WEATHERED

	# 5 Articulated Skeletal Toes with Pointed Claws (z: 3..5)
	for tx in [-2, -1, 0, 1, 2]:
		var claw_len = 5 if abs(tx) <= 1 else 4
		for tz in range(3, claw_len + 1):
			var col = C_BONE if tz < claw_len else C_TEETH
			voxels[Vector3i(tx, -10, tz)] = col
			if tz == 3:
				voxels[Vector3i(tx, -9, tz)] = C_BONE # Knuckle ridge

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 7. SHODDY NOTCHED IRON BROADSWORD (LETHAL 1-VOXEL THIN RAZOR BLADE, NATURAL HAND GRIP)
# Hand grips firmly at y = 0, pommel hangs below, crossguard sits right above fist!
static func build_shoddy_sword_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# --- A. Heavy Pitted Iron Ring Pommel (y: -7..-5, x: -2..2, z: -1..1) ---
	for y in range(-7, -4):
		for x in range(-2, 3):
			for z in range(-1, 2):
				if abs(x) == 2 and abs(z) == 1: continue
				var col = C_IRON_DARK
				if y == -7: col = C_RUST # Oxidized bottom ring
				voxels[Vector3i(x, y, z)] = col
	# Hollow center ring opening
	voxels.erase(Vector3i(0, -6, 0))

	# --- B. Two-Handed Dark Leather & Bronze Wire Grip (y: -4..3) ---
	# Hand grips firmly at y = -2..1. Grip is 3x3 with beveled corners.
	for y in range(-4, 4):
		for x in range(-1, 2):
			for z in range(-1, 2):
				if abs(x) == 1 and abs(z) == 1: continue
				var col = C_LEATHER_DARK
				if y in [-3, 0, 3]: col = C_BRONZE # Twisted spiral wire wraps!
				elif y % 2 == 0: col = C_LEATHER
				voxels[Vector3i(x, y, z)] = col

	# --- C. Forged Dark Iron Crossguard (y: 4..5, x: -4..4, z: -1..1) ---
	# Balanced 9-voxel width right above the knuckles
	for x in range(-4, 5):
		for y in range(4, 6):
			for z in range(-1, 2):
				var col = C_IRON_DARK
				if y == 5 or abs(x) == 4: col = C_IRON
				voxels[Vector3i(x, y, z)] = col
	# Center Bronze Boss & Rivets
	voxels[Vector3i(0, 4, 1)] = C_BRONZE
	voxels[Vector3i(0, 4, -1)] = C_BRONZE
	# Clawed Quillon Tips with rust pitting
	voxels[Vector3i(-4, 6, 0)] = C_IRON
	voxels[Vector3i(-5, 6, 0)] = C_RUST
	voxels[Vector3i(4, 6, 0)] = C_IRON
	voxels[Vector3i(5, 6, 0)] = C_RUST

	# --- D. LETHAL SLEEK BROADSWORD BLADE (y: 6..27, strictly z = 0!) ---
	# Perfectly proportioned 3-5 voxel width, 1 voxel thin razor blade!
	for y in range(6, 28):
		# w = 2 (5 voxels) at ricasso base y: 6..8; w = 1 (3 voxels) for blade body
		var w = 2 if y <= 8 else 1
		for x in range(-w, w + 1):
			var is_edge = (abs(x) == w)
			var is_fuller = (x == 0 and y <= 22 and y >= 8)
			
			var col = C_IRON
			if is_edge:
				# Honed razor steel cutting bevels with light glints
				col = C_STEEL_BRIGHT if y % 2 == 0 else C_STEEL_LIGHT
			elif is_fuller:
				col = C_IMP_EBONY # Dark recessed fuller blood groove
			else:
				col = C_IRON_DARK
				
			voxels[Vector3i(x, y, 0)] = col

	# Natural battle rust patches near crossguard
	voxels[Vector3i(0, 6, 0)] = C_RUST
	voxels[Vector3i(1, 7, 0)] = C_RUST

	# --- E. Battle Damage: Chipped Edges & Snapped Blade Tip ---
	# Notch 1: Deep axe bite on left edge at y = 13
	voxels.erase(Vector3i(-1, 13, 0))
	voxels[Vector3i(0, 13, 0)] = C_RUST # Oxidized notched crater

	# Notch 2: Shield clash gouge on right edge at y = 19
	voxels.erase(Vector3i(1, 19, 0))
	voxels[Vector3i(0, 19, 0)] = C_RUST

	# Broken Chisel Tip at y = 26..27 (Tip snapped in ancient siege)
	voxels.erase(Vector3i(1, 26, 0))
	voxels.erase(Vector3i(1, 27, 0))
	voxels.erase(Vector3i(0, 27, 0))
	voxels[Vector3i(-1, 27, 0)] = C_STEEL_BRIGHT # Exposed fresh fracture glint!
	voxels[Vector3i(0, 26, 0)] = C_STEEL_BRIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)


# 8. SPLINTERED WOODEN WAR SHIELD (Forward-Facing, Curved Planks, Heavy Iron Rim & Central Spike Umbo)
static func build_wooden_shield_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}

	# 3D Curved Timber Plank Shield Body (Radius 9 voxels, ~0.54m diameter)
	for y in range(-9, 10):
		for x in range(-9, 10):
			var dist2 = x * x + y * y
			if dist2 > 81: continue
			
			var curve_z = int(round((1.0 - float(dist2) / 81.0) * 2.5))
			var plank_id = int(floor(float(x + 9) / 4.5))
			var col = C_WOOD if plank_id % 2 == 0 else C_WOOD_DARK
			
			voxels[Vector3i(x, y, curve_z)] = col
			voxels[Vector3i(x, y, curve_z - 1)] = C_WOOD_DARK

	# Severe Splintered Edge Damage
	# Top-left splinter blowout
	for y in range(5, 10):
		for x in range(-9, -4):
			if (x + 8) * (x + 8) + (y - 7) * (y - 7) <= 12:
				for z in range(-2, 5):
					voxels.erase(Vector3i(x, y, z))
	# Bottom-right splinter blowout
	for y in range(-9, -5):
		for x in range(4, 10):
			if (x - 7) * (x - 7) + (y + 7) * (y + 7) <= 10:
				for z in range(-2, 5):
					voxels.erase(Vector3i(x, y, z))

	# Faded Blood-Red Tribal Skull War Sigil painted across planks
	for y in range(-4, 6):
		for x in range(-4, 5):
			var dist2 = x * x + y * y
			if dist2 <= 16 and dist2 >= 4:
				var curve_z = int(round((1.0 - float(dist2) / 81.0) * 2.5))
				if voxels.has(Vector3i(x, y, curve_z)):
					voxels[Vector3i(x, y, curve_z)] = C_WARPAINT_RED

	# Heavy Hammered Dark Iron Rim Cladding with Bronze Rivets
	for y in range(-9, 10):
		for x in range(-9, 10):
			var dist2 = x * x + y * y
			if dist2 >= 64 and dist2 <= 81:
				var curve_z = int(round((1.0 - float(dist2) / 81.0) * 2.5))
				if voxels.has(Vector3i(x, y, curve_z)):
					var col = C_IRON_DARK
					if (abs(x) == 7 or abs(y) == 7): col = C_BRONZE
					elif (x + y) % 4 == 0: col = C_RUST
					voxels[Vector3i(x, y, curve_z + 1)] = col

	# Massive Forged Dark Iron Central Umbo Boss with Brutal Spike
	for y in range(-3, 4):
		for x in range(-3, 4):
			if x * x + y * y <= 9:
				voxels[Vector3i(x, y, 3)] = C_IRON_DARK
				if x * x + y * y == 9:
					voxels[Vector3i(x, y, 3)] = C_BRONZE
	for y in range(-2, 3):
		for x in range(-2, 3):
			if x * x + y * y <= 4:
				voxels[Vector3i(x, y, 4)] = C_IRON
	# Central Brutal Conical Spike jutting forward (+Z)
	voxels[Vector3i(0, 0, 5)] = C_STEEL_LIGHT
	voxels[Vector3i(0, 0, 6)] = C_STEEL_BRIGHT

	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)
