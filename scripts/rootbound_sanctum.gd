extends Node3D

const Builder = preload("res://scripts/rootbound_builder.gd")
var layout: Dictionary
var builder: RefCounted
var camera: Camera3D
var gates: Array[MeshInstance3D] = []
var target: Vector3
var yaw: float = 0.65
var overhead: bool = false
var selection: OptionButton
var detail: Label
var gate_button: Button
var inspection_open: bool = true

func _ready() -> void:
	get_window().title = "Rootbound Sanctum — B"
	layout = JSON.parse_string(FileAccess.get_file_as_string("res://data/rootbound_layout.json"))
	builder = Builder.new(layout)
	builder.build(self)
	builder.build_landmarks(self)
	_add_gates()
	_add_units()
	_setup_view()
	_setup_ui()
	focus_room(2)
	set_gate_flags({"sanctuary07": true, "elite09": true, "boss12": true, "discover13": true})
	print("ROOTBOUND_READY ", JSON.stringify({"rooms": builder.room_meshes.size(), "floor_cells": builder.floor_cells.size(), "triangles": builder.triangles}))

func _add_units() -> void:
	var positions = {"warrior": [495, 1135], "archer": [522, 1135], "shaman": [550, 1135], "rogue": [578, 1135], "chieftain": [695, 140]}
	for key in positions:
		var measurement: Dictionary = layout["unit_measurements"][key]
		var unit: Node3D = load(measurement["scene"]).instantiate()
		unit.name = "Reference_" + key
		add_child(unit)
		unit.play_anim("idle")
		unit._process(0.0)
		unit.set_process(false)
		unit.position = builder.world_point(positions[key])
		unit.position.y = -float(measurement["idle_body"]["min"][1])
		unit.add_to_group("rootbound_unit")
		unit.set_meta("archetype", key)
		var label = Label3D.new()
		label.text = key.to_upper()
		label.position = unit.position + Vector3(0.0, float(measurement["idle_body"]["size"][1]) + 0.65, 0.0)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.font_size = 32
		label.pixel_size = 0.01
		label.modulate = Color("eadfba")
		add_child(label)

func _add_gates() -> void:
	for link in layout["links"]:
		if not link.has("gate"):
			continue
		var a: Vector3 = builder.world_point(link["points"][0])
		var b: Vector3 = builder.world_point(link["points"][1])
		var tangent = (b - a).normalized()
		var group = Node3D.new()
		group.name = "Gate_" + link["a"] + "_" + link["b"]
		group.position = a.lerp(b, 0.5)
		group.rotation.y = atan2(tangent.x, tangent.z)
		add_child(group)
		var frame: Array = []
		for side in [-1, 1]:
			for x in range(side * 12 - 1, side * 12 + 2):
				for y in range(16):
					for z in range(-1, 2):
						frame.append([x, y, z, 0x989273 if y < 14 else 0xb4a476])
		for x in range(-10, 11):
			for y in range(14, 16):
				frame.append([x, y, 0, 0xb4a476])
		builder._mesh(group, "StoneFrame", frame)
		var bars: Array = []
		var color: int = 0x64a39a if link["gate"] == "sanctuary07" else 0xb69351
		for x in range(-10, 11):
			for y in range(14):
				if posmod(x, 4) == 0 or y == 3 or y == 11:
					bars.append([x, y, 0, color])
		var gate: MeshInstance3D = builder._mesh(group, "Portcullis", bars)
		gate.set_meta("condition", link["gate"])
		gates.append(gate)

func set_gate_flags(flags: Dictionary) -> void:
	# Inspection supplies these flags. Combat systems do not exist in this scene.
	for gate in gates:
		var open: bool = bool(flags.get(gate.get_meta("condition"), false))
		gate.visible = not open
		gate.set_meta("open", open)
		for body in gate.find_children("*", "StaticBody3D", true, false):
			body.collision_layer = 0 if open else 1

func _setup_view() -> void:
	var environment = WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = Color("1b2522")
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("c9d8c8")
	environment.environment.ambient_light_energy = 0.65
	add_child(environment)
	var sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-56.0, -32.0, 0.0)
	sun.light_color = Color("ffe9bd")
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 260.0
	add_child(sun)
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.far = 1000.0
	camera.current = true
	add_child(camera)

