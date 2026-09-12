extends SceneTree

var viewer: Node = null
var current_monster: Node3D = null

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)

	# Completely hide all default UI for 100% clean in-engine capture
	var default_ui = viewer.get_node_or_null("UI")
	if default_ui:
		default_ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false

	# Push forest mesh back to ensure zero tree occlusion
	if viewer.forest:
		viewer.forest.position = Vector3(0.0, 0.0, -1.0)

	await process_frame
	await process_frame

	print(">>> STARTING 100% CLEAN FOOTAGE RECORDING FOR REMOTION OVERLAY <<<")

	# ==========================================
	# 1. GOBLIN WARRIOR (Total: 240 frames = 8.0s)
	# ==========================================
	viewer.switch_monster("warrior")
	current_monster = viewer.m_warrior
	viewer.pitch = -5.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)

	# 1A. Outfit 1 (Thô Sơ / Primitive): Idle (60f) & Walk (60f)
	viewer._select_outfit(1)
	current_monster.play_anim("idle")
	await _run_camera_frames(60, 20.0, 4.0, 0.0)
	current_monster.play_anim("walk")
	await _run_camera_frames(60, 28.0, 5.0, 0.0)

	# 1B. Outfit 2 (Chiến Binh Thép / Ironclad): Idle (30f) & Smash Attack (90f)
	viewer._select_outfit(2)
	current_monster.play_anim("idle")
	await _run_camera_frames(30, 22.0, 3.0, 0.0)
	current_monster.play_anim("smash")
	await _run_camera_frames(90, 24.0, 4.0, 0.0)

	# ==========================================
	# 2. GOBLIN ARCHER (Total: 300 frames = 10.0s)
	# ==========================================
	viewer.switch_monster("archer")
	current_monster = viewer.m_archer
	viewer.pitch = -5.0
	viewer.camera_distance = 3.2
	viewer.camera_pivot.position = Vector3(0.0, 0.65, 0.0)

	# 2A. Outfit 1 (Thô Sơ / Primitive Hunter): Idle (60f) & Walk (60f)
	viewer._select_outfit(1)
	current_monster.play_anim("idle")
	await _run_camera_frames(60, 20.0, 4.0, 0.0)
	current_monster.play_anim("walk")
	await _run_camera_frames(60, 28.0, 5.0, 0.0)

	# 2B. Outfit 2 (Ranger / Kiểm Lâm): Giương cung ngắm bắn (Aim: 75f) -> Bắn tên (Shoot: 45f) -> Bắn tiếp (Shoot: 60f)
	viewer._select_outfit(2)
	current_monster.play_anim("aim") # Giương cung ngắm bắn!
	await _run_camera_frames(75, 34.0, 3.0, 0.0)
	current_monster.play_anim("shoot") # Bắn tên với recoil!
	await _run_camera_frames(45, 34.0, 2.0, 0.0)
	current_monster.play_anim("shoot") # Bắn tiếp phát nữa!
	await _run_camera_frames(60, 34.0, 2.0, 0.0)

	# ==========================================
	# 3. GOBLIN SHAMAN (Total: 300 frames = 10.0s)
	# ==========================================
	viewer.switch_monster("shaman")
	current_monster = viewer.m_shaman
	viewer.pitch = -5.0
	viewer.camera_distance = 3.3
	viewer.camera_pivot.position = Vector3(0.0, 0.70, 0.0)

	# 3A. Outfit 1 (Thô Sơ / Witch Doctor): Idle (60f) & Walk (60f)
	viewer._select_outfit(1)
	current_monster.play_anim("idle")
	await _run_camera_frames(60, 18.0, 4.0, 0.0)
	current_monster.play_anim("walk")
	await _run_camera_frames(60, 26.0, 4.0, 0.0)

	# 3B. Outfit 2 (Arch-Shaman with 3D Cloak): Idle (45f) -> Chant (75f) -> Summon (60f)
	viewer._select_outfit(2)
	current_monster.play_anim("idle")
	await _run_camera_frames(45, -15.0, 3.0, 0.0)
	current_monster.play_anim("chant")
	await _run_camera_frames(75, -20.0, 4.0, 0.0)
	current_monster.play_anim("summon")
	await _run_camera_frames(60, 16.0, 3.0, 0.0)

	# ==========================================
	# 4. GOBLIN ROGUE (Total: 300 frames = 10.0s)
	# ==========================================
	viewer.switch_monster("rogue")
	current_monster = viewer.m_rogue
	viewer.pitch = -5.0
	viewer.camera_distance = 3.0
	viewer.camera_pivot.position = Vector3(0.0, 0.60, 0.0)

	# 4A. Outfit 1 (Thô Sơ / Scavenger): Idle (60f) & Walk (60f)
	viewer._select_outfit(1)
	current_monster.play_anim("idle")
	await _run_camera_frames(60, 22.0, 4.0, 0.0)
	current_monster.play_anim("walk")
	await _run_camera_frames(60, 28.0, 4.0, 0.0)

	# 4B. Outfit 2 (Sát Thủ / Shadow Assassin): Idle (45f) -> Dual Slash (75f) -> Scurry (60f)
	viewer._select_outfit(2)
	current_monster.play_anim("idle")
	await _run_camera_frames(45, 24.0, 3.0, 0.0)
	current_monster.play_anim("dual_slash")
	await _run_camera_frames(75, 30.0, 5.0, 0.0)
	current_monster.play_anim("scurry")
	await _run_camera_frames(60, 22.0, 4.0, 0.0)

	# ==========================================
	# 5. MACE OGRE (ONLY IDLE + MOVEMENT, NO ROAR, NO EARTHSHAKER) (Total: 300 frames = 10.0s)
	# ==========================================
	viewer.switch_monster("chieftain")
	current_monster = viewer.m_chieftain
	viewer.pitch = -6.0
	viewer.camera_distance = 4.8
	viewer.camera_pivot.position = Vector3(0.0, 1.15, 0.0)

	# 5A. 360° Turntable Idle: Colossal Muscular Frame, 16-Flanged Mace (150f = 5s)
	current_monster.play_anim("idle")
	await _run_camera_frames(150, 20.0, 3.0, 360.0 / 150.0)

	current_monster.rotation.y = 0.0 # Face forward

	# 5B. Di Chuyển / Movement Walk Cycle (150f = 5s)
	current_monster.play_anim("walk")
	await _run_camera_frames(150, 26.0, 5.0, 0.0)

	print(">>> ALL CLEAN FOOTAGE RECORDED SUCCESSFULLY! Total frames: 1440 <<<")
	quit(0)

func _run_camera_frames(frame_count: int, base_yaw: float, sway_amplitude: float, monster_rot_speed: float) -> void:
	for i in range(frame_count):
		var sway = sin(float(i) * 0.06) * sway_amplitude
		viewer.yaw = base_yaw + sway
		viewer._update_camera_transform()

		if current_monster and monster_rot_speed != 0.0:
			current_monster.rotation_degrees.y += monster_rot_speed

		await process_frame
