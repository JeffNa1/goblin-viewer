extends SceneTree

func _init() -> void:
	call_deferred("_test_points")

func _test_points() -> void:
	var scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre: GoblinChieftain = scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	ogre.set_process(false)
	
	# Extract all foot sole vertices from left_shin_mesh that have y = -0.285
	var mesh: ArrayMesh = ogre.left_shin_mesh.mesh as ArrayMesh
	var sole_points: Array[Vector3] = []
	for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
		if abs(v.y - (-0.285)) < 0.001:
			sole_points.append(v)
			
	print("Found %d sole vertices on foot!" % sole_points.size())
	
	# Check 10 random angles
	for i in range(5):
		var tp = randf_range(-30.0, 30.0)
		var tr = randf_range(-10.0, 10.0)
		var sp = randf_range(0.0, 50.0)
		
		var pose = {
			"hips_pos": Vector3.ZERO,
			"hips_rot": Vector3.ZERO,
			"left_thigh_rot": Vector3(tp, 0.0, tr),
			"left_shin_rot": Vector3(sp, 0.0, 0.0),
			"right_thigh_rot": Vector3.ZERO,
			"right_shin_rot": Vector3.ZERO
		}
		ogre._apply_pose(pose)
		ogre.hips.force_update_transform()
		ogre.left_shin.force_update_transform()
		
		# True min from all mesh vertices
		var true_min = 999.0
		for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:
			var wv = ogre.left_shin_mesh.global_transform * v
			if wv.y < true_min: true_min = wv.y
			
		# Min from just the 4 corner sole points:
		# Corners: (x = +/-0.09, y = -0.285, z = -0.09 and +0.15)
		var corners = [
			Vector3(-0.09, -0.285, -0.09),
			Vector3( 0.09, -0.285, -0.09),
			Vector3(-0.09, -0.285,  0.15),
			Vector3( 0.09, -0.285,  0.15),
			Vector3( 0.0,  -0.285,  0.165), # Claws tip
		]
		var approx_min = 999.0
		for c in corners:
			var wc = ogre.left_shin_mesh.global_transform * c
			if wc.y < approx_min: approx_min = wc.y
			
		print("tp=%+5.1f sp=%+5.1f -> true=%.5f approx=%.5f diff=%.2f mm" % [
			tp, sp, true_min, approx_min, abs(true_min - approx_min) * 1000.0
		])
		
	quit(0)
