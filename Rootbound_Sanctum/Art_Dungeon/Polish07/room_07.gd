extends "res://Rootbound_Sanctum/Art_Dungeon/room_art.gd"

# Room 07 only. The original room, route data, lighting and character remain untouched.
# Faceted, authored silhouettes replace large cubes; shared floor physics stays canonical.
const ASHLAR = [0x66776d, 0x708074, 0x798679, 0x829080]
const PALE: int = 0x9ca78d
const RECESS: int = 0x394d43
const BRONZE: int = 0x9e865b
var sculpt_surfaces: Dictionary = {}
var sculpt_triangles: int = 0
var contour: Array[Vector3] = []
var contour_lengths: Array[float] = []
var perimeter: float = 0.0

func _face(category: String, vertices: Array, normal: Vector3, tone: int) -> void:
	var center = Vector3.ZERO
	for vertex in vertices:
		center += vertex
	center /= float(vertices.size())
	var key = "%s_%d_%d" % [category, floori(center.x / 6.0), floori(center.z / 6.0)]
	if not sculpt_surfaces.has(key):
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		sculpt_surfaces[key] = st
	var st: SurfaceTool = sculpt_surfaces[key]
	st.set_color(_color(tone))
	st.set_normal(normal.normalized())
	for i in range(1, vertices.size() - 1):
		var a: Vector3 = vertices[0]
		var b: Vector3 = vertices[i]
		var c: Vector3 = vertices[i + 1]
		var cross_value = (b - a).cross(c - a)
		if cross_value.length_squared() < 0.0000000001:
			continue
		# Godot's front face is clockwise. Normals remain outward.
		st.add_vertex(a)
		st.add_vertex(c if cross_value.dot(normal) > 0 else b)
		st.add_vertex(b if cross_value.dot(normal) > 0 else c)
		sculpt_triangles += 1

func _octagon(hx: float, hz: float, cut: float, y: float) -> Array:
	return [Vector3(-hx + cut, y, -hz), Vector3(hx - cut, y, -hz), Vector3(hx, y, -hz + cut), Vector3(hx, y, hz - cut), Vector3(hx - cut, y, hz), Vector3(-hx + cut, y, hz), Vector3(-hx, y, hz - cut), Vector3(-hx, y, -hz + cut)]

func _block(category: String, p: Vector3, size: Vector3, tone: int, bevel: float = 0.06, basis: Basis = Basis.IDENTITY) -> void:
	var half = size * 0.5
	var b = minf(bevel, minf(half.x, minf(half.y, half.z)) * 0.7)
	var cut = minf(bevel * 2.0, minf(half.x, half.z) * 0.6)
	var rings = [_octagon(half.x - b, half.z - b, cut * 0.7, -half.y), _octagon(half.x, half.z, cut, -half.y + b), _octagon(half.x, half.z, cut, half.y - b), _octagon(half.x - b, half.z - b, cut * 0.7, half.y)]
	# Sparse chipped upper arrises keep masonry aged without noisy random tinting.
	var wear_key = absi(roundi(p.x * 131.0 + p.y * 41.0 + p.z * 71.0))
	if category == "Stonework" and size.x > 0.7 and size.y > 0.4 and size.z < 0.7 and wear_key % 5 == 0:
		var corner = wear_key % 8
		var chip: Vector3 = rings[3][corner]
		chip.x *= 0.78
		chip.z *= 0.76
		rings[3][corner] = chip
	for ring in rings:
		for i in range(ring.size()):
			ring[i] = p + basis * ring[i]
	_face(category, rings[0], basis * Vector3.DOWN, tone)
	_face(category, rings[-1], basis * Vector3.UP, tone)
	for level in range(3):
		for i in range(8):
			var j = (i + 1) % 8
			var a: Vector3 = rings[level][i]
			var b_point: Vector3 = rings[level + 1][i]
			var c: Vector3 = rings[level + 1][j]
			var n = (b_point - a).cross(c - a).normalized()
			var outward: Vector3 = (a + b_point + c + rings[level][j]) * 0.25 - p
			if n.dot(outward) < 0:
				n = -n
			_face(category, [a, b_point, c, rings[level][j]], n, tone)

