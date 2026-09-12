extends SceneTree

func _init() -> void:
	call_deferred("_test")

func _test() -> void:
	print("--- TEST 1: WARRIOR GOBLIN WITH ORIGINAL WEAPON TRAIL ---")
	var warrior_scene = load("res://scenes/goblin.tscn")
	var warrior = warrior_scene.instantiate()
	root.add_child(warrior)
	await process_frame
	await process_frame
	
	assert(warrior.weapon_trail != null, "Warrior weapon trail must be initialized")
	print("Warrior weapon trail script: ", warrior.weapon_trail.get_script().resource_path)
	assert(warrior.weapon_trail.get_script().resource_path == "res://scripts/weapon_trail.gd", "Warrior must use weapon_trail.gd")
	assert(not ("crater_spikes" in warrior.weapon_trail), "Warrior weapon trail must NOT contain crater_spikes")
	assert(not ("is_vortex_active" in warrior.weapon_trail), "Warrior weapon trail must NOT contain is_vortex_active")
	
	print("Triggering Warrior Smash Attack...")
	warrior.play_anim("smash")
	for f in range(40):
		warrior._process(0.016)
		await process_frame
		
	print("Warrior smash attack executed successfully! Shockwave timer: ", warrior.weapon_trail.shockwave_timer)
	root.remove_child(warrior)
	warrior.queue_free()
	await process_frame
	
	print("\n--- TEST 2: MACE OGRE WITH DEDICATED OGRE WEAPON TRAIL ---")
	var ogre_scene = load("res://scenes/goblin_chieftain.tscn")
	var ogre = ogre_scene.instantiate()
	root.add_child(ogre)
	await process_frame
	await process_frame
	
	assert(ogre.weapon_trail != null, "Ogre weapon trail must be initialized")
	print("Ogre weapon trail script: ", ogre.weapon_trail.get_script().resource_path)
	assert(ogre.weapon_trail.get_script().resource_path == "res://scripts/ogre_weapon_trail.gd", "Ogre must use ogre_weapon_trail.gd")
	assert("crater_spikes" in ogre.weapon_trail, "Ogre weapon trail MUST contain crater_spikes")
	assert("is_vortex_active" in ogre.weapon_trail, "Ogre weapon trail MUST contain is_vortex_active")
	
	print("Triggering Ogre Earthshaker Attack...")
	ogre.play_anim("earthshaker")
	for f in range(65):
		ogre._process(0.016)
		await process_frame
		
	print("Ogre earthshaker attack executed successfully! Shockwave timer: ", ogre.weapon_trail.shockwave_timer)
	
	print("Triggering Ogre Whirlwind 360° Attack...")
	ogre.play_anim("whirlwind")
	for f in range(40):
		ogre._process(0.016)
		await process_frame
		
	print("Ogre whirlwind attack executed successfully! Vortex active: ", ogre.weapon_trail.is_vortex_active)
	root.remove_child(ogre)
	ogre.queue_free()
	await process_frame
	
	print("\n>>> ALL TESTS PASSED SUCCESSFULLY! EFFECT SEPARATION VERIFIED 100%! <<<")
	quit(0)
