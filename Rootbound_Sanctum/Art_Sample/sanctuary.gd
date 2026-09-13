extends Node3D

# Isolated art slice. No character or original map script is changed or loaded.
const CELL: float = 0.24
const WOOD_CELL: float = 0.12
const STONE = [0x566761, 0x65736a, 0x728074, 0x7e8b79, 0x909980]
const FLOOR = [0x455650, 0x4e5e58, 0x57655b, 0x606d61]
const LEAF = [0x263f32, 0x38543a, 0x4b6a3c, 0x688648]
const BARK = [0x44392e, 0x594331, 0x715038, 0x876342]
const GOLD: int = 0xbca06a
const JADE: int = 0x69c9b5
const VIEWS = ["shoulder", "corridor", "eye_level", "overview", "detail"]
var source_room_id: String = "07"
var room_cell_count: int = 0
var geometry_stats: Dictionary = {"voxel_triangles": 0, "block_instances": 0, "batches": 0}
var floor_cells: Dictionary = {}
var batches: Dictionary = {}
var camera: Camera3D
var actor: Node3D
var hud: CanvasLayer
var view_label: Label
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	get_window().title = "Rootbound Sanctum | Sanctuary Art Sample"
	rng.seed = 70317
	_build_footprint()
	_build_floor_detail()
	_build_architecture()
	_build_shrine()
	_build_dressing()
	_flush_blocks()
	_setup_lighting()
	_make_scale_figure()
	camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.near = 0.08
	camera.far = 160.0
	camera.current = true
	add_child(camera)
	_setup_hud()
	set_view("shoulder")
	print("SANCTUARY_ART_READY ", JSON.stringify(geometry_stats))

func _color(value: int) -> Color:
	return Color(float((value >> 16) & 255) / 255.0, float((value >> 8) & 255) / 255.0, float(value & 255) / 255.0)

func _build_footprint() -> void:
	var layout: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/rootbound_layout.json"))
	var polygon = PackedVector2Array()
	for room in layout["rooms"]:
		if room["id"] == source_room_id:
			for p in room["polygon"]:
				polygon.append(Vector2((float(p[0]) - 500.0) * 0.12, (float(p[1]) - 685.0) * 0.12))
	for x in range(-80, 81):
		for z in range(-65, 80):
			var point = Vector2(float(x) * CELL, float(z) * CELL)
			var in_room = Geometry2D.is_point_in_polygon(point, polygon)
			var south = absf(point.x) <= 2.4 and point.y >= 10.8 and point.y <= 18.24
			var north = absf(point.x) <= 2.4 and point.y <= -10.8 and point.y >= -14.4
			var sides = absf(point.y) <= 2.4 and absf(point.x) >= 13.5 and absf(point.x) <= 18.24
			if in_room or south or north or sides:
				floor_cells[Vector2i(x, z)] = true
				if in_room:
					room_cell_count += 1
	var floor_grid: Dictionary = {}
	for cell in floor_cells:
		var tile_x = floori(float(cell.x) / 4.0)
		var tile_z = floori(float(cell.y) / 4.0)
		var color: int = FLOOR[posmod(tile_x * 19 + tile_z * 31, FLOOR.size())]
		if posmod(cell.x, 4) == 0 or posmod(cell.y, 4) == 0:
			color = 0x34463f
		# Worn brass route lines are flush with the stone, not raised obstacles.
		if (abs(cell.x) == 7 and cell.y >= 5) or (abs(cell.x) == 17 and cell.y < 5 and cell.y > -35):
			color = GOLD if posmod(cell.y, 11) != 0 else 0x57655b
		floor_grid[Vector3i(cell.x, -1, cell.y)] = color
		floor_grid[Vector3i(cell.x, -2, cell.y)] = 0x293e36
	_emit_grid("Foundation", floor_grid, CELL, Vector3(0, CELL * 0.5, 0), true)
	var boundary: Dictionary = {}
	for cell in floor_cells:
		for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var outside: Vector2i = cell + offset
			if not floor_cells.has(outside):
				boundary[outside] = true
	var thick = boundary.duplicate()
	for cell in boundary:
		for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			if not floor_cells.has(cell + offset):
				thick[cell + offset] = true
	var wall_grid: Dictionary = {}
	for cell in thick:
		var height: int = 26
		if abs(cell.x) > 70 or cell.y > 73 or cell.y < -57:
			# Dark cut ends keep the art slice self-contained.
			height = 23
		for y in range(height):
			var row = floori(float(y) / 3.0)
			var column = floori(float(cell.x + cell.y + posmod(row, 2) * 3) / 6.0)
			var color: int = STONE[posmod(column * 7 + row * 11, 4)]
			if posmod(y, 3) == 0 or posmod(cell.x + cell.y + posmod(row, 2) * 3, 6) == 0:
				color = 0x56655b
			if y < 3:
				color = 0x4b5f50
			if y == height - 1 or y == 19:
				color = 0x9ba58a
			wall_grid[Vector3i(cell.x, y, cell.y)] = color
	_emit_grid("Masonry", wall_grid, CELL, Vector3(0, CELL * 0.5, 0), true)

