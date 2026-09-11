import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

with open(archer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Add IK solver method in goblin_archer.gd
ik_code = """
func _solve_draw_hand_ik(nock_world_pos: Vector3) -> void:
\t# Right shoulder in world space
\tvar sh_pos: Vector3 = right_arm.global_position
\tvar to_target: Vector3 = nock_world_pos - sh_pos
\tvar dist: float = to_target.length()
\t
\tvar l1: float = 0.27 # Upper arm length
\tvar l2: float = 0.24 # Forearm length
\tvar d_clamped: float = clampf(dist, 0.08, (l1 + l2) * 0.96)
\t
\t# Elbow flexion angle by Law of Cosines
\tvar cos_elbow: float = clampf((l1 * l1 + l2 * l2 - d_clamped * d_clamped) / (2.0 * l1 * l2), -1.0, 1.0)
\tvar elbow_angle_rad: float = acos(cos_elbow)
\tvar forearm_flex_deg: float = -(180.0 - rad_to_deg(elbow_angle_rad))
\t
\t# Shoulder angle from shoulder-to-target line
\tvar cos_sh: float = clampf((l1 * l1 + d_clamped * d_clamped - l2 * l2) / (2.0 * l1 * d_clamped), -1.0, 1.0)
\tvar sh_angle_rad: float = acos(cos_sh)
\t
\t# In Torso space:
\tvar target_torso: Vector3 = torso.to_local(nock_world_pos)
\tvar sh_torso: Vector3 = right_arm.position # (0.27, 0.48, 0)
\tvar dir_torso: Vector3 = (target_torso - sh_torso).normalized()
\t
\t# Archery Pole vector: elbow stays high and flared out to the right (+X, +Y, -Z)
\tvar pole_torso: Vector3 = Vector3(0.7, 0.5, -0.5).normalized()
\tvar arm_plane_normal: Vector3 = dir_torso.cross(pole_torso).normalized()
\tif arm_plane_normal.length_squared() < 0.01:
\t\tarm_plane_normal = Vector3.UP
\tvar elbow_up_dir: Vector3 = arm_plane_normal.cross(dir_torso).normalized()
\t
\t# Upper arm direction vector
\tvar upper_arm_dir: Vector3 = dir_torso * cos(sh_angle_rad) + elbow_up_dir * sin(sh_angle_rad)
\t
\t# Convert upper_arm_dir to Euler angles for right_arm (at rest hangs along -Y)
\t# We want local -Y to align with upper_arm_dir
\tvar forward_y: Vector3 = -upper_arm_dir.normalized()
\tvar side_x: Vector3 = arm_plane_normal.normalized()
\tvar front_z: Vector3 = side_x.cross(forward_y).normalized()
\tvar b: Basis = Basis(side_x, forward_y, front_z).orthonormalized()
\t
\tright_arm.transform.basis = b
\tright_forearm.rotation_degrees = Vector3(forearm_flex_deg, 0.0, 0.0)
"""

# Call _solve_draw_hand_ik in _apply_pose when current_anim is aim
old_apply = """\tif p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
\tif p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]"""

new_apply = """\tif p.has("use_ik") and p["use_ik"]:
\t\tvar nock_g: Vector3 = bow.to_global(Vector3(0.03, 0.0, -0.24))
\t\t_solve_draw_hand_ik(nock_g)
\telse:
\t\tif p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
\t\tif p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]"""

text = text.replace(old_apply, new_apply)
text += ik_code

with open(archer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] goblin_archer.gd updated with _solve_draw_hand_ik.")
