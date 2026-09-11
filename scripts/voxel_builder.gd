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

# --- 1. HEAD (Big Chunky Hooked Nose, 3D Curved Tusks & Long Sharp Pointed Goblin Ears) ---
static func build_head_mesh() -> ArrayMesh:
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
	
	# LONG SHARP POINTED GOBLIN EARS (Swept horizontally & angled back, tapering to a needle tip)
	for side in [-1, 1]:
		# s: distance steps outward from head side (s=0 at x=5, up to s=8 at x=13)
		for s in range(9):
			var ex = side * (5 + s)
			var ez = 0 - int(float(s) * 0.4) # Sweeps backwards naturally
			
			# Taper vertical span from wide base (y: 8..14) to sharp tip (y: 12)
			var y_low = 8 + int(float(s) * 0.5)
			var y_high = 14 - int(float(s) * 0.25)
			if s == 8:
				y_low = 12
				y_high = 12 # Single sharp needle-point tip!
			elif s == 7:
				y_low = 11
				y_high = 13
				
			for ey in range(y_low, y_high + 1):
				# Feral ear notch / tear at s=5 on upper rim
				if s == 5 and ey == y_high: continue
				
				var col = C_SKIN
				var is_inner = (s >= 1 and s <= 4 and ey >= y_low + 1 and ey <= y_high - 1)
				if is_inner:
					col = C_EAR_INNER # Pinkish cartilage ear cup
				elif ey == y_high or s == 8:
					col = C_SKIN_LIGHT # Highlight along top sharp ridge to tip
				elif ey == y_low:
					col = C_SKIN_DARK # Darker underside
					
				voxels[Vector3i(ex, ey, ez)] = col
				# Give base of ear depth at z-1
				if s <= 4:
					voxels[Vector3i(ex, ey, ez - 1)] = C_SKIN_DARK
					
	var arr = []
	for k in voxels:
		arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(arr)

# --- 2. TORSO & TUNIC (Upward 0 to 17) ---
static func build_torso_mesh() -> ArrayMesh:
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

# --- 3. UPPER ARM ---
static func build_upper_arm_mesh() -> ArrayMesh:
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

# --- 4. FOREARMS & SOLID CLENCHED FISTS (Zero Holes / Fully Sealed) ---
static func build_forearm_mesh(is_right: bool) -> ArrayMesh:
	var voxels = []
	if not is_right:
		# Left Forearm & Open Claw Hand
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
		# Right Forearm & Solid Clenched Fist Gripping Weapon (Fully Solid, Zero Gaps)
		for y in range(-9, 1):
			for x in range(-2, 3):
				for z in range(-2, 3):
					var col = C_SKIN
					# 1. Leather bracer wrap around mid-forearm (y: -5, -4)
					if y == -4 or y == -5:
						col = C_LEATHER_DARK if y == -5 else C_LEATHER
					# 2. Wrist taper (y: -6)
					elif y == -6:
						col = C_SKIN if z >= 0 else C_SKIN_DARK
					# 3. Solid Clenched Fist (y: -7, -8, -9) - Completely filled, no hollow tunnel!
					elif y <= -7:
						# Knuckles & Finger Segments in front (z == 2)
						if z == 2:
							col = C_SKIN_LIGHT if y == -7 else (C_CLAWS if y == -9 and abs(x) <= 1 else C_SKIN)
						# Outer flank / pinky finger (x == 2)
						elif x == 2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						# Inner flank / Clenched Thumb (x == -2)
						elif x == -2:
							col = C_CLAWS if (y == -8 and z == 1) else C_SKIN_LIGHT
						# Back of hand (z == -2)
						elif z == -2:
							col = C_SKIN_DARK if y == -9 else C_SKIN
						# Interior core of fist (solid skin / palm flesh tightly gripping handle)
						else:
							col = C_SKIN
					voxels.append([x, y, z, col])
					
		# Extra defined 3D Thumb knuckle & claw wrapped over the front
		voxels.append([-2, -7, 1, C_SKIN_LIGHT])
		voxels.append([-1, -7, 2, C_SKIN_LIGHT])
		voxels.append([-1, -8, 2, C_CLAWS])
		# Claws on front fingertips
		voxels.append([0, -9, 2, C_CLAWS])
		voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

