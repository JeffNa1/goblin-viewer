extends RefCounted

const VoxelMesh = preload("res://scripts/voxel_builder.gd")
const ORIGIN = Vector2(560.0, 930.0)
const CELL: float = 0.24
const FLOOR_COLORS = {
	"01": 0x59624f, "02": 0x646653, "03": 0x59684a, "04": 0x686251,
	"05": 0x756348, "06": 0x626b55, "07": 0x677d68, "08": 0x4f6b61,
	"09": 0x735848, "10": 0x796746, "11": 0x70634e, "12": 0x515c43,
	"13": 0x655a67, "14": 0x7b8067, "00": 0x59604e
}

var layout: Dictionary
var pixel_scale: float
var floor_cells: Dictionary = {}
var blocked_cells: Dictionary = {}
var room_meshes: Dictionary = {}
var floor_counts: Dictionary = {}
var triangles: int = 0

func _init(data: Dictionary) -> void:
	layout = data
	pixel_scale = float(data["meters_per_planning_unit"]) / 10.0

func world_point(point: Array) -> Vector3:
	return Vector3((float(point[0]) - ORIGIN.x) * pixel_scale, 0.0, (float(point[1]) - ORIGIN.y) * pixel_scale)

func grid_point(point: Array) -> Vector2i:
	var world = world_point(point)
	return Vector2i(roundi(world.x / CELL), roundi(world.z / CELL))

func pixel_point(cell: Vector2i) -> Vector2:
	return Vector2(cell) * CELL / pixel_scale + ORIGIN

func build(parent: Node3D) -> void:
	_rasterize()
	var buffers: Dictionary = {"00": []}
	for room in layout["rooms"]:
		buffers[room["id"]] = []
		floor_counts[room["id"]] = 0
	for cell in floor_cells:
		var id: String = floor_cells[cell]
		var color = _floor_color(cell, id)
		buffers[id].append([cell.x, -1, cell.y, color])
		buffers[id].append([cell.x, -2, cell.y, 0x353b31])
		if id != "00":
			floor_counts[id] += 1
	_build_walls(parent)
	_build_obstacles(parent)
	for id in buffers:
		var mesh_node = _mesh(parent, "Room_" + id, buffers[id])
		if id != "00":
			mesh_node.add_to_group("rootbound_room")
			mesh_node.set_meta("room_id", id)
			room_meshes[id] = mesh_node

func _rasterize() -> void:
	for room in layout["rooms"]:
		var polygon = PackedVector2Array()
		for point in room["polygon"]:
			polygon.append(Vector2(float(point[0]), float(point[1])))
		var box: Array = room["box"]
		var a = grid_point([box[0], box[1]])
		var b = grid_point([float(box[0]) + float(box[2]), float(box[1]) + float(box[3])])
		for x in range(a.x - 1, b.x + 2):
			for z in range(a.y - 1, b.y + 2):
				var cell = Vector2i(x, z)
				if Geometry2D.is_point_in_polygon(pixel_point(cell), polygon):
					floor_cells[cell] = str(room["id"])
	for link in layout["links"]:
		var points: Array = link["points"]
		for i in range(points.size() - 1):
			var a = Vector2(float(points[i][0]), float(points[i][1]))
			var b = Vector2(float(points[i + 1][0]), float(points[i + 1][1]))
			var lo = grid_point([minf(a.x, b.x) - 20.0, minf(a.y, b.y) - 20.0])
			var hi = grid_point([maxf(a.x, b.x) + 20.0, maxf(a.y, b.y) + 20.0])
			for x in range(lo.x - 1, hi.x + 2):
				for z in range(lo.y - 1, hi.y + 2):
					var cell = Vector2i(x, z)
					var point = pixel_point(cell)
					if point.distance_squared_to(Geometry2D.get_closest_point_to_segment(point, a, b)) <= 400.0:
						if not floor_cells.has(cell):
							floor_cells[cell] = "00"

func _floor_color(cell: Vector2i, id: String) -> int:
	var color: int = FLOOR_COLORS[id]
	if posmod(cell.x, 5) == 0 or posmod(cell.y, 5) == 0:
		return color - 0x0b0b09
	if posmod(cell.x * 31 + cell.y * 17, 11) < 3:
		return color + 0x060605
	return color

func _build_walls(parent: Node3D) -> void:
	var boundary: Dictionary = {}
	for cell in floor_cells:
		for offset in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var outside: Vector2i = cell + offset
			if not floor_cells.has(outside):
				boundary[outside] = true
	var voxels: Array = []
	for cell in boundary:
		# Low foreground walls preserve the current south-east camera sight line.
		var foreground: bool = floor_cells.has(cell + Vector2i.LEFT) or floor_cells.has(cell + Vector2i.UP)
		var height: int = 3 if foreground else 11
		if not foreground and posmod(cell.x + cell.y, 13) < 2:
			height += 2
		for y in range(-2, height):
			var color: int = 0x626650 if posmod(y, 3) != 0 else 0x535940
			if y == height - 1:
				color = 0x949578
			voxels.append([cell.x, y, cell.y, color])
	var wall = _mesh(parent, "ShapedWalls", voxels)
	wall.add_to_group("rootbound_wall")

