import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

with open(archer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Remove _solve_draw_hand_ik and use pure clean, beautiful FK
# In _apply_pose:
old_apply = """\tif p.has("use_ik") and p["use_ik"]:
\t\tvar nock_g: Vector3 = bow.to_global(Vector3(0.03, 0.0, -0.24))
\t\t_solve_draw_hand_ik(nock_g)
\telse:
\t\tif p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
\t\tif p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]"""

new_apply = """\tif p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
\tif p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]"""

text = text.replace(old_apply, new_apply)

# Update _compute_aim
old_aim = text[text.find("# --- 4. AIM"):text.find("# --- 5. SHOOT")]

new_aim = """# --- 4. AIM (True Archery Form: Left Arm Pushes Bow Out, Right Arm Pulls String to Cheek) ---
func _compute_aim(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar tremor = sin(time_val * 40.0) * 0.3
\t
\t# Body turned sideways (Torso yaw ~ -65 deg)
\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02, 0.0)
\tp["hips_rot"] = Vector3(0.0, -45.0, 0.0)
\tp["torso_rot"] = Vector3(2.0, -20.0, 0.0)
\t
\t# Staggered feet
\tp["left_thigh_rot"] = Vector3(-16.0, 0.0, -8.0)
\tp["left_shin_rot"] = Vector3(22.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(14.0, 0.0, 8.0)
\tp["right_shin_rot"] = Vector3(18.0, 0.0, 0.0)
\t
\t# Head turned left to look directly down target sightline (-65 + 65 = 0 deg)
\tp["head_rot"] = Vector3(-2.0, 65.0, 0.0)
\t
\t# LEFT ARM: Holds the WOODEN BOW GRIP and extends fully forward towards target!
\tp["left_arm_rot"] = Vector3(-88.0 + tremor, 12.0, 4.0)
\tp["left_forearm_rot"] = Vector3(-4.0, 0.0, 0.0)
\t
\t# BOW: Held in left hand. Wooden bow curves forward towards target (+Z).
\t# String pulls back toward archer's cheek (-Z).
\tp["bow_rot"] = Vector3(90.0, 0.0, 0.0)
\t
\t# RIGHT ARM: Pulls the BOWSTRING back to right cheek/jaw!
\t# Elbow high and back, forearm bent back to jaw
\tp["right_arm_rot"] = Vector3(-75.0 + tremor, 38.0, 75.0)
\tp["right_forearm_rot"] = Vector3(-130.0, 0.0, 0.0)
\t
\tp["is_drawn"] = true
\tp["arrow_visible"] = true
\treturn p
"""

text = text.replace(old_aim, new_aim)

with open(archer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] goblin_archer.gd updated with proper bow arm (Left) and draw arm (Right)!")