# --- 5. ARTICULATED LEGS & 3D THICK FEET ---
static func build_thigh_mesh() -> ArrayMesh:
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

# Sculpted 3D Muscular Shin, Solid Heel, Arched Instep & Chunky Claws
static func build_shin_mesh() -> ArrayMesh:
	var voxels = []
	
	# 1. Upper Shin & Muscular Calf Bulge (y: -6 to 0)
	for y in range(-6, 1):
		var z_min = -3 if (y >= -5 and y <= -2) else -2 # Calf bulges backwards
		for x in range(-2, 3):
			for z in range(z_min, 3):
				var col = C_SKIN
				if z == 2: # Shin bone ridge in front
					col = C_SKIN_LIGHT
				elif z == -3: # Muscular back of calf
					col = C_SKIN_DARK
				voxels.append([x, y, z, col])
				
	# 2. Lower Leg Leather Wraps (y: -7 to -5)
	for y in range(-7, -5):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var col = C_LEATHER_DARK if y == -6 else C_LEATHER
				voxels.append([x, y, z, col])
				
	# 3. Flared Ankle / Malleolus (y = -8)
	for x in range(-3, 4):
		for z in range(-2, 3):
			var col = C_SKIN_DARK if abs(x) == 3 else C_SKIN
			voxels.append([x, -8, z, col])
			
	# 4. Solid Arched Foot & Robust Heel (y: -10 to -8, z: -3 to 3)
	for y in range(-10, -7):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and (z == -3 or z == 3): continue
				if y == -8 and (z > 1 or abs(x) == 3): continue # Instep slope
				
				var col = C_SKIN
				if y == -10:
					col = C_SKIN_DARK # Tough sole
				elif z >= 0 and y == -8:
					col = C_SKIN_LIGHT # Arched instep crest
				voxels.append([x, y, z, col])
				
	# 5. 3 Chunky 3D Predatory Toes with Claws (z: 4 to 7)
	for tx in [-2, 0, 2]:
		# Knuckles (2 voxels tall: y in [-10, -9])
		for tz in range(4, 6):
			for ty in [-10, -9]:
				var col = C_SKIN_LIGHT if (ty == -9 and tz == 4) else C_SKIN
				voxels.append([tx, ty, tz, col])
				if tz == 4:
					var side_x = tx + (1 if tx < 0 else -1)
					if side_x != 0 or tx != 0:
						voxels.append([side_x, -10, tz, C_SKIN])
						
		# Sharp Claw Tips (z: 6..7)
		voxels.append([tx, -10, 6, C_CLAWS])
		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

