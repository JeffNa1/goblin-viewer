extends SceneTree

func _init() -> void:
	call_deferred("_test")

func _test() -> void:
	print("--- TESTING VIEWER SCENE WITH OGRE OUTFIT 3 ---")
	var v_scene = load("res://scenes/viewer.tscn")
	var viewer = v_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	# 1. Switch to Chieftain
	print("[1/4] Switching to Chieftain...")
	viewer.switch_monster("chieftain")
	await process_frame
	await process_frame
	
	print("  -> active_monster_type: ", viewer.active_monster_type)
	print("  -> btn_outfit1.visible: ", viewer.btn_outfit1.visible, " text: ", viewer.btn_outfit1.text)
	print("  -> btn_outfit2.visible: ", viewer.btn_outfit2.visible, " text: ", viewer.btn_outfit2.text)
	print("  -> btn_outfit3.visible: ", viewer.btn_outfit3.visible, " text: ", viewer.btn_outfit3.text)
	assert(viewer.btn_outfit3.visible == true, "btn_outfit3 MUST be visible for chieftain!")
	assert("Hoàng Kim" in viewer.btn_outfit3.text, "btn_outfit3 must have Hoàng Kim label")

	# 2. Select Outfit 3 via UI
	print("[2/4] Selecting Outfit 3 via _select_outfit(3)...")
	viewer._select_outfit(3)
	await process_frame
	print("  -> Ogre current_outfit: ", viewer.current_monster_node.current_outfit)
	assert(viewer.current_monster_node.current_outfit == 3, "Ogre current_outfit must be 3")
	print("  -> Status label: ", viewer.status_lbl.text)
	assert("Hoàng Kim" in viewer.status_lbl.text, "Status label must show Hoàng Kim")

	# 3. Simulate KEY_O cycling
	print("[3/4] Testing KEY_O cycling from Outfit 3...")
	var cur_o = viewer.current_monster_node.current_outfit
	var max_o = 3 if viewer.active_monster_type in ["warrior", "archer", "shaman", "rogue", "chieftain"] else 2
	var next_o = (cur_o % max_o) + 1
	viewer._select_outfit(next_o)
	await process_frame
	print("  -> Cycled from 3 to: ", viewer.current_monster_node.current_outfit)
	assert(viewer.current_monster_node.current_outfit == 1, "Must cycle from 3 back to 1")

	# 4. Cycle 1 -> 2 -> 3
	print("[4/4] Cycling 1 -> 2 -> 3...")
	cur_o = viewer.current_monster_node.current_outfit
	next_o = (cur_o % max_o) + 1
	viewer._select_outfit(next_o)
	await process_frame
	print("  -> Cycled 1 to: ", viewer.current_monster_node.current_outfit)
	assert(viewer.current_monster_node.current_outfit == 2, "Must cycle 1 to 2")

	cur_o = viewer.current_monster_node.current_outfit
	next_o = (cur_o % max_o) + 1
	viewer._select_outfit(next_o)
	await process_frame
	print("  -> Cycled 2 to: ", viewer.current_monster_node.current_outfit)
	assert(viewer.current_monster_node.current_outfit == 3, "Must cycle 2 to 3")

	print("\nALL VIEWER OGRE OUTFIT 3 UI TESTS 100% PASSED!")
	quit(0)
