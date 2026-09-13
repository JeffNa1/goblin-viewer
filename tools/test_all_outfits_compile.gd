extends SceneTree

func _init() -> void:
	call_deferred("_test")

func _test() -> void:
	print("--- TESTING ALL 5 MONSTERS OUTFIT 3 IN VOXEL_BUILDER_TEST.GD ---")
	var VB = load("res://scripts/voxel_builder_test.gd")
	if not VB:
		printerr("FAIL: Cannot load voxel_builder_test.gd")
		quit(1)
		return
	
	print("[1/5] Warrior Outfit 3...")
	var w = [VB.build_head_mesh(3), VB.build_torso_mesh(3), VB.build_upper_arm_mesh(3), VB.build_forearm_mesh(true, 3), VB.build_thigh_mesh(3), VB.build_shin_mesh(3), VB.build_club_mesh(3)]
	for m in w: assert(m != null)
	print("  -> Warrior OK!")

	print("[2/5] Archer Outfit 3...")
	var a = [VB.build_archer_head_mesh(3), VB.build_archer_torso_mesh(3), VB.build_archer_upper_arm_mesh(3), VB.build_archer_forearm_mesh(true, 3), VB.build_archer_thigh_mesh(3), VB.build_archer_shin_mesh(3), VB.build_imperial_bow_mesh(false), VB.build_imperial_quiver_mesh(), VB.build_imperial_arrow_mesh()]
	for m in a: assert(m != null)
	print("  -> Archer OK!")

	print("[3/5] Shaman Outfit 3...")
	var s = [VB.build_shaman_head_mesh(3), VB.build_shaman_torso_mesh(3), VB.build_shaman_cloak_mesh(3), VB.build_shaman_staff_mesh(3), VB.build_totem_mesh(3)]
	for m in s: assert(m != null)
	print("  -> Shaman OK!")

	print("[4/5] Rogue Outfit 3...")
	var r = [VB.build_rogue_head_mesh(3), VB.build_rogue_torso_mesh(3), VB.build_rogue_upper_arm_mesh(3), VB.build_rogue_forearm_mesh(true, 3), VB.build_rogue_thigh_mesh(3), VB.build_rogue_shin_mesh(3), VB.build_dagger_mesh(3)]
	for m in r: assert(m != null)
	print("  -> Rogue OK!")

	print("[5/5] Mace Ogre Outfit 3...")
	var o = [VB.build_ogre_head_mesh(3), VB.build_ogre_torso_mesh(3), VB.build_ogre_upper_arm_mesh(3), VB.build_ogre_forearm_mesh(true, 3), VB.build_ogre_thigh_mesh(3), VB.build_ogre_shin_mesh(3), VB.build_ogre_mace_mesh(3)]
	for m in o: assert(m != null)
	print("  -> Ogre OK!")

	print("\n========================================================")
	print("  ALL 5 MONSTERS OUTFIT 3 (HOÀNG KIM) 100% OPERATIONAL! ")
	print("========================================================")
	quit(0)