# --- 6. SPIKED WAR CLUB ---
static func build_club_mesh() -> ArrayMesh:
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
	
	# Layered Forest Glade: Giant Sentinels (5.0m - 6.5m) + Mid-Canopy Pines (3.2m - 4.0m)
	# Format: [tx, tz, th] (scale 0.10m per voxel)
	var trees = [
		# Mid-ground trees (Lush green canopies framing right above goblin's head)
		Vector3i(0, 36, -26),      # Center mid-tree (3.6m tall)
		Vector3i(-18, 38, -24),    # Left mid-tree (3.8m tall)
		Vector3i(18, 38, -24),     # Right mid-tree (3.8m tall)
		Vector3i(-32, 34, -10),    # Left flank tree (3.4m tall)
		Vector3i(32, 34, -10),     # Right flank tree (3.4m tall)
		
		# Towering Colossus Sentinels in the background (5.0m - 6.5m)
		Vector3i(-12, 65, -45),    # Deep giant sentinel (6.5m tall!)
		Vector3i(12, 64, -45),     # Deep giant sentinel (6.4m tall!)
		Vector3i(-28, 55, -36),    # Deep-left colossus (5.5m tall)
		Vector3i(28, 56, -36),     # Deep-right colossus (5.6m tall)
		Vector3i(-42, 46, 2),      # Foreground-left framing colossus (4.6m tall)
		Vector3i(42, 48, 2)        # Foreground-right framing colossus (4.8m tall)
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

static func build_shaman_head_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Base Head with pointed ears and jaw
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) == 3 and abs(z) == 3: continue
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
	for y in range(4, 8):
		for x in range(-5, 6):
			for z in range(-4, 7):
				if abs(x) == 5 and (z < -2 or z > 4): continue
				voxels[Vector3i(x, y, z)] = C_SKIN
	voxels[Vector3i(-3, 6, 6)] = C_TEETH
	voxels[Vector3i(3, 6, 6)] = C_TEETH

	# Cranium (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# Ears
	for side in [-1, 1]:
		for s in range(8):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.4)
			var ez = -1 - int(float(s) * 0.7)
			voxels[Vector3i(ex, ey, ez)] = C_SKIN
			if s <= 3: voxels[Vector3i(ex, ey, ez + 1)] = C_EAR_INNER

	# SHAMAN BEAST SKULL MASK (Upper Face y: 9..17, z: 2..7)
	for y in range(9, 17):
		for x in range(-5, 6):
			for z in range(3, 8):
				var on_shell = (abs(x) == 5 or y == 16 or z == 7)
				if on_shell:
					voxels[Vector3i(x, y, z)] = C_BONE if (y in [9, 13]) else C_SKULL_BONE
	# Skull Snout
	for y in range(9, 13):
		for x in range(-2, 3):
			for z in range(7, 11):
				voxels[Vector3i(x, y, z)] = C_SKULL_BONE if y > 9 else C_BONE

	# Glowing Eerie Eye Holes (Cyan spiritual flame)
	voxels[Vector3i(-2, 12, 8)] = C_GLOW_CYAN
	voxels[Vector3i(-3, 12, 8)] = C_GLOW_CYAN
	voxels[Vector3i(2, 12, 8)] = C_GLOW_CYAN
	voxels[Vector3i(3, 12, 8)] = C_GLOW_CYAN

	# Curved Beast Horns (Sprouting from Skull Temples)
	for side in [-1, 1]:
		# Horn base: x=side*5, y=15, z=2 -> curves outward and back
		var horn_pts = [
			Vector3i(side * 5, 15, 2),
			Vector3i(side * 6, 16, 1),
			Vector3i(side * 7, 17, 0),
			Vector3i(side * 8, 18, -1),
			Vector3i(side * 9, 18, -3),
			Vector3i(side * 9, 17, -5),
			Vector3i(side * 8, 16, -7), # Horn tip curls down/back
		]
		for hp in horn_pts:
			voxels[hp] = C_BONE
			voxels[hp + Vector3i(0, -1, 0)] = C_WOOD_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_torso_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Ritual Robes with Bone Fetishes & Purple Fabric
	for y in range(16):
		var rad_x = 5 if y < 4 else (6 if y < 12 else 5)
		var rad_z = 4 if y < 12 else 4
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				var is_surf = (abs(x) == rad_x or abs(z) == rad_z or y in [0, 15])
				var col = C_PURPLE_DARK
				if y in [4, 8, 12] and is_surf: col = C_PURPLE_MAGIC
				if y in [0, 1]: col = C_TUNIC_DARK # Tattered hem
				voxels[Vector3i(x, y, z)] = col

	# Bone Necklace & Amulet (y: 11..13, z: 5)
	for x in range(-4, 5):
		voxels[Vector3i(x, 13 - abs(x) / 2, 5)] = C_ROPE
	voxels[Vector3i(-3, 11, 5)] = C_BONE
	voxels[Vector3i(3, 11, 5)] = C_BONE
	voxels[Vector3i(0, 10, 5)] = C_GLOW_CYAN # Soul Gem Amulet
	voxels[Vector3i(0, 9, 5)] = C_BONE

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_shaman_staff_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Twisted Gnarled Staff length: 44 voxels (1.32m)
	for y in range(-16, 22):
		var wobble_x = int(sin(float(y) * 0.4) * 1.2)
		var wobble_z = int(cos(float(y) * 0.3) * 1.0)
		for dx in range(-1, 2):
			for dz in range(-1, 2):
				if abs(dx) + abs(dz) <= 1:
					voxels[Vector3i(wobble_x + dx, y, wobble_z + dz)] = C_WOOD_DARK if (y in [-10, 0, 10]) else C_WOOD

	# Staff Crown: Mini Demon Skull (y: 22..28)
	for y in range(22, 28):
		for x in range(-3, 4):
			for z in range(-3, 4):
				if abs(x) + abs(z) <= 5:
					voxels[Vector3i(x, y, z)] = C_SKULL_BONE
	# Skull eye sockets
	voxels[Vector3i(-1, 25, 3)] = C_PURPLE_MAGIC
	voxels[Vector3i(1, 25, 3)] = C_PURPLE_MAGIC

	# Glowing Floating Soul Orb nestled in horns (y: 29..32)
	for y in range(29, 33):
		for x in range(-2, 3):
			for z in range(-2, 3):
				if abs(x) + abs(z) + abs(y - 30) <= 3:
					voxels[Vector3i(x, y, z)] = C_GLOW_CYAN if (x == 0 and z == 0) else C_PURPLE_MAGIC

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_totem_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Goblin Demon Totem Pillar (Height ~ 1.2m, 40 voxels)
	for y in range(36):
		var rad = 5 if (y in [10, 20, 30]) else 4
		for x in range(-rad, rad + 1):
			for z in range(-rad, rad + 1):
				if abs(x) == rad and abs(z) == rad: continue
				var col = C_WOOD_DARK if (x + y + z) % 3 == 0 else C_WOOD
				# Carved Face 1 (Lower y: 6..14)
				if z == rad:
					if y in [9, 10] and abs(x) in [2, 3]: col = C_PURPLE_MAGIC # Glowing runic eyes
					if y in [7, 8] and abs(x) <= 3: col = C_MOUTH_DARK # Grimacing mouth
					if y == 8 and abs(x) in [1, 3]: col = C_TEETH # Fangs
				# Carved Face 2 (Upper y: 22..30)
				if z == rad:
					if y in [26, 27] and abs(x) in [2, 3]: col = C_GLOW_CYAN # Glowing cyan eyes
					if y in [24, 25] and abs(x) <= 2: col = C_MOUTH_DARK
					if y == 25 and abs(x) == 1: col = C_TEETH
				voxels[Vector3i(x, y, z)] = col

	# Horns on Totem Crown (y: 35..42)
	for side in [-1, 1]:
		for s in range(6):
			voxels[Vector3i(side * (4 + s), 36 + s, 0)] = C_BONE
			voxels[Vector3i(side * (4 + s), 36 + s, 1)] = C_WOOD_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- C. GOBLIN ROGUE (Khăn Bịt Mặt & Song Dao Găm Răng Cưa) ---