func _lathe(category: String, p: Vector3, profile: Array, tone: int, sides: int = 12, stretch: Vector2 = Vector2.ONE) -> void:
	var rings: Array = []
	for value in profile:
		var ring: Array = []
		for i in range(sides):
			var angle = TAU * float(i) / float(sides)
			ring.append(p + Vector3(cos(angle) * value.x * stretch.x, value.y, sin(angle) * value.x * stretch.y))
		rings.append(ring)
	_face(category, rings[0], Vector3.DOWN, tone)
	_face(category, rings[-1], Vector3.UP, tone)
	for level in range(rings.size() - 1):
		for i in range(sides):
			var j = (i + 1) % sides
			var a: Vector3 = rings[level][i]
			var b: Vector3 = rings[level + 1][i]
			var c: Vector3 = rings[level + 1][j]
			var n = (b - a).cross(c - a).normalized()
			var radial = Vector3(a.x - p.x, 0, a.z - p.z)
			if n.dot(radial) < 0:
				n = -n
			if n.is_zero_approx():
				n = radial.normalized()
			_face(category, [a, b, c, rings[level][j]], n, tone)

func _tube(category: String, points: Array, radius_a: float, radius_b: float, tone: int, sides: int = 9) -> void:
	var path: Array[Vector3] = []
	for section in range(points.size() - 1):
		var a: Vector3 = points[maxi(0, section - 1)]
		var b: Vector3 = points[section]
		var c: Vector3 = points[section + 1]
		var d: Vector3 = points[mini(points.size() - 1, section + 2)]
		var steps = maxi(3, ceili(b.distance_to(c) / 0.2))
		for i in range(steps):
			var t = float(i) / float(steps)
			path.append(0.5 * ((2.0 * b) + (-a + c) * t + (2.0 * a - 5.0 * b + 4.0 * c - d) * t * t + (-a + 3.0 * b - 3.0 * c + d) * t * t * t))
	path.append(points[-1])
	var previous: Array = []
	for step in range(path.size()):
		var tangent = (path[mini(step + 1, path.size() - 1)] - path[maxi(step - 1, 0)]).normalized()
		var right = tangent.cross(Vector3.UP).normalized()
		if right.length_squared() < 0.5:
			right = tangent.cross(Vector3.RIGHT).normalized()
		var up = right.cross(tangent).normalized()
		var radius = lerpf(radius_a, radius_b, float(step) / float(path.size() - 1))
		var ring: Array = []
		for i in range(sides):
			var angle = TAU * float(i) / float(sides)
			var ridge = 1.0 + (0.07 * sin(float(i) * 2.8) if category == "Roots" else 0.0)
			ring.append(path[step] + (cos(angle) * right + sin(angle) * up) * radius * ridge)
		if step == 0:
			_face(category, ring, -tangent, tone)
		else:
			for i in range(sides):
				var j = (i + 1) % sides
				var outward: Vector3 = (ring[i] + ring[j]) * 0.5 - path[step]
				var shade = tone
				if category == "Roots":
					shade = [0x544230, 0x655039, 0x75583e, 0x806247][i % 4]
				_face(category, [previous[i], ring[i], ring[j], previous[j]], outward, shade)
		if step == path.size() - 1:
			_face(category, ring, tangent, tone)
		previous = ring

func _leaf(category: String, p: Vector3, direction: Vector3, width: float, tone: int, normal: Vector3 = Vector3.BACK) -> void:
	var axis = direction.normalized()
	var side = axis.cross(normal).normalized() * width
	if side.is_zero_approx():
		side = Vector3.RIGHT * width
	var ridge = p + direction * 0.46 + normal * width * 0.32
	var edge = [p, p + direction * 0.37 + side, p + direction * 0.76 + side * 0.56, p + direction, p + direction * 0.76 - side * 0.56, p + direction * 0.37 - side]
	for i in range(edge.size()):
		var j = (i + 1) % edge.size()
		var n: Vector3 = (edge[j] - edge[i]).cross(ridge - edge[i]).normalized()
		if n.dot(normal) < 0:
			n = -n
		_face(category, [edge[i], edge[j], ridge], n, tone)
	_face(category, edge, -normal, tone)

func _flush_blocks() -> void:
	super._flush_blocks()
	for key in sculpt_surfaces:
		var category: String = key.split("_")[0]
		var material = StandardMaterial3D.new()
		material.vertex_color_use_as_albedo = true
		material.vertex_color_is_srgb = true
		material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		material.roughness = 0.91
		if category == "Bronze":
			material.metallic = 0.45
			material.roughness = 0.58
		if category == "Water":
			material.roughness = 0.24
		if category in ["Flame", "Jade"]:
			material.emission_enabled = true
			material.emission = _color(0xffc373 if category == "Flame" else 0x4cab95)
			material.emission_energy_multiplier = 1.0 if category == "Flame" else 0.4
		var st: SurfaceTool = sculpt_surfaces[key]
		st.set_material(material)
		st.index()
		var instance = MeshInstance3D.new()
		instance.name = "Sculpt07_" + key
		instance.mesh = st.commit()
		add_child(instance)
	geometry_stats["sculpted_triangles"] = sculpt_triangles
	geometry_stats["sculpted_batches"] = sculpt_surfaces.size()
	sculpt_surfaces.clear()

