extends SceneTree

func _init() -> void:
	call_deferred("_test_all")

func _test_all() -> void:
	print("==================================================")
	print("  TESTING ALL 5 MONSTERS OUTFIT 3 AVAILABILITY   ")
	print("==================================================")
	var v_scene = load("res://scenes/viewer.tscn")
	var viewer = v_scene.instantiate()
	root.add_child(viewer)
	await process_frame
	await process_frame
	
	var monsters = ["warrior", "archer", "shaman", "rogue", "chieftain"]
	for m in monsters:
		viewer.switch_monster(m)
		await process_frame
		print("[*] Monster: ", m)
		print("    - btn_outfit1: ", viewer.btn_outfit1.visible, " (", viewer.btn_outfit1.text, ")")
		print("    - btn_outfit2: ", viewer.btn_outfit2.visible, " (", viewer.btn_outfit2.text, ")")
		print("    - btn_outfit3: ", viewer.btn_outfit3.visible, " (", viewer.btn_outfit3.text, ")")
		assert(viewer.btn_outfit1.visible == true, "Outfit 1 must be visible")
		assert(viewer.btn_outfit2.visible == true, "Outfit 2 must be visible")
		assert(viewer.btn_outfit3.visible == true, "Outfit 3 must be visible for " + m)
		
		# Test selecting outfit 3
		viewer._select_outfit(3)
		await process_frame
		assert(viewer.current_monster_node.current_outfit == 3, "Failed to switch to outfit 3 for " + m)
		print("    - Successfully selected Outfit 3: ", viewer.status_lbl.text)
	
	print("\nALL 5 MONSTERS HAVE COMPLETE, WORKING OUTFIT 3!")
	quit(0)
