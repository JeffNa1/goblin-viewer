import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
viewer_gd = os.path.join(PROJECT_DIR, "scripts", "viewer.gd")

with open(viewer_gd, "r", encoding="utf-8") as f:
    text = f.read()

# Add a print statement in _ready or showcase
snippet = """\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("aim")
\tawait get_tree().create_timer(0.1).timeout
\tvar nock_g = m_archer.bow.to_global(Vector3(0.03, 0.0, -0.24))
\tvar hand_g = m_archer.right_forearm.to_global(Vector3(0.0, -0.24, 0.0))
\tprint("[MEASURE] NOCK GLOBAL: ", nock_g)
\tprint("[MEASURE] HAND GLOBAL: ", hand_g)
\tprint("[MEASURE] OFFSET (NOCK - HAND): ", nock_g - hand_g)
"""

old_block = """\tswitch_monster("archer")
\tcurrent_monster_node.play_anim("idle")"""

text = text.replace(old_block, snippet + old_block)
with open(viewer_gd, "w", encoding="utf-8") as f:
    f.write(text)
print("[OK] Added measurement snippet.")
