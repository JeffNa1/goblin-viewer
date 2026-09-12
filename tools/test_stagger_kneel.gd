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
	
	print("--- TESTING STAGGER KNEEL POSES ---")
	
	# Pose 1: Heavy Impact Recoil (Upper body knocked back, feet sliding back)
	var p_recoil = {
		"hips_pos": Vector3(0.0, g_y + 0.01, -0.08),
		"hips_rot": Vector3(-12.0, 0.0, 0.0),
		"torso_rot": Vector3(-24.0, 0.0, 0.0),
		"head_rot": Vector3(-26.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-25.0, 15.0, 30.0),
		"right_forearm_rot": Vector3(-60.0, 0.0, 0.0),
		"warhammer_rot": Vector3(50.0, 0.0, 0.0),
		"left_arm_rot": Vector3(-40.0, 0.0, -30.0),
		"left_forearm_rot": Vector3(-20.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(14.0, 0.0, -7.0),
		"left_shin_rot": Vector3(10.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(-10.0, 0.0, 7.0),
		"right_shin_rot": Vector3(20.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_recoil, 30.0, -5.0, 4.2, "stagger_test_1_recoil.png")
	
	# Pose 2: Deep Kneel Drop (Right knee sinks toward earth, mace planted as pillar, left hand braces on left knee)
	var p_kneel = {
		"hips_pos": Vector3(0.0, g_y - 0.135, -0.04),
		"hips_rot": Vector3(10.0, 4.0, -2.0),
		"torso_rot": Vector3(24.0, -4.0, 2.0),
		"head_rot": Vector3(-16.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-12.0, 10.0, 22.0),
		"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
		"warhammer_rot": Vector3(175.0, 0.0, -10.0),
		"left_arm_rot": Vector3(-35.0, 12.0, -12.0),
		"left_forearm_rot": Vector3(-78.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(32.0, 0.0, -8.0),
		"left_shin_rot": Vector3(24.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(-38.0, 0.0, 8.0),
		"right_shin_rot": Vector3(82.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_kneel, 32.0, -4.0, 3.8, "stagger_test_2_kneel_front.png")
	await _apply_and_snap(ogre, p_kneel, -60.0, -4.0, 3.8, "stagger_test_2_kneel_side.png")
	
	# Pose 3: Panting Defiance on one knee
	var p_panting = {
		"hips_pos": Vector3(0.0, g_y - 0.135, -0.06),
		"hips_rot": Vector3(10.0, 5.0, -3.0),
		"torso_rot": Vector3(20.0, -5.0, 3.0),
		"head_rot": Vector3(-15.0, 0.0, 0.0),
		"right_arm_rot": Vector3(-8.0, 10.0, 24.0),
		"right_forearm_rot": Vector3(-48.0, 0.0, 0.0),
		"warhammer_rot": Vector3(175.0, 0.0, -10.0),
		"left_arm_rot": Vector3(-20.0, 0.0, -24.0),
		"left_forearm_rot": Vector3(-60.0, 0.0, 0.0),
		"left_thigh_rot": Vector3(36.0, 0.0, -8.0),
		"left_shin_rot": Vector3(36.0, 0.0, 0.0),
		"right_thigh_rot": Vector3(-44.0, 0.0, 8.0),
		"right_shin_rot": Vector3(70.0, 0.0, 0.0)
	}
	await _apply_and_snap(ogre, p_panting, 30.0, -3.0, 3.8, "stagger_test_3_pant.png")
	
	print(">>> STAGGER KNEEL POSES TESTED! <<<")
	quit(0)

func _apply_and_snap(ogre: GoblinChieftain, p: Dictionary, yaw: float, pitch: float, dist: float, fn: String) -> void:
	ogre._apply_pose(p)
	viewer.yaw = yaw
	viewer.pitch = pitch
	viewer.camera_distance = dist
	viewer.camera_pivot.position = Vector3(0.0, 0.75, 0.0)
	viewer._update_camera_transform()
	await process_frame
	await process_frame
	var img = root.get_viewport().get_texture().get_image()
	if img:
		img.save_png(out_dir + "/" + fn)
		print("  [SAVED] %s" % fn)
