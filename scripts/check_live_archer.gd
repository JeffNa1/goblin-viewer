extends SceneTree

func _init() -> void:
	var viewer_scene = load("res://scenes/viewer.tscn")
	var viewer = viewer_scene.instantiate()
	root.add_child(viewer)
	
	viewer.switch_monster("archer")
	var archer = viewer.current_monster_node
	archer.play_anim("aim")
	# Force process a few frames
	for f in range(20):
		archer._process(0.05)
	
	print('Hips Global Rot: ', archer.hips.global_rotation_degrees)
	print('Torso Global Rot: ', archer.torso.global_rotation_degrees)
	print('Head Global Pos: ', archer.head.global_position)
	print('Head Global Rot: ', archer.head.global_rotation_degrees)
	print('Left Arm Global Rot: ', archer.left_arm.global_rotation_degrees)
	print('Bow Global Pos: ', archer.bow.global_position)
	print('Right Arm Local Rot: ', archer.right_arm.rotation_degrees)
	print('Right Arm Global Pos: ', archer.right_arm.global_position)
	print('Right Arm Global Rot: ', archer.right_arm.global_rotation_degrees)
	print('Right Forearm Local Rot: ', archer.right_forearm.rotation_degrees)
	print('Right Forearm Global Pos: ', archer.right_forearm.global_position)
	print('Right Forearm Global Rot: ', archer.right_forearm.global_rotation_degrees)
	
	var r_hand_pos = archer.right_forearm.to_global(Vector3(0.0, -0.24, 0.0))
	var bow_grip_pos = archer.bow.global_position
	var nock_target_pos = archer.bow.to_global(Vector3(0.0, 0.0, -0.69))
	
	print('\n--- ARCHERY ALIGNMENT VERIFICATION ---')
	print('Bow Grip Global: ', bow_grip_pos)
	print('Bowstring Apex / Nock Global: ', nock_target_pos)
	print('Right Hand Global: ', r_hand_pos)
	print('Distance Hand to Nock: ', r_hand_pos.distance_to(nock_target_pos) * 100.0, ' cm')
	print('Distance Hand to Chin/Head: ', r_hand_pos.distance_to(archer.head.global_position) * 100.0, ' cm')
	
	quit()
