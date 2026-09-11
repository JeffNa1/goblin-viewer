import os
import time

script_dir = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer\scripts"
viewer_gd = os.path.join(script_dir, "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Temporarily replace _capture_showcase_screenshots to capture archer anims
old_cap = text[text.find("func _capture_showcase_screenshots() -> void:"):text.find("func _on_editor_slider_changed")]

new_cap = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.4).timeout
\tswitch_monster("archer")
\t
\t# 1. Archer Idle
\tcurrent_monster_node.play_anim("idle")
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("test_archer_idle.png")
\t
\t# 2. Archer Walk
\tcurrent_monster_node.play_anim("walk")
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("test_archer_walk.png")
\t
\t# 3. Archer Run
\tcurrent_monster_node.play_anim("run")
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("test_archer_run.png")
\t
\t# 4. Archer Aim
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.3).timeout
\t_save_shot("test_archer_aim.png")
\t
\t# 5. Archer Aim side view (yaw = 90)
\tyaw = 90.0
\t_update_camera_transform()
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("test_archer_aim_side.png")
\t
\t# 6. Archer Aim front view (yaw = 0)
\tyaw = 0.0
\t_update_camera_transform()
\tawait get_tree().create_timer(0.2).timeout
\t_save_shot("test_archer_aim_front.png")
\t
\t# 7. Archer Shoot
\tyaw = 30.0
\t_update_camera_transform()
\tcurrent_monster_node.play_anim("shoot")
\tawait get_tree().create_timer(0.12).timeout
\t_save_shot("test_archer_shoot.png")
\t
\t# 8. Archer Backstep
\tcurrent_monster_node.play_anim("backstep")
\tawait get_tree().create_timer(0.25).timeout
\t_save_shot("test_archer_backstep.png")
\t
\tcurrent_monster_node.play_anim("idle")
\treset_camera()
"""

# Replace in viewer_gd
text = text.replace(old_cap, new_cap)
with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] Test capture script ready.")
