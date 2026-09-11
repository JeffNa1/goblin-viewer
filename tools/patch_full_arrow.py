import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
vb_path = os.path.join(PROJECT_DIR, "scripts", "voxel_builder.gd")
archer_gd_path = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

# 1. Update build_arrow_mesh in voxel_builder.gd
with open(vb_path, "r", encoding="utf-8") as f:
    vb_text = f.read()

old_arrow = """static func build_arrow_mesh() -> ArrayMesh:
\tvar voxels: Dictionary = {}
\t# Arrow length: 18 voxels (0.54m) along +Z
\t# Flint Arrowhead (z: 8..10)
\tvoxels[Vector3i(0, 0, 10)] = C_SPIKE_DARK
\tvoxels[Vector3i(0, 0, 9)] = C_SPIKE
\tvoxels[Vector3i(1, 0, 8)] = C_SPIKE
\tvoxels[Vector3i(-1, 0, 8)] = C_SPIKE
\tvoxels[Vector3i(0, 1, 8)] = C_SPIKE
\tvoxels[Vector3i(0, -1, 8)] = C_SPIKE
\tvoxels[Vector3i(0, 0, 8)] = C_ROPE

\t# Wooden Shaft (z: -7..7)
\tfor z in range(-7, 8):
\t\tvoxels[Vector3i(0, 0, z)] = C_WOOD

\t# Fletching Feathers (z: -7..-5)
\tfor z in range(-7, -4):
\t\tvar col = C_FEATHER_RED if z % 2 == 0 else C_FEATHER_WHITE
\t\tvoxels[Vector3i(1, 0, z)] = col
\t\tvoxels[Vector3i(-1, 0, z)] = col
\t\tvoxels[Vector3i(0, 1, z)] = col
\t\tvoxels[Vector3i(0, -1, z)] = col

\t# Nock (z: -8)
\tvoxels[Vector3i(0, 0, -8)] = C_BONE

\tvar v_arr: Array = []
\tfor k in voxels:
\t\tv_arr.append([k.x, k.y, k.z, voxels[k]])
\treturn build_seamless_mesh(v_arr)"""

new_arrow = """static func build_arrow_mesh() -> ArrayMesh:
\tvar voxels: Dictionary = {}
\t# Arrow length: 26 voxels (0.78m) along +Z - full hunting arrow
\t# Flint Arrowhead (z: 14..17)
\tvoxels[Vector3i(0, 0, 17)] = C_SPIKE_DARK
\tvoxels[Vector3i(0, 0, 16)] = C_SPIKE
\tvoxels[Vector3i(1, 0, 15)] = C_SPIKE
\tvoxels[Vector3i(-1, 0, 15)] = C_SPIKE
\tvoxels[Vector3i(0, 1, 15)] = C_SPIKE
\tvoxels[Vector3i(0, -1, 15)] = C_SPIKE
\tvoxels[Vector3i(0, 0, 15)] = C_SPIKE
\tvoxels[Vector3i(0, 0, 14)] = C_ROPE

\t# Wooden Shaft (z: -7..13)
\tfor z in range(-7, 14):
\t\tvoxels[Vector3i(0, 0, z)] = C_WOOD

\t# Fletching Feathers (z: -7..-4)
\tfor z in range(-7, -3):
\t\tvar col = C_FEATHER_RED if z % 2 == 0 else C_FEATHER_WHITE
\t\tvoxels[Vector3i(1, 0, z)] = col
\t\tvoxels[Vector3i(-1, 0, z)] = col
\t\tvoxels[Vector3i(0, 1, z)] = col
\t\tvoxels[Vector3i(0, -1, z)] = col

\t# Nock (z: -8)
\tvoxels[Vector3i(0, 0, -8)] = C_BONE

\tvar v_arr: Array = []
\tfor k in voxels:
\t\tv_arr.append([k.x, k.y, k.z, voxels[k]])
\treturn build_seamless_mesh(v_arr)"""

if old_arrow in vb_text:
    vb_text = vb_text.replace(old_arrow, new_arrow)
    with open(vb_path, "w", encoding="utf-8") as f:
        f.write(vb_text)
    print("[OK] voxel_builder.gd build_arrow_mesh updated to full-length hunting arrow.")
else:
    print("[WARN] old_arrow not found in voxel_builder.gd")

# 2. Update goblin_archer.gd to use_ik = true in aim
with open(archer_gd_path, "r", encoding="utf-8") as f:
    ag_text = f.read()

ag_text = ag_text.replace('p["arrow_visible"] = true\n\treturn p',
                          'p["arrow_visible"] = true\n\tp["use_ik"] = true\n\treturn p')

with open(archer_gd_path, "w", encoding="utf-8") as f:
    f.write(ag_text)
print("[OK] goblin_archer.gd updated with p['use_ik'] = true in aim.")
