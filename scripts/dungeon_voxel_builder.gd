class_name DungeonVoxelBuilder
extends RefCounted

# =============================================================================
# DUNGEON VOXEL BUILDER - PROCEDURAL ROGUELIKE HACK & SLASH ARCHITECTURE
# Inspired by Hades, Enter the Gungeon, Diablo & Top-Down Dungeon RPG Battlemaps
# =============================================================================

const V_SCALE: float = 0.20 # 20cm per voxel cube - classic chunky high-readability voxel art

# Palette Constants (sRGB hex)
const C_STONE_FLOOR: int      = 0x94a3b8 # Clean dungeon flagstone
const C_STONE_FLOOR_ALT: int  = 0x64748b # Darker stone variation
const C_STONE_WALL: int       = 0x334155 # Sturdy masonry wall block
const C_STONE_WALL_DARK: int  = 0x1e293b # Deep foundation mortar
const C_STONE_WALL_TRIM: int  = 0x475569 # Cornice / wall cap
const C_STONE_PILLAR: int     = 0xcbd5e1 # Fluted stone column

# Room 1: Royal Hub (Emerald & Gold)
const C_MARBLE_WHITE: int     = 0xe2e8f0 # Polished imperial floor tile
const C_EMERALD: int          = 0x15803d # Lush green mosaic tile
const C_EMERALD_DARK: int     = 0x0f5128 # Forest green mosaic shade
const C_GOLD_TRIM: int        = 0xf59e0b # Gilded floor inlay / ornamental trim
const C_GOLD_BRIGHT: int      = 0xfbbf24 # Polished royal brass

# Room 2: Grotto Cavern & Subterranean Spring
const C_CAVERN_ROCK: int      = 0x3a2e2b # Unhewn rough subterranean rock
const C_CAVERN_DARK: int      = 0x221a18 # Deep bedrock shadow
const C_CAVERN_MOSS: int      = 0x4d7c0f # Vibrant bioluminescent cave moss
const C_CAVERN_MOSS_PALE: int = 0x84cc16 # Glowing fungus patch
const C_WATER_CYAN: int       = 0x0891b2 # Deep underground spring
const C_WATER_GLOW: int       = 0x22d3ee # Bioluminescent water ripple
const C_SHROOM_STEM: int      = 0xd6d3d1 # Pale fungus stalk
const C_SHROOM_CAP_RED: int   = 0xdc2626 # Glowing crimson toadstool cap
const C_SHROOM_CAP_GOLD: int  = 0xeab308 # Glowing gold spore cap
const C_SHROOM_CAP_CYAN: int  = 0x06b6d4 # Bioluminescent azure mushroom

# Room 3: Scriptorium (Oak Wood & Sundial)
const C_WOOD_FLOOR: int       = 0x54351c # Warm polished timber floor
const C_WOOD_DARK: int        = 0x382110 # Dark mahogany trim
const C_WOOD_BOOKSHELF: int   = 0x451a03 # Ancient library shelf
const C_BOOK_RED: int         = 0x991b1b # Arcane grimoire
const C_BOOK_GOLD: int        = 0xd97706 # Gilded tome
const C_BOOK_TEAL: int        = 0x0f766e # Ancient chronicle
const C_PARCHMENT: int        = 0xfef3c7 # Rolled parchment scroll

# Room 4: Cosmic Arena (Obsidian, Violet & Azure Stars)
const C_OBSIDIAN_FLOOR: int   = 0x140f22 # Deep midnight void tile
const C_COSMIC_PURPLE: int    = 0x7e22ce # Astral ring purple
const C_COSMIC_CYAN: int      = 0x06b6d4 # Neon astral ring cyan
const C_COSMIC_MAGENTA: int   = 0xc026d3 # Outer galaxy ring
const C_CRYSTAL_NODE: int     = 0x38bdf8 # Glowing floating pylon

# Room 5: Shadow Mausoleum (Gothic Crypt)
const C_CRYPT_SLATE: int      = 0x334155 # Cold tomb flagstone
const C_CRYPT_PURPLE: int     = 0x581c87 # Shadow mist hue
const C_SARCOPHAGUS_RED: int  = 0x881337 # Royal crimson marble coffin
const C_SARCOPHAGUS_GOLD: int = 0xf59e0b # Angel wing inlay
const C_BONE_WHITE: int       = 0xf8fafc # Skeleton remains

# Room 6: Infernal Dragon Throne (Boss Arena)
const C_DRAGON_STONE: int     = 0x271818 # Volcanic basalt floor
const C_LAVA_CRUST: int       = 0x450a0a # Cooled slag border
const C_LAVA_HOT: int         = 0xea580c # Flowing molten lava
const C_LAVA_CORE: int        = 0xfbbf24 # White-hot magma vein
const C_DRAGON_GOLD: int      = 0xf59e0b # Dragon wing mosaic inlay
const C_DRAGON_CRIMSON: int   = 0xb91c1c # Dragon breath mosaic tile
const C_FIRE_FLAME: int       = 0xf97316 # Brazier flame core

