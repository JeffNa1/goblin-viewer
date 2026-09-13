extends "res://Rootbound_Sanctum/Art_Sample/sanctuary.gd"

const Early = preload("res://Rootbound_Sanctum/Art_Dungeon/early_rooms.gd")
const Late = preload("res://Rootbound_Sanctum/Art_Dungeon/late_rooms.gd")
var room_data: Dictionary
var plan
var anchor_cell: Vector2i
var extent: Vector2
var focus_point: Vector3
var landmark_name: String = ""
var edge_spots: Array[Vector3] = []
var blocker_centers: Array[Vector3] = []

func _ready() -> void:
	# The director owns review input and configures geometry after insertion.
	set_process_unhandled_key_input(false)

func configure(source: Dictionary, grid) -> void:
	room_data = source
	plan = grid
	source_room_id = str(source["id"])
	rng.seed = 90317 + int(source_room_id) * 131
	var box: Array = source["box"]
	var center = [float(box[0]) + float(box[2]) * 0.5, float(box[1]) + float(box[3]) * 0.5]
	anchor_cell = plan.grid_point(center) if source_room_id != "00" else Vector2i.ZERO
	position = Vector3(float(anchor_cell.x) * CELL, 0, float(anchor_cell.y) * CELL)
	extent = Vector2(float(box[2]), float(box[3])) * plan.pixel_scale
	for global_cell in plan.by_room[source_room_id]:
		floor_cells[global_cell - anchor_cell] = true
	room_cell_count = floor_cells.size()
	_build_surface()
	if source_room_id == "00":
		_build_passages()
	else:
		_find_edge_spots()
		for rect in source["blockers"]:
			var p = local_plan([float(rect[0]) + float(rect[2]) * 0.5, float(rect[1]) + float(rect[3]) * 0.5])
			blocker_centers.append(p)
			_solid_box("PlannedBlocker", p + Vector3.UP * 1.05, Vector3(float(rect[2]) * plan.pixel_scale, 2.1, float(rect[3]) * plan.pixel_scale))
		if source_room_id == "07":
			landmark_name = "Heartwood recovery fountain"
			_build_architecture()
			_build_shrine()
			_build_dressing()
			focus_point = Vector3(0, 2.4, -4.32)
		else:
			_build_room_shell_details()
			if int(source_room_id) <= 6:
				Early.build(self)
			else:
				Late.build(self)
	_flush_blocks()
	print("ROOM_ART_READY ", source_room_id, " ", landmark_name, " ", JSON.stringify(geometry_stats))

func local_plan(point: Array) -> Vector3:
	return plan.world_point(point) - position

func _build_surface() -> void:
	var floor_grid: Dictionary = {}
	for cell in floor_cells:
		floor_grid[Vector3i(cell.x, -1, cell.y)] = 0x3e5148
		floor_grid[Vector3i(cell.x, -2, cell.y)] = 0x2d4138
		if posmod(cell.x, 4) == 0 and posmod(cell.y, 4) == 0:
			if floor_cells.has(cell + Vector2i(3, 0)) and floor_cells.has(cell + Vector2i(0, 3)) and floor_cells.has(cell + Vector2i(3, 3)):
				var tone: int = FLOOR[posmod(floori(float(cell.x) / 4) * 19 + floori(float(cell.y) / 4) * 31, 4)]
				if source_room_id == "05":
					tone = [0x5a5547, 0x625a4d, 0x696050, 0x706453][posmod(cell.x + floori(float(cell.y) / 4), 4)]
				if source_room_id == "12":
					tone = [0x43564b, 0x47574c, 0x4b5d4f, 0x526252][posmod(floori(float(cell.x) / 4) + floori(float(cell.y) / 4), 4)]
				_box(Vector3((float(cell.x) + 1.5) * CELL, 0.012, (float(cell.y) + 1.5) * CELL), Vector3(0.93, 0.024, 0.93), tone)
	_emit_grid("Floor_" + source_room_id, floor_grid, CELL, Vector3(0, 0.12, 0), false)
	var boundary: Dictionary = {}
	for cell in floor_cells:
		for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			if not plan.cells.has(cell + anchor_cell + dir):
				boundary[cell + dir] = true
	var thick = boundary.duplicate()
	for cell in boundary:
		for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			if not plan.cells.has(cell + anchor_cell + dir):
				thick[cell + dir] = true
	var grid: Dictionary = {}
	for cell in thick:
		var height = 26
		if source_room_id == "01":
			height = 3
		elif source_room_id == "00":
			height = 19
		elif source_room_id == "12":
			height = 30 + posmod(floori(float(cell.x + cell.y) / 5.0), 9)
		elif source_room_id == "08":
			var water_center = local_plan([1022, 1134])
			var bank_delta = Vector2(float(cell.x) * CELL - water_center.x, float(cell.y) * CELL - water_center.z) / Vector2(11.28, 14.64)
			if bank_delta.length_squared() < 1.1025:
				height = 5
		for y in range(height):
			var row = floori(float(y) / 3.0)
			var color: int = STONE[posmod(floori(float(cell.x + cell.y) / 6) * 7 + row * 11, 4)]
			if posmod(y, 3) == 0:
				color = 0x56655b
			if source_room_id == "12":
				color = [0x485649, 0x53604e, 0x5e6955, 0x69735d][posmod(floori(float(cell.x) / 4) + floori(float(cell.y) / 5) + floori(float(y) / 4), 4)]
			if y == height - 1:
				color = 0x97a085
			grid[Vector3i(cell.x, y, cell.y)] = color
	_emit_grid("Walls_" + source_room_id, grid, CELL, Vector3(0, 0.12, 0), true)

