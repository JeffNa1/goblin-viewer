import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

cap_code = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.4).timeout
\tswitch_monster("archer")
\t
\t# 1. Aim
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.3).timeout
\t_save_shot("godot_archer_aim.png")
\t
\t# 2. Shoot (snap recoil + flying arrow)
\tcurrent_monster_node.play_anim("shoot")
\tawait get_tree().create_timer(0.12).timeout
\t_save_shot("godot_archer_shoot.png")
\t
\t# 3. Backstep Hop
\tawait get_tree().create_timer(0.85).timeout
\tcurrent_monster_node.play_anim("backstep")
\tawait get_tree().create_timer(0.28).timeout
\t_save_shot("godot_archer_backstep.png")
\t
\tawait get_tree().create_timer(0.6).timeout
\tcurrent_monster_node.play_anim("aim")
"""

old_snippet = text[text.find("func _capture_showcase_screenshots() -> void:"):text.find("func _process(delta: float) -> void:")]
text = text.replace(old_snippet, cap_code)

with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] Shoot and backstep capture sequence ready.")