func _build_floor_detail() -> void:
	# Millimeter relief on the existing foundation makes thin real slab joints.
	for x in range(-80, 80, 4):
		for z in range(-64, 80, 4):
			if not (floor_cells.has(Vector2i(x, z)) and floor_cells.has(Vector2i(x + 3, z)) and floor_cells.has(Vector2i(x, z + 3)) and floor_cells.has(Vector2i(x + 3, z + 3))):
				continue
			var p = Vector3((float(x) + 1.5) * CELL, 0.012, (float(z) + 1.5) * CELL)
			var tone: int = FLOOR[posmod(floori(float(x) / 4.0) * 19 + floori(float(z) / 4.0) * 31, FLOOR.size())]
			_box(p, Vector3(0.93, 0.024, 0.93), tone)
			if posmod(x * 7 + z * 11, 28) == 0:
				_box(p + Vector3(0.3, 0.014, 0.27), Vector3(0.18, 0.004, 0.06), 0x3c4f45)
				_box(p + Vector3(0.39, 0.014, 0.18), Vector3(0.06, 0.004, 0.18), 0x3c4f45)
			if p.length() > 9.0 and posmod(x + z * 3, 20) == 0:
				_box(p + Vector3(-0.3, 0.014, -0.3), Vector3(0.24, 0.004, 0.3), 0x496448)
	for side in [-1, 1]:
		_box(Vector3(float(side) * 1.8, 0.028, 9.6), Vector3(0.06, 0.008, 16.8), GOLD)
		_box(Vector3(float(side) * 4.08, 0.028, -3.2), Vector3(0.06, 0.008, 9.6), GOLD)
		# The approach walls get physical joints and chipped offsets for close views.
		for row in range(11):
			for brick in range(7):
				var z = 11.52 + float(brick) * 0.96 + float(row % 2) * 0.48
				_box(Vector3(float(side) * 2.5, 0.24 + float(row) * 0.48, z), Vector3(0.12, 0.444, 0.918), STONE[(row + brick) % 4])

func _build_architecture() -> void:
	for side in [-1, 1]:
		for z in [-6.9, 6.9]:
			_pillar(Vector3(float(side) * 10.6, 0, z), 6.3)
		for x in [-5.9, 5.9]:
			_pillar(Vector3(x, 0, float(side) * 9.0), 6.3)
	_arch(Vector3(0, 0, 11.4), 0.0)
	_arch(Vector3(0, 0, 16.6), 0.0)
	_arch(Vector3(0, 0, -11.4), 0.0)
	_arch(Vector3(-15, 0, 0), PI * 0.5)
	_arch(Vector3(15, 0, 0), PI * 0.5)
	# Repeated coffer ribs make the close corridor read as enclosed architecture.
	for z in [12.4, 13.6, 14.8, 17.8]:
		_box(Vector3(0, 5.85, z), Vector3(5.25, 0.36, 0.36), 0x8b947c)
	_box(Vector3(0, 6.13, 14.8), Vector3(5.28, 0.24, 6.96), 0x415349)
	_solid_box("CorridorRoof", Vector3(0, 6.13, 14.8), Vector3(5.28, 0.24, 6.96))
	# High, broken vault ribs remain above the camera and fighting volume.
	for z in [-6.8, 6.8]:
		for side in [-1, 1]:
			for step in range(15):
				var x: float = float(side) * (10.6 - float(step) * 0.48)
				var y = snappedf(6.3 + sin(float(step) / 18.0 * PI * 0.5) * 2.5, 0.12)
				_box(Vector3(x, y, z), Vector3(0.6, 0.48, 0.6), STONE[step % STONE.size()])
	# Raised heraldry panels beside the northern doorway.
	for side in [-1, 1]:
		var p = Vector3(float(side) * 4.35, 0, -9.7)
		_relief(p)
		_brazier(Vector3(float(side) * 3.1, 0, -8.8))
	for side in [-1, 1]:
		_torch(Vector3(float(side) * 2.24, 2.6, 13.5))
		_torch(Vector3(float(side) * 2.24, 2.6, 17.5))

