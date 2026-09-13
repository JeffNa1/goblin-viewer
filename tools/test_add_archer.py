import os
import re

ROOT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin-viewer"
VB_PATH = os.path.join(ROOT_DIR, "scripts", "voxel_builder_test.gd")
ARCHER_PATH = os.path.join(ROOT_DIR, "scripts", "goblin_archer.gd")
VIEWER_PATH = os.path.join(ROOT_DIR, "scripts", "viewer.gd")
README_PATH = os.path.join(ROOT_DIR, "README.md")

# ==============================================================================
# 1. PATCH VOXEL_BUILDER.GD
# ==============================================================================
with open(VB_PATH, "r", encoding="utf-8") as f:
    vb_code = f.read()

# 1.1 Update head dispatcher
old_head_disp = """static func build_archer_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_head_mesh_outfit1()
	return build_archer_head_mesh_outfit2()"""

new_head_disp = """static func build_archer_head_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_head_mesh_outfit1()
	elif outfit == 3:
		return build_archer_head_mesh_outfit3()
	return build_archer_head_mesh_outfit2()"""

if old_head_disp in vb_code:
    vb_code = vb_code.replace(old_head_disp, new_head_disp)
    print("[OK] Updated build_archer_head_mesh dispatcher")
else:
    print("[WARN] old_head_disp not found")

# 1.2 Add build_archer_head_mesh_outfit3 after build_archer_head_mesh_outfit2
head_outfit3_code = """
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
"""

head2_anchor = """	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

# --- ARCHER OUTFITS: BỘ ĐỒ 1 (THÔ SƠ / HOANG DÃ) & BỘ ĐỒ 2 (RANGER XẠ THỦ) ---"""

if head2_anchor in vb_code:
    vb_code = vb_code.replace(head2_anchor, head2_anchor.split("\n\n")[0] + "\n" + head_outfit3_code + "\n# --- ARCHER OUTFITS: BỘ ĐỒ 1 (THÔ SƠ / HOANG DÃ) & BỘ ĐỒ 2 (RANGER XẠ THỦ) ---")
    print("[OK] Inserted build_archer_head_mesh_outfit3")
else:
    print("[WARN] head2_anchor not found")

# 1.3 Update torso dispatcher
old_torso_disp = """static func build_archer_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_torso_mesh_outfit1()
	return build_archer_torso_mesh_outfit2()"""

new_torso_disp = """static func build_archer_torso_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_torso_mesh_outfit1()
	elif outfit == 3:
		return build_archer_torso_mesh_outfit3()
	return build_archer_torso_mesh_outfit2()"""

if old_torso_disp in vb_code:
    vb_code = vb_code.replace(old_torso_disp, new_torso_disp)
    print("[OK] Updated build_archer_torso_mesh dispatcher")
else:
    print("[WARN] old_torso_disp not found")

# 1.4 Add build_archer_torso_mesh_outfit3
torso_outfit3_code = """
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
"""

torso2_anchor = """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:"""

if torso2_anchor in vb_code:
    vb_code = vb_code.replace(torso2_anchor, """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)
""" + torso_outfit3_code + """
static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_torso_mesh_outfit3")
else:
    print("[WARN] torso2_anchor not found")

# 1.5 Update upper arm dispatcher & add outfit3
old_uarm_disp = """static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_upper_arm_mesh_outfit1()
	return build_archer_upper_arm_mesh_outfit2()"""

new_uarm_disp = """static func build_archer_upper_arm_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_upper_arm_mesh_outfit1()
	elif outfit == 3:
		return build_archer_upper_arm_mesh_outfit3()
	return build_archer_upper_arm_mesh_outfit2()"""

if old_uarm_disp in vb_code:
    vb_code = vb_code.replace(old_uarm_disp, new_uarm_disp)
    print("[OK] Updated build_archer_upper_arm_mesh dispatcher")
else:
    print("[WARN] old_uarm_disp not found")

uarm_outfit3_code = """
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
"""

uarm2_anchor = """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:"""

if uarm2_anchor in vb_code:
    vb_code = vb_code.replace(uarm2_anchor, """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)
""" + uarm_outfit3_code + """
static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_upper_arm_mesh_outfit3")
else:
    print("[WARN] uarm2_anchor not found")

# 1.6 Update forearm dispatcher & add outfit3
old_forearm_disp = """static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_forearm_mesh_outfit1(is_right)
	return build_archer_forearm_mesh_outfit2(is_right)"""

