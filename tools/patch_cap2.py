import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

cap_code = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.4).timeout
\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.3).timeout
\t_save_shot("godot_archer_aim.png")
\t
\tcamera_distance = 2.3
\t_update_camera_transform()
\tawait get_tree().create_timer(0.15).timeout
\t_save_shot("godot_archer_aim_close.png")
\t
\tcamera_distance = 3.4
\t_update_camera_transform()
\tcurrent_monster_node.play_anim("idle")
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("godot_archer_idle.png")
\t
\t# Return to aim for user
\tcurrent_monster_node.play_anim("aim")
"""

old_snippet = text[text.find("func _capture_showcase_screenshots() -> void:"):text.find("func _process(delta: float) -> void:")]
text = text.replace(old_snippet, cap_code)

with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] viewer.gd screenshot capture sequence updated.")
