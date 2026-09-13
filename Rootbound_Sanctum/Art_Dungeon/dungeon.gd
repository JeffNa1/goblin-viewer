extends Node3D

const Grid = preload("res://Rootbound_Sanctum/Art_Dungeon/layout_grid.gd")
const RoomArt = preload("res://Rootbound_Sanctum/Art_Dungeon/room_art.gd")
const VIEW_NAMES = ["shoulder", "eye_level", "overview"]
var plan
var rooms: Dictionary = {}
var passages
var camera: Camera3D
var figure: Node3D
var hud: CanvasLayer
var label: Label
var picker: OptionButton
var ids: Array[String] = []
var poses: Dictionary = {}
var selected_id: String = "01"
var selected_view: String = "shoulder"
var built: bool = false

func _ready() -> void:
	get_window().title = "Rootbound Sanctum | All Rooms Art Viewer"
	_setup_ui()
	await get_tree().process_frame
	plan = Grid.new()
	plan.add_floor_collision(self)
	var lighting = RoomArt.new()
	lighting.name = "LightingAndScaleFigure"
	add_child(lighting)
	lighting._setup_lighting()
	lighting._make_scale_figure()
	figure = lighting.actor
	figure.visible = false
	camera = Camera3D.new()
	camera.name = "ReviewCamera"
	camera.near = 0.08
	camera.far = 800.0
	camera.current = true
	add_child(camera)
	for source in plan.data["rooms"]:
		var id: String = source["id"]
		label.text = "BUILDING " + id + " / " + source["name"].to_upper()
		var room = RoomArt.new()
		room.name = "Room_" + id
		add_child(room)
		room.configure(source, plan)
		rooms[id] = room
		ids.append(id)
		picker.add_item(id + "  " + source["name"])
		room.visible = false
		await get_tree().process_frame
	passages = RoomArt.new()
	passages.name = "ConnectedPassages"
	add_child(passages)
	passages.configure({"id": "00", "name": "Connected Passages", "box": [0, 0, 1200, 1700], "blockers": []}, plan)
	passages.visible = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	_prepare_poses()
	built = true
	select_room("01", "shoulder")
	print("DUNGEON_ART_READY rooms=", rooms.size(), " links=", plan.data["links"].size())

func _prepare_poses() -> void:
	var space = get_world_3d().direct_space_state
	var capsule = CapsuleShape3D.new()
	capsule.radius = 0.45
	capsule.height = 1.8
	var sphere = SphereShape3D.new()
	sphere.radius = 0.16
	var distances = {"01": 7.0, "02": 7.0, "03": 10.5, "04": 6.5, "05": 7.0, "06": 7.0, "07": 9.5, "08": 6.8, "09": 8.0, "10": 6.0, "11": 9.5, "12": 10.5, "13": 5.0, "14": 6.5}
	for id in ids:
		var room = rooms[id]
		var target: Vector3 = room.position + room.focus_point
		var candidates: Array = []
		for cell in room.floor_cells:
			if posmod(cell.x, 4) != 0 or posmod(cell.y, 4) != 0:
				continue
			var point: Vector3 = room.position + Vector3(float(cell.x) * Grid.CELL, 0.024, float(cell.y) * Grid.CELL)
			var back = Vector3(point.x - target.x, 0, point.z - target.z)
			var distance = back.length()
			if distance < 3.0:
				continue
			back /= distance
			var preferred_back = Vector3.FORWARD if id == "14" else Vector3.BACK
			var score = absf(distance - distances[id]) * 4.0 + (1.0 - back.dot(preferred_back)) * 3.0
			candidates.append({"point": point, "score": score, "back": back})
		candidates.sort_custom(func(a, b): return a["score"] < b["score"])
		var picked: Dictionary = {}
		for candidate in candidates:
			var point: Vector3 = candidate["point"]
			var back: Vector3 = candidate["back"]
			var right = Vector3.UP.cross(back)
			var shoulder_cam = point + back * 1.75 + right * 0.62 + Vector3.UP * 1.68
			if _shape_clear(space, capsule, point + Vector3.UP * 0.98) and _shape_clear(space, sphere, shoulder_cam):
				var ray = PhysicsRayQueryParameters3D.create(point + Vector3.UP * 1.25, shoulder_cam)
				if space.intersect_ray(ray).is_empty():
					picked = {"actor": point, "back": back, "shoulder": shoulder_cam, "target": target}
					break
		if picked.is_empty():
			push_error("No clear shoulder camera for room " + id)
			continue
		var desired_eye: Vector3 = target + picked["back"].rotated(Vector3.UP, 0.55) * float(distances[id]) * 0.85
		if id == "05":
			desired_eye = target + Vector3.BACK * float(distances[id]) * 0.85
		elif id == "08":
			desired_eye = plan.world_point([987, 1218])
			picked["eye_target"] = plan.world_point([1022, 1134]) + Vector3.UP * 0.6
		elif id == "14":
			desired_eye = target + Vector3.FORWARD * float(distances[id]) * 0.85
		candidates.sort_custom(func(a, b): return a["point"].distance_squared_to(desired_eye) < b["point"].distance_squared_to(desired_eye))
		picked["eye_level"] = picked["actor"] + Vector3.UP * 1.68
		for candidate in candidates:
			var point: Vector3 = candidate["point"] + Vector3.UP * 1.68
			if picked.has("eye_target") and not space.intersect_ray(PhysicsRayQueryParameters3D.create(point, picked["eye_target"])).is_empty():
				continue
			if _shape_clear(space, sphere, point) and _shape_clear(space, capsule, candidate["point"] + Vector3.UP * 0.98):
				picked["eye_level"] = point
				break
		var extent: Vector2 = room.extent
		var reach = maxf(extent.x, extent.y)
		picked["overview"] = room.position + Vector3(extent.x * 0.85, reach * 1.5, extent.y * 1.1)
		picked["overview_target"] = room.position + Vector3.UP * 1.8
		picked["overview_size"] = reach * 0.78 + 8.0
		poses[id] = picked

