import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

with open(archer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Replace right arm in _compute_aim
old_r_arm = """\t# RIGHT ARM: Pulls the BOWSTRING back to right cheek/jaw!
\t# Elbow high and back, forearm bent back to jaw
\tp["right_arm_rot"] = Vector3(-75.0 + tremor, 38.0, 75.0)
\tp["right_forearm_rot"] = Vector3(-130.0, 0.0, 0.0)"""

new_r_arm = """\t# RIGHT ARM: Pulls the BOWSTRING back to right cheek/jaw!
\t# Right hand locks onto nock and bowstring
\tp["right_arm_rot"] = Vector3(-74.0 + tremor, -44.0, -16.0)
\tp["right_forearm_rot"] = Vector3(-30.0, 0.0, 0.0)"""

text = text.replace(old_r_arm, new_r_arm)

with open(archer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] Right arm updated to lock onto nock.")