func _pillar(p: Vector3, height: float) -> void:
	for tier in range(3):
		_box(p + Vector3(0, 0.12 + float(tier) * 0.24, 0), Vector3(1.68 - float(tier) * 0.24, 0.24, 1.68 - float(tier) * 0.24), STONE[4 - tier])
	for row in range(10):
		_box(p + Vector3(0, 0.93 + float(row) * 0.48, 0), Vector3(0.96, 0.44, 0.96), STONE[(row + 1) % 4])
	for side in [-1, 1]:
		_box(p + Vector3(float(side) * 0.48, 3, -0.18), Vector3(0.12, 4.56, 0.18), 0x929c82)
		_box(p + Vector3(-0.18, 3, float(side) * 0.48), Vector3(0.18, 4.56, 0.12), 0x929c82)
	for band in [0.72, 2.16, 5.76]:
		_box(p + Vector3(0, band, 0), Vector3(1.2, 0.12, 1.2), GOLD)
	for tier in range(3):
		_box(p + Vector3(0, height - 0.54 + float(tier) * 0.24, 0), Vector3(1.08 + float(tier) * 0.3, 0.24, 1.08 + float(tier) * 0.3), STONE[2 + tier])
	_solid_box("Pillar", p + Vector3(0, height * 0.5, 0), Vector3(1.2, height, 1.2))

func _arch(p: Vector3, yaw: float) -> void:
	var basis = Basis(Vector3.UP, yaw)
	for side in [-1, 1]:
		for row in range(9):
			_box(p + basis * Vector3(float(side) * 2.88, 0.24 + float(row) * 0.48, 0), Vector3(0.9, 0.44, 1.08), STONE[(row + 2) % STONE.size()], yaw)
		for y in [0.24, 3.0, 4.2]:
			_box(p + basis * Vector3(float(side) * 2.88, y, 0), Vector3(1.2, 0.24, 1.32), GOLD if y == 3.0 else 0x9ba58a, yaw)
		_solid_box("PortalJamb", p + basis * Vector3(float(side) * 2.88, 2.1, 0), Vector3(0.96, 4.2, 1.08), yaw)
	for step in range(-10, 11):
		var x: float = float(step) * 0.24
		var y = snappedf(3.0 + sqrt(maxf(0.0, 5.76 - x * x)), 0.24)
		_box(p + basis * Vector3(x, y + 0.3, 0), Vector3(0.24, 0.6, 1.08), STONE[posmod(step, STONE.size())], yaw)
		_box(p + basis * Vector3(x, y + 0.07, 0.6), Vector3(0.24, 0.12, 0.12), GOLD, yaw)
	_box(p + Vector3(0, 5.7, 0), Vector3(0.72, 0.72, 1.44), 0xa5ad89, yaw)
	_box(p + basis * Vector3(0, 5.73, 0.78), Vector3(0.18, 0.42, 0.12), JADE, yaw, "jade")

func _relief(p: Vector3) -> void:
	_box(p + Vector3(0, 2.9, 0), Vector3(1.92, 4.8, 0.36), 0x354b40)
	for side in [-1, 1]:
		_box(p + Vector3(float(side) * 1.02, 2.9, 0.12), Vector3(0.24, 4.92, 0.36), 0x93a084)
	_box(p + Vector3(0, 5.4, 0.12), Vector3(2.28, 0.24, 0.48), GOLD)
	_box(p + Vector3(0, 1.0, 0.36), Vector3(1.56, 0.3, 0.84), 0x93a084)
	_box(p + Vector3(0, 2.4, 0.36), Vector3(0.72, 2.52, 0.48), 0x738a73)
	_box(p + Vector3(0, 3.54, 0.48), Vector3(1.08, 1.08, 0.72), 0x96a58b)
	for side in [-1, 1]:
		_box(p + Vector3(float(side) * 0.3, 3.66, 0.88), Vector3(0.18, 0.12, 0.12), JADE, 0, "jade")
		for i in range(4):
			_box(p + Vector3(float(side) * (0.24 + float(i) * 0.12), 4.08 + float(i) * 0.12, 0.48), Vector3(0.24, 0.24, 0.48), GOLD)
	_box(p + Vector3(0, 3.0, 0.88), Vector3(0.24, 0.24, 0.12), 0x344b3e)