func _contour_point(distance: float) -> Vector3:
	var value = fposmod(distance, perimeter)
	for i in range(contour.size()):
		var next = (i + 1) % contour.size()
		var length = contour[i].distance_to(contour[next])
		if value <= contour_lengths[i] + length:
			return contour[i].lerp(contour[next], (value - contour_lengths[i]) / length)
	return contour[0]

func _build_surface() -> void:
	super._build_surface()
	# Keep the tested original wall collider; replace only its visible coarse shell.
	for child in get_children():
		if child is MeshInstance3D and str(child.name).begins_with("Walls_07"):
			child.visible = false
	for point in room_data["polygon"]:
		contour.append(local_plan(point))
	for i in range(contour.size()):
		contour_lengths.append(perimeter)
		perimeter += contour[i].distance_to(contour[(i + 1) % contour.size()])
	var count = ceili(perimeter / 1.1)
	var length = perimeter / float(count)
	for row in range(11):
		for i in range(count):
			var distance = (float(i) + float(row % 2) * 0.5) * length
			var a = _contour_point(distance)
			var b = _contour_point(distance + length)
			var p = (a + b) * 0.5
			var doorway = false
			for portal in plan.portals["07"]:
				if p.distance_to(portal["point"] - position) < 3.15:
					doorway = true
			if doorway:
				continue
			var direction = (b - a).normalized()
			var inward = Vector3(-direction.z, 0, direction.x)
			var basis = Basis(Vector3.UP, -atan2(direction.z, direction.x))
			p -= inward * 0.25
			p.y = 0.29 + float(row) * 0.56
			var tone: int = ASHLAR[posmod(i * 7 + row * 3, 4)]
			_block("Stonework", p, Vector3(a.distance_to(b) - 0.024, 0.538, 0.56), tone, 0.038, basis)
			if posmod(i * 7 + row * 13, 17) == 0 and row > 0 and row < 10:
				var fissure: Array = []
				for point in [Vector3(-0.08, 0.256, 0.284), Vector3(-0.02, 0.13, 0.284), Vector3(-0.12, 0.055, 0.284), Vector3(-0.06, -0.16, 0.284)]:
					fissure.append(p + basis * point)
				_tube("Weathering", fissure, 0.009, 0.003, 0x3f5148, 4)
			if row == 0 and i % 5 == 0:
				for sprig in range(5):
					var start = p + basis * Vector3(float(sprig - 2) * 0.10, -0.20, 0.294)
					_leaf("Weathering", start, basis * Vector3(0.12, 0.15 + float(sprig % 2) * 0.1, 0.012), 0.06, LEAF[sprig % 4], inward)
			if row == 0 or row == 10:
				_block("Stonework", p + Vector3.UP * 0.22, Vector3(a.distance_to(b), 0.13, 0.67), PALE, 0.025, basis)
			if row == 7:
				_block("Stonework", p + Vector3.UP * 0.19 + inward * 0.05, Vector3(a.distance_to(b), 0.1, 0.61), 0x88967f, 0.02, basis)
	# A flush, worn botanical seal breaks the empty tile field without blocking combat.
	for radius in [1.66, 1.82]:
		var points: Array = []
		for i in range(49):
			var angle = TAU * float(i) / 48.0
			points.append(Vector3(cos(angle) * radius, 0.029, 4.5 + sin(angle) * radius))
		_tube("Bronze", points, 0.014, 0.014, 0x8f8864, 4)
	for side in [-1, 1]:
		for i in range(4):
			var p = Vector3(0, 0.03, 3.5 + float(i) * 0.5)
			_leaf("Carving", p, Vector3(float(side) * 0.8, 0, 0.5), 0.14, 0x72816a, Vector3.UP)

