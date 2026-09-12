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
	print("--- CAPTURING OVERHAULED OGRE ROAR ---")
	print("========================================")
	
	ogre.play_anim("roar")
	
	# Phase 1: Inhale & Windup (t ~ 0.38s -> 24 frames of 0.016s)
	print("1. Capturing Roar Phase 1: Inhale & Hoist...")
	for f in range(24):
		ogre._process(0.016)
		await process_frame
	await _snap_camera(28.0, -8.0, 4.4, Vector3(0.0, 0.75, 0.0), "ogre_roar_inhale.png")
	
	# Phase 2: Skyward Bellow & War Totem (t ~ 0.95s -> 36 more frames)
	print("2. Capturing Roar Phase 2: Skyward Bellow & War Totem...")
	for f in range(36):
		ogre._process(0.016)
		await process_frame
	await _snap_camera(32.0, -10.0, 4.6, Vector3(0.0, 0.85, 0.0), "ogre_roar_bellow.png")
	await _snap_camera(-55.0, -8.0, 4.6, Vector3(0.0, 0.85, 0.0), "ogre_roar_bellow_side.png")
	
	# Phase 3: Heavy Exhale & Gravitational Hammer Descent (t ~ 1.55s -> 37 more frames)
	print("3. Capturing Roar Phase 3: Heavy Exhale & Hammer Descent...")
	for f in range(37):
		ogre._process(0.016)
		await process_frame
	await _snap_camera(25.0, -6.0, 4.4, Vector3(0.0, 0.75, 0.0), "ogre_roar_exhale.png")
	
	# Phase 4: Seamless Stance Settle (t ~ 2.02s -> 29 more frames)
	print("4. Capturing Roar Phase 4: Seamless Settle...")
	for f in range(29):
		ogre._process(0.016)
		await process_frame
	await _snap_camera(25.0, -6.0, 4.4, Vector3(0.0, 0.75, 0.0), "ogre_roar_settle.png")
	
	print("========================================")
	print(">>> ALL ROAR CAPTURES SAVED! <<<")
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