# Room 8: Subterranean River & Smuggler's Wharf
const C_DOCK_PLANK: int       = 0x523018 # Weathered river dock timber
const C_DOCK_POST: int        = 0x2c1808 # Heavy pier piling
const C_BOAT_HULL: int        = 0x5c3317 # Merchant barge hull
const C_BOAT_SAIL: int        = 0xe2e8f0 # Rolled canvas sail
const C_WHIRLPOOL_VORTEX: int = 0x06b6d4 # Floor exit magical whirlpool

# Common Dungeon Props
const C_IRON_GRATE: int       = 0x1e293b # Heavy portcullis / spike trap
const C_SPIKE_STEEL: int      = 0x94a3b8 # Sharp steel spikes
const C_BRAZIER_BOWL: int     = 0x0f172a # Cast iron fire basin
const C_TORCH_WOOD: int       = 0x451a03 # Torch wooden handle


# =============================================================================
# HELPER VOXEL SHAPE PRIMITIVES
# =============================================================================

static func add_box(voxels: Array, x0: int, x1: int, y0: int, y1: int, z0: int, z1: int, col: int) -> void:
	for x in range(x0, x1 + 1):
		for y in range(y0, y1 + 1):
			for z in range(z0, z1 + 1):
				voxels.append([x, y, z, col])

static func add_pillar(voxels: Array, cx: int, cz: int, y0: int, y1: int, rad: int = 2, col_base: int = C_STONE_WALL_DARK, col_shaft: int = C_STONE_PILLAR, col_cap: int = C_GOLD_TRIM) -> void:
	# Base pedestal (rad + 1)
	add_box(voxels, cx - rad - 1, cx + rad + 1, y0, y0 + 1, cz - rad - 1, cz + rad + 1, col_base)
	# Shaft
	for y in range(y0 + 2, y1 - 1):
		for dx in range(-rad, rad + 1):
			for dz in range(-rad, rad + 1):
				if dx * dx + dz * dz <= rad * rad + 1:
					var c = col_shaft if (dx + dz) % 2 == 0 else col_base
					voxels.append([cx + dx, y, cz + dz, c])
	# Capital header
	add_box(voxels, cx - rad - 1, cx + rad + 1, y1 - 1, y1, cz - rad - 1, cz + rad + 1, col_cap)

static func add_brazier(voxels: Array, cx: int, cz: int, y_ground: int, col_flame: int = C_FIRE_FLAME) -> void:
	# Tripod / stone base
	add_box(voxels, cx - 1, cx + 1, y_ground, y_ground + 1, cz - 1, cz + 1, C_BRAZIER_BOWL)
	# Iron bowl
	add_box(voxels, cx - 2, cx + 2, y_ground + 2, y_ground + 3, cz - 2, cz + 2, C_BRAZIER_BOWL)
	# Fiery coal core
	add_box(voxels, cx - 1, cx + 1, y_ground + 3, y_ground + 4, cz - 1, cz + 1, col_flame)
	voxels.append([cx, y_ground + 5, cz, C_GOLD_BRIGHT])