new_forearm_disp = """static func build_archer_forearm_mesh(is_right: bool, outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_forearm_mesh_outfit1(is_right)
	elif outfit == 3:
		return build_archer_forearm_mesh_outfit3(is_right)
	return build_archer_forearm_mesh_outfit2(is_right)"""

if old_forearm_disp in vb_code:
    vb_code = vb_code.replace(old_forearm_disp, new_forearm_disp)
    print("[OK] Updated build_archer_forearm_mesh dispatcher")
else:
    print("[WARN] old_forearm_disp not found")

forearm_outfit3_code = """
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
"""

forearm2_anchor = """		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:"""

forearm2_anchor_alt = """		voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)

static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:"""

if forearm2_anchor_alt in vb_code:
    vb_code = vb_code.replace(forearm2_anchor_alt, """		voxels.append([1, -9, 2, C_CLAWS])
	return build_seamless_mesh(voxels)
""" + forearm_outfit3_code + """
static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_forearm_mesh_outfit3")
elif forearm2_anchor in vb_code:
    vb_code = vb_code.replace(forearm2_anchor, """		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)
""" + forearm_outfit3_code + """
static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_forearm_mesh_outfit3")
else:
    print("[WARN] forearm2_anchor not found")

# 1.7 Update thigh dispatcher & add outfit3
old_thigh_disp = """static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_thigh_mesh_outfit1()
	return build_archer_thigh_mesh_outfit2()"""

new_thigh_disp = """static func build_archer_thigh_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_thigh_mesh_outfit1()
	elif outfit == 3:
		return build_archer_thigh_mesh_outfit3()
	return build_archer_thigh_mesh_outfit2()"""

if old_thigh_disp in vb_code:
    vb_code = vb_code.replace(old_thigh_disp, new_thigh_disp)
    print("[OK] Updated build_archer_thigh_mesh dispatcher")
else:
    print("[WARN] old_thigh_disp not found")

thigh_outfit3_code = """
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
"""

thigh2_anchor = """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)

static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:"""

if thigh2_anchor in vb_code:
    vb_code = vb_code.replace(thigh2_anchor, """				voxels.append([x, y, z, col])
	return build_seamless_mesh(voxels)
""" + thigh_outfit3_code + """
static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_thigh_mesh_outfit3")
else:
    print("[WARN] thigh2_anchor not found")

# 1.8 Update shin dispatcher & add outfit3
old_shin_disp = """static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_shin_mesh_outfit1()
	return build_archer_shin_mesh_outfit2()"""

new_shin_disp = """static func build_archer_shin_mesh(outfit: int = 2) -> ArrayMesh:
	if outfit == 1:
		return build_archer_shin_mesh_outfit1()
	elif outfit == 3:
		return build_archer_shin_mesh_outfit3()
	return build_archer_shin_mesh_outfit2()"""

if old_shin_disp in vb_code:
    vb_code = vb_code.replace(old_shin_disp, new_shin_disp)
    print("[OK] Updated build_archer_shin_mesh dispatcher")
else:
    print("[WARN] old_shin_disp not found")

shin_outfit3_code = """
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
"""

shin2_anchor = """		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)

static func build_bow_mesh(drawn: bool = false) -> ArrayMesh:"""

if shin2_anchor in vb_code:
    vb_code = vb_code.replace(shin2_anchor, """		voxels.append([tx, -10, 7, C_CLAWS])
		voxels.append([tx, -9, 6, C_CLAWS])
		
	return build_seamless_mesh(voxels)
""" + shin_outfit3_code + """
static func build_bow_mesh(drawn: bool = false) -> ArrayMesh:""")
    print("[OK] Inserted build_archer_shin_mesh_outfit3")
else:
    print("[WARN] shin2_anchor not found")

# 1.9 Add build_imperial_bow_mesh, build_imperial_quiver_mesh, build_imperial_arrow_mesh
imperial_weapons_code = """
# ==============================================================================
# IMPERIAL WEAPONS SUITE (CUNG HOÀNG KIM, BAO TÊN & MŨI TÊN THẦN ĐẾ CHẾ)
# ==============================================================================

