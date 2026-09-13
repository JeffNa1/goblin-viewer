extends SceneTree
func _init(): call_deferred("run")
func run():
    var scene=load("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/dungeon.tscn").instantiate()
    root.add_child(scene)
    while not scene.built:await process_frame
    for mesh in scene.rooms["08"].find_children("*","MeshInstance3D",true,false):
        if mesh.visible:mesh.create_trimesh_collision()
    await physics_frame
    await physics_frame
    scene.select_room("08","eye_level")
    var space=scene.get_world_3d().direct_space_state
    var target=scene.plan.world_point([1022,1134])+Vector3.UP*.6
    var camera=scene.camera.global_position
    var hit=space.intersect_ray(PhysicsRayQueryParameters3D.create(camera,target))
    print("ARCHIVE_HIT ",hit.collider.get_path() if not hit.is_empty() else "clear"," camera=",camera)
    var options=[]
    var sphere=SphereShape3D.new();sphere.radius=.15
    for z in [-3.,-2.,-1.,0.,1.,2.,3.]:
        for x in [-3.,-2.,-1.,0.,1.,2.,3.]:
            var p=camera+Vector3(x,0,z)
            var q=PhysicsShapeQueryParameters3D.new();q.shape=sphere;q.transform.origin=p
            if not space.intersect_shape(q).is_empty():continue
            if not space.intersect_ray(PhysicsRayQueryParameters3D.create(p,target)).is_empty():continue
            if space.intersect_ray(PhysicsRayQueryParameters3D.create(p-Vector3.UP*1.4,p-Vector3.UP*2.0)).is_empty():continue
            options.append({"position":str(p),"offset":x*x+z*z})
    options.sort_custom(func(a,b):return a.offset<b.offset)
    print("CLEAR_CAMERA_OPTIONS ",options.slice(0,10))
    quit()