# =============================================================================
# 1. ROOM 1: SẢNH ĐIỆN HOÀNG GIA (SPAWN HUB - CENTER: 0, 0)
# =============================================================================
static func build_hub_mesh() -> ArrayMesh:
	var voxels: Array = []
	# Floor bounds: X: -50..+50, Z: -60..+60 (20m x 24m)
	var x_min = -50
	var x_max = 50
	var z_min = -60
	var z_max = 60
	
	# 1. Floor Tilework with Royal Emerald & Gold Inlaid Rug
	for x in range(x_min, x_max + 1):
		for z in range(z_min, z_max + 1):
			var is_rug = (abs(x) <= 30 and abs(z) <= 45)
			var is_border = (abs(x) in [29, 30] and abs(z) <= 45) or (abs(z) in [44, 45] and abs(x) <= 30)
			var is_inner_diamond = (abs(x) + abs(z) * 0.7) < 22.0
			
			var col = C_MARBLE_WHITE
			if is_border:
				col = C_GOLD_TRIM
			elif is_inner_diamond:
				col = C_GOLD_BRIGHT if (abs(x) + abs(z)) % 3 == 0 else C_EMERALD_DARK
			elif is_rug:
				col = C_EMERALD if (x + z) % 4 != 0 else C_EMERALD_DARK
			else:
				col = C_STONE_FLOOR if (x + z) % 2 == 0 else C_STONE_FLOOR_ALT
				
			voxels.append([x, 0, z, col])
			
	# 2. North Wall (Tall: 24 voxels = 4.8m) with Grand Arch to Grotto
	for x in range(x_min, x_max + 1):
		# Open central door X in [-10, 10]
		if abs(x) > 10:
			for y in range(1, 25):
				var col = C_STONE_WALL if y < 22 else C_STONE_WALL_TRIM
				voxels.append([x, y, z_min, col])
		else:
			# Arch header over doorway
			for y in range(16, 25):
				voxels.append([x, y, z_min, C_GOLD_TRIM if y == 16 else C_STONE_WALL])
				
	# 3. South Wall (HACK & SLASH LOW OCCLUSION: 5 voxels = 1.0m)
	for x in range(x_min, x_max + 1):
		if abs(x) > 10: # Central entrance steps
			for y in range(1, 6):
				voxels.append([x, y, z_max, C_STONE_WALL if y < 5 else C_STONE_WALL_TRIM])
				
	# 4. West Wall (with doorway to Cosmic Arena X in [-10, 10])
	for z in range(z_min, z_max + 1):
		if abs(z) > 10:
			for y in range(1, 20):
				voxels.append([x_min, y, z, C_STONE_WALL if y < 18 else C_STONE_WALL_TRIM])
		else:
			for y in range(14, 20):
				voxels.append([x_min, y, z, C_GOLD_TRIM if y == 14 else C_STONE_WALL])
				
	# 5. East Wall (Iron-barred sealed gate to Boss Arena)
	for z in range(z_min, z_max + 1):
		if abs(z) > 12:
			for y in range(1, 20):
				voxels.append([x_max, y, z, C_STONE_WALL if y < 18 else C_STONE_WALL_TRIM])
		else:
			# Iron bars of the sealed gate
			for y in range(1, 16):
				if z % 3 == 0 or y in [1, 7, 14]:
					voxels.append([x_max, y, z, C_IRON_GRATE])
			for y in range(16, 20):
				voxels.append([x_max, y, z, C_STONE_WALL])
				
	# 6. Four Grand Fluted Marble Pillars
	add_pillar(voxels, -22, -25, 1, 22, 2, C_STONE_WALL_DARK, C_STONE_PILLAR, C_GOLD_TRIM)
	add_pillar(voxels,  22, -25, 1, 22, 2, C_STONE_WALL_DARK, C_STONE_PILLAR, C_GOLD_TRIM)
	add_pillar(voxels, -22,  25, 1, 22, 2, C_STONE_WALL_DARK, C_STONE_PILLAR, C_GOLD_TRIM)
	add_pillar(voxels,  22,  25, 1, 22, 2, C_STONE_WALL_DARK, C_STONE_PILLAR, C_GOLD_TRIM)
	
	# 7. Guardian Effigy Dais at North End
	add_box(voxels, -8, 8, 1, 4, -55, -45, C_STONE_WALL)
	add_box(voxels, -6, 6, 5, 12, -53, -47, C_STONE_PILLAR)
	# Statue head / crown
	add_box(voxels, -4, 4, 13, 18, -52, -48, C_GOLD_BRIGHT)
	
	# 8. Four Warm Braziers Framing Center
	add_brazier(voxels, -14, -12, 1, C_FIRE_FLAME)
	add_brazier(voxels,  14, -12, 1, C_FIRE_FLAME)
	add_brazier(voxels, -14,  12, 1, C_FIRE_FLAME)
	add_brazier(voxels,  14,  12, 1, C_FIRE_FLAME)
	
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)


# =============================================================================
# 2. ROOM 2: HANG NẤM PHÁT QUANG & HỒ NƯỚC NGẦM (GROTTO - NORTH: +40, -160)
# =============================================================================
static func build_grotto_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = 40
	var cz = -160
	var rx = 65
	var rz = 55
	
	for dx in range(-rx, rx + 1):
		for dz in range(-rz, rz + 1):
			var d_norm = float(dx * dx) / float(rx * rx) + float(dz * dz) / float(rz * rz)
			if d_norm <= 1.0:
				var x = cx + dx
				var z = cz + dz
				var dist_center = sqrt(dx * dx + dz * dz)
				
				# 1. Natural Organic Cave Floor
				if dist_center < 25.0:
					# Sunken Luminous Pool (y = -2, -1)
					voxels.append([x, -2, z, C_WATER_CYAN])
					voxels.append([x, -1, z, C_WATER_GLOW if (x + z) % 3 == 0 else C_WATER_CYAN])
				else:
					# Cavern Soil / Moss Surface
					var is_moss = (dist_center < 42.0 and (x ^ z) % 3 != 0)
					var col = C_CAVERN_MOSS if is_moss else C_CAVERN_ROCK
					voxels.append([x, 0, z, col])
					
				# 2. Organic Rough Cavern Walls
				if d_norm >= 0.82:
					var wall_h = int(lerpf(6.0, 22.0, (d_norm - 0.82) / 0.18))
					# South side low wall for camera view
					if dz > 35:
						wall_h = mini(wall_h, 5)
					for y in range(1, wall_h):
						var w_col = C_CAVERN_DARK if y % 4 == 0 else C_CAVERN_ROCK
						if y < 4 and is_equal_approx(d_norm, 0.85):
							w_col = C_CAVERN_MOSS_PALE
						voxels.append([x, y, z, w_col])
						
	# 3. Wooden Footbridge Crossing Pool (Z from -170 to -150 at X = 32)
	for z in range(cz - 22, cz + 22):
		for x in range(cx - 10, cx - 6):
			voxels.append([x, 0, z, C_WOOD_FLOOR if z % 2 == 0 else C_WOOD_DARK])
			
	# 4. Giant Bioluminescent Mushrooms (3 Grand Toadstools)
	_add_voxel_mushroom(voxels, cx - 22, cz - 18, 12, 7, C_SHROOM_CAP_CYAN)
	_add_voxel_mushroom(voxels, cx + 24, cz + 14, 15, 9, C_SHROOM_CAP_GOLD)
	_add_voxel_mushroom(voxels, cx + 18, cz - 25, 10, 6, C_SHROOM_CAP_RED)
	
	# 5. Overgrown Giant Roots burrowing through ceiling
	for y in range(6, 20):
		voxels.append([cx - 30 + (y / 2), y, cz - 30 + (y / 3), C_WOOD_DARK])
		voxels.append([cx - 29 + (y / 2), y, cz - 30 + (y / 3), C_WOOD_DARK])
		
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)

