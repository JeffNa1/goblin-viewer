extends SceneTree

var viewer: Node = null
var overlay_layer: CanvasLayer = null
var lbl_monster_name: Label = null
var lbl_anim_name: Label = null
var lbl_info: Label = null
var badge_rect: ColorRect = null

var target_yaw: float = 24.0
var target_pitch: float = -5.0
var target_dist: float = 3.3
var target_pivot: Vector3 = Vector3(0.0, 0.65, 0.0)

var current_monster: Node3D = null

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)

	# Hide default debug / editor UI
	var default_ui = viewer.get_node_or_null("UI")
	if default_ui:
		default_ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false

	# Push forest slightly back and ensure clearing is 100% open
	if viewer.forest:
		viewer.forest.position = Vector3(0.0, 0.0, -1.0)

	_setup_showcase_overlay()

	# Wait for scene initialization
	await process_frame
	await process_frame

	print(">>> STARTING 100% UNOBSTRUCTED 3D VOXEL SHOWCASE RECORDING <<<")

	# ==========================================
	# INTRO TITLE CARD (2.5s = 75 frames)
	# ==========================================
	_set_overlay_text("✦ VOXEL MONSTER BESTIARY ✦", "CHRONICLES OF THE GOBLIN HORDE", "Real-Time 3D Procedural Voxel Characters & Skeletal Animations • Godot 4", Color(1.0, 0.75, 0.2))
	viewer.switch_monster("warrior")
	current_monster = viewer.m_warrior
	current_monster.play_anim("idle")
	target_yaw = 20.0
	target_pitch = -4.0
	target_dist = 3.8
	target_pivot = Vector3(0.0, 0.65, 0.0)
	await _run_frames(75, 20.0, 0.0, 0.0)

	# ==========================================
	# 1. GOBLIN WARRIOR (Melee Bruiser)
	# ==========================================
	viewer.switch_monster("warrior")
	current_monster = viewer.m_warrior
	current_monster.rotation.y = 0.0
	target_dist = 3.2
	target_pitch = -5.0
	target_pivot = Vector3(0.0, 0.65, 0.0)

	# 1.1 Turntable 360° Idle (90 frames = 3s)
	_set_overlay_text("GOBLIN WARRIOR", "▶ 360° Inspection: Combat Idle", "Role: Frontline Vanguard • Weapon: Spiked Heavy War-Club", Color(0.95, 0.55, 0.2))
	current_monster.play_anim("idle")
	await _run_frames(90, 22.0, 4.0, 360.0 / 90.0) # Monster spins 360° cleanly!

	current_monster.rotation.y = 0.0 # Face forward

	# 1.2 Marching Walk Cycle (75 frames = 2.5s)
	_set_overlay_text("GOBLIN WARRIOR", "▶ Animation: Marching Walk Cycle", "Procedural Bone Inverse Kinematics • 100% Rigid Voxel Weighting", Color(0.95, 0.55, 0.2))
	current_monster.play_anim("walk")
	await _run_frames(75, 28.0, 6.0, 0.0)

	# 1.3 Skullcrusher Smash (85 frames = ~2.8s)
	_set_overlay_text("GOBLIN WARRIOR", "▶ Action: Skullcrusher Smash!", "Devastating Two-Handed Overhand Slam", Color(1.0, 0.3, 0.2))
	current_monster.play_anim("smash")
	await _run_frames(85, 20.0, 4.0, 0.0)

	# ==========================================
	# 2. GOBLIN ARCHER (Needle Eye Sniper)
	# ==========================================
	viewer.switch_monster("archer")
	viewer._select_outfit(2) # Ranger Outfit
	current_monster = viewer.m_archer
	current_monster.rotation.y = 0.0
	target_dist = 3.2
	target_pitch = -5.0
	target_pivot = Vector3(0.0, 0.65, 0.0)

	# 2.1 Turntable 360° Idle (90 frames = 3s)
	_set_overlay_text("GOBLIN ARCHER", "▶ 360° Inspection: Ranger Scout Idle", "Role: Canopy Sniper • Gear: Curved Yew Bow & Barbed Quiver", Color(0.3, 0.9, 0.45))
	current_monster.play_anim("idle")
	await _run_frames(90, 22.0, 4.0, 360.0 / 90.0)

	current_monster.rotation.y = 0.0

	# 2.2 Aim & Shoot (85 frames = ~2.8s)
	_set_overlay_text("GOBLIN ARCHER", "▶ Action: Piercing Snipe", "Full String Draw, Target Lock & Recoil Release", Color(0.3, 0.9, 0.45))
	current_monster.play_anim("aim_shoot")
	await _run_frames(85, 32.0, 5.0, 0.0)

	# 2.3 Triple Volley Suppression (80 frames = ~2.7s)
	_set_overlay_text("GOBLIN ARCHER", "▶ Action: Triple Volley Attack", "Rapid Sequential Suppression Arrows", Color(0.4, 1.0, 0.6))
	current_monster.play_anim("triple_shot")
	await _run_frames(80, 25.0, 4.0, 0.0)

	# ==========================================
	# 3. GOBLIN SHAMAN (Void Caller Arch-Mage)
	# ==========================================
	viewer.switch_monster("shaman")
	viewer._select_outfit(2) # Arch-Shaman with 3D Billowing Cloak
	current_monster = viewer.m_shaman
	current_monster.rotation.y = 0.0
	target_dist = 3.3
	target_pitch = -5.0
	target_pivot = Vector3(0.0, 0.70, 0.0)

	# 3.1 Turntable 360° Idle (90 frames = 3s)
	_set_overlay_text("GOBLIN SHAMAN", "▶ 360° Inspection: Arch-Mage Idle", "Gear: Billowing 3D Shamanic Cloak & Ritual Antler Staff", Color(0.7, 0.45, 1.0))
	current_monster.play_anim("idle")
	await _run_frames(90, 20.0, 5.0, 360.0 / 90.0)

	current_monster.rotation.y = 0.0

	# 3.2 Ritual Incantation Chant (85 frames = ~2.8s)
	_set_overlay_text("GOBLIN SHAMAN", "▶ Action: Bloodcurse Chant", "Swaying Channeling of Primal Ancestral Void Spirits", Color(0.8, 0.5, 1.0))
	current_monster.play_anim("chant")
	await _run_frames(85, -15.0, 6.0, 0.0)

	# 3.3 Summon Totem (80 frames = ~2.7s)
	_set_overlay_text("GOBLIN SHAMAN", "▶ Action: Totem Summoning Gesture", "Staves Ground Slam to Invoke Spirit Pillars", Color(0.4, 0.85, 1.0))
	current_monster.play_anim("summon")
	await _run_frames(80, 18.0, 4.0, 0.0)

	# ==========================================
	# 4. GOBLIN ROGUE (Shadow Assassin)
	# ==========================================
	viewer.switch_monster("rogue")
	viewer._select_outfit(2)
	current_monster = viewer.m_rogue
	current_monster.rotation.y = 0.0
	target_dist = 3.0
	target_pitch = -5.0
	target_pivot = Vector3(0.0, 0.60, 0.0)

	# 4.1 Turntable 360° Idle (90 frames = 3s)
	_set_overlay_text("GOBLIN ROGUE", "▶ 360° Inspection: Low Infiltrator Idle", "Role: Shadow Infiltrator • Weapon: Dual Obsidian Daggers", Color(0.25, 0.8, 0.95))
	current_monster.play_anim("idle")
	await _run_frames(90, 24.0, 4.0, 360.0 / 90.0)

	current_monster.rotation.y = 0.0

	# 4.2 Dual Slash X-Combo (85 frames = ~2.8s)
	_set_overlay_text("GOBLIN ROGUE", "▶ Action: Dual Slash X-Combo", "Cross-Cutting Fatal Double Strike", Color(0.25, 0.8, 0.95))
	current_monster.play_anim("dual_slash")
	await _run_frames(85, 28.0, 5.0, 0.0)

	# 4.3 Scurry Sprint (80 frames = ~2.7s)
	_set_overlay_text("GOBLIN ROGUE", "▶ Action: Low-Profile Scurry Sprint", "Acrobatic Shadow Dash Evasion", Color(0.3, 0.9, 1.0))
	current_monster.play_anim("scurry")
	await _run_frames(80, 22.0, 4.0, 0.0)

	# ==========================================
	# 5. MACE OGRE (WORLD BOSS TITAN - NEW MODEL)
	# ==========================================
	viewer.switch_monster("chieftain")
	current_monster = viewer.m_chieftain
	current_monster.rotation.y = 0.0
	target_dist = 4.8
	target_pitch = -6.0
	target_pivot = Vector3(0.0, 1.15, 0.0)

	# 5.1 Full 360° Inspection (120 frames = 4.0s)
	_set_overlay_text("MACE OGRE [WORLD BOSS]", "▶ 360° Full Inspection: Colossal Titan", "51,468 Voxels • Muscular Anatomy • 16-Flanged Spiked Mace (100% Clean, No Checkerboard)", Color(1.0, 0.25, 0.25))
	current_monster.play_anim("idle")
	await _run_frames(120, 20.0, 4.0, 360.0 / 120.0) # Full 360 turntable of the new Ogre!

	current_monster.rotation.y = 0.0

	# 5.2 Heavy Titan Walk (80 frames = ~2.7s)
	_set_overlay_text("MACE OGRE [WORLD BOSS]", "▶ Animation: Heavy Stomp Walk Cycle", "Ground-Quaking Stomp of the Primal Colossus", Color(1.0, 0.35, 0.25))
	current_monster.play_anim("walk")
	await _run_frames(80, 26.0, 5.0, 0.0)

	# 5.3 War Roar (85 frames = ~2.8s)
	_set_overlay_text("MACE OGRE [WORLD BOSS]", "▶ Action: Primal Battle Roar", "Chest Puffed, Brandishing Colossal Warhammer to the Sky", Color(1.0, 0.5, 0.2))
	current_monster.play_anim("roar")
	await _run_frames(85, 18.0, 4.0, 0.0)

	# 5.4 Cataclysmic Earthshaker (110 frames = ~3.7s)
	target_dist = 5.4
	target_pivot = Vector3(0.0, 1.40, 0.0)
	_set_overlay_text("MACE OGRE [WORLD BOSS]", "▶ Action: Cataclysmic Earthshaker!", "Leaping Two-Handed Heavy Mace Crash Into the Earth", Color(1.0, 0.15, 0.15))
	current_monster.play_anim("earthshaker")
	await _run_frames(110, 24.0, 3.0, 0.0)

	# ==========================================
	# OUTRO OVERVIEW (2.5s = 75 frames)
	# ==========================================
	target_dist = 6.2
	target_pivot = Vector3(0.0, 0.9, 0.0)
	_set_overlay_text("✦ GODOT 4 VOXEL SHOWCASE ✦", "All 5 Characters Rigged & Animated", "Procedural Voxel Pipeline • Pure In-Engine Video Capture", Color(1.0, 0.8, 0.2))
	await _run_frames(75, 20.0, 2.0, 0.0)

	print(">>> UNOBSTRUCTED SHOWCASE RECORDING COMPLETED SUCCESSFULLY! <<<")
	quit(0)

