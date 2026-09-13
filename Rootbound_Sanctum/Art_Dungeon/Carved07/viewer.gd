extends Node3D

const Grid = preload("res://Rootbound_Sanctum/Art_Dungeon/layout_grid.gd")
const BaseRoom = preload("res://Rootbound_Sanctum/Art_Dungeon/room_art.gd")
const VIEW_NAMES = ["shoulder", "eye_level", "carving", "fountain", "vessels", "portal", "overview", "corridor"]
var room
var passages
var camera: Camera3D
var figure: Node3D
var hud: CanvasLayer
var label: Label
var built: bool = false
var selected_view: String = "shoulder"
var phase: String = "after"

func _ready() -> void:
	get_window().title = "Rootbound Sanctum | Room 07 | True Cubic Carving"
	get_viewport().msaa_3d = Viewport.MSAA_4X
	phase = "before" if OS.get_cmdline_user_args().has("--baseline") else "after"
	var plan = Grid.new()
	plan.add_floor_collision(self)
	var lighting = BaseRoom.new()
	add_child(lighting)
	lighting._setup_lighting()
	lighting._make_scale_figure()
	figure = lighting.actor
	camera = Camera3D.new()
	camera.near = .08
	camera.far = 800
	camera.current = true
	add_child(camera)
	var path = "res://Rootbound_Sanctum/Art_Dungeon/Polish07/room_07.gd" if phase == "before" else "res://Rootbound_Sanctum/Art_Dungeon/Carved07/room_07.gd"
	room = load(path).new()
	room.name = "Room_07"
	add_child(room)
	for source in plan.data["rooms"]:
		if source["id"] == "07":
			room.configure(source, plan)
	passages = BaseRoom.new()
	passages.name = "OriginalPassages"
	add_child(passages)
	passages.configure({"id":"00", "box":[0,0,1200,1700], "blockers":[]}, plan)
	passages.visible = false
	_setup_ui()
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_view("shoulder")
	built = true
	print("CARVED07_VIEWER_READY phase=", phase)

func set_view(view: String) -> void:
	selected_view = view
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.fov = 68.0
	var origin: Vector3 = room.position
	figure.visible = view in ["shoulder", "corridor"]
	figure.rotation.y = 0
	passages.visible = view == "corridor"
	var p = Vector3.ZERO
	var target = Vector3(0,2.4,-4.32)
	match view:
		"shoulder":
			figure.position = origin + Vector3(2.98,.024,4.85)
			p = Vector3(3.60,1.704,6.60)
		"eye_level":
			p = Vector3(5.5,1.70,3.5)
		"carving":
			p = Vector3(6.7,2.8,-4.8)
			target = Vector3(4.35,3.05,-9.35)
			camera.fov = 58
		"fountain":
			p = Vector3(3.6,1.65,-.7)
			target = Vector3(0,1.8,-4)
			camera.fov = 62
		"vessels":
			p = Vector3(10.25,1.55,-3.25)
			target = Vector3(10.4,.58,-5.8)
			camera.fov = 52
		"portal":
			p = Vector3(1.2,1.7,-7.0)
			target = Vector3(0,3.0,-11.4)
			camera.fov = 66
		"overview":
			camera.projection = Camera3D.PROJECTION_ORTHOGONAL
			camera.size = 31.4
			p = Vector3(25.5,45,25.08)
			target = Vector3(0,1.8,0)
		"corridor":
			figure.position = origin + Vector3(-.45,.024,15.4)
			p = Vector3(.17,1.704,17.15)
			target = Vector3(0,2,-3)
	camera.position = origin + p
	camera.look_at(origin + target)
	label.text = "07 / QUIET SANCTUARY  |  " + phase.to_upper() + "  |  " + view.to_upper()

func _setup_ui() -> void:
	hud = CanvasLayer.new()
	add_child(hud)
	var panel = PanelContainer.new()
	panel.position = Vector2(18,18)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(.025,.055,.05,.94)
	style.content_margin_left = 16
	style.content_margin_right = 16
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel",style)
	hud.add_child(panel)
	var stack = VBoxContainer.new()
	panel.add_child(stack)
	label = Label.new()
	label.add_theme_color_override("font_color",Color("dfc797"))
	label.add_theme_font_size_override("font_size",18)
	stack.add_child(label)
	var help = Label.new()
	help.text = "1 Shoulder   2 Eye level   3 Carving   4 Fountain   5 Vessels   6 Portal   7 Overview   8 Corridor   H Hide UI\nRoom 07 art review only. No free walking or combat. Red figure is a scale proxy."
	help.add_theme_font_size_override("font_size",13)
	stack.add_child(help)

func _unhandled_key_input(event: InputEvent) -> void:
	if not built or not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode >= KEY_1 and event.keycode <= KEY_8:
		set_view(VIEW_NAMES[event.keycode - KEY_1])
	elif event.keycode == KEY_H:
		hud.visible = not hud.visible
