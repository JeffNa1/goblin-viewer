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
	ogre.set_process(false) # Control stepping manually so frames are exact!
	
	print("--- CAPTURING EXACT OGRE POSES ---")
	
	# 1. STAGGER (Quỳ Gối authentic deep kneel)
	print("Capturing Stagger Deep Kneel (Front & Side)...")
	ogre.play_anim("stagger")
	for f in range(55): # tau ~ 0.53 (deep kneel panting with crutch)
		ogre._process(0.016)
		await process_frame
		
	await _snap_camera(32.0, -4.0, 3.8, Vector3(0.0, 0.65, 0.0), "ogre_stagger_kneel_front.png")
	await _snap_camera(-62.0, -4.0, 3.8, Vector3(0.0, 0.65, 0.0), "ogre_stagger_kneel_side.png")
	await _snap_camera(90.0, -4.0, 3.8, Vector3(0.0, 0.65, 0.0), "ogre_stagger_kneel_right_side.png")
	
	print(">>> EXACT OGRE CAPTURES COMPLETED! <<<")
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