func _build_shrine() -> void:
	var center = Vector3(0, 0, -4.32)
	# Every tier stays within the approved central blocker footprint.
	_box(center + Vector3(0, 0.12, 0), Vector3(5.04, 0.24, 4.08), 0x8c967d)
	_box(center + Vector3(0, 0.36, 0), Vector3(4.56, 0.24, 3.6), 0x566c5b)
	_box(center + Vector3(0, 0.54, 0), Vector3(4.08, 0.12, 3.12), 0x27685f, 0, "water")
	for side in [-1, 1]:
		_box(center + Vector3(float(side) * 2.16, 0.6, 0), Vector3(0.24, 0.48, 3.84), 0x9aa78a)
		_box(center + Vector3(0, 0.6, float(side) * 1.8), Vector3(4.56, 0.48, 0.24), 0x9aa78a)
		_box(center + Vector3(0, 0.84, float(side) * 1.8), Vector3(4.68, 0.12, 0.36), GOLD)
	_solid_box("ApprovedShrineBlocker", center + Vector3(0, 0.48, 0), Vector3(5.04, 0.96, 4.08))
	for i in range(24):
		var p = center + Vector3(rng.randf_range(-1.92, 1.92), 0.612, rng.randf_range(-1.44, 1.44))
		_box(p, Vector3(0.24 * float(rng.randi_range(1, 3)), 0.024, 0.12), 0x6db5a3, 0, "water")
	var wood: Dictionary = {}
	_root_path(wood, [center + Vector3(0, 0.6, 0), center + Vector3(-0.48, 2, -0.24), center + Vector3(-0.84, 3.7, -0.48), center + Vector3(-0.36, 5.2, -0.72), center + Vector3(0.6, 7.5, -1.2)], 0.84, 0.24)
	_root_path(wood, [center + Vector3(-0.5, 2.5, -0.2), center + Vector3(1.2, 3.8, -0.4), center + Vector3(3.5, 5.4, -1), center + Vector3(6.5, 6.5, -1.6), center + Vector3(8.8, 7.2, -3)], 0.55, 0.1)
	_root_path(wood, [center + Vector3(-0.7, 3.2, -0.3), center + Vector3(-2.2, 4.5, -0.4), center + Vector3(-4.5, 5.1, 0.2), center + Vector3(-6.8, 6.5, 1.8)], 0.48, 0.08)
	_root_path(wood, [center + Vector3(-0.3, 4.8, -0.7), center + Vector3(-2, 6, -1.9), center + Vector3(-3.8, 7.6, -3)], 0.34, 0.08)
	for i in range(9):
		var angle = TAU * float(i) / 9.0
		var endpoint = center + Vector3(cos(angle) * 1.88, 0.66, sin(angle) * 1.4)
		_root_path(wood, [center + Vector3(-0.24, 1.7, 0), center + Vector3(cos(angle) * 0.96, 0.84, sin(angle)), endpoint], 0.34, 0.1)
	_emit_grid("Heartwood", wood, WOOD_CELL, Vector3.ZERO, false)
	# A suspended, stepped jade heart is the room's primary focal point.
	for i in range(7):
		var width = 0.18 * float(4 - absi(i - 3))
		_box(center + Vector3(0.26, 2.4 + float(i) * 0.18, 0.72), Vector3(width, 0.18, width), JADE, 0, "jade")
	for y in [2.2, 3.8]:
		_box(center + Vector3(0.24, y, 0.72), Vector3(0.96, 0.12, 0.48), GOLD)
	for x in [-1.8, 1.8]:
		_candles(center + Vector3(x, 0.84, 1.65))
	for point in [Vector3(-6.4, 6.4, -2.8), Vector3(-3.5, 7.5, -7.3), Vector3(6.4, 6.5, -5.8), Vector3(8.4, 7.1, -7.1), Vector3(0.4, 7.5, -5.5)]:
		_foliage(point, 1.25, 28)
	_light(center + Vector3(0.3, 3, 1.4), 0x6ae0c4, 1.8, 9.5, true)