static func _add_voxel_mushroom(voxels: Array, x: int, z: int, stem_h: int, cap_r: int, cap_col: int) -> void:
	# Stalk
	for y in range(1, stem_h):
		voxels.append([x, y, z, C_SHROOM_STEM])
		voxels.append([x + 1, y, z, C_SHROOM_STEM])
		voxels.append([x, y, z + 1, C_SHROOM_STEM])
		voxels.append([x + 1, y, z + 1, C_SHROOM_STEM])
	# Dome Cap
	for dx in range(-cap_r, cap_r + 1):
		for dz in range(-cap_r, cap_r + 1):
			var r2 = dx * dx + dz * dz
			if r2 <= cap_r * cap_r:
				var dy = int(sqrt(max(0, cap_r * cap_r - r2)) * 0.6)
				voxels.append([x + dx, stem_h + dy, z + dz, cap_col])
				voxels.append([x + dx, stem_h + dy - 1, z + dz, C_SHROOM_STEM])


# =============================================================================
# 3. ROOM 3: ĐIỆN CHIÊM TINH & HỌC VIỆN CỔ (SCRIPTORIUM - NW: -130, -130)
# =============================================================================
static func build_scriptorium_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = -130
	var cz = -130
	var rx = 40
	var rz = 40
	
	# Floor with Solar Sundial Inlay
	for dx in range(-rx, rx + 1):
		for dz in range(-rz, rz + 1):
			var x = cx + dx
			var z = cz + dz
			var dist = sqrt(dx * dx + dz * dz)
			if dist <= 38.0:
				var col = C_WOOD_FLOOR
				# Concentric rings & sundial rays
				if is_equal_approx(dist, 14.0) or is_equal_approx(dist, 26.0) or is_equal_approx(dist, 36.0):
					col = C_GOLD_TRIM
				elif (abs(dx) == abs(dz) or dx == 0 or dz == 0) and dist < 36.0:
					col = C_GOLD_BRIGHT
				elif dist < 6.0:
					col = C_GOLD_TRIM
				else:
					col = C_WOOD_FLOOR if (dx + dz) % 2 == 0 else C_WOOD_DARK
				voxels.append([x, 0, z, col])
				
				# Semi-circular back walls (North/West)
				if dist >= 35.0 and (dz < 10 or dx < 0):
					var wall_h = 18
					for y in range(1, wall_h):
						voxels.append([x, y, z, C_STONE_WALL])
						
	# Bookshelves along Curved Wall
	for a in [-45, -90, -135, -180]:
		var rad_a = deg_to_rad(float(a))
		var bx = cx + int(cos(rad_a) * 32.0)
		var bz = cz + int(sin(rad_a) * 32.0)
		_add_bookshelf(voxels, bx, bz, 1, 14)
		
	# Center Astrolabe Altar / Lectern
	add_box(voxels, cx - 3, cx + 3, 1, 4, cz - 3, cz + 3, C_WOOD_DARK)
	add_box(voxels, cx - 2, cx + 2, 4, 6, cz - 2, cz + 2, C_GOLD_TRIM)
	voxels.append([cx, 7, cz, C_CRYSTAL_NODE])
	
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)

