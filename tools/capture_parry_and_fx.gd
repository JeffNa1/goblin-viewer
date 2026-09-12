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
	
	print("========================================")
	print("--- CAPTURING PARRY & UPGRADED VFX ---")
	print("========================================")
	
	# ----------------------------------------------------
	# 1. PARRY REACTION ANIMATION
	# ----------------------------------------------------
	print("1. Capturing Parry Deflection Clash...")
	ogre.play_anim("stagger")
	for f in range(7): # t ~ 0.11s (Phase 1 clash & violent recoil)
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	await _snap_camera(28.0, -6.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_parry_deflect.png")
	
	print("2. Capturing Parry Backward Stumble...")
	for f in range(18): # t ~ 0.40s (Phase 2 heavy backward stumble Z = -0.22m)
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	await _snap_camera(-48.0, -6.0, 4.4, Vector3(0.0, 0.70, -0.1), "ogre_parry_stumble.png")
	await _snap_camera(85.0, -5.0, 4.4, Vector3(0.0, 0.70, -0.1), "ogre_parry_stumble_side.png")
	
	# ----------------------------------------------------
	# 2. EARTHSHAKER CATACLYSMIC GROUND IMPACT
	# ----------------------------------------------------
	print("3. Capturing Earthshaker Triple Shockwave & Crater Spikes...")
	ogre.play_anim("earthshaker")
	# Advance 60 frames to tau = 0.48 (t = 0.96s -> impact triggers)
	for f in range(60):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	# Advance 9 frames into impact (t ~ 0.144s after impact: rings expand, crater spikes erupt, debris flies)
	for f in range(9):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	await _snap_camera(36.0, -15.0, 4.6, Vector3(0.1, 0.55, 0.1), "ogre_earthshaker_mega_vfx.png")
	await _snap_camera(-38.0, -14.0, 4.6, Vector3(0.1, 0.55, 0.1), "ogre_earthshaker_mega_side.png")
	
	# ----------------------------------------------------
	# 3. WHIRLWIND INTIMIDATING 3-TIER TORNADO STORM
	# ----------------------------------------------------
	print("4. Capturing Whirlwind 3-Tier Vortex & Tornado Debris...")
	ogre.play_anim("whirlwind")
	for f in range(45):
		ogre._process(0.016)
		if ogre.weapon_trail: ogre.weapon_trail._process(0.016)
		await process_frame
		
	await _snap_camera(28.0, -12.0, 4.4, Vector3(0.0, 0.75, 0.0), "ogre_whirlwind_tornado_vfx.png")
	await _snap_camera(-65.0, -10.0, 4.5, Vector3(0.0, 0.75, 0.0), "ogre_whirlwind_tornado_side.png")
	
	print("========================================")
	print(">>> ALL PARRY & VFX CAPTURES SAVED! <<<")
	print("========================================")
	quit(0)

func _snap_camera(yaw: float, pitch: float, dist: float, pivot_pos: Vector3, fn: String) -> void:
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
