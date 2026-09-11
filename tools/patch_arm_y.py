import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

with open(archer_gd, "r", encoding="utf-8") as f:
    text = f.read()

text = text.replace('p["left_arm_rot"] = Vector3(-86.0 + tremor, -18.0, 6.0)',
                    'p["left_arm_rot"] = Vector3(-86.0 + tremor, 45.0, 6.0)')

with open(archer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] goblin_archer.gd left_arm_rot Y updated to +45 deg.")
