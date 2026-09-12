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
	
	# Hide UI for clean renders
	var ui = viewer.get_node_or_null("UI")
	if ui: ui.visible = false
	if viewer.editor_panel: viewer.editor_panel.visible = false
	
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	print("--- CAPTURING ALL OGRE ANIMATION SCREENSHOTS ---")
	
	# 1. Low angle ground contact verification (Feet on floor)
	viewer.m_chieftain.play_anim("shoulder")
	viewer.yaw = 25.0
	viewer.pitch = 5.0 # Low angle looking slightly up from ground level
	viewer.camera_distance = 2.4
	viewer.camera_pivot.position = Vector3(0.0, 0.25, 0.0) # Aim right at feet
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 20)
	_take_screenshot("ogre_ground_contact_feet.png")
	
	# 2. Shoulder Stance (Full body)
	viewer.m_chieftain.play_anim("shoulder")
	viewer.yaw = 28.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 20)
	_take_screenshot("ogre_shoulder_stance.png")
	
	# 3. Ground Stance (Resting on mace)
	viewer.m_chieftain.set_stance("ground")
	viewer.yaw = 22.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.0
	viewer.camera_pivot.position = Vector3(0.1, 0.85, 0.0)
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 25)
	_take_screenshot("ogre_ground_stance.png")
	
	# 4. Guard Stance (Low combat crouch)
	viewer.m_chieftain.set_stance("guard")
	viewer.yaw = 32.0
	viewer.pitch = -5.0
	viewer.camera_distance = 3.8
	viewer.camera_pivot.position = Vector3(0.0, 0.80, 0.0)
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 25)
	_take_screenshot("ogre_guard_stance.png")
	
	# 5. Walk Stride Plant (Lumbering stride)
	viewer.m_chieftain.play_anim("walk")
	viewer.yaw = 45.0
	viewer.pitch = -4.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 30)
	_take_screenshot("ogre_walk_stride.png")
	
	# 6. Cleave (Wide horizontal sweep arc - dynamic front-facing angle)
	viewer.m_chieftain.play_anim("cleave")
	viewer.yaw = -135.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.2
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.65).timeout
	_take_screenshot("ogre_cleave_sweep.png")
	
	# 7. Roar - Phase 1: Chest Pound (Check zero chest clipping)
	viewer.m_chieftain.play_anim("roar")
	viewer.yaw = 25.0
	viewer.pitch = -4.0
	viewer.camera_distance = 3.6
	viewer.camera_pivot.position = Vector3(0.0, 0.95, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.50).timeout
	_take_screenshot("ogre_roar_chest_pound.png")
	
	# 8. Roar - Phase 2: Skyward Bellow (War cry with skyward mace)
	viewer.camera_distance = 5.2
	viewer.camera_pivot.position = Vector3(0.0, 1.25, 0.0)
	viewer._update_camera_transform()
	await create_timer(0.45).timeout
	_take_screenshot("ogre_roar_bellow.png")
	
	# 9. Earthshaker (Crater slam impact)
	viewer.m_chieftain.play_anim("earthshaker")
	viewer.yaw = 38.0
	viewer.pitch = -8.0
	viewer.camera_distance = 4.3
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.2)
	viewer._update_camera_transform()
	# Step into impact hit-stop phase (approx 1.1s in)
	for f in range(68):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.2).timeout
	_take_screenshot("ogre_earthshaker_impact.png")
	
	# 10. Earthshaker (Smooth recovery, zero hitch)
	for f in range(35):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.2).timeout
	_take_screenshot("ogre_earthshaker_recovery.png")
	
	# 11. Whirlwind (Continuous 360 centrifugal spin)
	viewer.m_chieftain.play_anim("whirlwind")
	viewer.yaw = 15.0
	viewer.pitch = -6.0
	viewer.camera_distance = 4.5
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	for f in range(46):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.2).timeout
	_take_screenshot("ogre_whirlwind_sweep.png")
	
	# 12. Stagger (Heavy recoil brace)
	viewer.m_chieftain.play_anim("stagger")
	viewer.yaw = 30.0
	viewer.pitch = -5.0
	viewer.camera_distance = 4.0
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.0)
	viewer._update_camera_transform()
	for f in range(44):
		viewer.m_chieftain._process(0.016)
		await process_frame
	await create_timer(0.2).timeout
	_take_screenshot("ogre_stagger_brace.png")
	
	# 13. Stunned (Woozy drunken daze, mace safely near knee away from face)
	viewer.m_chieftain.play_anim("stunned")
	viewer.yaw = 22.0
	viewer.pitch = -3.0
	viewer.camera_distance = 3.9
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await _simulate_anim(viewer.m_chieftain, 25)
	_take_screenshot("ogre_stunned_daze.png")
	
	print(">>> ALL OGRE ANIMATION SCREENSHOTS CAPTURED SUCCESSFULLY! <<<")
	quit(0)

func _simulate_anim(ogre: GoblinChieftain, frames: int) -> void:
	for f in range(frames):
		ogre._process(0.016)
		await process_frame
	await create_timer(0.2).timeout

func _take_screenshot(filename: String) -> void:
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = out_dir + "/" + filename
		var err = img.save_png(path)
		if err == OK:
			print("  [SAVED] %s" % filename)
		else:
			printerr("  [ERROR] Failed to save %s: %d" % [filename, err])