func _build_architecture() -> void:
	for side in [-1, 1]:
		for z in [-6.9, 6.9]:
			_pillar(Vector3(float(side) * 10.6, 0, z), 6.3)
		for x in [-5.9, 5.9]:
			_pillar(Vector3(x, 0, float(side) * 9.0), 6.3)
	for p in [Vector3(0, 0, 11.4), Vector3(0, 0, 16.6), Vector3(0, 0, -11.4)]:
		_arch(p, 0)
	_arch(Vector3(-15, 0, 0), PI * 0.5)
	_arch(Vector3(15, 0, 0), PI * 0.5)
	for z in [12.4, 13.6, 14.8, 17.8]:
		_block("Stonework", Vector3(0, 5.85, z), Vector3(5.25, 0.36, 0.36), 0x8b947c)
	_block("Stonework", Vector3(0, 6.13, 14.8), Vector3(5.28, 0.24, 6.96), 0x415349)
	_solid_box("CorridorRoof", Vector3(0, 6.13, 14.8), Vector3(5.28, 0.24, 6.96))
	for z in [-6.8, 6.8]:
		for side in [-1, 1]:
			for i in range(12):
				var a = float(i) * 0.096
				var b = a + 0.091
				var start = a if side == 1 else PI - b
				var end = b if side == 1 else PI - a
				_voussoir(Vector3(0, 6.24, z), Vector2(10.6, 2.48), Vector2(11.1, 2.96), start, end, 0.64, 0, ASHLAR[i % 4])
	for side in [-1, 1]:
		_relief(Vector3(float(side) * 4.35, 0, -9.7))
		_brazier(Vector3(float(side) * 3.1, 0, -8.8))
		_torch(Vector3(float(side) * 2.24, 2.6, 13.5))
		_torch(Vector3(float(side) * 2.24, 2.6, 17.5))
		_carved_panel(Vector3(float(side) * 12.0, 0.5, 3.7), -float(side) * PI * 0.5, 0.72)

func _pillar(p: Vector3, height: float) -> void:
	for tier in range(3):
		_block("Stonework", p + Vector3(0, 0.12 + float(tier) * 0.24, 0), Vector3(1.68 - float(tier) * 0.24, 0.24, 1.68 - float(tier) * 0.24), PALE if tier == 0 else ASHLAR[2], 0.07)
	for row in range(10):
		_lathe("Stonework", p, [Vector2(0.43, 0.76 + row * 0.48), Vector2(0.51, 0.80 + row * 0.48), Vector2(0.51, 1.17 + row * 0.48), Vector2(0.43, 1.21 + row * 0.48)], ASHLAR[row % 4], 12)
	for i in range(12):
		var angle = TAU * float(i) / 12.0
		var radial = Vector3(cos(angle), 0, sin(angle))
		_tube("Stonework", [p + radial * 0.51 + Vector3.UP * 1.0, p + radial * 0.48 + Vector3.UP * 3.0, p + radial * 0.51 + Vector3.UP * 5.42], 0.042, 0.042, 0x929d84, 5)
		_leaf("Carving", p + radial * 0.54 + Vector3.UP * 5.35, Vector3.UP * 0.78 + radial * 0.3, 0.18, PALE, radial)
	for y in [0.72, 2.16, 5.76]:
		_lathe("Bronze", p, [Vector2(0.55, y - 0.05), Vector2(0.59, y), Vector2(0.55, y + 0.05)], BRONZE, 12)
	for tier in range(3):
		_block("Stonework", p + Vector3(0, height - 0.54 + float(tier) * 0.24, 0), Vector3(1.08 + float(tier) * 0.3, 0.24, 1.08 + float(tier) * 0.3), ASHLAR[2] if tier == 0 else PALE, 0.06)
	_solid_box("Pillar", p + Vector3(0, height * 0.5, 0), Vector3(1.2, height, 1.2))

func _voussoir(p: Vector3, inner: Vector2, outer: Vector2, start: float, end: float, depth: float, yaw: float, tone: int) -> void:
	var basis = Basis(Vector3.UP, yaw)
	var front: Array = []
	var back: Array = []
	for value in [[inner, start], [outer, start], [outer, end], [inner, end]]:
		var point = Vector3(cos(value[1]) * value[0].x, sin(value[1]) * value[0].y, 0)
		front.append(p + basis * (point + Vector3.BACK * depth * 0.5))
		back.append(p + basis * (point + Vector3.FORWARD * depth * 0.5))
	_face("Stonework", front, basis * Vector3.BACK, tone)
	_face("Stonework", back, basis * Vector3.FORWARD, tone)
	for i in range(4):
		var j = (i + 1) % 4
		var n: Vector3 = (front[j] - front[i]).cross(back[i] - front[i]).normalized()
		var middle: Vector3 = (front[0] + front[1] + front[2] + front[3] + back[0] + back[1] + back[2] + back[3]) / 8.0
		if n.dot((front[i] + front[j] + back[i] + back[j]) * 0.25 - middle) < 0:
			n = -n
		_face("Stonework", [front[i], front[j], back[j], back[i]], n, tone)

