extends SceneTree
func _init():
    call_deferred("run")
func run():
    var scene=load("res://Rootbound_Sanctum/Art_Dungeon/dungeon.tscn").instantiate()
    root.add_child(scene)
    while not scene.built: await process_frame
    var records=[]
    for id in scene.ids:
        var r=scene.rooms[id]
        var rec={"id":id,"name":r.room_data["name"],"position":vec(r.position),"extent":[r.extent.x,r.extent.y],"focus":vec(r.focus_point),"blockers":[],"edges":[],"portals":[],"floor_cells":r.room_cell_count,"landmark":r.landmark_name}
        for p in r.blocker_centers: rec.blockers.append(vec(p))
        for p in r.edge_spots: rec.edges.append(vec(p))
        for p in scene.plan.portals[id]:
            rec.portals.append({"point":vec(p.point-r.position),"direction":vec(p.out)})
        var pose=scene.poses[id].duplicate()
        for key in pose:
            if pose[key] is Vector3: pose[key]=vec(pose[key])
        rec["poses"]=pose
        records.append(rec)
    var file=FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Evidence/baseline-rooms.json",FileAccess.WRITE)
    file.store_string(JSON.stringify(records,"  "))
    print("BASELINE_EXPORTED ",records.size())
    scene.queue_free()
    await process_frame
    quit()
func vec(v): return [v.x,v.y,v.z]
