const fs = require('fs');
const path = require('path');

const filePath = "C:\\Users\\Administrator\\.gemini\\antigravity\\scratch\\goblin-viewer\\scripts\\voxel_builder_test.gd";
let content = fs.readFileSync(filePath, 'utf8');

// Check that target functions exist
if (!content.includes("static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:")) {
    console.error("Could not find build_shaman_head_mesh");
    process.exit(1);
}

// 1. Update build_shaman_head_mesh
content = content.replace(
`static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_head_mesh_outfit2()
	return build_shaman_head_mesh_outfit1()`,
`static func build_shaman_head_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_head_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_head_mesh_outfit2()
	return build_shaman_head_mesh_outfit1()`
);

// 2. Head Outfit 3 method
const headOutfit3Code = `
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
`;

// Insert headOutfit3Code right after build_shaman_head_mesh_outfit2
const head2Marker = "static func build_shaman_head_mesh_outfit2() -> ArrayMesh:";
const head2EndMarker = "return build_seamless_mesh(v_arr)";
// Find head2 return
const head2Idx = content.indexOf(head2Marker);
const head2ReturnIdx = content.indexOf(head2EndMarker, head2Idx);
const insertHeadPos = head2ReturnIdx + head2EndMarker.length;
content = content.slice(0, insertHeadPos) + "\n" + headOutfit3Code + content.slice(insertHeadPos);

// 3. Update build_shaman_torso_mesh
content = content.replace(
`static func build_shaman_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_torso_mesh_outfit2()
	return build_shaman_torso_mesh_outfit1()`,
`static func build_shaman_torso_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_torso_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_torso_mesh_outfit2()
	return build_shaman_torso_mesh_outfit1()`
);

// 4. Torso Outfit 3 method
const torsoOutfit3Code = `
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
`;

// Insert torsoOutfit3Code right after build_shaman_torso_mesh_outfit2
const torso2Marker = "static func build_shaman_torso_mesh_outfit2() -> ArrayMesh:";
const torso2Idx = content.indexOf(torso2Marker);
const torso2ReturnIdx = content.indexOf(head2EndMarker, torso2Idx);
const insertTorsoPos = torso2ReturnIdx + head2EndMarker.length;
content = content.slice(0, insertTorsoPos) + "\n" + torsoOutfit3Code + content.slice(insertTorsoPos);

// 5. Update build_shaman_cloak_mesh
content = content.replace(
`static func build_shaman_cloak_mesh() -> ArrayMesh:`,
`static func build_shaman_cloak_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_cloak_mesh_outfit3()`
);

// 6. Cloak Outfit 3 method
const cloakOutfit3Code = `
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
`;

// Insert cloakOutfit3Code right after build_shaman_cloak_mesh
const cloakMarker = "static func build_shaman_cloak_mesh(outfit: int = 2) -> ArrayMesh:";
const cloakIdx = content.indexOf(cloakMarker);
const cloakReturnIdx = content.indexOf(head2EndMarker, cloakIdx);
const insertCloakPos = cloakReturnIdx + head2EndMarker.length;
content = content.slice(0, insertCloakPos) + "\n" + cloakOutfit3Code + content.slice(insertCloakPos);

// 7. Update build_shaman_staff_mesh
content = content.replace(
`static func build_shaman_staff_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_staff_mesh_outfit2()
	return build_shaman_staff_mesh_outfit1()`,
`static func build_shaman_staff_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_staff_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_staff_mesh_outfit2()
	return build_shaman_staff_mesh_outfit1()`
);

// 8. Staff Outfit 3 method
const staffOutfit3Code = `
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
`;

// Insert staffOutfit3Code right after build_shaman_staff_mesh_outfit2
const staff2Marker = "static func build_shaman_staff_mesh_outfit2() -> ArrayMesh:";
const staff2Idx = content.indexOf(staff2Marker);
const staff2ReturnIdx = content.indexOf(head2EndMarker, staff2Idx);
const insertStaffPos = staff2ReturnIdx + head2EndMarker.length;
content = content.slice(0, insertStaffPos) + "\n" + staffOutfit3Code + content.slice(insertStaffPos);

// 9. Update build_shaman_upper_arm_mesh
content = content.replace(
`static func build_shaman_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_upper_arm_mesh_outfit2()
	return build_shaman_upper_arm_mesh_outfit1()`,
`static func build_shaman_upper_arm_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_upper_arm_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_upper_arm_mesh_outfit2()
	return build_shaman_upper_arm_mesh_outfit1()`
);

// 10. Upper Arm Outfit 3 method
const armOutfit3Code = `
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
`;