func _setup_ui() -> void:
	var layer = CanvasLayer.new()
	layer.name = "InspectionUI"
	add_child(layer)
	var panel = PanelContainer.new()
	panel.position = Vector2(18, 16)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.08, 0.065, 0.94)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 12.0
	panel.add_theme_stylebox_override("panel", style)
	layer.add_child(panel)
	var stack = VBoxContainer.new()
	panel.add_child(stack)
	var title = Label.new()
	title.text = "ROOTBOUND SANCTUM  /  B"
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color("dec68f"))
	stack.add_child(title)
	var row = HBoxContainer.new()
	stack.add_child(row)
	selection = OptionButton.new()
	for room in layout["rooms"]:
		selection.add_item(room["id"] + "  " + room["name"])
	selection.item_selected.connect(focus_room)
	row.add_child(selection)
	_add_button(row, "Overview", focus_overview)
	_add_button(row, "Scale", focus_scale)
	_add_button(row, "Boss", focus_boss)
	gate_button = _add_button(row, "Gates: open", _toggle_gates)
	detail = Label.new()
	detail.add_theme_color_override("font_color", Color("c5cdbd"))
	stack.add_child(detail)
	var help = Label.new()
	help.text = "WASD / arrows: pan   ·   Wheel: zoom   ·   Q / E: rotate   ·   Home: overview\nInspection only. Reference monsters are static. No combat, rewards, or level transitions."
	help.add_theme_font_size_override("font_size", 13)
	help.add_theme_color_override("font_color", Color("95aa99"))
	stack.add_child(help)

func _add_button(row: HBoxContainer, text: String, callback: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.pressed.connect(callback)
	row.add_child(button)
	return button

func focus_room(index: int) -> void:
	var room: Dictionary = layout["rooms"][index]
	var box: Array = room["box"]
	target = builder.world_point([float(box[0]) + float(box[2]) * 0.5, float(box[1]) + float(box[3]) * 0.5])
	camera.size = maxf(float(box[2]), float(box[3])) * builder.pixel_scale * 1.2
	overhead = false
	selection.select(index)
	detail.text = room["id"] + "  " + room["family"] + "  ·  %.1f × %.1f m envelope" % [float(box[2]) * builder.pixel_scale, float(box[3]) * builder.pixel_scale]
	_update_camera()

func focus_overview() -> void:
	selection.select(-1)
	selection.text = "All rooms"
	target = builder.world_point([557, 866]) - Vector3.RIGHT * 30.0
	camera.size = 223.0
	overhead = true
	detail.text = "14 approved spaces  ·  All reference monsters keep their original scene scale"
	_update_camera()

func focus_scale() -> void:
	focus_room(2)
	target = builder.world_point([537, 1128]) + Vector3.UP * 0.5
	camera.size = 14.0
	overhead = false
	detail.text = "Regular monsters at original scale  ·  0.24 m terrain voxels  ·  4.8 m corridor centerline width"
	_update_camera()

func focus_boss() -> void:
	focus_room(11)
	target = builder.world_point([695, 140]) + Vector3.UP
	camera.size = 14.0
	overhead = false
	detail.text = "Chieftain at original scale  ·  Body measured before map construction"
	_update_camera()

func _toggle_gates() -> void:
	inspection_open = not inspection_open
	set_gate_flags({"sanctuary07": inspection_open, "elite09": inspection_open, "boss12": inspection_open, "discover13": inspection_open})
	gate_button.text = "Gates: open" if inspection_open else "Gates: closed"

func _update_camera() -> void:
	if overhead:
		camera.position = target + Vector3(0.0, 300.0, 0.01)
		camera.look_at(target, Vector3.FORWARD)
	else:
		camera.position = target + Vector3(sin(yaw), 1.28, cos(yaw)) * camera.size
		camera.look_at(target, Vector3.UP)

func _process(delta: float) -> void:
	var move = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP): move.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN): move.y += 1.0
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT): move.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT): move.x += 1.0
	if move != Vector2.ZERO:
		var right = Vector3(camera.basis.x.x, 0.0, camera.basis.x.z).normalized()
		var forward = Vector3(camera.basis.z.x, 0.0, camera.basis.z.z).normalized()
		target += (right * move.x + forward * move.y).normalized() * camera.size * delta * 0.65
		_update_camera()
	if Input.is_physical_key_pressed(KEY_Q) or Input.is_physical_key_pressed(KEY_E):
		yaw += delta * (1.0 if Input.is_physical_key_pressed(KEY_Q) else -1.0)
		overhead = false
		_update_camera()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: camera.size = maxf(6.0, camera.size / 1.12)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: camera.size = minf(280.0, camera.size * 1.12)
		_update_camera()
	if event is InputEventKey and event.pressed and event.keycode == KEY_HOME:
		focus_overview()