static func build_rogue_head_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Standard anatomical goblin base
	for y in range(4):
		for x in range(-3, 4):
			for z in range(-3, 4):
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK if y == 0 else C_SKIN
	# Cranium (y: 8..16)
	for y in range(8, 17):
		var rad_x = 5 if (y in [8, 9, 13, 14]) else (6 if y < 15 else 4)
		var rad_z = 5 if y < 15 else 3
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				voxels[Vector3i(x, y, z)] = C_SKIN

	# ROGUE BANDANA / COWL (Covers mouth and lower jaw y: 4..10)
	for y in range(4, 11):
		for x in range(-5, 6):
			for z in range(-4, 8):
				var on_surf = (abs(x) == 5 or abs(z) == 7 or y == 4)
				if on_surf:
					voxels[Vector3i(x, y, z)] = C_TUNIC_DARK if y == 4 else 0x1e1b18

	# Sharp predatory eyes (y: 10, z: 6)
	voxels[Vector3i(-2, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-3, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(-2, 10, 7)] = C_EYE_PUPIL
	voxels[Vector3i(2, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(3, 10, 6)] = C_EYE_YELLOW
	voxels[Vector3i(2, 10, 7)] = C_EYE_PUPIL

	# Pointed Ears
	for side in [-1, 1]:
		for s in range(8):
			var ex = side * (5 + s)
			var ey = 10 - int(float(s) * 0.4)
			var ez = -1 - int(float(s) * 0.7)
			voxels[Vector3i(ex, ey, ez)] = C_SKIN
			if s <= 3: voxels[Vector3i(ex, ey, ez + 1)] = C_EAR_INNER

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_dagger_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Serrated Bone Dagger: length 18 voxels (0.54m) along +Y
	# Pommel (y: -6..-5)
	voxels[Vector3i(0, -6, 0)] = C_BONE
	voxels[Vector3i(1, -6, 0)] = C_BONE
	voxels[Vector3i(-1, -6, 0)] = C_BONE

	# Leather Grip (y: -4..0)
	for y in range(-4, 1):
		voxels[Vector3i(0, y, 0)] = C_LEATHER
		voxels[Vector3i(0, y, 1)] = C_LEATHER_DARK

	# Crossguard (y: 1, x: -3..3)
	for x in range(-3, 4):
		voxels[Vector3i(x, 1, 0)] = C_BONE
		voxels[Vector3i(x, 1, 1)] = C_LEATHER

	# Serrated Curved Blade (y: 2..12)
	for y in range(2, 13):
		var curve_z = int(float(y - 2) * 0.35)
		# Spine
		voxels[Vector3i(0, y, curve_z)] = C_BONE
		# Cutting edge (with serration hooks)
		var is_tooth = (y % 2 == 1)
		voxels[Vector3i(0, y, curve_z + 1)] = C_TEETH if is_tooth else C_SKULL_BONE
		if is_tooth and y < 11:
			voxels[Vector3i(0, y - 1, curve_z + 2)] = C_TEETH # Barb tooth hook

	# Needle Point Tip (y: 13..14)
	voxels[Vector3i(0, 13, 4)] = C_TEETH
	voxels[Vector3i(0, 14, 5)] = C_TEETH

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- D. GOBLIN CHIEFTAIN (Boss Tù Trưởng Khổng Lồ, Mũ Sắt Sừng, Đại Chùy) ---

static func build_boss_head_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Massive Head with Heavy Iron Helmet & Giant Horns
	# Neck (y: 0..3)
	for y in range(4):
		for x in range(-4, 5):
			for z in range(-4, 5):
				voxels[Vector3i(x, y, z)] = C_SKIN_DARK

	# Heavy Jaw with brutal scars (y: 4..8)
	for y in range(4, 9):
		for x in range(-6, 7):
			for z in range(-5, 8):
				var col = C_SKIN
				if x in [-2, -1] and y in [5, 6]: col = C_RUST # Battle scar
				voxels[Vector3i(x, y, z)] = col
	# Giant Boar Tusks
	voxels[Vector3i(-4, 7, 7)] = C_TEETH
	voxels[Vector3i(-4, 8, 8)] = C_TEETH
	voxels[Vector3i(4, 7, 7)] = C_TEETH
	voxels[Vector3i(4, 8, 8)] = C_TEETH

	# HEAVY IRON HORNED HELMET (Cranium y: 9..18)
	for y in range(9, 19):
		var rad_x = 7 if y < 17 else 5
		var rad_z = 6 if y < 17 else 4
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				var on_outer = (abs(x) == rad_x or abs(z) == rad_z or y >= 17)
				if on_outer:
					voxels[Vector3i(x, y, z)] = C_IRON_DARK if (y == 9 or y == 18) else C_IRON
				else:
					voxels[Vector3i(x, y, z)] = C_SKIN

	# Steel Nose Guard (y: 8..13, x: 0, z: 8)
	for y in range(8, 14):
		voxels[Vector3i(0, y, 8)] = C_STEEL_LIGHT
		voxels[Vector3i(1, y, 7)] = C_IRON
		voxels[Vector3i(-1, y, 7)] = C_IRON

	# Burning Red Boss Eyes
	voxels[Vector3i(-3, 11, 7)] = C_FEATHER_RED
	voxels[Vector3i(-2, 11, 7)] = C_GOLD
	voxels[Vector3i(3, 11, 7)] = C_FEATHER_RED
	voxels[Vector3i(2, 11, 7)] = C_GOLD

	# Colossal War Horns (y: 15..24)
	for side in [-1, 1]:
		var h_pts = [
			Vector3i(side * 7, 16, 2),
			Vector3i(side * 8, 17, 1),
			Vector3i(side * 9, 18, 0),
			Vector3i(side * 10, 20, 0),
			Vector3i(side * 11, 22, 1),
			Vector3i(side * 12, 24, 2),
			Vector3i(side * 12, 25, 4), # Tips point forward & up
		]
		for p in h_pts:
			voxels[p] = C_BONE
			voxels[p + Vector3i(0, 0, -1)] = C_WOOD_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_boss_torso_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Heavy Armored Torso with Spiked Iron Pauldron on Right Shoulder
	for y in range(17):
		var rad_x = 7 if y < 4 else (8 if y < 14 else 7)
		var rad_z = 5 if y < 14 else 5
		for x in range(-rad_x, rad_x + 1):
			for z in range(-rad_z, rad_z + 1):
				var col = C_TUNIC_DARK
				# Studded Iron Armor Bands
				if y in [2, 6, 10, 14] and (abs(x) == rad_x or abs(z) == rad_z):
					col = C_STEEL_LIGHT if ((abs(x) == rad_x and abs(z) == rad_z) or (x == 0 and abs(z) == rad_z)) else C_IRON
				voxels[Vector3i(x, y, z)] = col

	# Spiked Iron Pauldron (Right Shoulder: x: 7..11, y: 13..18)
	for x in range(7, 12):
		for y in range(13, 19):
			for z in range(-4, 5):
				voxels[Vector3i(x, y, z)] = C_IRON_DARK if y == 13 else C_IRON
	# 3 Giant Steel Spikes on Pauldron
	voxels[Vector3i(10, 19, 0)] = C_SPIKE
	voxels[Vector3i(10, 20, 0)] = C_SPIKE
	voxels[Vector3i(10, 21, 0)] = C_SPIKE_DARK

	voxels[Vector3i(10, 18, 3)] = C_SPIKE
	voxels[Vector3i(10, 19, 4)] = C_SPIKE_DARK

	voxels[Vector3i(10, 18, -3)] = C_SPIKE
	voxels[Vector3i(10, 19, -4)] = C_SPIKE_DARK

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_boss_warhammer_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Colossal Spiked Iron War-Hammer: length ~ 1.5m (50 voxels)
	# Thick Reinforced Shaft
	for y in range(-20, 24):
		for x in range(-1, 2):
			for z in range(-1, 2):
				var col = C_WOOD_DARK
				if y in [-15, -5, 5, 15]: col = C_IRON # Iron reinforcement rings
				voxels[Vector3i(x, y, z)] = col

	# Massive Cubical Iron Hammerhead (y: 18..30, x: -6..6, z: -5..5)
	for y in range(18, 31):
		for x in range(-6, 7):
			for z in range(-5, 6):
				var on_surf = (abs(x) == 6 or abs(z) == 5 or y in [18, 30])
				voxels[Vector3i(x, y, z)] = C_IRON if on_surf else C_IRON_DARK

	# 8 Brutal Steel Ram Spikes extending from Hammer faces
	# Front ram spike (+Z)
	for dz in range(6, 11):
		voxels[Vector3i(0, 24, dz)] = C_SPIKE if dz < 10 else C_STEEL_LIGHT
	# Back ram spike (-Z)
	for dz in range(-10, -5):
		voxels[Vector3i(0, 24, dz)] = C_SPIKE if dz > -10 else C_STEEL_LIGHT
	# Left spikes (-X)
	for dx in range(-10, -6):
		voxels[Vector3i(dx, 24, 0)] = C_SPIKE
	# Right spikes (+X)
	for dx in range(7, 11):
		voxels[Vector3i(dx, 24, 0)] = C_SPIKE

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)
