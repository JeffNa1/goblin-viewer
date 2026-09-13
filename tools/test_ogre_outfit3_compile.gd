extends SceneTree

func _init() -> void:
	call_deferred("_test")

func _test() -> void:
	print("--- TESTING OGRE OUTFIT 3 MESHES & CHIEFTAIN NODE ---")
	var VB = load("res://scripts/voxel_builder.gd")
	if not VB:
		printerr("FAIL: Cannot load voxel_builder.gd")
		quit(1)
		return
	
	print("[1/3] Building Ogre Outfit 3 Head...")
	var head = VB.build_ogre_head_mesh(3)
	assert(head != null, "Head mesh is null")
	print("  -> Head OK, surface count: ", head.get_surface_count())

	print("[2/3] Building Ogre Outfit 3 Torso, Mace, Limbs...")
	var torso = VB.build_ogre_torso_mesh(3)
	var mace = VB.build_ogre_mace_mesh(3)
	var uarm = VB.build_ogre_upper_arm_mesh(3)
	var lfore = VB.build_ogre_forearm_mesh(false, 3)
	var rfore = VB.build_ogre_forearm_mesh(true, 3)
	var thigh = VB.build_ogre_thigh_mesh(3)
	var shin = VB.build_ogre_shin_mesh(3)
	assert(torso != null and mace != null and uarm != null and lfore != null and rfore != null and thigh != null and shin != null)
	print("  -> All 8 meshes built successfully!")

	print("[3/3] Instantiating GoblinChieftain node and setting outfit 3...")
	var ogre_scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre = ogre_scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	print("  -> Current outfit on spawn: ", ogre.current_outfit)
	ogre.set_outfit(3)
	await process_frame
	print("  -> Current outfit after set_outfit(3): ", ogre.current_outfit)
	assert(ogre.current_outfit == 3, "Ogre outfit must be 3")
	assert(ogre.warhammer_mesh.mesh != null, "Warhammer mesh must be set")
	
	print("ALL OGRE OUTFIT 3 COMPILATION & GENERATION TESTS PASSED!")
	quit(0)
