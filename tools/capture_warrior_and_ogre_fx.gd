extends SceneTree

var out_dir = "C:/Users/Administrator/.gemini/antigravity/brain/75728a4d-fc04-43bb-a8c4-d7f4280ff39e"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	var ui = viewer.get_node_or_null("UI")
	if ui: ui.visible = false
	if viewer.editor_panel: viewer.editor_panel.visible = false
	
	# ----------------------------------------------------
	# 1. WARRIOR GOBLIN ORIGINAL IMPACT
	# ----------------------------------------------------
	print("--- CAPTURING WARRIOR GOBLIN ORIGINAL EFFECT ---")
	viewer.switch_monster("warrior")
	await process_frame
	await process_frame
	
	var warrior = viewer.m_goblin
	warrior.set_process(false)
	if warrior.weapon_trail: warrior.weapon_trail.set_process(false)
	
	warrior.play_anim("smash")
	# Advance into smash impact: tau = 0.50 (t = 0.65s) -> 41 frames
	for f in range(41):
		warrior._process(0.016)
		if warrior.weapon_trail: warrior.weapon_trail._process(0.016)
		await process_frame
		
	# Advance 5 frames into shockwave expansion
	for f in range(5):
		warrior._process(0.016)
		if warrior.weapon_trail: warrior.weapon_trail._process(0.016)
		await process_frame
		
	await _snap(viewer, 35.0, -12.0, 2.5, Vector3(0.0, 0.45, 0.2), "warrior_original_smash_fx.png")
	
	# ----------------------------------------------------
	# 2. MACE OGRE MASSIVE IMPACT
	# ----------------------------------------------------
	print("--- CAPTURING MACE OGRE MASSIVE EFFECT ---")
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	var ogre = viewer.m_chieftain
	ogre.set_process(false)
	if ogre.weapon_trail: ogre.weapon_trail.set_process(false)
	
	ogre.play_anim("earthshaker")
	# Advance into earthshaker impact: tau = 0.48 (t = 0.96s) -> 60 frames
	for f in range(60):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	# Advance 8 frames into impact (shockwaves + crater spikes + flying debris)
	for f in range(8):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	await _snap(viewer, 35.0, -12.0, 4.2, Vector3(0.0, 0.75, 0.3), "ogre_retained_earthshaker_fx.png")
	
	print(">>> CAPTURES SAVED! <<<")
	quit(0)

func _snap(viewer: Node, yaw: float, pitch: float, dist: float, pivot_pos: Vector3, fn: String) -> void:
	viewer.yaw = yaw
	viewer.pitch = pitch
	viewer.camera_distance = dist
	viewer.camera_pivot.position = pivot_pos
	viewer._update_camera_transform()
	await process_frame
	await process_frame
	var img = root.get_viewport().get_texture().get_image()
	if img:
		img.save_png(out_dir + "/" + fn)
		print("  [SAVED] %s" % fn)