func _build_dressing() -> void:
	# Edge dressing never occupies the tested approach or ring around the shrine.
	for side in [-1, 1]:
		for z in [-6.7, 6.7]:
			var p = Vector3(float(side) * 11.7, 0, z)
			var wood: Dictionary = {}
			_root_path(wood, [p, p + Vector3(-float(side) * 0.6, 1.2, 0.2), p + Vector3(0, 3.4, -0.24), p + Vector3(float(side) * 0.5, 5.6, -1.2), p + Vector3(-float(side) * 1.2, 7.1, -2.1)], 0.48, 0.1)
			_emit_grid("WallRoots", wood, WOOD_CELL, Vector3.ZERO, false)
			_foliage(p + Vector3(0, 6.1, -1.3), 1.2, 20)
			_foliage(p + Vector3(-float(side) * 0.4, 0.35, 0.5), 0.6, 14)
			for i in range(10):
				var rock = p + Vector3(rng.randf_range(-0.8, 0.8), 0.12, rng.randf_range(-0.8, 0.8))
				_box(rock, Vector3(0.36, 0.24, 0.48), STONE[rng.randi_range(0, 4)])
			_urn(p + Vector3(-float(side) * 1.3, 0, 0.9))
			_brazier(p + Vector3(-float(side) * 2.3, 0, 1.2))
	for side in [-1, 1]:
		for z in [3.0, -3.0]:
			_urn(Vector3(float(side) * 12.4, 0, z))
			_candles(Vector3(float(side) * 11.8, 0, z + 0.8))
	# Moss falls from selected joints instead of coating every surface uniformly.
	for x in [-5.9, 5.9]:
		for z in [-9.0, 9.0]:
			for level in range(10):
				var p = Vector3(x + sin(float(level) * 0.7) * 0.24, 5.5 - float(level) * 0.3, z + (0.6 if z < 0 else -0.6))
				_box(p, Vector3(0.42, 0.36, 0.18), LEAF[level % LEAF.size()])
	for side in [-1, 1]:
		for z in [12.1, 15.1, 17.7]:
			var p = Vector3(float(side) * 1.96, 0.02, z)
			for i in range(5):
				_box(p + Vector3(rng.randf_range(-0.15, 0.15), 0.08, rng.randf_range(-0.3, 0.3)), Vector3(0.12, 0.16, 0.12), LEAF[i % 4])
			_mushroom(p + Vector3(-float(side) * 0.16, 0, 0.3))

func _root_path(grid: Dictionary, points: Array, start_radius: float, end_radius: float) -> void:
	for section in range(points.size() - 1):
		var a: Vector3 = points[section]
		var b: Vector3 = points[section + 1]
		var steps = maxi(2, ceili(a.distance_to(b) / (WOOD_CELL * 0.7)))
		for step in range(steps + 1):
			var t = float(step) / float(steps)
			var p = a.lerp(b, t)
			var progress = (float(section) + t) / float(points.size() - 1)
			var radius = lerpf(start_radius, end_radius, progress)
			var cell = Vector3i(roundi(p.x / WOOD_CELL), roundi(p.y / WOOD_CELL), roundi(p.z / WOOD_CELL))
			var extent = ceili(radius / WOOD_CELL)
			for x in range(-extent, extent + 1):
				for y in range(-extent, extent + 1):
					for z in range(-extent, extent + 1):
						if Vector3(x, y, z).length() * WOOD_CELL > radius:
							continue
						var key = cell + Vector3i(x, y, z)
						grid[key] = BARK[posmod(floori(float(key.x) / 2.0) + floori(float(key.z) / 2.0), BARK.size())]

func _foliage(p: Vector3, radius: float, amount: int) -> void:
	for i in range(amount):
		var offset = Vector3(rng.randf_range(-radius, radius), rng.randf_range(-radius * 0.35, radius * 0.35), rng.randf_range(-radius, radius))
		var size = rng.randf_range(0.24, 0.72)
		_box((p + offset).snapped(Vector3.ONE * 0.12), Vector3(size, size * 0.6, size).snapped(Vector3.ONE * 0.12), LEAF[i % LEAF.size()])