// Insert armOutfit3Code right after build_shaman_upper_arm_mesh_outfit2
const arm2Marker = "static func build_shaman_upper_arm_mesh_outfit2() -> ArrayMesh:";
const arm2Idx = content.indexOf(arm2Marker);
const arm2ReturnIdx = content.indexOf("return build_seamless_mesh(voxels)", arm2Idx);
const insertArmPos = arm2ReturnIdx + "return build_seamless_mesh(voxels)".length;
content = content.slice(0, insertArmPos) + "\n" + armOutfit3Code + content.slice(insertArmPos);

// 11. Update build_shaman_forearm_mesh
content = content.replace(
`static func build_shaman_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_forearm_mesh_outfit2(is_right)
	return build_shaman_forearm_mesh_outfit1(is_right)`,
`static func build_shaman_forearm_mesh(is_right: bool, outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_forearm_mesh_outfit3(is_right)
	elif outfit == 2:
		return build_shaman_forearm_mesh_outfit2(is_right)
	return build_shaman_forearm_mesh_outfit1(is_right)`
);

// 12. Forearm Outfit 3 method
const forearmOutfit3Code = `
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
`;

// Insert forearmOutfit3Code right after build_shaman_forearm_mesh_outfit2
const forearm2Marker = "static func build_shaman_forearm_mesh_outfit2(is_right: bool) -> ArrayMesh:";
const forearm2Idx = content.indexOf(forearm2Marker);
const forearm2ReturnIdx = content.indexOf("return build_seamless_mesh(voxels)", forearm2Idx);
const insertForearmPos = forearm2ReturnIdx + "return build_seamless_mesh(voxels)".length;
content = content.slice(0, insertForearmPos) + "\n" + forearmOutfit3Code + content.slice(insertForearmPos);

// 13. Update build_shaman_thigh_mesh
content = content.replace(
`static func build_shaman_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_thigh_mesh_outfit2()
	return build_shaman_thigh_mesh_outfit1()`,
`static func build_shaman_thigh_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_thigh_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_thigh_mesh_outfit2()
	return build_shaman_thigh_mesh_outfit1()`
);

// 14. Thigh Outfit 3 method
const thighOutfit3Code = `
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
`;

// Insert thighOutfit3Code right after build_shaman_thigh_mesh_outfit2
const thigh2Marker = "static func build_shaman_thigh_mesh_outfit2() -> ArrayMesh:";
const thigh2Idx = content.indexOf(thigh2Marker);
const thigh2ReturnIdx = content.indexOf("return build_seamless_mesh(voxels)", thigh2Idx);
const insertThighPos = thigh2ReturnIdx + "return build_seamless_mesh(voxels)".length;
content = content.slice(0, insertThighPos) + "\n" + thighOutfit3Code + content.slice(insertThighPos);

// 15. Update build_shaman_shin_mesh
content = content.replace(
`static func build_shaman_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 2:
		return build_shaman_shin_mesh_outfit2()
	return build_shaman_shin_mesh_outfit1()`,
`static func build_shaman_shin_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_shaman_shin_mesh_outfit3()
	elif outfit == 2:
		return build_shaman_shin_mesh_outfit2()
	return build_shaman_shin_mesh_outfit1()`
);

// 16. Shin Outfit 3 method
const shinOutfit3Code = `
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
`;

// Insert shinOutfit3Code right after build_shaman_shin_mesh_outfit2
const shin2Marker = "static func build_shaman_shin_mesh_outfit2() -> ArrayMesh:";
const shin2Idx = content.indexOf(shin2Marker);
const shin2ReturnIdx = content.indexOf("return build_seamless_mesh(voxels)", shin2Idx);
const insertShinPos = shin2ReturnIdx + "return build_seamless_mesh(voxels)".length;
content = content.slice(0, insertShinPos) + "\n" + shinOutfit3Code + content.slice(insertShinPos);

// 17. Update build_totem_mesh to accept outfit parameter and support outfit 3
content = content.replace(
`static func build_totem_mesh() -> ArrayMesh:`,
`static func build_totem_mesh(outfit: int = 1) -> ArrayMesh:
	if outfit == 3:
		return build_totem_mesh_outfit3()`
);

// 18. Totem Outfit 3 method
const totemOutfit3Code = `
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
`;

// Insert totemOutfit3Code right after build_totem_mesh
const totemMarker = "static func build_totem_mesh(outfit: int = 1) -> ArrayMesh:";
const totemIdx = content.indexOf(totemMarker);
const totemReturnIdx = content.indexOf(head2EndMarker, totemIdx);
const insertTotemPos = totemReturnIdx + head2EndMarker.length;
content = content.slice(0, insertTotemPos) + "\n" + totemOutfit3Code + content.slice(insertTotemPos);

fs.writeFileSync(filePath, content, 'utf8');
console.log("Successfully updated voxel_builder_test.gd with Shaman Outfit 3 methods!");
