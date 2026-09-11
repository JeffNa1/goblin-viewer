extends SceneTree

func _init() -> void:
	var archer_scene = load("res://scenes/goblin_archer.tscn")
	var archer = archer_scene.instantiate()
	root.add_child(archer)
	
	# Current aim pose
	var pose = archer._compute_aim(0.0)
	archer._apply_pose(pose)
	archer.force_update_transform()
	
	var r_shoulder = archer.right_arm.global_position
	var r_elbow = archer.right_forearm.global_position
	var r_hand = archer.right_forearm.to_global(Vector3(0.0, -0.24, 0.0))
	var torso_pos = archer.torso.global_position
	var head_pos = archer.head.global_position
	
	print('--- CURRENT AIM POSITIONS ---')
	print('Torso Pos: ', torso_pos)
	print('Head Pos: ', head_pos)
	print('Right Shoulder: ', r_shoulder)
	print('Right Elbow: ', r_elbow)
	print('Right Hand: ', r_hand)
	
	# Check points along right upper arm (5 samples) and forearm (5 samples) in Torso local space
	var t_inv = archer.torso.global_transform.affine_inverse()
	print('\n--- SAMPLES ALONG RIGHT ARM IN TORSO LOCAL SPACE ---')
	print('(Torso half-extents approx: X=[-0.22, 0.22], Y=[0, 0.54], Z=[-0.16, 0.16])')
	for i in range(6):
		var p_world = r_shoulder.lerp(r_elbow, float(i) / 5.0)
		var p_local = t_inv * p_world
		print('UpperArm Sample ', i, ': ', p_local)
	for i in range(6):
		var p_world = r_elbow.lerp(r_hand, float(i) / 5.0)
		var p_local = t_inv * p_world
		var inside_x = abs(p_local.x) < 0.21
		var inside_y = p_local.y >= 0.0 and p_local.y <= 0.52
		var inside_z = abs(p_local.z) < 0.16
		var clipping = inside_x and inside_y and inside_z
		print('Forearm Sample ', i, ': ', p_local, ' -> CLIPPING TORSO? ', clipping)
	
	quit()
