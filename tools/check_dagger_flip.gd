extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	viewer.switch_monster("rogue")
	var rogue = viewer.m_rogue
	var r_dag = rogue.right_dagger
	
	print("--- TESTING OUTWARD SWING (+X) ---")
	var q_start = Basis.from_euler(Vector3(deg_to_rad(-85.0), deg_to_rad(15.0), deg_to_rad(-15.0))).get_rotation_quaternion()
	var q_end = Basis.from_euler(Vector3(deg_to_rad(88.0), deg_to_rad(-10.0), deg_to_rad(12.0))).get_rotation_quaternion()
	
	# Outward waypoint: blade points to the right (+X) and slightly forward (+Z), clear of forearm
	# In local dagger coords, if Y is rotated to +X:
	# Euler (0, 0, -90) puts Y onto +X!
	# Let's test b_mid with Z around -90 to -110 deg
	var b_mid = Basis.from_euler(Vector3(deg_to_rad(10.0), deg_to_rad(15.0), deg_to_rad(-95.0)))
	var q_mid = b_mid.get_rotation_quaternion()
	
	for step in range(11):
		var t = float(step) / 10.0
		var q: Quaternion
		if t < 0.5:
			q = q_start.slerp(q_mid, t * 2.0)
		else:
			q = q_mid.slerp(q_end, (t - 0.5) * 2.0)
			
		r_dag.transform.basis = Basis(q)
		var blade_mid = r_dag.transform * Vector3(0.0, 0.25, 0.08)
		var blade_tip = r_dag.transform * Vector3(0.0, 0.45, 0.15)
		
		# Distance to forearm axis (x=0, z=0)
		var dist_axis_mid = Vector2(blade_mid.x, blade_mid.z).length()
		var dist_axis_tip = Vector2(blade_tip.x, blade_tip.z).length()
		print("t=%.1f | blade_mid=(%.3f, %.3f, %.3f) d=%.3f | blade_tip=(%.3f, %.3f, %.3f) d=%.3f" % [
			t, blade_mid.x, blade_mid.y, blade_mid.z, dist_axis_mid, blade_tip.x, blade_tip.y, blade_tip.z, dist_axis_tip
		])
		
	quit(0)