func _find_edge_spots() -> void:
	var candidates: Array[Vector3] = []
	for cell in floor_cells:
		if posmod(cell.x, 4) != 0 or posmod(cell.y, 4) != 0:
			continue
		var inside = true
		var near_edge = false
		for dir in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			inside = inside and floor_cells.has(cell + dir * 4)
			near_edge = near_edge or not floor_cells.has(cell + dir * 8)
		if not inside or not near_edge:
			continue
		var p = Vector3(float(cell.x) * CELL, 0, float(cell.y) * CELL)
		var near_door = false
		for portal in plan.portals[source_room_id]:
			if p.distance_to(portal["point"] - position) < 4.2:
				near_door = true
		if not near_door:
			candidates.append(p)
	for i in range(8):
		var angle = float(i) * TAU / 8.0
		var target = Vector3(cos(angle) * extent.x * 0.45, 0, sin(angle) * extent.y * 0.45)
		var best = Vector3.INF
		var distance = INF
		for p in candidates:
			var separated = true
			for previous in edge_spots:
				if p.distance_to(previous) < 3.2:
					separated = false
			if separated and p.distance_squared_to(target) < distance:
				best = p
				distance = p.distance_squared_to(target)
		if best.is_finite():
			edge_spots.append(best)

func _build_room_shell_details() -> void:
	for portal in plan.portals[source_room_id]:
		var p: Vector3 = portal["point"] - position
		var out: Vector3 = portal["out"]
		_arch(p, atan2(out.x, out.z))
	for i in range(edge_spots.size()):
		var p = edge_spots[i]
		if source_room_id in ["01", "12", "14"]:
			for tier in range(4):
				_box(p + Vector3(0, 0.18 + float(tier) * 0.3, 0), Vector3(1.2 - float(tier) * 0.18, 0.36, 1.2 - float(tier) * 0.12), STONE[tier])
		else:
			_pillar(p, 6.3)
		if i % 2 == 0:
			_foliage(p + Vector3(0.66, 0.2, 0.36), 0.55, 12)
			_urn(p + Vector3(-0.9, 0, -0.4))
			_candles(p + Vector3(-0.66, 0, 0.6))
			_light(p + Vector3(0, 3, 0.7), 0xffc481, 1.4, 7, false)
		else:
			_torch(p + Vector3(0, 2.8, 0.6))
		for chip in range(5):
			_box(p + Vector3(rng.randf_range(-0.8, 0.8), 0.08, rng.randf_range(-0.8, 0.8)), Vector3(0.24, 0.16, 0.36), STONE[chip % 4])

func _build_passages() -> void:
	landmark_name = "Original connected route corridors"
	for link in plan.data["links"]:
		for i in range(link["points"].size() - 1):
			var a: Vector3 = plan.world_point(link["points"][i])
			var b: Vector3 = plan.world_point(link["points"][i + 1])
			var side = Vector3.UP.cross((b - a).normalized())
			var steps = maxi(1, ceili(a.distance_to(b) / 6.0))
			for j in range(steps):
				var p = a.lerp(b, (float(j) + 0.5) / float(steps))
				for sign_value in [-1, 1]:
					var lamp = p + side * float(sign_value) * 1.9 + Vector3.UP * 2.7
					_box(lamp, Vector3(0.18, 0.48, 0.18), 0xffce89, 0, "flame")
					_light(lamp, 0xffc481, 0.9, 5.5, false)