func _arch(p: Vector3, yaw: float) -> void:
	var basis = Basis(Vector3.UP, yaw)
	for side in [-1, 1]:
		for row in range(7):
			_block("Stonework", p + basis * Vector3(float(side) * 2.79, 0.23 + float(row) * 0.46, 0), Vector3(0.92, 0.442, 1.12), ASHLAR[row % 4], 0.055, basis)
		for y in [0.22, 2.92]:
			_block("Stonework", p + basis * Vector3(float(side) * 2.79, y, 0), Vector3(1.13, 0.24, 1.28), PALE, 0.055, basis)
		_solid_box("PortalJamb", p + basis * Vector3(float(side) * 2.88, 2.1, 0), Vector3(0.96, 4.2, 1.08), yaw)
		for i in range(3):
			var origin = p + basis * Vector3(float(side) * 2.79, 0.8 + float(i) * 0.61, 0.59)
			_leaf("Carving", origin, Vector3.UP * 0.43 + basis * Vector3(float(side) * 0.13, 0, 0), 0.13, PALE, basis * Vector3.BACK)
	for i in range(19):
		var a = PI * float(i) / 19.0 + 0.005
		var b = PI * float(i + 1) / 19.0 - 0.005
		_voussoir(p + Vector3.UP * 3.02, Vector2(2.34, 2.34), Vector2(3.1, 2.92), a, b, 1.10, yaw, ASHLAR[i % 4])
		_voussoir(p + Vector3.UP * 3.02 + basis * Vector3.BACK * 0.61, Vector2(2.38, 2.38), Vector2(2.48, 2.48), a, b, 0.10, yaw, PALE)
	_block("Stonework", p + Vector3.UP * 5.79, Vector3(0.58, 0.67, 1.36), PALE, 0.12, basis)
	_leaf("Jade", p + basis * Vector3(0, 5.52, 0.72), Vector3.UP * 0.42, 0.13, JADE, basis * Vector3.BACK)

func _relief(p: Vector3) -> void:
	_carved_panel(p, 0, 1.0)

func _carved_panel(p: Vector3, yaw: float, scale_value: float) -> void:
	var basis = Basis(Vector3.UP, yaw).scaled(Vector3.ONE * scale_value)
	_block("Carving", p + basis * Vector3(0, 2.9, 0), Vector3(2.28, 4.98, 0.32), PALE, 0.09, basis)
	_block("Carving", p + basis * Vector3(0, 2.93, 0.19), Vector3(1.9, 4.48, 0.12), RECESS, 0.075, basis)
	for side in [-1, 1]:
		_block("Carving", p + basis * Vector3(float(side) * 0.96, 2.9, 0.29), Vector3(0.11, 4.5, 0.16), 0x818e76, 0.024, basis)
		for i in range(8):
			var origin = p + basis * Vector3(float(side) * 0.97, 1.0 + float(i) * 0.48, 0.38)
			_leaf("Carving", origin, basis * Vector3(float(side) * 0.11, 0.29, 0), 0.09 * scale_value, PALE, basis.z.normalized())
	for y in [0.78, 5.1]:
		_block("Carving", p + basis * Vector3(0, y, 0.31), Vector3(2.0, 0.14, 0.23), 0x8f9d82, 0.04, basis)
	var trunk: Array = []
	for point in [Vector3(0, 1.0, 0.37), Vector3(-0.18, 2.0, 0.4), Vector3(0.12, 3.0, 0.42), Vector3(-0.08, 4.1, 0.42), Vector3(0, 4.87, 0.36)]:
		trunk.append(p + basis * point)
	_tube("Carving", trunk, 0.17 * scale_value, 0.055 * scale_value, 0x93a087, 7)
	for i in range(5):
		for side in [-1, 1]:
			var y = 1.28 + float(i) * 0.65
			var width = 0.73 - absf(float(i) - 2.0) * 0.10
			var a = p + basis * Vector3(0, y, 0.41)
			var b = p + basis * Vector3(float(side) * width * 0.55, y + 0.30, 0.47)
			var c = p + basis * Vector3(float(side) * width, y + 0.64, 0.38)
			_tube("Carving", [a, b, c], 0.065 * scale_value, 0.023 * scale_value, 0x85967b, 6)
			_leaf("Carving", b - basis * Vector3(0, 0.1, 0), basis * Vector3(float(side) * width * 0.55, 0.48, 0.09), 0.20 * scale_value, PALE, basis.z.normalized())
			_leaf("Carving", a + basis * Vector3(float(side) * 0.2, 0.3, 0.08), basis * Vector3(float(side) * 0.22, 0.41, 0), 0.13 * scale_value, 0x9eaa90, basis.z.normalized())
	_leaf("Bronze", p + basis * Vector3(0, 2.72, 0.65), basis * Vector3(0, 0.77, 0), 0.29 * scale_value, BRONZE, basis.z.normalized())
	_leaf("Jade", p + basis * Vector3(0, 2.91, 0.75), basis * Vector3(0, 0.40, 0), 0.12 * scale_value, JADE, basis.z.normalized())
	_block("Stonework", p + basis * Vector3(0, 0.64, 0.26), Vector3(2.48, 0.26, 0.94), PALE, 0.075, basis)