func _run_frames(frame_count: int, base_yaw: float, sway_amplitude: float, monster_rot_speed: float) -> void:
	for i in range(frame_count):
		# Camera stays in safe front arc, gently swaying for natural dynamic feel
		var sway = sin(float(i) * 0.05) * sway_amplitude
		viewer.yaw = base_yaw + sway
		viewer.pitch = lerpf(viewer.pitch, target_pitch, 0.08)
		viewer.camera_distance = lerpf(viewer.camera_distance, target_dist, 0.08)
		viewer.camera_pivot.position = viewer.camera_pivot.position.lerp(target_pivot, 0.08)
		viewer._update_camera_transform()

		# Rotate monster if turntable speed is given
		if current_monster and monster_rot_speed != 0.0:
			current_monster.rotation_degrees.y += monster_rot_speed

		await process_frame

func _set_overlay_text(m_name: String, anim_name: String, info: String, theme_col: Color) -> void:
	if lbl_monster_name:
		lbl_monster_name.text = m_name
		lbl_monster_name.modulate = theme_col
	if lbl_anim_name:
		lbl_anim_name.text = anim_name
	if lbl_info:
		lbl_info.text = info
	if badge_rect:
		badge_rect.color = theme_col

func _setup_showcase_overlay() -> void:
	overlay_layer = CanvasLayer.new()
	overlay_layer.name = "ShowcaseOverlay"
	root.add_child(overlay_layer)

	var root_ctrl = Control.new()
	root_ctrl.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(root_ctrl)

	# 1. Top Cinematic Bar (Height 55px)
	var top_bar = ColorRect.new()
	top_bar.color = Color(0.04, 0.05, 0.07, 0.92)
	top_bar.custom_minimum_size = Vector2(0, 55)
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	root_ctrl.add_child(top_bar)

	var top_hbox = HBoxContainer.new()
	top_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	top_hbox.offset_left = 30
	top_hbox.offset_right = -30
	top_bar.add_child(top_hbox)

	var lbl_top_left = Label.new()
	lbl_top_left.text = "✦ 3D VOXEL BESTIARY SHOWCASE ✦"
	lbl_top_left.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_top_left.add_theme_font_size_override("font_size", 16)
	lbl_top_left.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95))
	top_hbox.add_child(lbl_top_left)

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(spacer)

	var lbl_top_right = Label.new()
	lbl_top_right.text = "GODOT ENGINE 4.7 • PROCEDURAL SKELETAL RIGS"
	lbl_top_right.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_top_right.add_theme_font_size_override("font_size", 14)
	lbl_top_right.add_theme_color_override("font_color", Color(0.65, 0.75, 0.85))
	top_hbox.add_child(lbl_top_right)

	# 2. Bottom Cinematic Lower-Third Card (Height 90px)
	var bottom_bar = ColorRect.new()
	bottom_bar.color = Color(0.04, 0.05, 0.07, 0.94)
	bottom_bar.anchor_left = 0.0
	bottom_bar.anchor_right = 1.0
	bottom_bar.anchor_top = 1.0
	bottom_bar.anchor_bottom = 1.0
	bottom_bar.offset_top = -90
	bottom_bar.offset_bottom = 0
	root_ctrl.add_child(bottom_bar)

	badge_rect = ColorRect.new()
	badge_rect.color = Color(1.0, 0.6, 0.2)
	badge_rect.custom_minimum_size = Vector2(0, 4)
	badge_rect.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bottom_bar.add_child(badge_rect)

	var bottom_vbox = VBoxContainer.new()
	bottom_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	bottom_vbox.offset_left = 36
	bottom_vbox.offset_top = 10
	bottom_vbox.offset_right = -36
	bottom_vbox.offset_bottom = -10
	bottom_vbox.add_theme_constant_override("separation", 2)
	bottom_bar.add_child(bottom_vbox)

	var header_hbox = HBoxContainer.new()
	header_hbox.add_theme_constant_override("separation", 16)
	bottom_vbox.add_child(header_hbox)

	lbl_monster_name = Label.new()
	lbl_monster_name.text = "GOBLIN WARRIOR"
	lbl_monster_name.add_theme_font_size_override("font_size", 24)
	lbl_monster_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_hbox.add_child(lbl_monster_name)

	lbl_anim_name = Label.new()
	lbl_anim_name.text = "▶ Action: Skullcrusher Smash"
	lbl_anim_name.add_theme_font_size_override("font_size", 18)
	lbl_anim_name.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	lbl_anim_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_hbox.add_child(lbl_anim_name)

	lbl_info = Label.new()
	lbl_info.text = "Role: Frontline Bruiser • Weapon: Spiked War-Club"
	lbl_info.add_theme_font_size_override("font_size", 14)
	lbl_info.add_theme_color_override("font_color", Color(0.7, 0.78, 0.88))
	bottom_vbox.add_child(lbl_info)