func _urn(p: Vector3) -> void:
	_box(p + Vector3(0, 0.12, 0), Vector3(0.48, 0.24, 0.48), 0x6b5841)
	_box(p + Vector3(0, 0.42, 0), Vector3(0.72, 0.36, 0.72), 0x8e7957)
	_box(p + Vector3(0, 0.72, 0), Vector3(0.48, 0.24, 0.48), 0x9c8d68)
	for side in [-1, 1]:
		_box(p + Vector3(float(side) * 0.24, 0.9, 0), Vector3(0.12, 0.12, 0.6), GOLD)
		_box(p + Vector3(0, 0.9, float(side) * 0.24), Vector3(0.36, 0.12, 0.12), GOLD)

func _candles(p: Vector3) -> void:
	for i in range(4):
		var h = 0.18 + float(i % 3) * 0.12
		var center = p + Vector3(float(i - 2) * 0.18, h * 0.5, float(i % 2) * 0.18)
		_box(center, Vector3(0.12, h, 0.12), 0xd5c69c)
		_box(center + Vector3(0, h * 0.5 + 0.06, 0), Vector3(0.06, 0.12, 0.06), 0xffd481, 0, "flame")

func _mushroom(p: Vector3) -> void:
	_box(p + Vector3(0, 0.18, 0), Vector3(0.12, 0.36, 0.12), 0x6b9580)
	_box(p + Vector3(0, 0.36, 0), Vector3(0.48, 0.12, 0.36), 0x7bcbaf, 0, "jade")
	_box(p + Vector3(0, 0.48, 0), Vector3(0.24, 0.12, 0.24), 0xa8ddbd, 0, "jade")

func _brazier(p: Vector3) -> void:
	_box(p + Vector3(0, 0.12, 0), Vector3(0.96, 0.24, 0.96), 0x839277)
	_box(p + Vector3(0, 0.66, 0), Vector3(0.36, 0.84, 0.36), 0x45574a)
	_box(p + Vector3(0, 1.2, 0), Vector3(0.84, 0.24, 0.84), GOLD)
	for i in range(5):
		_box(p + Vector3(float(i % 3 - 1) * 0.18, 1.46 + float(i % 2) * 0.18, float(i / 3) * 0.18 - 0.1), Vector3(0.18, 0.3, 0.18), 0xffb75f, 0, "flame")
	_light(p + Vector3(0, 1.9, 0), 0xffc481, 2.4, 8, true)
	_solid_box("Brazier", p + Vector3(0, 0.72, 0), Vector3(0.84, 1.44, 0.84))

func _torch(p: Vector3) -> void:
	_box(p - Vector3(0, 0.36, 0), Vector3(0.12, 0.84, 0.12), 0x53422e)
	_box(p, Vector3(0.3, 0.24, 0.3), GOLD)
	_box(p + Vector3(0, 0.3, 0), Vector3(0.24, 0.42, 0.24), 0xffbd69, 0, "flame")
	_box(p + Vector3(0, 0.48, 0), Vector3(0.12, 0.3, 0.12), 0xffe6ae, 0, "flame")
	_light(p + Vector3(0, 0.3, 0), 0xffbc70, 2, 6.5, true)

func _box(p: Vector3, size: Vector3, color: int, yaw: float = 0.0, kind: String = "stone") -> void:
	var key = "%s_%d_%d" % [kind, floori(p.x / 6.0), floori(p.z / 6.0)]
	if not batches.has(key):
		batches[key] = {"kind": kind, "items": []}
	batches[key]["items"].append([Transform3D(Basis(Vector3.UP, yaw).scaled(size), p), color])