func _build_obstacles(parent: Node3D) -> void:
	var voxels: Array = []
	for room in layout["rooms"]:
		var id: String = room["id"]
		for rect in room["blockers"]:
			var lo = grid_point([rect[0], rect[1]])
			var hi = grid_point([float(rect[0]) + float(rect[2]), float(rect[1]) + float(rect[3])])
			var center = (Vector2(lo) + Vector2(hi)) * 0.5
			for x in range(lo.x, hi.x):
				for z in range(lo.y, hi.y):
					var cell = Vector2i(x, z)
					if not floor_cells.has(cell):
						continue
					blocked_cells[cell] = true
					var height: int = 3
					var color: int = 0x807453
					var dx: float = absf(float(x) - center.x)
					var dz: float = absf(float(z) - center.y)
					var edge: bool = x == lo.x or x == hi.x - 1 or z == lo.y or z == hi.y - 1
					match id:
						"03":
							color = 0x64763d
							height = 2
							if dx < 3.0 or dz < 3.0:
								height = 4
								color = 0x725033
							if dx < 2.0 and dz < 2.0:
								height = 12 - int(dx + dz)
						"04", "08":
							color = 0x69553e
							height = 5 if edge else 3
						"05":
							color = 0x524d42
							height = 5
							if not edge and dx < 4.0 and dz < 3.0:
								color = 0xba6f37
						"06", "09", "11":
							color = 0x8b8563 if id != "09" else 0x845544
							height = 9 if not edge else 2
						"07":
							color = 0x80a594 if not edge else 0x939678
							height = 3 if not edge else 4
							if dx < 1.0 and dz < 1.0:
								height = 8
						"10", "13":
							color = 0x80734f
							height = 1
							if dx < 3.0 and dz < 2.0:
								height = 5
								color = 0xc09a4d if edge or dx > 1.0 else 0x75512e
						"12":
							color = 0x697051
							height = 2 + maxi(0, 8 - int(dx * 0.7 + dz * 0.8))
					for y in range(height):
						voxels.append([x, y, z, color if y == height - 1 else color - 0x0b0b09])
	_mesh(parent, "RoomObstacles", voxels)

func build_landmarks(parent: Node3D) -> void:
	var water: Array = []
	for basin in [[590.0, 1640.0, 170.0, 64.0], [1022.0, 1134.0, 94.0, 122.0]]:
		var lo = grid_point([basin[0] - basin[2], basin[1] - basin[3]])
		var hi = grid_point([basin[0] + basin[2], basin[1] + basin[3]])
		for x in range(lo.x, hi.x + 1):
			for z in range(lo.y, hi.y + 1):
				var cell = Vector2i(x, z)
				var point = pixel_point(cell)
				var radius = Vector2((point.x - basin[0]) / basin[2], (point.y - basin[1]) / basin[3])
				if radius.length_squared() <= 1.0 and not floor_cells.has(cell):
					water.append([x, -3, z, 0x386e63 if posmod(x + z, 7) != 0 else 0x457d6f])
	_mesh(parent, "UndergroundWater", water, false).add_to_group("rootbound_landmark")
	var boat: Array = []
	var anchor = grid_point([462, 1638])
	for x in range(-4, 5):
		for z in range(-12, 13):
			if abs(x) + maxi(0, abs(z) - 8) > 4:
				continue
			boat.append([anchor.x + x, -2, anchor.y + z, 0x735334])
			if abs(x) == 4 or abs(x) + maxi(0, abs(z) - 8) == 4:
				for y in range(-1, 2):
					boat.append([anchor.x + x, y, anchor.y + z, 0x997146])
			elif z == -5 or z == 5:
				boat.append([anchor.x + x, 0, anchor.y + z, 0xb18c55])
	_mesh(parent, "LandingBoat", boat, false).add_to_group("rootbound_landmark")
	var stairs: Array = []
	var lo = grid_point([1005, 408])
	var hi = grid_point([1025, 450])
	for x in range(lo.x, hi.x):
		for z in range(lo.y, hi.y):
			if not floor_cells.has(Vector2i(x, z)):
				continue
			blocked_cells[Vector2i(x, z)] = true
			for y in range(1 + (z - lo.y) / 3):
				stairs.append([x, y, z, 0xaba684])
	_mesh(parent, "AscentSteps", stairs).add_to_group("rootbound_landmark")

func _mesh(parent: Node3D, node_name: String, voxels: Array, solid: bool = true) -> MeshInstance3D:
	var mesh_node = MeshInstance3D.new()
	mesh_node.name = node_name
	mesh_node.mesh = VoxelMesh.build_seamless_mesh_scaled(voxels, CELL)
	mesh_node.position.y = CELL * 0.5
	var material = StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	material.roughness = 0.95
	mesh_node.material_override = material
	parent.add_child(mesh_node)
	if solid:
		mesh_node.create_trimesh_collision()
		mesh_node.add_to_group("rootbound_collision")
	for surface in range(mesh_node.mesh.get_surface_count()):
		triangles += mesh_node.mesh.surface_get_array_len(surface) / 3
	return mesh_node
