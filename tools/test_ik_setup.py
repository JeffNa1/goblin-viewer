import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

test_fn = """
func test_archer_aim_ik() -> void:
\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.05).timeout
\t
\tvar nock_target: Vector3 = m_archer.bow.to_global(Vector3(0.03, 0.0, -0.24))
\tvar sh_pos: Vector3 = m_archer.right_arm.global_position
\tvar to_nock = nock_target - sh_pos
\tvar dist = to_nock.length()
\tprint("[IK] NOCK WORLD: ", nock_target)
\tprint("[IK] SHOULDER WORLD: ", sh_pos)
\tprint("[IK] DISTANCE: ", dist)
\t
\t# Two bone lengths
\tvar l1 = 0.27
\tvar l2 = 0.24
\tvar cos_elbow = clampf((l1*l1 + l2*l2 - dist*dist) / (2.0 * l1 * l2), -1.0, 1.0)
\tvar elbow_flex = PI - acos(cos_elbow)
\tvar cos_sh = clampf((l1*l1 + dist*dist - l2*l2) / (2.0 * l1 * dist), -1.0, 1.0)
\tvar sh_lift = acos(cos_sh)
\t
\tprint("[IK] ELBOW FLEX DEG: ", rad_to_deg(elbow_flex))
\tprint("[IK] SHOULDER LIFT DEG: ", rad_to_deg(sh_sh if "sh_sh" in "" else sh_lift))
"""

# Let's clean up viewer.gd measurement snippet and add test_archer_aim_ik
old_snippet = text[text.find("func _capture_showcase_screenshots() -> void:"):text.find("func _process(delta: float) -> void:")]

new_snippet = """func _capture_showcase_screenshots() -> void:
\tawait get_tree().create_timer(0.4).timeout
\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.1).timeout
\t
\tvar nock_target: Vector3 = m_archer.bow.to_global(Vector3(0.03, 0.0, -0.24))
\tvar sh_pos: Vector3 = m_archer.right_arm.global_position
\tvar to_nock = nock_target - sh_pos
\tvar dist = to_nock.length()
\tprint("[IK] NOCK: ", nock_target, " | SHOULDER: ", sh_pos, " | DIST: ", dist)
"""

text = text.replace(old_snippet, new_snippet)
with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] test script updated.")
