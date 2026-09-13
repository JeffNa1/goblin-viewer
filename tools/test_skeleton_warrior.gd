extends SceneTree

func _init() -> void:
	print("========================================")
	print("🧪 TESTING SKELETON WARRIOR IMPLEMENTATION")
	print("========================================")
	
	# 1. Test VoxelBuilder Mesh Generators
	print("\n--- 1. Testing VoxelBuilder Meshes ---")
	var meshes = {
		"head": VoxelBuilder.build_skeleton_head_mesh(),
		"torso": VoxelBuilder.build_skeleton_torso_mesh(),
		"arm": VoxelBuilder.build_skeleton_upper_arm_mesh(),
		"forearm_l": VoxelBuilder.build_skeleton_forearm_mesh(false),
		"forearm_r": VoxelBuilder.build_skeleton_forearm_mesh(true),
		"thigh": VoxelBuilder.build_skeleton_thigh_mesh(),
		"shin": VoxelBuilder.build_skeleton_shin_mesh(),
		"sword": VoxelBuilder.build_shoddy_sword_mesh(),
		"shield": VoxelBuilder.build_wooden_shield_mesh()
	}
	
	for k in meshes:
		var m = meshes[k]
		assert(m != null, "Mesh %s is null!" % k)
		var aabb = m.get_aabb()
		print("  ✓ Mesh [%s]: AABB size = %s, center = %s" % [k, str(aabb.size), str(aabb.position + aabb.size * 0.5)])
		
	# 2. Test SkeletonWarrior Scene Instantiation
	print("\n--- 2. Testing SkeletonWarrior Scene ---")
	var scene = load("res://scenes/skeleton_warrior.tscn")
	assert(scene != null, "Failed to load scenes/skeleton_warrior.tscn!")
	var inst = scene.instantiate()
	root.add_child(inst)
	
	print("  ✓ Skeleton instantiated successfully!")
	print("  ✓ Ground hips Y: %.3f" % inst.ground_hips_y)
	
	# 3. Test Animations
	print("\n--- 3. Testing Animations ---")
	var anims = ["idle", "walk", "run", "slash", "thrust", "block", "hurt", "stunned"]
	for a in anims:
		inst.play_anim(a)
		# Process a few frames
		for i in range(10):
			inst._process(0.016)
		print("  ✓ Played anim: %s (current_anim: %s)" % [a, inst.current_anim])
		
	# 4. Test Stances
	print("\n--- 4. Testing Weapon Stances ---")
	var defs = inst.get_stance_definitions()
	print("  ✓ Stance definitions count: %d" % defs.size())
	for d in defs:
		var s_id = d["id"]
		inst.set_stance(s_id)
		for i in range(10):
			inst._process(0.016)
		print("  ✓ Stance set: %s (%s) - Current stance: %s" % [s_id, d["name"], inst.current_stance])
		
	# 5. Test Weapon Info
	var winfo = inst.get_weapon_info()
	print("  ✓ Weapon Info: %s (prop: %s)" % [winfo["title"], winfo["prop"]])
	
	# 6. Test Viewer Scene Integration
	print("\n--- 5. Testing Viewer Scene Integration ---")
	var v_scene = load("res://scenes/viewer.tscn")
	assert(v_scene != null, "Failed to load scenes/viewer.tscn!")
	var v_inst = v_scene.instantiate()
	root.add_child(v_inst)
	print("  ✓ Viewer scene instantiated!")
	
	# Test switching to skeleton
	v_inst.switch_monster("skeleton")
	assert(v_inst.active_monster_type == "skeleton", "Active monster type is not skeleton!")
	assert(v_inst.m_skeleton != null and v_inst.m_skeleton.visible == true, "m_skeleton is not visible!")
	print("  ✓ Switched to skeleton in viewer!")
	
	# Test action buttons
	for i in range(8):
		v_inst._trigger_action(i)
		v_inst._process(0.016)
	print("  ✓ All 8 actions triggered cleanly!")
	
	# Test stance buttons
	for i in range(3):
		v_inst._on_stance_btn_pressed(i)
		v_inst._process(0.016)
	print("  ✓ All 3 stances triggered cleanly!")
	
	var f = FileAccess.open("res://tools/skeleton_test_results.txt", FileAccess.WRITE)
	if f:
		f.store_string("ALL_SKELETON_WARRIOR_TESTS_PASSED_SUCCESSFULLY\n")
		f.close()
	print("\n========================================")
	print("🎉 ALL SKELETON WARRIOR TESTS PASSED!")
	print("========================================")
	quit(0)