func _build_shrine() -> void:
	var c = Vector3(0, 0, -4.32)
	_block("Fountain", c + Vector3.UP * 0.12, Vector3(5.04, 0.24, 4.08), 0x8c967d, 0.18)
	_block("Fountain", c + Vector3.UP * 0.35, Vector3(4.68, 0.24, 3.72), ASHLAR[0], 0.14)
	_block("Water", c + Vector3.UP * 0.56, Vector3(4.05, 0.06, 3.09), 0x27685f, 0.08)
	for side in [-1, 1]:
		_block("Fountain", c + Vector3(float(side) * 2.12, 0.64, 0), Vector3(0.30, 0.46, 3.43), PALE, 0.065)
		_block("Fountain", c + Vector3(0, 0.64, float(side) * 1.7), Vector3(4.19, 0.46, 0.30), PALE, 0.065)
		_block("Fountain", c + Vector3(0, 0.86, float(side) * 1.7), Vector3(4.30, 0.12, 0.38), 0xa9b196, 0.035)
		_block("Fountain", c + Vector3(float(side) * 2.12, 0.86, 0), Vector3(0.38, 0.12, 3.40), 0xa9b196, 0.035)
		for x in [-1.7, -1.1, -0.55, 0.0, 0.55, 1.1, 1.7]:
			var p = c + Vector3(x, 0.43, float(side) * 1.86)
			_leaf("Fountain", p, Vector3(0, 0.34, 0), 0.14, ASHLAR[0], Vector3(0, 0, side))
			_leaf("Fountain", p + Vector3(0, 0.035, float(side) * 0.01), Vector3(0, 0.26, 0), 0.087, PALE, Vector3(0, 0, side))
	_solid_box("ApprovedShrineBlocker", c + Vector3.UP * 0.48, Vector3(5.04, 0.96, 4.08))
	_tube("Roots", [c + Vector3(0, 0.6, 0), c + Vector3(-0.48, 2, -0.24), c + Vector3(-0.84, 3.7, -0.48), c + Vector3(-0.36, 5.2, -0.72), c + Vector3(0.6, 7.5, -1.2)], 0.82, 0.13, BARK[1], 13)
	var branches = [
		[c + Vector3(-0.5, 2.5, -0.2), c + Vector3(1.2, 3.8, -0.4), c + Vector3(3.5, 5.4, -1), c + Vector3(6.5, 6.5, -1.6), c + Vector3(8.8, 7.2, -3)],
		[c + Vector3(-0.7, 3.2, -0.3), c + Vector3(-2.2, 4.5, -0.4), c + Vector3(-4.5, 5.1, 0.2), c + Vector3(-6.8, 6.5, 1.8)],
		[c + Vector3(-0.3, 4.8, -0.7), c + Vector3(-2, 6, -1.9), c + Vector3(-3.8, 7.6, -3)]
	]
	for i in range(branches.size()):
		_tube("Roots", branches[i], 0.49 - float(i) * 0.07, 0.045, BARK[1], 11)
		var tip: Vector3 = branches[i][-1]
		for side in [-1, 1]:
			var end = tip + Vector3(float(side) * 1.1, 0.52, 0.64)
			_tube("Roots", [branches[i][-2], tip, end], 0.13, 0.018, BARK[1], 7)
			_foliage(end, 0.82, 18)
	for i in range(9):
		var angle = TAU * float(i) / 9.0
		_tube("Roots", [c + Vector3(-0.24, 1.7, 0), c + Vector3(cos(angle) * 0.96, 0.80, sin(angle)), c + Vector3(cos(angle) * 1.88, 0.64, sin(angle) * 1.4)], 0.30, 0.045, BARK[1], 9)
	var heart = c + Vector3(0.26, 0, 0.72)
	_lathe("Jade", heart, [Vector2(0.025, 2.32), Vector2(0.28, 2.67), Vector2(0.35, 3.1), Vector2(0.23, 3.48), Vector2(0.018, 3.8)], JADE, 7, Vector2(1, 0.72))
	for side in [-1, 1]:
		_tube("Bronze", [heart + Vector3(0, 2.23, 0), heart + Vector3(float(side) * 0.50, 2.83, 0), heart + Vector3(float(side) * 0.45, 3.40, 0), heart + Vector3(0, 3.88, 0)], 0.042, 0.025, BRONZE, 6)
	_tube("Roots", [heart + Vector3(0, 3.88, 0), c + Vector3(0.4, 4.6, 0.18), c + Vector3(-0.5, 5.1, -0.5)], 0.06, 0.16, BARK[1], 7)
	for x in [-1.8, 1.8]:
		_candles(c + Vector3(x, 0.92, 1.48))
	for radius in [0.64, 1.17]:
		var ring: Array = []
		for i in range(33):
			var angle = TAU * float(i) / 32.0
			ring.append(c + Vector3(cos(angle) * radius, 0.603, sin(angle) * radius * 0.68))
		_tube("Water", ring, 0.012, 0.012, 0x529587, 4)
	for point in [Vector3(-6.4, 6.4, -2.8), Vector3(-3.5, 7.5, -7.3), Vector3(6.4, 6.5, -5.8), Vector3(8.4, 7.1, -7.1), Vector3(0.4, 7.5, -5.5)]:
		_foliage(point, 1.0, 26)
	_light(c + Vector3(0.3, 3, 1.4), 0x6ae0c4, 1.8, 9.5, true)