static func _add_bookshelf(voxels: Array, x: int, z: int, y0: int, h: int) -> void:
	add_box(voxels, x - 3, x + 3, y0, y0 + h, z - 1, z + 1, C_WOOD_BOOKSHELF)
	for shelf_y in [y0 + 3, y0 + 6, y0 + 9, y0 + 12]:
		for bx in range(x - 2, x + 3):
			var b_col = C_BOOK_RED if (bx + shelf_y) % 3 == 0 else (C_BOOK_GOLD if (bx + shelf_y) % 3 == 1 else C_BOOK_TEAL)
			voxels.append([bx, shelf_y, z, b_col])


# =============================================================================
# 4. ROOM 4: ĐIỆN TINH TÚ BÍ THUẬT (COSMIC ARENA - WEST: -130, 0)
# =============================================================================
static func build_cosmic_arena_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = -130
	var cz = 0
	var half_w = 55
	
	for dx in range(-half_w, half_w + 1):
		for dz in range(-half_w, half_w + 1):
			var x = cx + dx
			var z = cz + dz
			var dist = sqrt(dx * dx + dz * dz)
			
			# Floor Tilework: Obsidian with Concentric Astral Rings
			var col = C_OBSIDIAN_FLOOR
			if dist < 48.0:
				if abs(dist - 44.0) < 1.4:
					col = C_COSMIC_MAGENTA
				elif abs(dist - 32.0) < 1.4:
					col = C_COSMIC_PURPLE
				elif abs(dist - 20.0) < 1.4:
					col = C_COSMIC_CYAN
				elif dist < 8.0:
					col = C_COSMIC_CYAN if (dx + dz) % 2 == 0 else C_CRYSTAL_NODE
				elif (abs(dx) == abs(dz)) and dist < 44.0:
					col = C_COSMIC_PURPLE
			voxels.append([x, 0, z, col])
			
			# Perimeter Walls with Door Openings
			var is_wall_x = (abs(dx) == half_w)
			var is_wall_z = (abs(dz) == half_w)
			
			if is_wall_x or is_wall_z:
				# Doorways: East (to Hub: dz in [-10, 10]), North (to Scriptorium: dx in [-10, 10]), South (to Crypt)
				var is_door_e = (dx == half_w and abs(dz) <= 10)
				var is_door_n = (dz == -half_w and abs(dx) <= 10)
				var is_door_s = (dz == half_w and abs(dx) <= 10)
				var is_door = is_door_e or is_door_n or is_door_s
				
				# South wall low occlusion
				var max_h = 5 if (dz == half_w and not is_door) else 20
				if not is_door:
					for y in range(1, max_h):
						voxels.append([x, y, z, C_STONE_WALL if y < max_h - 2 else C_COSMIC_PURPLE])
				else:
					for y in range(14, 20):
						voxels.append([x, y, z, C_STONE_WALL])
						
	# 4 Levitating Crystal Pylons at 4 Quadrants
	_add_floating_crystal(voxels, cx - 26, cz - 26, 4)
	_add_floating_crystal(voxels, cx + 26, cz - 26, 4)
	_add_floating_crystal(voxels, cx - 26, cz + 26, 4)
	_add_floating_crystal(voxels, cx + 26, cz + 26, 4)
	
	# Center Altar Pedestal with Skeleton Relic
	add_box(voxels, cx - 5, cx + 5, 1, 3, cz - 5, cz + 5, C_OBSIDIAN_FLOOR)
	add_box(voxels, cx - 3, cx + 3, 3, 5, cz - 3, cz + 3, C_COSMIC_PURPLE)
	voxels.append([cx, 6, cz, C_BONE_WHITE])
	
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)

static func _add_floating_crystal(voxels: Array, x: int, z: int, y_start: int) -> void:
	# Base pedestal
	add_box(voxels, x - 2, x + 2, 1, 2, z - 2, z + 2, C_STONE_WALL_DARK)
	# Floating Crystal Octahedron (y_start to y_start + 8)
	for dy in range(0, 9):
		var rad = 3 - abs(dy - 4)
		for dx in range(-rad, rad + 1):
			for dz in range(-rad, rad + 1):
				if abs(dx) + abs(dz) <= rad:
					voxels.append([x + dx, y_start + dy, z + dz, C_CRYSTAL_NODE if rad > 1 else C_COSMIC_CYAN])


