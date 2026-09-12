extends SceneTree

var viewer: Node = null
var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/ec0b555c-b953-40a9-a69a-c4d1848bb995"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	var ui = viewer.get_node_or_null("UI")
	if ui: ui.visible = false
	if viewer.editor_panel: viewer.editor_panel.visible = false
	
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	var ogre: GoblinChieftain = viewer.m_chieftain
	ogre.set_process(false)
	if ogre.weapon_trail:
		ogre.weapon_trail.set_process(false)
		
	print("--- CAPTURING ZERO-CLIPPING PARRY REACTION FRAMES ---")
	ogre.play_anim("stagger")
	
	# Frame 1: Phase 1 Deflection (t ~ 0.12s)
	for f in range(8):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
	await _snap_camera(35.0, -6.0, 3.8, Vector3(0.0, 0.85, 0.0), "ogre_parry_phase1_deflect.png")
	
	# Frame 2: Close-up on Head & Mace (t ~ 0.18s)
	for f in range(4):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
	await _snap_camera(45.0, 2.0, 2.3, Vector3(0.15, 0.95, -0.05), "ogre_parry_head_closeup.png")
	
	# Frame 3: Phase 2 Backward Stumble (t ~ 0.40s)
	for f in range(14):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
	await _snap_camera(-40.0, -6.0, 4.2, Vector3(0.0, 0.70, -0.1), "ogre_parry_phase2_stumble.png")
	await _snap_camera(85.0, -4.0, 4.2, Vector3(0.0, 0.70, -0.1), "ogre_parry_phase2_side.png")
	
	# Frame 4: Phase 3 Regaining Balance (t ~ 0.80s)
	for f in range(25):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
	await _snap_camera(28.0, -6.0, 3.8, Vector3(0.0, 0.80, -0.05), "ogre_parry_phase3_recovery.png")
	
	print("--- ALL PARRY FRAMES CAPTURED SUCCESSFULLY ---")
	quit(0)

func _snap_camera(yaw: float, pitch: float, dist: float, target: Vector3, filename: String) -> void:
	var cam: Camera3D = viewer.camera
	var pitch_rad = deg_to_rad(pitch)
	var yaw_rad = deg_to_rad(yaw)
	var offset = Vector3(
		dist * cos(pitch_rad) * sin(yaw_rad),
		dist * sin(-pitch_rad),
		dist * cos(pitch_rad) * cos(yaw_rad)
	)
	cam.global_position = target + offset
	cam.look_at(target, Vector3.UP)
	
	await process_frame
	await process_frame
	
	var img = root.get_viewport().get_texture().get_image()
	var path = out_dir + "/" + filename
	img.save_png(path)
	print("Saved snapshot: %s" % path)