func tree(p: Vector3, height: float, spread: float, radius: float) -> void:
	var wood: Dictionary = {}
	_root_path(wood, [p, p + Vector3(-0.4, height * 0.25, 0), p + Vector3(0.2, height * 0.6, -0.4), p + Vector3(0.8, height, -1)], radius, 0.16)
	for side in [-1, 1]:
		var end = p + Vector3(float(side) * spread, height * 0.9, float(side) * 1.2)
		_root_path(wood, [p + Vector3(0, height * 0.35, 0), p + Vector3(float(side) * spread * 0.4, height * 0.65, 0), end], radius * 0.65, 0.08)
		_foliage(end, 1.5, 36)
	for i in range(6):
		var a = TAU * float(i) / 6.0
		_root_path(wood, [p + Vector3(0, 1.4, 0), p + Vector3(cos(a) * radius * 1.8, 0.3, sin(a) * radius * 1.8)], radius * 0.45, 0.08)
	_emit_grid("SculptedRoots", wood, WOOD_CELL, Vector3.ZERO, false)
	_foliage(p + Vector3(0.8, height, -1), 1.4, 32)

func water_basin(center: Vector3, radius: Vector2) -> void:
	var water: Dictionary = {}
	var step_value = 0.48
	for x in range(floori((center.x - radius.x) / step_value), ceili((center.x + radius.x) / step_value)):
		for z in range(floori((center.z - radius.y) / step_value), ceili((center.z + radius.y) / step_value)):
			var p = Vector3(float(x) * step_value, 0, float(z) * step_value)
			var normalized = Vector2((p.x - center.x) / radius.x, (p.z - center.z) / radius.y)
			var global_cell = Vector2i(roundi((p.x + position.x) / CELL), roundi((p.z + position.z) / CELL))
			if normalized.length_squared() <= 1.0 and not plan.cells.has(global_cell):
				water[Vector3i(x, -1, z)] = 0x315f5b if posmod(x + z, 9) != 0 else 0x55978b
	_emit_grid("DecorativeWater", water, step_value, Vector3.ZERO, false)

func chest(p: Vector3, width: float, color: int = GOLD) -> void:
	_box(p + Vector3(0, 0.18, 0), Vector3(width + 0.48, 0.36, 1.92), 0x77816a)
	_box(p + Vector3(0, 0.9, 0), Vector3(width, 1.08, 1.32), 0x594230)
	for side in [-1, 1]:
		_box(p + Vector3(float(side) * width * 0.36, 1, 0), Vector3(0.18, 1.2, 1.44), color)
	for layer in range(3):
		_box(p + Vector3(0, 1.5 + float(layer) * 0.12, 0), Vector3(width, 0.12, 1.32 - float(layer) * 0.36), color)
	_box(p + Vector3(0, 1.05, 0.72), Vector3(0.48, 0.48, 0.12), color)
	_box(p + Vector3(0, 1.08, 0.81), Vector3(0.12, 0.24, 0.06), JADE, 0, "jade")

func shelf(p: Vector3, width: float, height: float = 3.6, yaw: float = 0.0) -> void:
	var basis = Basis(Vector3.UP, yaw)
	for sign_value in [-1, 1]:
		_box(p + basis * Vector3(float(sign_value) * width * 0.5, height * 0.5, 0), Vector3(0.18, height, 0.9), 0x765c3f, yaw)
	for level in range(4):
		var y = 0.3 + float(level) * (height - 0.6) / 3.0
		_box(p + Vector3(0, y, 0), Vector3(width, 0.18, 0.96), 0x9b7e52, yaw)
		if level == 3:
			continue
		for i in range(int(width / 0.18) - 1):
			var h = [0.42, 0.54, 0.66, 0.48][i % 4]
			var x = -width * 0.5 + 0.2 + float(i) * 0.18
			var center = p + basis * Vector3(x, y + 0.12 + h * 0.5, 0)
			_box(center, Vector3(0.12, h, 0.66), [0x784d3c, 0x466c63, 0xbaa274, 0x69728a, 0x8f7744][(i + level) % 5], yaw)
			_box(center + basis * Vector3(0, h * 0.2, 0.36), Vector3(0.12, 0.06, 0.06), GOLD, yaw)

func banner(p: Vector3, width: float, height: float, color: int, yaw: float = 0.0) -> void:
	var basis = Basis(Vector3.UP, yaw)
	_box(p + Vector3(0, height, 0), Vector3(width + 0.6, 0.12, 0.18), GOLD, yaw)
	_box(p + Vector3(0, height * 0.55, 0), Vector3(width, height * 0.9, 0.12), color, yaw)
	_box(p + basis * Vector3(0, height * 0.6, 0.09), Vector3(0.12, height * 0.4, 0.06), GOLD, yaw)
	for side in [-1, 1]:
		_box(p + basis * Vector3(float(side) * width * 0.2, height * 0.65, 0.09), Vector3(width * 0.4, 0.12, 0.06), GOLD, yaw)