# =============================================================================
# 5. ROOM 5: HẦM MỘ CỔ TỬ THẦN (SHADOW MAUSOLEUM - SW: -130, +130)
# =============================================================================
static func build_crypt_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = -130
	var cz = 130
	var hw = 50
	var hl = 65
	
	for dx in range(-hw, hw + 1):
		for dz in range(-hl, hl + 1):
			var x = cx + dx
			var z = cz + dz
			
			# 1. Floor with Angel Wing Inlay
			var col = C_CRYPT_SLATE
			var d_center = sqrt(dx * dx + dz * dz)
			if d_center < 32.0 and (abs(dx) > 4 or abs(dz) > 15):
				# Wing feathers
				if (abs(dx) - abs(dz) * 0.4) > 0 and (abs(dx) - abs(dz) * 0.4) < 18.0:
					col = C_SARCOPHAGUS_GOLD
			elif (dx + dz) % 2 == 0:
				col = C_STONE_WALL_DARK
			voxels.append([x, 0, z, col])
			
			# 2. Walls with Gothic Arched Niche Cavities
			var is_wall_x = (abs(dx) == hw)
			var is_wall_z = (abs(dz) == hl)
			if is_wall_x or is_wall_z:
				var is_door_n = (dz == -hl and abs(dx) <= 10)
				var is_door_e = (dx == hw and abs(dz) <= 10)
				
				# South wall low
				var max_h = 5 if dz == hl else 22
				if not is_door_n and not is_door_e:
					for y in range(1, max_h):
						voxels.append([x, y, z, C_STONE_WALL if y < max_h - 2 else C_CRYPT_PURPLE])
				else:
					for y in range(14, 22):
						voxels.append([x, y, z, C_STONE_WALL])
						
	# 3. Gothic Vaulted Arch Columns along sides
	for z_off in [-40, -15, 15, 40]:
		add_pillar(voxels, cx - 35, cz + z_off, 1, 20, 2, C_STONE_WALL_DARK, C_CRYPT_SLATE, C_CRYPT_PURPLE)
		add_pillar(voxels, cx + 35, cz + z_off, 1, 20, 2, C_STONE_WALL_DARK, C_CRYPT_SLATE, C_CRYPT_PURPLE)
		
	# 4. Royal Sarcophagus at Center (Contains Dragon Crest Key!)
	add_box(voxels, cx - 12, cx + 12, 1, 3, cz - 20, cz + 20, C_STONE_WALL_DARK) # Raised dais
	add_box(voxels, cx - 7, cx + 7, 4, 8, cz - 14, cz + 14, C_SARCOPHAGUS_RED)   # Sarcophagus body
	# Gold filigree trim & carved face
	add_box(voxels, cx - 8, cx + 8, 8, 9, cz - 15, cz + 15, C_SARCOPHAGUS_GOLD)  # Lid edge
	add_box(voxels, cx - 5, cx + 5, 9, 10, cz - 10, cz + 10, C_BONE_WHITE)       # Carved skull relief
	
	# 5. Purple Mist Braziers
	add_brazier(voxels, cx - 18, cz - 14, 1, C_COSMIC_PURPLE)
	add_brazier(voxels, cx + 18, cz - 14, 1, C_COSMIC_PURPLE)
	add_brazier(voxels, cx - 18, cz + 14, 1, C_COSMIC_PURPLE)
	add_brazier(voxels, cx + 18, cz + 14, 1, C_COSMIC_PURPLE)
	
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)


# =============================================================================
# 6. ROOM 6: ĐẠI ĐIỆN HỎA LONG (BOSS ARENA - EAST: +160, 0)
# =============================================================================
static func build_dragon_arena_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = 160
	var cz = 0
	var hw = 75 # 30m wide
	var hl = 90 # 36m long
	
	for dx in range(-hw, hw + 1):
		for dz in range(-hl, hl + 1):
			var x = cx + dx
			var z = cz + dz
			
			# 1. Molten Lava Gutters along Outer Perimeter (abs(dz) in [70, 80] or abs(dx) in [60, 68])
			var is_lava_gutter = (abs(dz) > 65 and abs(dz) < 78 and abs(dx) < 65)
			
			var col = C_DRAGON_STONE
			if is_lava_gutter:
				col = C_LAVA_CORE if (x + z) % 3 == 0 else C_LAVA_HOT
			else:
				# 2. Giant Fiery Dragon Motif Inlaid in Floor Center
				var dist_center = sqrt(float(dx * dx) * 0.7 + float(dz * dz) * 1.2)
				if dist_center < 38.0:
					if (abs(dx * 1.5) + abs(dz)) < 30.0:
						col = C_LAVA_HOT if (dx + dz) % 2 == 0 else C_DRAGON_CRIMSON
					else:
						col = C_DRAGON_GOLD if (dx + dz) % 3 == 0 else C_DRAGON_CRIMSON
				elif (dx + dz) % 2 == 0:
					col = C_LAVA_CRUST
			voxels.append([x, 0, z, col])
			
			# 3. Perimeter Walls
			var is_wall_x = (abs(dx) == hw)
			var is_wall_z = (abs(dz) == hl)
			if is_wall_x or is_wall_z:
				var is_door_w = (dx == -hw and abs(dz) <= 14) # Entrance from Hub
				var is_door_s = (dz == hl and abs(dx) <= 12)  # Exit to Colonnade/Docks
				
				var max_h = 6 if (dz == hl and not is_door_s) else 26 # Low south wall
				if not is_door_w and not is_door_s:
					for y in range(1, max_h):
						var w_col = C_STONE_WALL if y < max_h - 3 else C_DRAGON_CRIMSON
						voxels.append([x, y, z, w_col])
				else:
					for y in range(16, 26):
						voxels.append([x, y, z, C_STONE_WALL])
						
	# 4. Six Colossal Flaming Pillars Framing Arena
	for z_p in [-50, 0, 50]:
		add_pillar(voxels, cx - 45, cz + z_p, 1, 24, 3, C_STONE_WALL_DARK, C_LAVA_CRUST, C_DRAGON_GOLD)
		add_brazier(voxels, cx - 45, cz + z_p, 25, C_FIRE_FLAME)
		add_pillar(voxels, cx + 45, cz + z_p, 1, 24, 3, C_STONE_WALL_DARK, C_LAVA_CRUST, C_DRAGON_GOLD)
		add_brazier(voxels, cx + 45, cz + z_p, 25, C_FIRE_FLAME)
		
	# 5. Grand Bone Dragon Throne at Far East (+60)
	var tx = cx + 55
	add_box(voxels, tx - 6, tx + 14, 1, 5, cz - 16, cz + 16, C_STONE_WALL_DARK)  # Dais 1
	add_box(voxels, tx - 2, tx + 12, 6, 9, cz - 12, cz + 12, C_DRAGON_CRIMSON)   # Dais 2
	add_box(voxels, tx + 4, tx + 10, 10, 16, cz - 7, cz + 7, C_SARCOPHAGUS_GOLD) # Throne Back
	# Dragon Skull Horns Crown
	voxels.append([tx + 8, 18, cz - 5, C_BONE_WHITE])
	voxels.append([tx + 9, 20, cz - 7, C_BONE_WHITE])
	voxels.append([tx + 8, 18, cz + 5, C_BONE_WHITE])
	voxels.append([tx + 9, 20, cz + 7, C_BONE_WHITE])
	
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)