func _foliage(p: Vector3, radius: float, amount: int) -> void:
	for i in range(amount):
		var angle = float(i) * 2.39996
		var offset = Vector3(cos(angle) * radius * rng.randf_range(0.2, 1.0), rng.randf_range(-0.2, 0.3) * radius, sin(angle) * radius * rng.randf_range(0.2, 1.0))
		var start = p + offset
		var direction = Vector3(cos(angle) * 0.42, rng.randf_range(0.10, 0.42), sin(angle) * 0.42)
		var normal = Vector3(0.1, 1.0, 0.2).normalized()
		_leaf("Foliage", start, direction, 0.15, LEAF[i % 4], normal)
		_leaf("Foliage", start + Vector3.UP * 0.08, direction.rotated(Vector3.UP, 1.0) * 0.8, 0.12, LEAF[(i + 1) % 4], normal)

func _urn(p: Vector3) -> void:
	_lathe("Vessels", p, [Vector2(0.22, 0.02), Vector2(0.26, 0.12), Vector2(0.24, 0.2), Vector2(0.38, 0.40), Vector2(0.36, 0.62), Vector2(0.22, 0.79), Vector2(0.21, 0.9), Vector2(0.28, 0.96), Vector2(0.28, 1.03), Vector2(0.20, 1.03), Vector2(0.17, 0.85)], 0x8e7957, 14)
	for i in range(10):
		var a = TAU * float(i) / 10.0
		var radial = Vector3(cos(a), 0, sin(a))
		_leaf("Vessels", p + radial * 0.35 + Vector3.UP * 0.32, Vector3.UP * 0.29, 0.06, 0xb1a178, radial)
	for side in [-1, 1]:
		_tube("Bronze", [p + Vector3(float(side) * 0.23, 0.83, 0), p + Vector3(float(side) * 0.47, 0.78, 0), p + Vector3(float(side) * 0.43, 0.52, 0), p + Vector3(float(side) * 0.32, 0.5, 0)], 0.035, 0.035, BRONZE, 6)

