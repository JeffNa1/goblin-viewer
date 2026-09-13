extends RefCounted

# Matches the existing planning projection without loading mutable character helpers.
const CELL: float = 0.24
const ORIGIN = Vector2(560.0, 930.0)
var data: Dictionary
var pixel_scale: float
var cells: Dictionary = {}
var by_room: Dictionary = {"00": {}}
var portals: Dictionary = {}

func _init() -> void:
	data = JSON.parse_string(FileAccess.get_file_as_string("res://data/rootbound_layout.json"))
	pixel_scale = float(data["meters_per_planning_unit"]) / 10.0
	for room in data["rooms"]:
		by_room[room["id"]] = {}
		portals[room["id"]] = []
		var polygon = PackedVector2Array()
		for point in room["polygon"]:
			polygon.append(Vector2(float(point[0]), float(point[1])))
		var box: Array = room["box"]
		var a = grid_point([box[0], box[1]])
		var b = grid_point([float(box[0]) + float(box[2]), float(box[1]) + float(box[3])])
		for x in range(a.x - 1, b.x + 2):
			for z in range(a.y - 1, b.y + 2):
				var cell = Vector2i(x, z)
				if Geometry2D.is_point_in_polygon(Vector2(cell) * CELL / pixel_scale + ORIGIN, polygon):
					cells[cell] = str(room["id"])
	for link in data["links"]:
		var points: Array = link["points"]
		portals[link["a"]].append({"point": world_point(points[0]), "out": (world_point(points[1]) - world_point(points[0])).normalized()})
		portals[link["b"]].append({"point": world_point(points[-1]), "out": (world_point(points[-2]) - world_point(points[-1])).normalized()})
		for i in range(points.size() - 1):
			var a = Vector2(float(points[i][0]), float(points[i][1]))
			var b = Vector2(float(points[i + 1][0]), float(points[i + 1][1]))
			var lo = grid_point([minf(a.x, b.x) - 20.0, minf(a.y, b.y) - 20.0])
			var hi = grid_point([maxf(a.x, b.x) + 20.0, maxf(a.y, b.y) + 20.0])
			for x in range(lo.x - 1, hi.x + 2):
				for z in range(lo.y - 1, hi.y + 2):
					var cell = Vector2i(x, z)
					var point = Vector2(cell) * CELL / pixel_scale + ORIGIN
					if point.distance_squared_to(Geometry2D.get_closest_point_to_segment(point, a, b)) <= 400.0 and not cells.has(cell):
						cells[cell] = "00"
	for cell in cells:
		by_room[cells[cell]][cell] = true

func world_point(point: Array) -> Vector3:
	return Vector3((float(point[0]) - ORIGIN.x) * pixel_scale, 0, (float(point[1]) - ORIGIN.y) * pixel_scale)

func grid_point(point: Array) -> Vector2i:
	var world = world_point(point)
	return Vector2i(roundi(world.x / CELL), roundi(world.z / CELL))

func add_floor_collision(parent: Node3D) -> void:
	# Shared half-grid coordinates prevent sub-micron seams between translated rooms.
	var faces = PackedVector3Array()
	for cell in cells:
		var left = float(cell.x * 2 - 1) * (CELL * 0.5)
		var right = float(cell.x * 2 + 1) * (CELL * 0.5)
		var front = float(cell.y * 2 + 1) * (CELL * 0.5)
		var back = float(cell.y * 2 - 1) * (CELL * 0.5)
		var corners = [Vector3(left, 0, front), Vector3(right, 0, front), Vector3(right, 0, back), Vector3(left, 0, back)]
		for index in [0, 2, 1, 0, 3, 2]:
			faces.append(corners[index])
	var shape = ConcavePolygonShape3D.new()
	shape.set_faces(faces)
	var collision = CollisionShape3D.new()
	collision.shape = shape
	var body = StaticBody3D.new()
	body.name = "ContinuousPlanningFloor"
	body.add_child(collision)
	parent.add_child(body)
