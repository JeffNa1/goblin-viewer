extends "res://Rootbound_Sanctum/Art_Dungeon/dungeon.gd"

const LoadingScreen = preload("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/loading.gd")
var asset_root = "res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Assets/"
var loading
var loading_failed := false
var world: Node3D
var loading_events: Array = []
var started_usec: int

func _ready() -> void:
    started_usec = Time.get_ticks_usec()
    get_window().title = "Rootbound Sanctum | All Carved Rooms"
    get_viewport().msaa_3d = Viewport.MSAA_4X
    loading = LoadingScreen.new()
    add_child(loading)
    world = Node3D.new()
    world.visible = false
    add_child(world)
    _setup_ui()
    hud.visible = false
    _record_loading("screen_visible",0.0)
    # The loading page must reach the display before any world construction.
    await get_tree().process_frame
    await RenderingServer.frame_post_draw
    plan = Grid.new()
    var names: Array[String] = ["floor","lighting"]
    for source in plan.data["rooms"]: names.append(source["id"])
    names.append("passages")
    var total = names.size()+1
    var done = 0
    for name in names:
        var path = asset_root+name+".scn"
        loading.update_progress(done,total,"Preparing "+name)
        if not ResourceLoader.exists(path):
            _fail_loading("Missing chamber: "+name)
            return
        var request = ResourceLoader.load_threaded_request(path,"PackedScene",false)
        if request != OK:
            _fail_loading("Cannot start chamber "+name)
            return
        while true:
            var progress: Array = []
            var status = ResourceLoader.load_threaded_get_status(path,progress)
            if status == ResourceLoader.THREAD_LOAD_LOADED: break
            if status in [ResourceLoader.THREAD_LOAD_FAILED,ResourceLoader.THREAD_LOAD_INVALID_RESOURCE]:
                _fail_loading("Cannot read chamber "+name)
                return
            loading.update_progress(done+(float(progress[0])*.9 if not progress.is_empty() else 0.0),total,"Preparing "+name)
            await get_tree().process_frame
        # Never call get before the background request reports LOADED.
        var packed = ResourceLoader.load_threaded_get(path)
        var node = packed.instantiate()
        world.add_child(node)
        if name == "lighting":
            figure = node.find_child("ScaleProxy",true,false)
            figure.visible = false
        elif name == "passages":
            passages = node
            passages.visible = false
        elif name != "floor":
            node.restore(plan)
            rooms[name] = node
            ids.append(name)
            picker.add_item(name+"  "+node.room_data["name"])
            node.visible = false
        done += 1
        loading.update_progress(done,total,"Ready "+name)
        _record_loading("loaded_"+name,loading.bar.value)
        await get_tree().process_frame
    camera = Camera3D.new()
    camera.near = .08
    camera.far = 800
    camera.current = true
    world.add_child(camera)
    await get_tree().physics_frame
    await get_tree().physics_frame
    _prepare_poses()
    if poses.size()!=14:
        _fail_loading("A chamber has no clear review camera")
        return
    select_map()
    world.visible = true
    loading.update_progress(done,total,"Preparing the full view")
    # Warm the actual full-map render under the opaque loading page.
    await RenderingServer.frame_post_draw
    await get_tree().process_frame
    await RenderingServer.frame_post_draw
    loading.update_progress(total,total,"Sanctuary ready")
    _record_loading("ready",100.0)
    built = true
    hud.visible = true
    loading.visible = false
    print("CARVED_ALL_READY rooms=",rooms.size()," loading_seconds=",float(Time.get_ticks_usec()-started_usec)/1000000.0)

func _record_loading(stage: String, progress: float) -> void:
    loading_events.append({"stage":stage,"progress":progress,"seconds":float(Time.get_ticks_usec()-started_usec)/1000000.0,"overlay_visible":loading.visible,"world_visible":world.visible,"built":built})

func _fail_loading(text: String) -> void:
    loading_failed = true
    loading.fail(text)
    _record_loading("failed",loading.bar.value)
    printerr("LOADING_FAILED ",text)

func select_room(id: String, view: String = "shoulder") -> void:
    if view == "detail":
        super.select_room(id,"eye_level")
        selected_view = "detail"
        camera.fov = 43
        camera.look_at(rooms[id].position+rooms[id].focus_point)
        figure.visible = false
        label.text = id+" / "+rooms[id].room_data["name"].to_upper()+" | DETAIL"
    else:
        super.select_room(id,view)

func _unhandled_key_input(event: InputEvent) -> void:
    if built and event is InputEventKey and event.pressed and not event.echo and event.keycode==KEY_4:
        select_room(selected_id,"detail")
    else:
        super._unhandled_key_input(event)