static func build_imperial_bow_mesh(drawn: bool = false) -> ArrayMesh:
	var voxels: Dictionary = {}
	# Grand Imperial Recurve Warbow: Height ~ 32 voxels (~0.96m), ivory dragon-bone with ornate gold armor
	# 1. Ergonomic Velvet & Gold Grip (y: -2..2, z: 0..1, x: -1..1)
	for y in range(-2, 3):
		voxels[Vector3i(0, y, 0)] = C_ROYAL_CRIMSON if y % 2 == 0 else C_GOLD_BRIGHT
		voxels[Vector3i(0, y, 1)] = C_GOLD_BRIGHT if y == 0 else C_GOLD_RICH
		voxels[Vector3i(1, y, 0)] = C_GOLD_RICH
		voxels[Vector3i(-1, y, 0)] = C_GOLD_RICH

	# Golden Arrow Shelf & Sighting Crystal
	voxels[Vector3i(1, 1, 1)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 2, 2)] = C_GEM_RUBY_GLOW
	voxels[Vector3i(0, 2, 1)] = C_GEM_RUBY
	voxels[Vector3i(1, 2, 1)] = C_GOLD_BRIGHT
	voxels[Vector3i(-1, 2, 1)] = C_GOLD_BRIGHT

	# 2. Upper Imperial Limb (y: 3..16)
	for y in range(3, 17):
		var curve_z = int(sin(float(y - 2) / 14.0 * PI) * 3.6)
		if y >= 12: curve_z -= int(float(y - 11) * 1.3)
		if drawn and y >= 8: curve_z -= 1
		
		# Dragon-bone belly (inner), Golden plate armor backing (outer)
		voxels[Vector3i(0, y, curve_z - 1)] = C_BOW_IVORY
		voxels[Vector3i(0, y, curve_z)] = C_GOLD_BRIGHT if (y % 3 == 0) else C_GOLD_RICH
		
		# Gilded filigree flange wings on limbs
		if y in [5, 6, 9, 10, 13]:
			voxels[Vector3i(1, y, curve_z)] = C_GOLD_RICH
			voxels[Vector3i(-1, y, curve_z)] = C_GOLD_RICH
			if y == 9:
				voxels[Vector3i(0, y, curve_z + 1)] = C_GEM_RUBY
				
		# Sculpted Golden Eagle Talon Nock at tip (y: 15..17)
		if y == 16:
			voxels[Vector3i(0, y, curve_z)] = C_GOLD_BRIGHT
			voxels[Vector3i(0, y + 1, curve_z - 1)] = C_GOLD_BRIGHT
			voxels[Vector3i(0, y + 2, curve_z - 2)] = C_GOLD_RICH
			voxels[Vector3i(1, y, curve_z)] = C_GOLD_BRIGHT
			voxels[Vector3i(-1, y, curve_z)] = C_GOLD_BRIGHT

	# 3. Lower Imperial Limb (y: -3..-16)
	for y in range(-16, -2):
		var ay = abs(y)
		var curve_z = int(sin(float(ay - 2) / 14.0 * PI) * 3.6)
		if ay >= 12: curve_z -= int(float(ay - 11) * 1.3)
		if drawn and ay >= 8: curve_z -= 1
		
		voxels[Vector3i(0, y, curve_z - 1)] = C_BOW_IVORY
		voxels[Vector3i(0, y, curve_z)] = C_GOLD_BRIGHT if (ay % 3 == 0) else C_GOLD_RICH
		
		if ay in [5, 6, 9, 10, 13]:
			voxels[Vector3i(1, y, curve_z)] = C_GOLD_RICH
			voxels[Vector3i(-1, y, curve_z)] = C_GOLD_RICH
			if ay == 9:
				voxels[Vector3i(0, y, curve_z + 1)] = C_GEM_RUBY
				
		if y == -16:
			voxels[Vector3i(0, y, curve_z)] = C_GOLD_BRIGHT
			voxels[Vector3i(0, y - 1, curve_z - 1)] = C_GOLD_BRIGHT
			voxels[Vector3i(0, y - 2, curve_z - 2)] = C_GOLD_RICH
			voxels[Vector3i(1, y, curve_z)] = C_GOLD_BRIGHT
			voxels[Vector3i(-1, y, curve_z)] = C_GOLD_BRIGHT

	# 4. Radiant Golden Bowstring:
	# If drawn: Deep taut V-shape pulling back to z = -19 at y = 0
	# If rest: Straight taut line at z = -2
	if drawn:
		for i in range(42):
			var t = float(i) / 41.0
			var sy = int(round(lerp(0.0, 16.0, t)))
			var sz = int(round(lerp(-19.0, -2.0, t)))
			voxels[Vector3i(0, sy, sz)] = C_STRING_GOLD
			voxels[Vector3i(0, -sy, sz)] = C_STRING_GOLD
	else:
		for y in range(-16, 17):
			voxels[Vector3i(0, y, -2)] = C_STRING_GOLD

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_imperial_quiver_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Imperial Fluted Gold Quiver: height 18 voxels (-9..9)
	for y in range(-9, 10):
		for x in range(-2, 3):
			for z in range(-2, 3):
				var dist = abs(x) + abs(z)
				if dist <= 3:
					var is_outer = (abs(x) == 2 or abs(z) == 2)
					if is_outer or y == -9:
						# Royal crimson velvet band at top rim
						if y >= 7:
							voxels[Vector3i(x, y, z)] = C_ROYAL_CRIMSON if (x + z) % 2 == 0 else C_GOLD_BRIGHT
						# Gold Sunburst Medallion at center
						elif y == 0 and z == 2:
							voxels[Vector3i(x, y, z)] = C_GEM_RUBY if x == 0 else C_GOLD_BRIGHT
						else:
							# Fluted vertical gold ribs
							voxels[Vector3i(x, y, z)] = C_GOLD_BRIGHT if abs(x) == 2 else C_GOLD_RICH
							
	# Gilded Imperial Arrows with Phoenix Feathers poking from quiver top (y: 10..15)
	var arrow_offsets = [Vector3i(0, 0, 0), Vector3i(1, 0, 1), Vector3i(-1, 0, 0), Vector3i(0, 0, -1)]
	for o in arrow_offsets:
		for dy in range(10, 15):
			voxels[Vector3i(o.x, dy, o.z)] = C_GOLD_RICH
		# Phoenix feathers
		voxels[Vector3i(o.x + 1, 14, o.z)] = C_FEATHER_GOLD
		voxels[Vector3i(o.x - 1, 14, o.z)] = C_FEATHER_GOLD
		voxels[Vector3i(o.x, 15, o.z)] = C_ROYAL_CRIMSON

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)

