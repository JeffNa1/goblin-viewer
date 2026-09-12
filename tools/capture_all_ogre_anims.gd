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
	
	var ogre: GoblinChieftain = viewer.m_chieftain
	ogre.set_process(false) # Take explicit manual control for frame-perfect captures
	
	print("--- CAPTURING ALL OGRE ANIMATION SCREENSHOTS ---")
	
	# 1. Ground contact verification (Low angle looking at feet)
	_apply_anim_time(ogre, "shoulder", 0.5)
	await _snap_camera(25.0, 5.0, 2.4, Vector3(0.0, 0.25, 0.0), "ogre_ground_contact_feet.png")
	
	# 2. Shoulder Stance (Full body)
	_apply_anim_time(ogre, "shoulder", 0.0)
	await _snap_camera(28.0, -4.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_shoulder_stance.png")
	
	# 3. Ground Stance (Resting on mace)
	_apply_anim_time(ogre, "ground", 0.0)
	await _snap_camera(22.0, -4.0, 4.0, Vector3(0.1, 0.85, 0.0), "ogre_ground_stance.png")
	
	# 4. Guard Stance (Low combat crouch)
	_apply_anim_time(ogre, "guard", 0.0)
	await _snap_camera(32.0, -5.0, 3.8, Vector3(0.0, 0.80, 0.0), "ogre_guard_stance.png")
	
	# 5. Walk (Heavy lumbering stride)
	_apply_anim_time(ogre, "walk", 0.55)
	await _snap_camera(45.0, -4.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_walk_stride.png")
	
	# 6. Cleave - Phase 1: Windup (Two-handed coiled load at right shoulder)
	_apply_anim_time(ogre, "cleave", 0.28)
	await _snap_camera(35.0, -5.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_cleave_windup.png")
	
	# 7. Cleave - Phase 2: Sweep (Devastating horizontal power sweep across front)
	_apply_anim_time(ogre, "cleave", 0.65)
	await _snap_camera(-135.0, -5.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_cleave_sweep.png")
	
	# 8. Cleave - Phase 3: Overshoot & Follow-Through
	_apply_anim_time(ogre, "cleave", 0.95)
	await _snap_camera(-120.0, -5.0, 4.2, Vector3(0.0, 0.85, 0.0), "ogre_cleave_overshoot.png")
	
	# 9. Roar - Phase 1: Warhammer Plant Anchor
	_apply_anim_time(ogre, "roar", 0.35)
	await _snap_camera(25.0, -4.0, 4.0, Vector3(0.0, 0.85, 0.0), "ogre_roar_plant.png")
	
	# 10. Roar - Phase 2: Skyward Bellow (Primal Chieftain Totem)
	_apply_anim_time(ogre, "roar", 1.05)
	await _snap_camera(25.0, -4.0, 4.2, Vector3(0.0, 1.0, 0.0), "ogre_roar_bellow.png")
	
	# 11. Earthshaker - Phase 1: Overhead Hoist (Both hands heave colossal mace)
	_apply_anim_time(ogre, "earthshaker", 0.50)
	await _snap_camera(35.0, -4.0, 4.6, Vector3(0.0, 1.0, 0.0), "ogre_earthshaker_lift.png")
	
	# 12. Earthshaker - Phase 2: Ground Impact Slam (Crater strike forward)
	_apply_anim_time(ogre, "earthshaker", 1.05)
	await _snap_camera(38.0, -8.0, 4.3, Vector3(0.0, 0.75, 0.2), "ogre_earthshaker_impact.png")
	
	# 13. Earthshaker - Phase 3: Mace Extraction & Recovery
	_apply_anim_time(ogre, "earthshaker", 1.70)
	await _snap_camera(38.0, -6.0, 4.3, Vector3(0.0, 0.80, 0.1), "ogre_earthshaker_recovery.png")
	
	# 14. Whirlwind (Continuous 360 centrifugal spin)
	_apply_anim_time(ogre, "whirlwind", 0.32)
	await _snap_camera(15.0, -6.0, 4.5, Vector3(0.0, 0.85, 0.0), "ogre_whirlwind_sweep.png")
	
	# 15. Stagger (Heavy recoil brace)
	_apply_anim_time(ogre, "stagger", 0.60)
	await _snap_camera(30.0, -5.0, 4.0, Vector3(0.0, 0.75, 0.0), "ogre_stagger_brace.png")
	
	# 16. Stunned (Woozy daze)
	_apply_anim_time(ogre, "stunned", 1.20)
	await _snap_camera(22.0, -3.0, 3.9, Vector3(0.0, 0.85, 0.0), "ogre_stunned_daze.png")
	
	print(">>> ALL OGRE ANIMATION SCREENSHOTS CAPTURED SUCCESSFULLY! <<<")
	quit(0)

func _apply_anim_time(ogre: GoblinChieftain, anim_name: String, t: float) -> void:
	ogre.current_anim = anim_name
	var pose = ogre._compute_pose(anim_name, t)
	ogre._apply_pose(pose)

func _snap_camera(yaw: float, pitch: float, dist: float, pivot: Vector3, filename: String) -> void:
	viewer.yaw = yaw
	viewer.pitch = pitch
	viewer.camera_distance = dist
	viewer.camera_pivot.position = pivot
	viewer._update_camera_transform()
	await process_frame
	await process_frame
	var img = root.get_viewport().get_texture().get_image()
	if img:
		var path = out_dir + "/" + filename
		var err = img.save_png(path)
		if err == OK:
			print("  [SAVED] %s" % filename)
		else:
			printerr("  [ERROR] Failed to save %s: %d" % [filename, err])