func _flush_blocks() -> void:
	for key in batches:
		var batch: Dictionary = batches[key]
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		material.vertex_color_is_srgb = true
		material.roughness = 0.92
		material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		if batch["kind"] == "flame" or batch["kind"] == "jade":
			material.emission_enabled = true
			material.emission = _color(0xffc373 if batch["kind"] == "flame" else 0x4cab95)
			material.emission_energy_multiplier = 1.0 if batch["kind"] == "flame" else 0.4
		if batch["kind"] == "water":
			material.roughness = 0.3
		var cube = BoxMesh.new()
		cube.size = Vector3.ONE
		cube.material = material
		var mm = MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_colors = true
		mm.mesh = cube
		mm.instance_count = batch["items"].size()
		for i in range(mm.instance_count):
			mm.set_instance_transform(i, batch["items"][i][0])
			mm.set_instance_color(i, _color(batch["items"][i][1]))
		var instance = MultiMeshInstance3D.new()
		instance.name = "Detail_" + key
		instance.multimesh = mm
		add_child(instance)
		geometry_stats["block_instances"] += mm.instance_count
		geometry_stats["batches"] += 1
	batches.clear()

func _emit_grid(node_name: String, grid: Dictionary, scale_value: float, offset: Vector3, solid: bool) -> void:
	# Face culling spans chunk boundaries. Chunks also localize light influence.
	var half = scale_value * 0.5
	var directions = [Vector3i.RIGHT, Vector3i.LEFT, Vector3i.UP, Vector3i.DOWN, Vector3i.BACK, Vector3i.FORWARD]
	var corners = [
		[Vector3(half,-half,half), Vector3(half,-half,-half), Vector3(half,half,-half), Vector3(half,half,half)],
		[Vector3(-half,-half,-half), Vector3(-half,-half,half), Vector3(-half,half,half), Vector3(-half,half,-half)],
		[Vector3(-half,half,half), Vector3(half,half,half), Vector3(half,half,-half), Vector3(-half,half,-half)],
		[Vector3(-half,-half,-half), Vector3(half,-half,-half), Vector3(half,-half,half), Vector3(-half,-half,half)],
		[Vector3(-half,-half,half), Vector3(half,-half,half), Vector3(half,half,half), Vector3(-half,half,half)],
		[Vector3(half,-half,-half), Vector3(-half,-half,-half), Vector3(-half,half,-half), Vector3(half,half,-half)]
	]
	var surfaces: Dictionary = {}
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	material.vertex_color_is_srgb = true
	material.roughness = 0.94
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	for cell in grid:
		var center = Vector3(cell) * scale_value
		var key = Vector2i(floori(center.x / 6.0), floori(center.z / 6.0))
		for face in range(6):
			if grid.has(cell + directions[face]):
				continue
			if not surfaces.has(key):
				var tool = SurfaceTool.new()
				tool.begin(Mesh.PRIMITIVE_TRIANGLES)
				tool.set_material(material)
				surfaces[key] = tool
			var st: SurfaceTool = surfaces[key]
			st.set_color(_color(grid[cell]))
			st.set_normal(Vector3(directions[face]))
			for index in [0, 2, 1, 0, 3, 2]:
				st.add_vertex(center + corners[face][index])
			geometry_stats["voxel_triangles"] += 2
	for key in surfaces:
		var st: SurfaceTool = surfaces[key]
		st.index()
		var instance = MeshInstance3D.new()
		instance.name = node_name + "_%d_%d" % [key.x, key.y]
		instance.mesh = st.commit()
		instance.position = offset
		add_child(instance)
		if solid:
			instance.create_trimesh_collision()

func _solid_box(node_name: String, p: Vector3, size: Vector3, yaw: float = 0.0) -> void:
	var body = StaticBody3D.new()
	body.name = node_name
	body.position = p
	body.rotation.y = yaw
	var collider = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)
	add_child(body)

func _light(p: Vector3, color: int, energy: float, radius: float, shadows: bool) -> void:
	var light = OmniLight3D.new()
	light.position = p
	light.light_color = _color(color)
	light.light_energy = energy
	light.omni_range = radius
	light.omni_attenuation = 1.2
	light.shadow_enabled = shadows
	light.shadow_bias = 0.03
	add_child(light)

func _setup_lighting() -> void:
	var world = WorldEnvironment.new()
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("11272b")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("95b8b2")
	env.ambient_light_energy = 0.42
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 1.12
	env.tonemap_white = 4.0
	env.ssao_enabled = true
	env.ssao_radius = 1.1
	env.ssao_intensity = 1.7
	env.glow_enabled = true
	env.glow_intensity = 0.4
	world.environment = env
	add_child(world)
	var moon = DirectionalLight3D.new()
	moon.rotation_degrees = Vector3(-56, -38, 0)
	moon.light_color = Color("bfdfd8")
	moon.light_energy = 0.95
	moon.shadow_enabled = true
	moon.directional_shadow_max_distance = 85.0
	moon.shadow_bias = 0.02
	add_child(moon)
	_light(Vector3(-5, 6, 1), 0xadc9b5, 0.8, 15, false)

