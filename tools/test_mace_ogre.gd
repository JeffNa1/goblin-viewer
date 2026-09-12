extends SceneTree

func _init() -> void:
	call_deferred("_run_test")

func _run_test() -> void:
	print("=========================================")
	print(">>> TESTING MACE OGRE REDESIGN & INTEGRATION <<<")
	print("=========================================")

	var chieftain_scene = load("res://scenes/goblin_chieftain.tscn")
	if not chieftain_scene:
		printerr("FAIL: Unable to load res://scenes/goblin_chieftain.tscn")
		quit(1)
		return

	var ogre: GoblinChieftain = chieftain_scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame

	# 1. Check Mesh Generation & Detailed Geometries
	var meshes = {
		"Head (build_ogre_head_mesh)": ogre.head_mesh,
		"Torso (build_ogre_torso_mesh)": ogre.torso_mesh,
		"Mace (build_ogre_mace_mesh)": ogre.warhammer_mesh,
		"Left Arm (build_ogre_upper_arm_mesh)": ogre.left_arm_mesh,
		"Left Forearm (build_ogre_forearm_mesh)": ogre.left_forearm_mesh,
		"Right Arm (build_ogre_upper_arm_mesh)": ogre.right_arm_mesh,
		"Right Forearm (build_ogre_forearm_mesh)": ogre.right_forearm_mesh,
		"Left Thigh (build_ogre_thigh_mesh)": ogre.left_thigh_mesh,
		"Left Shin (build_ogre_shin_mesh)": ogre.left_shin_mesh,
		"Right Thigh (build_ogre_thigh_mesh)": ogre.right_thigh_mesh,
		"Right Shin (build_ogre_shin_mesh)": ogre.right_shin_mesh,
	}

	var total_verts = 0
	var total_faces = 0
	print("\n--- 1. MESH COMPLEXITY & VERTEX AUDIT ---")
	for m_name in meshes:
		var mi: MeshInstance3D = meshes[m_name]
		if mi == null or mi.mesh == null:
			printerr("FAIL: Mesh %s is NULL!" % m_name)
			quit(1)
			return
		var mesh: ArrayMesh = mi.mesh as ArrayMesh
		var surf_tool = MeshDataTool.new()
		surf_tool.create_from_surface(mesh, 0)
		var v_count = surf_tool.get_vertex_count()
		var f_count = surf_tool.get_face_count()
		total_verts += v_count
		total_faces += f_count
		print("  [OK] %-38s: %4d vertices, %4d faces" % [m_name, v_count, f_count])

	print("Total Mace Ogre Model: %d vertices, %d faces" % [total_verts, total_faces])

	# 2. Check Weapon Info & Stances
	print("\n--- 2. WEAPON & STANCE AUDIT ---")
	var w_info = ogre.get_weapon_info()
	print("  Weapon Title: %s" % w_info.get("title", ""))
	assert(w_info.get("title", "").find("ĐẠI CHÙY") != -1, "Weapon title must reference Đại Chùy")

	var s_defs = ogre.get_stance_definitions()
	print("  Stance Definitions Count: %d" % s_defs.size())
	for s in s_defs:
		print("    - %s: %s (%s)" % [s["id"], s["name"], s["shortcut"]])

	# 3. Check All Animations Processing
	print("\n--- 3. ANIMATION CYCLE VERIFICATION ---")
	var anims = ["idle", "walk", "cleave", "roar", "earthshaker", "whirlwind", "stagger", "stunned"]
	for a in anims:
		ogre.play_anim(a)
		for step in range(5):
			ogre._process(0.016)
		print("  [OK] Animation '%s' processed cleanly." % a)

	# 4. Check Stance Switching
	print("\n--- 4. STANCE SWITCHING ---")
	var stances = ["shoulder", "ground", "guard"]
	for st in stances:
		ogre.set_stance(st)
		ogre._process(0.016)
		print("  [OK] Stance '%s' set and processed cleanly." % st)

	# 5. Check Viewer Scene Integration
	print("\n--- 5. VIEWER SCENE INTEGRATION ---")
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	viewer.switch_monster("chieftain")
	viewer.sync_editor_from_monster()
	print("  [OK] Viewer switched to Mace Ogre successfully.")
	print("  Editor Title: %s" % viewer.ed_title.text)
	assert(viewer.ed_title.text.find("MACE OGRE") != -1, "Editor title must show MACE OGRE")
	print("  Status Label: %s" % viewer.status_lbl.text)
	assert(viewer.status_lbl.text.find("Mace Ogre") != -1, "Status label must show Mace Ogre")
	print("  Boss Button Text: %s" % viewer.btn_sel_boss.text)
	assert(viewer.btn_sel_boss.text.find("MACE OGRE") != -1, "Button text must show MACE OGRE")

	print("\n=========================================")
	print(">>> ALL MACE OGRE TESTS PASSED SUCCESSFULLY! <<<")
	print("=========================================")
	quit(0)
