extends SceneTree

var viewer: Node = null
var brain_dir: String = "C:/Users/Administrator/.gemini/antigravity/brain/b2d85561-9ef2-45aa-9eaa-fb4af7421d21"
var desktop_dir: String = "C:/Users/Administrator/Desktop/Rogue_Screenshots"

func _init() -> void:
	call_deferred("_start")

func _start() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	await process_frame
	await process_frame
	
	var ui = viewer.get_node_or_null("UI")
	if ui:
		ui.visible = false
	if viewer.editor_panel:
		viewer.editor_panel.visible = false
		
	viewer.switch_monster("rogue")
	var rogue = viewer.m_rogue
	
	DirAccess.make_dir_recursive_absolute(desktop_dir)
	
	# Set well-framed camera
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.15)
	viewer.camera_distance = 3.1
	viewer.pitch = -5.0
	viewer.yaw = 28.0
	viewer._update_camera_transform()
	
	await create_timer(0.2).timeout
	
	# -------------------------------------------------------------
	# 1. STAGE 1 START: STALKING CROUCH (action_time ~ 0.08s)
	# -------------------------------------------------------------
	print("Capturing 1: Stage 1 Stalking Crouch...")
	rogue.set_outfit(1)
	viewer.yaw = 28.0
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.08:
		await process_frame
	_save_screen("rogue_backstab_trans_start.png")
	
	# -------------------------------------------------------------
	# 2. STAGE 1 FLIP MIDPOINT: ZERO CLIPPING LATERAL ROLL (action_time ~ 0.26s)
	# -------------------------------------------------------------
	print("Capturing 2: Stage 1 Dagger Flip Midpoint (Isometric)...")
	rogue.play_anim("backstab")
	while rogue.action_time < 0.26:
		await process_frame
	_save_screen("rogue_backstab_trans_flip_mid.png")
	
	# -------------------------------------------------------------
	# 3. STAGE 1 FLIP MIDPOINT: SIDE PROFILE (action_time ~ 0.26s)
	# Shows wide space between blade and forearm
	# -------------------------------------------------------------
	print("Capturing 3: Stage 1 Dagger Flip Midpoint (Side Profile)...")
	viewer.yaw = 88.0
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.26:
		await process_frame
	_save_screen("rogue_backstab_trans_flip_mid_side.png")
	
	# -------------------------------------------------------------
	# 4. STAGE 1 COMPLETE: FORWARD GRIP LOCKED (action_time ~ 0.44s)
	# -------------------------------------------------------------
	print("Capturing 4: Stage 1 Flip Locked & Cocked...")
	viewer.yaw = 32.0
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.44:
		await process_frame
	_save_screen("rogue_backstab_trans_grip_locked.png")
	
	# -------------------------------------------------------------
	# 5. STAGE 2: EXPLOSIVE LUNGE & FORWARD IMPALE WITH BLOOD TRAILS (action_time ~ 0.65s)
	# -------------------------------------------------------------
	print("Capturing 5: Stage 2 Full Lunge Impale...")
	viewer.yaw = 32.0
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.25)
	viewer.camera_distance = 3.3
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.65:
		await process_frame
	_save_screen("rogue_backstab_trans_impale.png")
	
	# -------------------------------------------------------------
	# 6. STAGE 3: INTERNAL TWIST & LATERAL TEAR (action_time ~ 1.02s)
	# -------------------------------------------------------------
	print("Capturing 6: Stage 3 Wound Twist & Lateral Tear...")
	rogue.play_anim("backstab")
	while rogue.action_time < 1.02:
		await process_frame
	_save_screen("rogue_backstab_trans_twist_tear.png")
	
	# -------------------------------------------------------------
	# 7. STAGE 4: RECOVERY EXTRACTION & FLIP BACK (action_time ~ 1.38s)
	# -------------------------------------------------------------
	print("Capturing 7: Stage 4 Recovery Outward Dagger Flip...")
	viewer.yaw = 28.0
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.15)
	viewer.camera_distance = 3.1
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 1.38:
		await process_frame
	_save_screen("rogue_backstab_trans_flip_recovery.png")
	
	# -------------------------------------------------------------
	# 8. OUTFIT 2 (SHADOW ASSASSIN): FLIP MIDPOINT (action_time ~ 0.26s)
	# -------------------------------------------------------------
	print("Capturing 8: Outfit 2 Flip Midpoint...")
	viewer._select_outfit(2)
	viewer.yaw = 32.0
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.26:
		await process_frame
	_save_screen("rogue_outfit2_flip_mid.png")
	
	# -------------------------------------------------------------
	# 9. OUTFIT 2 (SHADOW ASSASSIN): FORWARD IMPALE (action_time ~ 0.65s)
	# -------------------------------------------------------------
	print("Capturing 9: Outfit 2 Forward Impale...")
	viewer.camera_pivot.position = Vector3(0.0, 0.55, 0.25)
	viewer.camera_distance = 3.3
	viewer._update_camera_transform()
	rogue.play_anim("backstab")
	while rogue.action_time < 0.65:
		await process_frame
	_save_screen("rogue_outfit2_impale.png")
	
	print(">>> ALL ROGUE TRANSITION LIVE ANIMATION SCREENSHOTS CAPTURED! <<<")
	quit(0)

func _save_screen(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var p1 = brain_dir + "/" + filename
		var e1 = img.save_png(p1)
		var p2 = desktop_dir + "/" + filename
		var e2 = img.save_png(p2)
		print("Saved %s (brain: %d, desk: %d)" % [filename, e1, e2])
	else:
		printerr("Failed to capture: %s" % filename)
