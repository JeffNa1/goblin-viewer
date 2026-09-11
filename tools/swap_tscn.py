import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
tscn_path = os.path.join(PROJECT_DIR, "scenes", "goblin_archer.tscn")

new_tscn = """[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/goblin_archer.gd" id="1_archer"]

[node name="GoblinArcher" type="Node3D"]
script = ExtResource("1_archer")

[node name="VisualRoot" type="Node3D" parent="."]

[node name="Hips" type="Node3D" parent="VisualRoot"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.618, 0)

[node name="Torso" type="Node3D" parent="VisualRoot/Hips"]

[node name="TorsoMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso"]

[node name="Quiver" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(0.906308, 0, -0.422618, -0.178606, 0.906308, -0.383022, 0.383022, 0.422618, 0.821394, 0.06, 0.28, -0.16)

[node name="QuiverMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/Quiver"]

[node name="Head" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.51, 0)

[node name="HeadMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/Head"]

[node name="LeftArm" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.27, 0.48, 0)

[node name="LeftArmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/LeftArm"]

[node name="LeftForearm" type="Node3D" parent="VisualRoot/Hips/Torso/LeftArm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="LeftForearmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/LeftArm/LeftForearm"]

[node name="RightArm" type="Node3D" parent="VisualRoot/Hips/Torso"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.27, 0.48, 0)

[node name="RightArmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm"]

[node name="RightForearm" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="RightForearmMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm"]

[node name="Bow" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.24, 0)

[node name="BowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm/Bow"]

[node name="Arrow" type="Node3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm/Bow"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.03, 0, 0)

[node name="ArrowMesh" type="MeshInstance3D" parent="VisualRoot/Hips/Torso/RightArm/RightForearm/Bow/Arrow"]

[node name="LeftThigh" type="Node3D" parent="VisualRoot/Hips"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.13, 0, 0)

[node name="LeftThighMesh" type="MeshInstance3D" parent="VisualRoot/Hips/LeftThigh"]

[node name="LeftShin" type="Node3D" parent="VisualRoot/Hips/LeftThigh"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="LeftShinMesh" type="MeshInstance3D" parent="VisualRoot/Hips/LeftThigh/LeftShin"]

[node name="RightThigh" type="Node3D" parent="VisualRoot/Hips"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.13, 0, 0)

[node name="RightThighMesh" type="MeshInstance3D" parent="VisualRoot/Hips/RightThigh"]

[node name="RightShin" type="Node3D" parent="VisualRoot/Hips/RightThigh"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.27, 0)

[node name="RightShinMesh" type="MeshInstance3D" parent="VisualRoot/Hips/RightThigh/RightShin"]
"""

with open(tscn_path, "w", encoding="utf-8") as f:
    f.write(new_tscn)
print("[OK] goblin_archer.tscn updated: Bow & Arrow moved to RightForearm.")
