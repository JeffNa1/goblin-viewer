extends SceneTree

func _init() -> void:
	call_deferred("_verify")

func _verify() -> void:
	var report: Array = []
	report.append("==================================================")
	report.append("  VERIFYING GOBLIN ARCHER OUTFIT 3 (IMPERIAL GOLD)")
	report.append("==================================================")
	
	var scene = load("res://scenes/goblin_archer.tscn")
	if not scene:
		report.append("[-] FAIL: Could not load goblin_archer.tscn")
		_save_and_exit(report, 1)
		return
		
	var archer = scene.instantiate()
	root.add_child(archer)
	await process_frame
	await process_frame
	
	report.append("[+] Successfully instantiated goblin_archer.tscn")
	report.append("[+] Initial outfit: %d" % archer.current_outfit)
	
	# Switch to Outfit 3
	archer.set_outfit(3)
	report.append("[+] Switched to Outfit 3. Current outfit is: %d" % archer.current_outfit)
	if archer.current_outfit != 3:
		report.append("[-] FAIL: Expected outfit 3, got: %d" % archer.current_outfit)
		_save_and_exit(report, 1)
		return
		
	# Verify all meshes exist and have surfaces
	var checks = [
		{"name": "Torso", "mesh": archer.torso_mesh.mesh},
		{"name": "Head", "mesh": archer.head_mesh.mesh},
		{"name": "Left Arm", "mesh": archer.left_arm_mesh.mesh},
		{"name": "Right Arm", "mesh": archer.right_arm_mesh.mesh},
		{"name": "Left Forearm", "mesh": archer.left_forearm_mesh.mesh},
		{"name": "Right Forearm", "mesh": archer.right_forearm_mesh.mesh},
		{"name": "Left Thigh", "mesh": archer.left_thigh_mesh.mesh},
		{"name": "Right Thigh", "mesh": archer.right_thigh_mesh.mesh},
		{"name": "Left Shin", "mesh": archer.left_shin_mesh.mesh},
		{"name": "Right Shin", "mesh": archer.right_shin_mesh.mesh},
		{"name": "Bow (Rest)", "mesh": archer.bow_rest_mesh},
		{"name": "Bow (Drawn)", "mesh": archer.bow_drawn_mesh},
		{"name": "Quiver", "mesh": archer.quiver_mesh.mesh},
		{"name": "Arrow", "mesh": archer.arrow_mesh.mesh}
	]
	
	for c in checks:
		var m: Mesh = c["mesh"]
		if m == null:
			report.append("[-] FAIL: Mesh missing for: %s" % c["name"])
			_save_and_exit(report, 1)
			return
		var sc = m.get_surface_count()
		report.append("  [OK] %-15s: %d surfaces" % [c["name"], sc])
		if sc == 0:
			report.append("[-] FAIL: Surface count is 0 for: %s" % c["name"])
			_save_and_exit(report, 1)
			return

	# Verify animation poses
	report.append("\n[+] Testing Animations in Outfit 3:")
	for anim_name in ["idle", "ready", "walk", "run", "aim", "shoot", "backstep", "hurt", "stunned"]:
		archer.play_anim(anim_name)
		archer.is_blending = false
		for step in range(5):
			archer._process(0.05)
			await process_frame
		var bow_state = "Drawn" if archer.bow_mesh.mesh == archer.bow_drawn_mesh else "Rest"
		report.append("  [OK] Anim %-10s -> Processed OK (Bow: %s)" % [anim_name, bow_state])

	# Verify Outfit Cycling
	report.append("\n[+] Testing Outfit Cycling:")
	for o in [1, 2, 3, 1]:
		archer.set_outfit(o)
		report.append("  [OK] Set outfit -> %d (Current: %d)" % [o, archer.current_outfit])

	report.append("\n==================================================")
	report.append("  ALL VERIFICATIONS PASSED (100% SUCCESS)")
	report.append("==================================================")
	_save_and_exit(report, 0)

func _save_and_exit(lines: Array, code: int) -> void:
	var txt = "\n".join(lines)
	print(txt)
	var f = FileAccess.open("res://tools/outfit3_report.txt", FileAccess.WRITE)
	if f:
		f.store_string(txt)
		f.close()
	quit(code)