static func build_imperial_arrow_mesh() -> ArrayMesh:
	var voxels: Dictionary = {}
	# Imperial Broadhead Arrow: 28 voxels along +Z
	# Golden Nock (z: -19..-18)
	voxels[Vector3i(0, 0, -19)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 0, -18)] = C_GOLD_RICH

	# Phoenix Fletching Feathers (z: -17..-13)
	for z in range(-17, -12):
		var col = C_ROYAL_CRIMSON if z <= -15 else C_FEATHER_GOLD
		voxels[Vector3i(1, 0, z)] = col
		voxels[Vector3i(-1, 0, z)] = col
		voxels[Vector3i(0, 1, z)] = col
		voxels[Vector3i(0, -1, z)] = col

	# Ivory & Gilded Shaft (z: -16..3)
	for z in range(-16, 4):
		voxels[Vector3i(0, 0, z)] = C_GOLD_RICH if (z % 3 == 0) else C_BOW_IVORY

	# Golden Ferrule Collar behind head (z: 4)
	voxels[Vector3i(0, 0, 4)] = C_GOLD_BRIGHT

	# Imperial Flanged Broadhead Arrowhead (z: 5..8)
	voxels[Vector3i(0, 0, 5)] = C_GOLD_DEEP
	voxels[Vector3i(1, 0, 5)] = C_GOLD_BRIGHT
	voxels[Vector3i(-1, 0, 5)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 1, 5)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, -1, 5)] = C_GOLD_BRIGHT

	voxels[Vector3i(0, 0, 6)] = C_GOLD_BRIGHT
	voxels[Vector3i(1, 0, 6)] = C_GOLD_BRIGHT
	voxels[Vector3i(-1, 0, 6)] = C_GOLD_BRIGHT

	voxels[Vector3i(0, 0, 7)] = C_GOLD_BRIGHT
	voxels[Vector3i(0, 0, 8)] = C_GEM_RUBY_GLOW # Piercing sun-crystal tip!

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)
"""

quiver_anchor = """	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)


# --- B. GOBLIN SHAMAN (Mặt Nạ Sọ Thú, Áo Choàng & Trượng Ma Thuật) ---"""

if quiver_anchor in vb_code:
    vb_code = vb_code.replace(quiver_anchor, quiver_anchor.split("\n\n\n")[0] + "\n" + imperial_weapons_code + "\n\n# --- B. GOBLIN SHAMAN (Mặt Nạ Sọ Thú, Áo Choàng & Trượng Ma Thuật) ---")
    print("[OK] Inserted imperial weapons suite")