func _shape_clear(space: PhysicsDirectSpaceState3D, shape: Shape3D, point: Vector3) -> bool:
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform.origin = point
	query.margin = 0.01
	return space.intersect_shape(query).is_empty()

func select_room(id: String, view: String = "shoulder") -> void:
	if not poses.has(id):
		push_error("Missing review pose: " + id)
		return
	selected_id = id
	selected_view = view
	for key in rooms:
		rooms[key].visible = key == id
	passages.visible = false
	var pose: Dictionary = poses[id]
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.fov = 68.0
	figure.visible = view == "shoulder"
	if view == "overview":
		camera.projection = Camera3D.PROJECTION_ORTHOGONAL
		camera.size = pose["overview_size"]
		camera.position = pose["overview"]
		camera.look_at(pose["overview_target"])
	else:
		camera.position = pose[view]
		camera.look_at(pose.get("eye_target", pose["target"]) if view == "eye_level" else pose["target"])
	figure.global_position = pose["actor"]
	figure.rotation.y = atan2(pose["back"].x, pose["back"].z)
	label.text = id + " / " + rooms[id].room_data["name"].to_upper() + "  |  " + view.replace("_", " ").to_upper()
	picker.select(ids.find(id))

func select_map() -> void:
	selected_view = "map"
	for room in rooms.values():
		room.visible = true
	passages.visible = true
	figure.visible = false
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 188.0
	camera.position = Vector3(110, 240, 220)
	camera.look_at(Vector3(0, 0, -12))
	label.text = "ROOTBOUND SANCTUM / CONNECTED ART LAYOUT"

func _setup_ui() -> void:
	hud = CanvasLayer.new()
	add_child(hud)
	var panel = PanelContainer.new()
	panel.position = Vector2(18, 18)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.055, 0.05, 0.94)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)
	hud.add_child(panel)
	var stack = VBoxContainer.new()
	panel.add_child(stack)
	label = Label.new()
	label.text = "BUILDING ROOTBOUND SANCTUM"
	label.add_theme_color_override("font_color", Color("dfc797"))
	label.add_theme_font_size_override("font_size", 18)
	stack.add_child(label)
	picker = OptionButton.new()
	picker.focus_mode = Control.FOCUS_NONE
	picker.item_selected.connect(func(index): select_room(ids[index], "shoulder"))
	stack.add_child(picker)
	var help = Label.new()
	help.text = "Left / Right: room    1: shoulder    2: eye level    3: overview    M: whole map    H: hide UI\nArt viewer only. No walking controller or combat. Scale figure is not the player character."
	help.add_theme_font_size_override("font_size", 13)
	help.add_theme_color_override("font_color", Color("a8bfb3"))
	stack.add_child(help)

func _unhandled_key_input(event: InputEvent) -> void:
	if not built or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_RIGHT or event.keycode == KEY_LEFT:
		var step = 1 if event.keycode == KEY_RIGHT else -1
		select_room(ids[posmod(ids.find(selected_id) + step, ids.size())], "shoulder")
	elif event.keycode >= KEY_1 and event.keycode <= KEY_3:
		select_room(selected_id, VIEW_NAMES[event.keycode - KEY_1])
	elif event.keycode == KEY_M:
		select_map()
	elif event.keycode == KEY_H:
		hud.visible = not hud.visible
