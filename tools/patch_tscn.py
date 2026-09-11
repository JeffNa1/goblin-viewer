import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
tscn_path = os.path.join(PROJECT_DIR, "scenes", "goblin_archer.tscn")

with open(tscn_path, "r", encoding="utf-8") as f:
    text = f.read()

old_block = """[node name="Bow" type="Node3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.24, 0)

[node name="BowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow"]

[node name="RightArm" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.27, 0.48, 0)

[node name="RightArmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm"]

[node name="RightForearm" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="RightForearmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm"]

[node name="Arrow" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.24, 0)

[node name="ArrowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm/Arrow"]"""

new_block = """[node name="Bow" type="Node3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.24, 0)

[node name="BowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow"]

[node name="Arrow" type="Node3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.03, 0, 0)

[node name="ArrowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/Arrow"]

[node name="RightArm" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.27, 0.48, 0)

[node name="RightArmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm"]

[node name="RightForearm" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="RightForearmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm"]"""

if old_block in text:
    text = text.replace(old_block, new_block)
    with open(tscn_path, "w", encoding="utf-8") as f:
        f.write(text)
    print("[OK] goblin_archer.tscn hierarchy updated successfully!")
else:
    print("[ERROR] old_block not found in goblin_archer.tscn")