else:
    print("[WARN] quiver_anchor not found")

with open(VB_PATH, "w", encoding="utf-8") as f:
    f.write(vb_code)
print("[OK] voxel_builder.gd successfully written!")

# ==============================================================================
# 2. PATCH GOBLIN_ARCHER.GD
# ==============================================================================
with open(ARCHER_PATH, "r", encoding="utf-8") as f:
    ga_code = f.read()

# 2.1 Update comment
ga_code = ga_code.replace(
    "# Outfits: 1 = Thô Sơ (Primitive Hunter), 2 = Ranger (Xạ Thủ Kiểm Lâm)",
    "# Outfits: 1 = Thô Sơ (Primitive Hunter), 2 = Ranger (Xạ Thủ Kiểm Lâm), 3 = Hoàng Kim (Imperial Golden Marksman)"
)

# 2.2 Update generate_voxel_meshes to include outfit 3 and weapon caching
old_gen_meshes = """func generate_voxel_meshes() -> void:
	# Pre-build meshes for Outfit 1 (Thô Sơ / Primitive Hunter)
	outfit_meshes[1] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(1),
		"head": VoxelBuilder.build_archer_head_mesh(1),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 1),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(1),
		"shin": VoxelBuilder.build_archer_shin_mesh(1)
	}
	
	# Pre-build meshes for Outfit 2 (Ranger / Xạ Thủ Kiểm Lâm)
	outfit_meshes[2] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(2),
		"head": VoxelBuilder.build_archer_head_mesh(2),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 2),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(2),
		"shin": VoxelBuilder.build_archer_shin_mesh(2)
	}
	
	quiver_mesh.mesh = VoxelBuilder.build_quiver_mesh()
	
	bow_rest_mesh = VoxelBuilder.build_bow_mesh(false)
	bow_drawn_mesh = VoxelBuilder.build_bow_mesh(true)
	bow_mesh.mesh = bow_rest_mesh
	
	arrow_mesh.mesh = VoxelBuilder.build_arrow_mesh()
	arrow.visible = false
	
	if not flying_arrow:
		flying_arrow = MeshInstance3D.new()
		flying_arrow.mesh = VoxelBuilder.build_arrow_mesh()
		flying_arrow.visible = false
		get_parent().call_deferred("add_child", flying_arrow)
		
	apply_outfit(current_outfit)"""

new_gen_meshes = """func generate_voxel_meshes() -> void:
	var std_bow_rest = VoxelBuilder.build_bow_mesh(false)
	var std_bow_drawn = VoxelBuilder.build_bow_mesh(true)
	var std_quiver = VoxelBuilder.build_quiver_mesh()
	var std_arrow = VoxelBuilder.build_arrow_mesh()

	# Pre-build meshes for Outfit 1 (Thô Sơ / Primitive Hunter)
	outfit_meshes[1] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(1),
		"head": VoxelBuilder.build_archer_head_mesh(1),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 1),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(1),
		"shin": VoxelBuilder.build_archer_shin_mesh(1),
		"bow_rest": std_bow_rest,
		"bow_drawn": std_bow_drawn,
		"quiver": std_quiver,
		"arrow": std_arrow
	}
	
	# Pre-build meshes for Outfit 2 (Ranger / Xạ Thủ Kiểm Lâm)
	outfit_meshes[2] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(2),
		"head": VoxelBuilder.build_archer_head_mesh(2),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 2),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(2),
		"shin": VoxelBuilder.build_archer_shin_mesh(2),
		"bow_rest": std_bow_rest,
		"bow_drawn": std_bow_drawn,
		"quiver": std_quiver,
		"arrow": std_arrow
	}

	# Pre-build meshes for Outfit 3 (Hoàng Kim / Imperial Golden Marksman)
	outfit_meshes[3] = {
		"torso": VoxelBuilder.build_archer_torso_mesh(3),
		"head": VoxelBuilder.build_archer_head_mesh(3),
		"upper_arm": VoxelBuilder.build_archer_upper_arm_mesh(3),
		"left_forearm": VoxelBuilder.build_archer_forearm_mesh(false, 3),
		"right_forearm": VoxelBuilder.build_archer_forearm_mesh(true, 3),
		"thigh": VoxelBuilder.build_archer_thigh_mesh(3),
		"shin": VoxelBuilder.build_archer_shin_mesh(3),
		"bow_rest": VoxelBuilder.build_imperial_bow_mesh(false),
		"bow_drawn": VoxelBuilder.build_imperial_bow_mesh(true),
		"quiver": VoxelBuilder.build_imperial_quiver_mesh(),
		"arrow": VoxelBuilder.build_imperial_arrow_mesh()
	}
	
	quiver_mesh.mesh = std_quiver
	bow_rest_mesh = std_bow_rest
	bow_drawn_mesh = std_bow_drawn
	bow_mesh.mesh = bow_rest_mesh
	arrow_mesh.mesh = std_arrow
	arrow.visible = false
	
	if not flying_arrow:
		flying_arrow = MeshInstance3D.new()
		flying_arrow.mesh = std_arrow
		flying_arrow.visible = false
		get_parent().call_deferred("add_child", flying_arrow)
		
	apply_outfit(current_outfit)"""

