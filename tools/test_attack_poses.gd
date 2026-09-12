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
	var g_y = ogre.ground_hips_y
	
	print("--- SOLVING TWO-HANDED GRIP KINEMATICS ---")
	
	# Let's test a sequence of synchronized 2-handed cleave poses
	# 1. Cleave Windup (Both hands back at right shoulder)
	# Right shoulder is at (+0.32, 0.50, 0), Left shoulder at (-0.32, 0.50, 0)
	# Both arms angled toward right shoulder
	var p_cleave_windup = {
		"hips_pos": Vector3(0.0, g_y + 0.003, 0.02),
		"hips_rot": Vector3(4.0, 36.0, 0.0),
		"torso_rot": Vector3(8.0, 48.0, 2.0),
		"head_rot": Vector3(-2.0, -38.0, 0.0),
		"right_arm_rot": Vector3(-35.0, 25.0, 38.0),
		"right_forearm_rot": Vector3(-95.0, 0.0, 0.0),
		"warhammer_rot": Vector3(65.0, 15.0, -20.0),
		"left_arm_rot": Vector3(-45.0, 35.0, 18.0),
		"left_forearm_rot": Vector3(-85.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-12.0, 0.0, -6.5),
		"left_shin_rot": Vector3(18.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(14.0, 0.0, 6.5),
		"right_shin_rot": Vector3(18.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_cleave_windup, 35.0, -5.0, 4.2, "grip_cleave_windup.png")
	
	# 2. Cleave Mid-Sweep (Both arms drive mace forward-left in a massive arc)
	var p_cleave_sweep = {
		"hips_pos": Vector3(0.0, g_y + 0.004, 0.10),
		"hips_rot": Vector3(4.0, -25.0, 0.0),
		"torso_rot": Vector3(10.0, -45.0, -4.0),
		"head_rot": Vector3(2.0, 22.0, 0.0),
		"right_arm_rot": Vector3(-55.0, -10.0, -15.0),
		"right_forearm_rot": Vector3(-30.0, 0.0, 0.0),
		"warhammer_rot": Vector3(90.0, 0.0, -75.0),
		"left_arm_rot": Vector3(-50.0, 0.0, -35.0),
		"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(10.0, 0.0, -6.5),
		"left_shin_rot": Vector3(14.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(-14.0, 0.0, 6.5),
		"right_shin_rot": Vector3(28.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_cleave_sweep, -135.0, -5.0, 4.2, "grip_cleave_sweep.png")
	
	# 3. Cleave Overshoot (Torso pulls through to far left, arms extend)
	var p_cleave_overshoot = {
		"hips_pos": Vector3(0.0, g_y + 0.004, 0.12),
		"hips_rot": Vector3(4.0, -35.0, 0.0),
		"torso_rot": Vector3(12.0, -65.0, -6.0),
		"head_rot": Vector3(4.0, 32.0, 0.0),
		"right_arm_rot": Vector3(-50.0, -15.0, -35.0),
		"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
		"warhammer_rot": Vector3(95.0, 0.0, -85.0),
		"left_arm_rot": Vector3(-35.0, -15.0, -50.0),
		"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(12.0, 0.0, -6.5),
		"left_shin_rot": Vector3(15.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(-14.0, 0.0, 6.5),
		"right_shin_rot": Vector3(28.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_cleave_overshoot, -120.0, -5.0, 4.2, "grip_cleave_overshoot.png")
	
	# 4. Smash Lift (Two hands raise mace straight overhead)
	var p_smash_lift = {
		"hips_pos": Vector3(0.0, g_y + 0.005, -0.04),
		"hips_rot": Vector3(-4.0, 0.0, 0.0),
		"torso_rot": Vector3(-16.0, 0.0, 0.0),
		"head_rot": Vector3(-12.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-145.0, 5.0, 14.0),
		"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
		"warhammer_rot": Vector3(160.0, 0.0, 0.0),
		"left_arm_rot": Vector3(-140.0, -5.0, -12.0),
		"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-12.0, 0.0, -6.5),
		"left_shin_rot": Vector3(20.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(10.0, 0.0, 6.5),
		"right_shin_rot": Vector3(14.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_smash_lift, 35.0, -4.0, 4.8, "grip_smash_lift.png")
	
	# 5. Smash Impact (Both hands drive mace down into earth in front)
	var p_smash_impact = {
		"hips_pos": Vector3(0.0, g_y + 0.015, 0.18),
		"hips_rot": Vector3(18.0, 0.0, 0.0),
		"torso_rot": Vector3(40.0, 0.0, 0.0),
		"head_rot": Vector3(-10.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-35.0, 5.0, 10.0),
		"right_forearm_rot": Vector3(-65.0, 0.0, 0.0),
		"warhammer_rot": Vector3(175.0, 0.0, 0.0),
		"left_arm_rot": Vector3(-32.0, -5.0, -8.0),
		"left_forearm_rot": Vector3(-68.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-24.0, 0.0, -7.5),
		"left_shin_rot": Vector3(36.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(16.0, 0.0, 7.5),
		"right_shin_rot": Vector3(22.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_smash_impact, 38.0, -8.0, 4.3, "grip_smash_impact.png")
	
	# 6. Roar: Full Skyward Roar with Hammer Plant & Stomp
	# Phase A: Aggressive Mace Plant on Earth
	var p_roar_plant = {
		"hips_pos": Vector3(0.02, g_y + 0.002, 0.0),
		"hips_rot": Vector3(6.0, 6.0, -2.0),
		"torso_rot": Vector3(6.0, 2.0, 2.0),
		"head_rot": Vector3(-8.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-15.0, 10.0, 24.0),
		"right_forearm_rot": Vector3(-42.0, 0.0, 0.0),
		"warhammer_rot": Vector3(175.0, 0.0, -10.0),
		"left_arm_rot": Vector3(-25.0, 0.0, -20.0),
		"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-8.0, 0.0, -7.0),
		"left_shin_rot": Vector3(14.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(4.0, 0.0, 6.0),
		"right_shin_rot": Vector3(8.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_roar_plant, 25.0, -4.0, 4.0, "grip_roar_plant.png")
	
	# Phase B: Titanic Skyward Bellow (Left Arm Wide Splay, Mace stays grounded as pillar)
	var p_roar_bellow = {
		"hips_pos": Vector3(0.02, g_y + 0.002, 0.0),
		"hips_rot": Vector3(0.0, 4.0, -2.0),
		"torso_rot": Vector3(-18.0, 0.0, 2.0),
		"head_rot": Vector3(-44.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-6.0, 10.0, 24.0),
		"right_forearm_rot": Vector3(-48.0, 0.0, 0.0),
		"warhammer_rot": Vector3(175.0, 0.0, -10.0),
		"left_arm_rot": Vector3(-95.0, -20.0, -55.0),
		"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(-6.0, 0.0, -7.0),
		"left_shin_rot": Vector3(12.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(2.0, 0.0, 6.0),
		"right_shin_rot": Vector3(8.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_roar_bellow, 25.0, -4.0, 4.0, "grip_roar_bellow.png")
	
	print(">>> ALL GRIP POSES TESTED AND CAPTURED! <<<")
	quit(0)

func _apply_and_snap(ogre: GoblinChieftain, p: Dictionary, yaw: float, pitch: float, dist: float, fn: String) -> void:
	ogre._apply_pose(p)
	viewer.yaw = yaw
	viewer.pitch = pitch
	viewer.camera_distance = dist
	viewer.camera_pivot.position = Vector3(0.0, 0.85, 0.0)
	viewer._update_camera_transform()
	await process_frame
	await process_frame
	var img = root.get_viewport().get_texture().get_image()
	if img:
		img.save_png(out_dir + "/" + fn)
		print("  [SAVED] %s" % fn)