func _candles(p: Vector3) -> void:
	for i in range(4):
		var height = 0.18 + float(i % 3) * 0.12
		var c = p + Vector3(float(i - 2) * 0.18, 0, float(i % 2) * 0.18)
		_lathe("Vessels", c, [Vector2(0.065, 0), Vector2(0.061, height), Vector2(0.032, height + 0.025)], 0xd5c69c, 8)
		_lathe("Flame", c + Vector3.UP * height, [Vector2(0.01, 0.03), Vector2(0.037, 0.09), Vector2(0.004, 0.2)], 0xffd481, 6)

func _brazier(p: Vector3) -> void:
	_block("Stonework", p + Vector3.UP * 0.12, Vector3(0.96, 0.24, 0.96), PALE, 0.09)
	_lathe("Vessels", p, [Vector2(0.28, 0.24), Vector2(0.17, 0.5), Vector2(0.19, 0.92), Vector2(0.26, 1.05), Vector2(0.48, 1.24), Vector2(0.48, 1.34), Vector2(0.37, 1.34), Vector2(0.24, 1.14)], BRONZE, 12)
	for i in range(6):
		var angle = TAU * float(i) / 6.0
		var c = p + Vector3(cos(angle) * 0.18, 1.22, sin(angle) * 0.18)
		_tube("Flame", [c, c + Vector3(0.04, 0.26, 0), c + Vector3(-0.08, 0.55 + float(i % 2) * 0.16, 0)], 0.10, 0.006, 0xffbd6b, 7)
	_light(p + Vector3.UP * 1.9, 0xffc481, 2.4, 8, true)
	_solid_box("Brazier", p + Vector3.UP * 0.72, Vector3(0.84, 1.44, 0.84))

func _torch(p: Vector3) -> void:
	_tube("Roots", [p - Vector3.UP * 0.75, p + Vector3.UP * 0.02], 0.055, 0.08, BARK[1], 8)
	_lathe("Bronze", p, [Vector2(0.08, -0.1), Vector2(0.18, 0.04), Vector2(0.18, 0.14)], BRONZE, 10)
	_tube("Flame", [p + Vector3.UP * 0.06, p + Vector3(0.05, 0.29, 0), p + Vector3(-0.05, 0.64, 0)], 0.15, 0.005, 0xffbd69, 8)
	_light(p + Vector3.UP * 0.3, 0xffbc70, 2, 6.5, true)

func _build_dressing() -> void:
	for side in [-1, 1]:
		for z in [-6.7, 6.7]:
			var p = Vector3(float(side) * 11.7, 0, z)
			_tube("Roots", [p, p + Vector3(-float(side) * 0.6, 1.2, 0.2), p + Vector3(0, 3.4, -0.24), p + Vector3(float(side) * 0.5, 5.6, -1.2), p + Vector3(-float(side) * 1.2, 7.1, -2.1)], 0.42, 0.045, BARK[1], 11)
			for i in range(3):
				_tube("Roots", [p + Vector3(0, 1.5, 0), p + Vector3(float(side) * 0.35, 0.32, 0.3), p + Vector3(float(side) * 0.5, 0.12, float(i - 1) * 0.7)], 0.12, 0.025, BARK[1], 7)
			_foliage(p + Vector3(0, 6.1, -1.3), 1.05, 24)
			_foliage(p + Vector3(-float(side) * 0.4, 0.20, 0.5), 0.62, 20)
			for i in range(9):
				var rock = p + Vector3(rng.randf_range(-0.8, 0.8), 0.09, rng.randf_range(-0.8, 0.8))
				_block("Stonework", rock, Vector3(rng.randf_range(0.2, 0.43), 0.18, rng.randf_range(0.24, 0.52)), ASHLAR[i % 4], 0.055, Basis(Vector3.UP, rng.randf_range(-PI, PI)))
			_urn(p + Vector3(-float(side) * 1.3, 0, 0.9))
			_brazier(p + Vector3(-float(side) * 2.3, 0, 1.2))
		for z in [3.0, -3.0]:
			_urn(Vector3(float(side) * 12.4, 0, z))
			_candles(Vector3(float(side) * 11.8, 0, z + 0.8))
	for x in [-5.9, 5.9]:
		for z in [-9.0, 9.0]:
			var points: Array = []
			for i in range(12):
				var p = Vector3(x + sin(float(i) * 0.7) * 0.16, 6.1 - float(i) * 0.24, z + (0.55 if z < 0 else -0.55))
				points.append(p)
				_leaf("Foliage", p, Vector3(0.23 if i % 2 == 0 else -0.23, -0.24, 0.08), 0.11, LEAF[i % 4])
			_tube("Roots", points, 0.04, 0.01, BARK[1], 5)