func _make_scale_figure() -> void:
	actor = Node3D.new()
	actor.name = "ScaleFigure_NotPlayerCharacter"
	add_child(actor)
	var pieces = [
		[Vector3(-0.16, 0.12, 0), Vector3(0.24, 0.24, 0.42), 0x29383f],
		[Vector3(0.16, 0.12, 0), Vector3(0.24, 0.24, 0.42), 0x29383f],
		[Vector3(-0.16, 0.55, 0), Vector3(0.24, 0.62, 0.24), 0x515954],
		[Vector3(0.16, 0.55, 0), Vector3(0.24, 0.62, 0.24), 0x515954],
		[Vector3(0, 1.12, 0), Vector3(0.6, 0.6, 0.36), 0x758d8f],
		[Vector3(0, 1.22, 0.24), Vector3(0.6, 0.84, 0.12), 0x813f38],
		[Vector3(-0.43, 1.03, 0), Vector3(0.24, 0.7, 0.24), 0x657a7a],
		[Vector3(0.43, 1.03, 0), Vector3(0.24, 0.7, 0.24), 0x657a7a],
		[Vector3(0, 1.68, 0), Vector3(0.36, 0.36, 0.36), 0xb2beb6],
		[Vector3(0, 0.9, 0), Vector3(0.64, 0.12, 0.42), GOLD]
	]
	for piece in pieces:
		var mesh = BoxMesh.new()
		mesh.size = piece[1]
		var mat = StandardMaterial3D.new()
		mat.albedo_color = _color(piece[2])
		mat.roughness = 0.9
		mesh.material = mat
		var node = MeshInstance3D.new()
		node.mesh = mesh
		node.position = piece[0]
		actor.add_child(node)

func set_view(view: String) -> void:
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.fov = 68.0
	actor.visible = view in ["shoulder", "corridor"]
	match view:
		"shoulder":
			actor.position = Vector3(-0.75, 0.024, 5.2)
			camera.position = actor.position + Vector3(0.62, 1.68, 1.75)
			camera.look_at(Vector3(0.15, 2.2, -4.4))
		"corridor":
			actor.position = Vector3(-0.45, 0.024, 15.4)
			camera.position = actor.position + Vector3(0.62, 1.68, 1.75)
			camera.look_at(Vector3(0, 2, -3))
		"eye_level":
			camera.position = Vector3(5.5, 1.7, 3.5)
			camera.look_at(Vector3(-0.2, 2.6, -4.4))
		"overview":
			camera.projection = Camera3D.PROJECTION_ORTHOGONAL
			camera.size = 30.0
			camera.position = Vector3(26, 29, 34)
			camera.look_at(Vector3(0, 2, 1.5))
		"detail":
			camera.position = Vector3(3.6, 1.65, -0.7)
			camera.look_at(Vector3(0, 2.4, -4.0))
	view_label.text = "07 / QUIET SANCTUARY     |     " + view.replace("_", " ").to_upper()

func _setup_hud() -> void:
	hud = CanvasLayer.new()
	hud.name = "ReviewUI"
	add_child(hud)
	var panel = PanelContainer.new()
	panel.position = Vector2(18, 18)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.055, 0.05, 0.9)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)
	hud.add_child(panel)
	var stack = VBoxContainer.new()
	panel.add_child(stack)
	view_label = Label.new()
	view_label.add_theme_color_override("font_color", Color("d9c391"))
	view_label.add_theme_font_size_override("font_size", 18)
	stack.add_child(view_label)
	var label = Label.new()
	label.text = "1 Shoulder   2 Corridor   3 Eye level   4 Overview   5 Detail   H Hide UI\nArt sample only. Scale figure is not the player character."
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("a1b8aa"))
	stack.add_child(label)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_5:
			set_view(VIEWS[event.keycode - KEY_1])
		elif event.keycode == KEY_H:
			hud.visible = not hud.visible