# =============================================================================
# 7. ROOM 7: MÊ CUNG CATACOMB & BẪY CHÔNG (CATACOMBS - SOUTH: 0, +130)
# =============================================================================
static func build_catacombs_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = 0
	var cz = 130
	var hw = 45
	var hl = 30
	
	for dx in range(-hw, hw + 1):
		for dz in range(-hl, hl + 1):
			var x = cx + dx
			var z = cz + dz
			
			# Floor with Spike Trap Recesses
			var is_trap_1 = (abs(dx - 18) < 6 and abs(dz) < 6)
			var is_trap_2 = (abs(dx + 18) < 6 and abs(dz) < 6)
			
			var col = C_STONE_FLOOR
			if is_trap_1 or is_trap_2:
				col = C_IRON_GRATE
			elif (dx + dz) % 2 == 0:
				col = C_STONE_FLOOR_ALT
			voxels.append([x, 0, z, col])
			
			# Walls & Choke-Point Dividers
			var is_divider = (abs(dx) < 4 and abs(dz) > 8)
			if is_divider:
				for y in range(1, 14):
					voxels.append([x, y, z, C_STONE_WALL])
					
	# Spike Steel Teeth (y = 1..2)
	for sx in [cx - 18, cx + 18]:
		for pdx in [-3, 0, 3]:
			for pdz in [-3, 0, 3]:
				voxels.append([sx + pdx, 1, cz + pdz, C_SPIKE_STEEL])
				voxels.append([sx + pdx, 2, cz + pdz, C_SPIKE_STEEL])
				
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)


# =============================================================================
# 8. ROOM 8: BẾN THUYỀN SÔNG NGẦM & CỔNG DỊCH CHUYỂN (WHARF - FAR SOUTH: 0, +240)
# =============================================================================
static func build_wharf_mesh() -> ArrayMesh:
	var voxels: Array = []
	var cx = 0
	var cz = 240
	var half_w = 120 # 48m wide gorge
	
	for dx in range(-half_w, half_w + 1):
		for dz in range(-35, 36):
			var x = cx + dx
			var z = cz + dz
			
			if dz < -10:
				# 1. Wooden Dock Platform along North Riverbank
				var is_dock_edge = (dz == -10)
				var col = C_DOCK_POST if is_dock_edge else (C_DOCK_PLANK if (dx + dz) % 2 == 0 else C_WOOD_DARK)
				voxels.append([x, 0, z, col])
			elif dz > 24:
				# 2. South Gorge Rock Wall
				for y in range(0, 10):
					voxels.append([x, y, z, C_CAVERN_DARK if y == 0 else C_CAVERN_ROCK])
			else:
				# 3. Flowing Bioluminescent Subterranean River (z in [-9, 23])
				var is_foam = (dz in [-9, 22] or (dx + dz) % 7 == 0)
				var w_col = C_WATER_GLOW if is_foam else C_WATER_CYAN
				voxels.append([x, -3, z, C_CAVERN_DARK]) # Riverbed
				voxels.append([x, -1, z, w_col])        # Water surface
				
	# 4. Moored Wooden Merchant Barge (X: +20 to +55, Z: -5 to +10)
	var bx = cx + 38
	var bz = cz + 3
	add_box(voxels, bx - 16, bx + 16, -1, 3, bz - 6, bz + 6, C_BOAT_HULL)
	# Hollow boat deck
	add_box(voxels, bx - 14, bx + 14, 0, 1, bz - 4, bz + 4, C_WOOD_FLOOR)
	# Mast & Canvas
	for y in range(2, 18):
		voxels.append([bx, y, bz, C_DOCK_POST])
	add_box(voxels, bx - 1, bx + 1, 12, 15, bz - 5, bz + 5, C_BOAT_SAIL)
	
	# 5. Mystic Whirlpool Portal at Far West (Exit to Floor 2!)
	var wx = cx - 75
	var wz = cz + 6
	for r in range(2, 16):
		var num_steps = r * 6
		for i in range(num_steps):
			var th = float(i) / float(num_steps) * TAU
			var px = wx + int(cos(th) * r)
			var pz = wz + int(sin(th) * r)
			var py = -int(float(r) * 0.25)
			var col = C_WHIRLPOOL_VORTEX if (r + i) % 2 == 0 else C_WATER_GLOW
			voxels.append([px, py, pz, col])
			
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)