if old_gen_meshes in ga_code:
    ga_code = ga_code.replace(old_gen_meshes, new_gen_meshes)
    print("[OK] Updated goblin_archer.gd generate_voxel_meshes")
else:
    print("[WARN] old_gen_meshes not found in goblin_archer.gd")

# 2.3 Update set_outfit & apply_outfit
old_apply_outfit = """func set_outfit(outfit_id: int) -> void:
	current_outfit = clamp(outfit_id, 1, 2)
	apply_outfit(current_outfit)
	outfit_changed.emit(current_outfit)

func apply_outfit(outfit_id: int) -> void:
	if not outfit_meshes.has(outfit_id):
		return
	var m: Dictionary = outfit_meshes[outfit_id]
	torso_mesh.mesh = m["torso"]
	head_mesh.mesh = m["head"]
	left_arm_mesh.mesh = m["upper_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["upper_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]"""

new_apply_outfit = """func set_outfit(outfit_id: int) -> void:
	current_outfit = clamp(outfit_id, 1, 3)
	apply_outfit(current_outfit)
	outfit_changed.emit(current_outfit)

func apply_outfit(outfit_id: int) -> void:
	if not outfit_meshes.has(outfit_id):
		return
	var m: Dictionary = outfit_meshes[outfit_id]
	torso_mesh.mesh = m["torso"]
	head_mesh.mesh = m["head"]
	left_arm_mesh.mesh = m["upper_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["upper_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]

	if m.has("bow_rest") and m.has("bow_drawn"):
		bow_rest_mesh = m["bow_rest"]
		bow_drawn_mesh = m["bow_drawn"]
		bow_mesh.mesh = bow_drawn_mesh if (current_pose and current_pose.get("is_drawn", false)) else bow_rest_mesh
	if m.has("quiver"):
		quiver_mesh.mesh = m["quiver"]
	if m.has("arrow"):
		arrow_mesh.mesh = m["arrow"]
		if flying_arrow:
			flying_arrow.mesh = m["arrow"]"""

if old_apply_outfit in ga_code:
    ga_code = ga_code.replace(old_apply_outfit, new_apply_outfit)
    print("[OK] Updated goblin_archer.gd set_outfit & apply_outfit")
else:
    print("[WARN] old_apply_outfit not found in goblin_archer.gd")

with open(ARCHER_PATH, "w", encoding="utf-8") as f:
    f.write(ga_code)
print("[OK] goblin_archer.gd successfully written!")

# ==============================================================================
# 3. PATCH VIEWER.GD
# ==============================================================================
with open(VIEWER_PATH, "r", encoding="utf-8") as f:
    vw_code = f.read()

# 3.1 Member variable
old_vars = """var btn_outfit1: Button = null
var btn_outfit2: Button = null"""

new_vars = """var btn_outfit1: Button = null
var btn_outfit2: Button = null
var btn_outfit3: Button = null"""

if old_vars in vw_code:
    vw_code = vw_code.replace(old_vars, new_vars)
    print("[OK] Declared btn_outfit3 in viewer.gd")
else:
    print("[WARN] old_vars not found in viewer.gd")

# 3.2 Instantiate button in _ready
old_btns_setup = """	btn_outfit2 = Button.new()
	btn_outfit2.name = "BtnOutfit2"
	btn_outfit2.text = "🛡️ Đồ 2 (Chiến Binh)"
	btn_outfit2.tooltip_text = "Bộ đồ 2: Chiến binh thép [Phím O]"
	btn_outfit2.pressed.connect(func(): _select_outfit(2))
	sub_group_stances.add_child(btn_outfit2)"""

