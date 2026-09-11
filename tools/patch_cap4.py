import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

cap_code = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.4).timeout
\tswitch_monster("archer")
\t
\t# 1. Natural Idle
\tcurrent_monster_node.play_anim("idle")
\tawait get_tree().create_timer(0.3).timeout
\t_save_shot("godot_archer_idle_natural.png")
\t
\t# 2. Correct Aim
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.35).timeout
\t_save_shot("godot_archer_aim_fixed2.png")
\t
\t# 3. Close up
\tcamera_distance = 2.3
\t_update_camera_transform()
\tawait get_tree().create_timer(0.15).timeout
\t_save_shot("godot_archer_aim_close2.png")
\t
\tcamera_distance = 3.4
\t_update_camera_transform()
"""

old_snippet = text[text.find("func _capture_showcase_screenshots() -> void:"):text.find("func _process(delta: float) -> void:")]
text = text.replace(old_snippet, cap_code)

# Make sure _capture_showcase_screenshots is called in _ready
if "call_deferred(\"_capture_showcase_screenshots\")" not in text:
    text = text.replace('reset_camera()\n\nfunc switch_monster',
                        'reset_camera()\n\tcall_deferred("_capture_showcase_screenshots")\n\nfunc switch_monster')

with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] viewer.gd capture sequence updated.")
