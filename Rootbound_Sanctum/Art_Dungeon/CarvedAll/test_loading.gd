extends SceneTree
func _init(): call_deferred("run")
func run():
    var path="res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/loading.gd"
    if not ResourceLoader.exists(path):
        printerr("FAIL: a real loading screen must precede scene construction")
        quit(1)
        return
    var screen=load(path).new()
    root.add_child(screen)
    await process_frame
    assert(screen.visible)
    screen.update_progress(1,4,"Preparing the next room")
    assert(is_equal_approx(screen.bar.value,25.0))
    screen.fail("Missing room asset")
    assert(screen.visible and screen.failed and screen.message.text.contains("Missing room asset"))
    screen.queue_free()
    await process_frame
    print("LOADING_UNIT_PASS visible, exact progress, visible failure")
    quit()