new_btns_setup = """	btn_outfit2 = Button.new()
	btn_outfit2.name = "BtnOutfit2"
	btn_outfit2.text = "🛡️ Đồ 2 (Chiến Binh)"
	btn_outfit2.tooltip_text = "Bộ đồ 2: Chiến binh thép [Phím O]"
	btn_outfit2.pressed.connect(func(): _select_outfit(2))
	sub_group_stances.add_child(btn_outfit2)

	btn_outfit3 = Button.new()
	btn_outfit3.name = "BtnOutfit3"
	btn_outfit3.text = "👑 Đồ 3 (Hoàng Kim)"
	btn_outfit3.tooltip_text = "Bộ đồ 3: Xạ thủ Hoàng Kim Đế Quốc (Giáp vàng ròng tinh xảo, vương miện cánh đại bàng, cung thần hoàng gia) [Phím O]"
	btn_outfit3.pressed.connect(func(): _select_outfit(3))
	sub_group_stances.add_child(btn_outfit3)"""

if old_btns_setup in vw_code:
    vw_code = vw_code.replace(old_btns_setup, new_btns_setup)
    print("[OK] Instantiated btn_outfit3 in viewer.gd")
else:
    print("[WARN] old_btns_setup not found in viewer.gd")

# 3.3 Update _update_outfit_ui
old_update_ui = """func _update_outfit_ui() -> void:
	if not btn_outfit1 or not btn_outfit2:
		return
	var has_outfit = (active_monster_type in ["warrior", "archer", "shaman", "rogue", "chieftain"])
	var sep = sub_group_stances.get_node_or_null("OutfitSep")
	if sep:
		sep.visible = has_outfit
	btn_outfit1.visible = has_outfit
	btn_outfit2.visible = has_outfit
	
	if has_outfit and current_monster_node:
		var cur = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
		btn_outfit1.modulate = Color(0.2, 1.0, 0.5) if cur == 1 else Color(0.7, 0.7, 0.7)
		btn_outfit2.modulate = Color(0.2, 1.0, 0.5) if cur == 2 else Color(0.7, 0.7, 0.7)"""

new_update_ui = """func _update_outfit_ui() -> void:
	if not btn_outfit1 or not btn_outfit2:
		return
	var has_outfit = (active_monster_type in ["warrior", "archer", "shaman", "rogue", "chieftain"])
	var sep = sub_group_stances.get_node_or_null("OutfitSep")
	if sep:
		sep.visible = has_outfit
	btn_outfit1.visible = has_outfit
	btn_outfit2.visible = has_outfit
	if btn_outfit3:
		btn_outfit3.visible = (active_monster_type == "archer")
	
	if has_outfit and current_monster_node:
		var cur = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
		btn_outfit1.modulate = Color(0.2, 1.0, 0.5) if cur == 1 else Color(0.7, 0.7, 0.7)
		btn_outfit2.modulate = Color(0.2, 1.0, 0.5) if cur == 2 else Color(0.7, 0.7, 0.7)
		if btn_outfit3:
			btn_outfit3.modulate = Color(1.0, 0.85, 0.2) if cur == 3 else Color(0.7, 0.7, 0.7)"""

if old_update_ui in vw_code:
    vw_code = vw_code.replace(old_update_ui, new_update_ui)
    print("[OK] Updated _update_outfit_ui in viewer.gd")
else:
    print("[WARN] old_update_ui not found in viewer.gd")

# 3.4 Update archer text in _update_outfit_ui
old_archer_text = """		elif active_monster_type == "archer":
			btn_outfit1.text = "🏹 Đồ 1 (Thô Sơ)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Thợ săn nguyên thủy (áo da thú, nanh vuốt hoang dã) [Phím O]"
			btn_outfit2.text = "🌲 Đồ 2 (Ranger)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Xạ thủ kiểm lâm (áo chẽn gambeson, giáp ngực plastron, ủng buộc dây) [Phím O]\""""

