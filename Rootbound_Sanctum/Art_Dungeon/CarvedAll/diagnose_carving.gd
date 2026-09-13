extends SceneTree
func _init():call_deferred("run")
func run():
    var room=load("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Assets/02.scn").instantiate()
    root.add_child(room)
    var crest=room.find_children("Heraldry_02*","MeshInstance3D",true,false)[0]
    crest.create_trimesh_collision()
    var body=crest.get_child(0);body.collision_layer=2
    await physics_frame
    await physics_frame
    var space=root.world_3d.direct_space_state
    for y in [1.4,1.85,2.4]:
        var q=PhysicsRayQueryParameters3D.create(crest.to_global(Vector3(-1.23,y,1.2)),crest.to_global(Vector3(-1.23,y,-.4)),2)
        var hit=space.intersect_ray(q)
        print("CARVE_PROBE y=",y," hit=",crest.to_local(hit.position) if not hit.is_empty() else "miss")
    print("CREST children=",crest.get_child_count()," transform=",crest.global_transform)
    quit()
