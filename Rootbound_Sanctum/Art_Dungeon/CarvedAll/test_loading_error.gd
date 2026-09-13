extends SceneTree
func _init(): call_deferred("run")
func run():
    var scene=load("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/dungeon.tscn").instantiate()
    scene.asset_root="res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/MissingFixture/"
    root.add_child(scene)
    for frame in range(300):
        if scene.loading_failed: break
        await process_frame
    assert(scene.loading_failed)
    assert(not scene.built and not scene.world.visible and scene.loading.visible)
    assert(scene.loading.message.text.contains("Missing chamber"))
    assert(scene.loading.bar.value<100)
    print("LOADING_ERROR_PASS no false completion or partial scene")
    scene.queue_free()
    await process_frame
    quit()
