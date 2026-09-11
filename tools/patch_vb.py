import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
vb_path = os.path.join(PROJECT_DIR, "scripts", "voxel_builder.gd")

with open(vb_path, "r", encoding="utf-8") as f:
    vb_text = f.read()

# Update build_bow_mesh in voxel_builder.gd
old_bow = """static func build_bow_mesh() -> ArrayMesh:
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
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if y % 2 == 0 else C_WOOD
		voxels[Vector3i(0, y, curve_z - 1)] = C_WOOD
		if y == 14:
			voxels[Vector3i(0, y, curve_z)] = C_BONE # Bone nock tip
			voxels[Vector3i(0, y + 1, curve_z - 1)] = C_BONE

	# Lower Limb (y: -3..-14)
	for y in range(-14, -2):
		var ay = abs(y)
		var curve_z = int(sin(float(ay - 2) / 12.0 * PI) * 3.0)
		if ay >= 11: curve_z -= (ay - 10)
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if ay % 2 == 0 else C_WOOD
		voxels[Vector3i(0, y, curve_z - 1)] = C_WOOD
		if y == -14:
			voxels[Vector3i(0, y, curve_z)] = C_BONE
			voxels[Vector3i(0, y - 1, curve_z - 1)] = C_BONE

	# Bowstring (y: -14..14 at z = -2)
	for y in range(-14, 15):
		voxels[Vector3i(0, y, -2)] = C_STRING

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)"""

new_bow = """static func build_bow_mesh(drawn: bool = false) -> ArrayMesh:
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
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if y % 2 == 0 else C_WOOD
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
		voxels[Vector3i(0, y, curve_z)] = C_WOOD_DARK if ay % 2 == 0 else C_WOOD
		voxels[Vector3i(0, y, curve_z - 1)] = C_WOOD
		if y == -14:
			voxels[Vector3i(0, y, curve_z)] = C_BONE
			voxels[Vector3i(0, y - 1, curve_z - 1)] = C_BONE

	# Bowstring:
	# If drawn: forms a taut V-shape pulling back to z = -8 at y = 0
	# If rest: straight line at z = -2
	if drawn:
		for y in range(-14, 15):
			var ay = abs(y)
			var string_z = int(lerp(-8.0, -2.0, float(ay) / 14.0))
			voxels[Vector3i(0, y, string_z)] = C_STRING
	else:
		for y in range(-14, 15):
			voxels[Vector3i(0, y, -2)] = C_STRING

	var v_arr: Array = []
	for k in voxels:
		v_arr.append([k.x, k.y, k.z, voxels[k]])
	return build_seamless_mesh(v_arr)"""

if old_bow in vb_text:
    vb_text = vb_text.replace(old_bow, new_bow)
    with open(vb_path, "w", encoding="utf-8") as f:
        f.write(vb_text)
    print("[OK] voxel_builder.gd build_bow_mesh updated with drawn support.")
else:
    print("[WARN] old_bow not found in voxel_builder.gd")