new_archer_text = """		elif active_monster_type == "archer":
			btn_outfit1.text = "🏹 Đồ 1 (Thô Sơ)"
			btn_outfit1.tooltip_text = "Bộ đồ 1: Thợ săn nguyên thủy (áo da thú, nanh vuốt hoang dã) [Phím O]"
			btn_outfit2.text = "🌲 Đồ 2 (Ranger)"
			btn_outfit2.tooltip_text = "Bộ đồ 2: Xạ thủ kiểm lâm (áo chẽn gambeson, giáp ngực plastron, ủng buộc dây) [Phím O]"
			if btn_outfit3:
				btn_outfit3.text = "👑 Đồ 3 (Hoàng Kim)"
				btn_outfit3.tooltip_text = "Bộ đồ 3: Xạ thủ Hoàng Kim Đế Quốc (Giáp vàng ròng tinh xảo, vương miện cánh đại bàng, cung thần hoàng gia nâng cấp) [Phím O]\""""

if old_archer_text in vw_code:
    vw_code = vw_code.replace(old_archer_text, new_archer_text)
    print("[OK] Updated archer outfit labels in viewer.gd")
else:
    print("[WARN] old_archer_text not found in viewer.gd")

# 3.5 Update KEY_O cycling
old_key_o = """			KEY_O:
				if current_monster_node and current_monster_node.has_method("set_outfit"):
					var cur_o = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
					_select_outfit(2 if cur_o == 1 else 1)"""

new_key_o = """			KEY_O:
				if current_monster_node and current_monster_node.has_method("set_outfit"):
					var cur_o = current_monster_node.get("current_outfit") if "current_outfit" in current_monster_node else 1
					var max_o = 3 if active_monster_type == "archer" else 2
					var next_o = (cur_o % max_o) + 1
					_select_outfit(next_o)"""

if old_key_o in vw_code:
    vw_code = vw_code.replace(old_key_o, new_key_o)
    print("[OK] Updated KEY_O handler in viewer.gd")
else:
    print("[WARN] old_key_o not found in viewer.gd")

with open(VIEWER_PATH, "w", encoding="utf-8") as f:
    f.write(vw_code)
print("[OK] viewer.gd successfully written!")

# ==============================================================================
# 4. PATCH README.MD
# ==============================================================================
with open(README_PATH, "r", encoding="utf-8") as f:
    rd_code = f.read()

old_rd_archer = """### 2. Goblin Archer (Xạ Thủ Cung)
- **Dual Outfit System**:
  - **Outfit 1 (Tribal Hunter / Thô Sơ)**: Tattered raw animal pelt vest, canine tooth chest trophy, sinew wrist bindings, wild fur loincloth, bare clawed feral feet with grounded sole support.
  - **Outfit 2 (Forest Ranger / Xạ Thủ Kiểm Lâm)**: Quilted forest-green gambeson, hardened leather chest plastron with bronze studs, vambraces, and tall laced hunting boots."""

new_rd_archer = """### 2. Goblin Archer (Xạ Thủ Cung)
- **Triple Outfit System**:
  - **Outfit 1 (Tribal Hunter / Thô Sơ)**: Tattered raw animal pelt vest, canine tooth chest trophy, sinew wrist bindings, wild fur loincloth, bare clawed feral feet with grounded sole support.
  - **Outfit 2 (Forest Ranger / Xạ Thủ Kiểm Lâm)**: Quilted forest-green gambeson, hardened leather chest plastron with bronze studs, vambraces, and tall laced hunting boots.
  - **Outfit 3 (Imperial Golden Marksman / Xạ Thủ Hoàng Kim Đế Quốc)**: Opulent gilded imperial armor, royal velvet crimson gambeson with gold diamond quilting, winged falcon diadem crown with twin phoenix plumes (crimson & gold), ornate sapphire ocular targeting monocle, ruby-crested eagle buckle & gorget, sculpted golden vambraces with claw thimbles, fluted golden greaves with winged sabatons, and an upgraded magnificent **Imperial Recurve Warbow** (dragon-bone limbs, sculpted gold filigree armor, ruby sighting crystal, divine gold bowstring) accompanied by a fluted golden quiver and gilded phoenix-fletched broadhead arrows."""

if old_rd_archer in rd_code:
    rd_code = rd_code.replace(old_rd_archer, new_rd_archer)
    rd_code = rd_code.replace(
        "- **O**: Switch monster outfit (Warrior & Archer: Outfit 1 <-> Outfit 2).",
        "- **O**: Switch monster outfit (Warrior: Outfit 1 <-> 2; Archer: Outfit 1 ➔ 2 ➔ 3)."
    )
    with open(README_PATH, "w", encoding="utf-8") as f:
        f.write(rd_code)
    print("[OK] README.md successfully updated!")
else:
    print("[WARN] old_rd_archer not found in README.md")

print("All modifications completed successfully!")