# =============================================================================
# 9. CONNECTING CORRIDORS (HÀNH LANG NỐI TOÀN BỘ 8 PHÒNG)
# =============================================================================
static func build_corridors_mesh() -> ArrayMesh:
	var voxels: Array = []
	
	# Corridor 1: Hub North (0, -60) -> Grotto South (40, -110)
	for z in range(-110, -60):
		var frac = float(-60 - z) / 50.0
		var x_center = int(lerpf(0.0, 40.0, frac))
		for dx in range(-8, 9):
			var x = x_center + dx
			voxels.append([x, 0, z, C_STONE_FLOOR if (x + z) % 2 == 0 else C_CAVERN_ROCK])
			# Side walls
			if abs(dx) in [7, 8]:
				for y in range(1, 14):
					voxels.append([x, y, z, C_CAVERN_ROCK])
					
	# Corridor 2: Hub West (-50, 0) -> Cosmic Arena East (-75, 0)
	for x in range(-75, -50):
		for dz in range(-8, 9):
			var z = dz
			voxels.append([x, 0, z, C_STONE_FLOOR if (x + z) % 2 == 0 else C_STONE_FLOOR_ALT])
			if abs(dz) in [7, 8]:
				for y in range(1, 14):
					voxels.append([x, y, z, C_STONE_WALL])
					
	# Corridor 3: Cosmic North (-130, -55) -> Scriptorium South (-130, -90)
	for z in range(-90, -55):
		for dx in range(-7, 8):
			var x = -130 + dx
			voxels.append([x, 0, z, C_WOOD_FLOOR if z % 2 == 0 else C_STONE_FLOOR])
			if abs(dx) in [6, 7]:
				for y in range(1, 14):
					voxels.append([x, y, z, C_STONE_WALL])
					
	# Corridor 4: Cosmic South (-130, +55) -> Crypt North (-130, +65)
	for z in range(55, 66):
		for dx in range(-8, 9):
			var x = -130 + dx
			voxels.append([x, 0, z, C_CRYPT_SLATE])
			if abs(dx) in [7, 8]:
				for y in range(1, 14):
					voxels.append([x, y, z, C_STONE_WALL])
					
	# Corridor 5: Crypt East (-80, 130) -> Catacombs West (-45, 130)
	for x in range(-80, -45):
		for dz in range(-7, 8):
			var z = 130 + dz
			voxels.append([x, 0, z, C_STONE_FLOOR])
			if abs(dz) in [6, 7]:
				for y in range(1, 12):
					voxels.append([x, y, z, C_STONE_WALL])
					
	# Corridor 6: Catacombs South (0, 160) -> Wharf North (0, 205)
	for z in range(160, 206):
		for dx in range(-8, 9):
			var x = dx
			voxels.append([x, 0, z, C_STONE_FLOOR if z < 185 else C_DOCK_PLANK])
			if abs(dx) in [7, 8]:
				for y in range(1, 10):
					voxels.append([x, y, z, C_STONE_WALL if z < 185 else C_CAVERN_ROCK])
					
	# Corridor 7: Dragon Boss South (+160, 90) -> Grand Colonnade to Wharf (+160, 205)
	for z in range(90, 206):
		for dx in range(-8, 9):
			var x = 160 + dx
			# Red royal carpet running down center
			var is_carpet = (abs(dx) <= 4)
			var col = C_DRAGON_CRIMSON if is_carpet else C_DRAGON_STONE
			voxels.append([x, 0, z, col])
			if abs(dx) in [7, 8]:
				for y in range(1, 12):
					voxels.append([x, y, z, C_STONE_WALL])
					
	return VoxelBuilder.build_seamless_mesh_scaled(voxels, V_SCALE)
