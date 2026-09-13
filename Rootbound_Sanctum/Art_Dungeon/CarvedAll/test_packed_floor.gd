extends SceneTree
func _init(): call_deferred("run")
func run():
    var failures=[]
    for id in ["01","07"]:
        var scene=load("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Assets/"+id+".scn").instantiate()
        root.add_child(scene)
        var tiles=0
        var total=0
        for node in scene.find_children("*","MultiMeshInstance3D",true,false):
            total+=node.multimesh.instance_count
            for i in range(node.multimesh.instance_count):
                var t=node.multimesh.get_instance_transform(i)
                if t.basis.x.length()>.1 and t.basis.y.length()>.001 and t.origin.y+t.basis.y.length()*.5<=.065: tiles+=1
        print("PACKED_FLOOR ",id," tiles=",tiles," total_instances=",total)
        if tiles<20:failures.append(id)
        scene.free()
    print("PACKED_FLOOR_FAILURES ",failures)
    quit(0 if failures.is_empty() else 1)
