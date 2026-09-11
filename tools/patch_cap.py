import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

old_cap = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.5).timeout
\t
\t# 1. Archer Aim Shot
\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.4).timeout
\t_save_shot("godot_archer_aim.png")
\tawait get_tree().create_timer(0.3).timeout"""

new_cap = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.5).timeout
\t
\t# 1. Archer Shots
\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("idle")
\tawait get_tree().create_timer(0.3).timeout
\t_save_shot("godot_archer_idle.png")
\t
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.4).timeout
\t_save_shot("godot_archer_aim.png")
\t
\t# Close up shot of aim
\tcamera_distance = 2.4
\t_update_camera_transform()
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("godot_archer_aim_close.png")
\tcamera_distance = 3.4
\t_update_camera_transform()
\tawait get_tree().create_timer(0.2).timeout"""

if old_cap in text:
    text = text.replace(old_cap, new_cap)
    with open(viewer_gd, "w", encoding="utf-8") as f:
        f.write(text)
    print("[OK] viewer.gd capture sequence updated.")
else:
    print("[ERROR] old_cap not found in viewer.gd")
