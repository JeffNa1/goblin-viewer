import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

with open(archer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Replace _compute_idle, _compute_walk, _compute_run, _compute_aim, _compute_shoot
old_idle = """# --- 1. IDLE (Bow at Side, Free Right Hand, Scouting) ---
func _compute_idle(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 2.2
\tvar breath = sin(t) * 0.008
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
\tp["hips_rot"] = Vector3(0.0, sin(t * 0.5) * 4.0, 0.0)
\tp["torso_rot"] = Vector3(sin(t) * 2.0, 0.0, 0.0)
\tp["head_rot"] = Vector3(-2.0, sin(t * 0.7) * 14.0, 0.0)
\t
\t# Left arm holds bow vertically at the hip
\tp["left_arm_rot"] = Vector3(-14.0 + breath * 60.0, 6.0, -18.0)
\tp["left_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(20.0, 0.0, -5.0)
\t
\t# Right arm relaxed at side
\tp["right_arm_rot"] = Vector3(6.0 - breath * 50.0, -4.0, 14.0)
\tp["right_forearm_rot"] = Vector3(-18.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-2.0, 0.0, -2.0)
\tp["left_shin_rot"] = Vector3(4.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(2.0, 0.0, 2.0)
\tp["right_shin_rot"] = Vector3(3.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p"""

new_idle = """# --- 1. IDLE (Natural Relaxed Hunter Stance, Bow Held Vertically at Side) ---
func _compute_idle(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 2.2
\tvar breath = sin(t) * 0.008
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
\tp["hips_rot"] = Vector3(0.0, sin(t * 0.5) * 3.0, 0.0)
\tp["torso_rot"] = Vector3(sin(t) * 2.0, 0.0, 0.0)
\tp["head_rot"] = Vector3(-2.0, sin(t * 0.7) * 12.0, 0.0)
\t
\t# Left arm hangs relaxed at the side with a natural slight elbow bend
\tp["left_arm_rot"] = Vector3(4.0 + breath * 40.0, 0.0, -10.0)
\tp["left_forearm_rot"] = Vector3(-8.0, 0.0, 0.0)
\t# Bow is held cleanly vertical, curve forward, string back
\tp["bow_rot"] = Vector3(0.0, 0.0, 10.0)
\t
\t# Right arm relaxed at side
\tp["right_arm_rot"] = Vector3(4.0 - breath * 40.0, 0.0, 10.0)
\tp["right_forearm_rot"] = Vector3(-10.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-2.0, 0.0, -2.0)
\tp["left_shin_rot"] = Vector3(4.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(2.0, 0.0, 2.0)
\tp["right_shin_rot"] = Vector3(3.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p"""

text = text.replace(old_idle, new_idle)

# Update aim bow_rot
old_aim_bow = 'p["bow_rot"] = Vector3(-90.0, 0.0, 172.0)'
new_aim_bow = 'p["bow_rot"] = Vector3(90.0, 0.0, 0.0)'
text = text.replace(old_aim_bow, new_aim_bow)

# Update shoot bow_rot
text = text.replace('p["bow_rot"] = Vector3(lerp(-90.0, -102.0, s), 0.0, 172.0)',
                    'p["bow_rot"] = Vector3(lerp(90.0, 98.0, s), 0.0, 0.0)')
text = text.replace('p["bow_rot"] = Vector3(lerp(-102.0, -90.0, s), 0.0, 172.0)',
                    'p["bow_rot"] = Vector3(lerp(98.0, 90.0, s), 0.0, 0.0)')
text = text.replace('p["bow_rot"] = Vector3(-90.0, 0.0, 172.0)',
                    'p["bow_rot"] = Vector3(90.0, 0.0, 0.0)')

# Update walk bow_rot
old_walk_arm = """\tp["left_arm_rot"] = Vector3(-20.0 + c_leg * 8.0, 8.0, -18.0)
\tp["left_forearm_rot"] = Vector3(-40.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(22.0, 0.0, -5.0)"""

new_walk_arm = """\tp["left_arm_rot"] = Vector3(4.0 + c_leg * 10.0, 0.0, -10.0)
\tp["left_forearm_rot"] = Vector3(-10.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(0.0, 0.0, 10.0)"""
text = text.replace(old_walk_arm, new_walk_arm)

with open(archer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] goblin_archer.gd updated with correct bow facing & natural idle pose!")
