extends RefCounted

static func build(a) -> void:
	match a.source_room_id:
		"08": _archive(a)
		"09": _vault(a)
		"10": _spoils(a)
		"11": _choir(a)
		"12": _grotto(a)
		"13": _cache(a)
		"14": _ascent(a)

static func _archive(a) -> void:
	a.landmark_name = "Flooded crescent library and eroded book galleries"
	a.water_basin(a.local_plan([1022, 1134]), Vector2(11.28, 14.64))
	for i in range(a.blocker_centers.size()):
		var p: Vector3 = a.blocker_centers[i]
		a._box(p + Vector3(0, 0.18, 0), Vector3(2.76, 0.36, 1.92), 0x89947e)
		a.shelf(p + Vector3(0, 0.36, -0.3), 2.64, 4.2)
		a._candles(p + Vector3(0.84, 0.36, 0.66))
	for i in range(a.edge_spots.size()):
		var p: Vector3 = a.edge_spots[i]
		if i % 2 == 0:
			a.shelf(p + Vector3(0, 0, 0.72), 2.4, 3.6)
		else:
			a._foliage(p + Vector3(0, 5.7, 0), 1.0, 24)
			for j in range(7):
				a._box(p + Vector3(0.18, 5.4 - float(j) * 0.36, 0.72), Vector3(0.3, 0.36, 0.18), a.LEAF[j % 4])
	var bank: Vector3 = a.local_plan([1000, 1090])
	for i in range(7):
		a._box(bank + Vector3(float(i) * 0.6, -0.12, -float(i) * 0.36), Vector3(0.48, 0.12, 0.84), 0x629d8a, 0, "water")
	a._light(a.local_plan([1000, 1110]) + Vector3.UP * 3, 0x6bbfae, 2, 16, false)
	a.focus_point = a.blocker_centers[0] + Vector3(0.7, 2.5, 0)

static func _vault(a) -> void:
	a.landmark_name = "Twin blood obelisks and an unobstructed ritual circle"
	for i in range(a.blocker_centers.size()):
		var p: Vector3 = a.blocker_centers[i]
		for tier in range(4):
			a._box(p + Vector3(0, 0.12 + float(tier) * 0.24, 0), Vector3(2.28 - float(tier) * 0.24, 0.24, 2.28 - float(tier) * 0.24), [0x69505a, 0x80676c, 0x96817b, 0xb6a08a][tier])
		for row in range(16):
			var width = 1.08 if row < 12 else 1.08 - float(row - 11) * 0.18
			a._box(p + Vector3(0, 1.14 + float(row) * 0.24, 0), Vector3(width, 0.24, width), 0x53464e)
		for y in [1.44, 2.64, 3.84]:
			a._box(p + Vector3(0, y, 0.6), Vector3(0.12, 0.54, 0.12), 0xe1857a, 0, "flame")
		a.banner(p + Vector3(0, 0.6, -0.84), 1.68, 4.5, 0x713f4c)
		a._light(p + Vector3(0, 2.4, 1.4), 0xe49085, 1.9, 10, true)
	var center: Vector3 = a.local_plan([915, 812])
	for radius in [4.8, 5.2]:
		for i in range(96):
			var angle = float(i) * TAU / 96.0
			a._box((center + Vector3(cos(angle) * radius, 0.032, sin(angle) * radius)).snapped(Vector3(0.12, 0.001, 0.12)), Vector3(0.18, 0.008, 0.18), 0x955c60)
	for i in range(8):
		var angle = float(i) * TAU / 8.0
		var p = center + Vector3(cos(angle) * 3.6, 0.032, sin(angle) * 3.6)
		a._box(p, Vector3(0.48, 0.008, 0.12), a.GOLD)
		a._box(p, Vector3(0.12, 0.008, 0.48), a.GOLD)
	a.focus_point = a.blocker_centers[1] + Vector3(0, 2.6, 0)

static func _spoils(a) -> void:
	a.landmark_name = "Sealed bronze reliquary beneath a gilded apse"
	var p: Vector3 = a.blocker_centers[0]
	a._box(p + Vector3(0, 0.12, 0), Vector3(6.6, 0.24, 2.4), 0x899079)
	a.chest(p + Vector3(0, 0.24, 0), 4.2)
	for side in [-1, 1]:
		a._candles(p + Vector3(float(side) * 2.76, 0.24, 0.66))
		for i in range(4):
			a._box(p + Vector3(float(side) * (1.92 + float(i) * 0.24), 2.4 + float(i) * 0.48, -0.6), Vector3(0.24, 0.48, 0.24), a.GOLD)
	for i in range(17):
		var x = float(i - 8) * 0.3
		var y = 3.2 + sqrt(maxf(0, 5.76 - x * x)) * 0.7
		a._box(p + Vector3(x, y, -0.72), Vector3(0.3, 0.3, 0.3), 0xc8b17c)
	a._light(p + Vector3(0, 3.2, 1.5), 0xffd998, 2.2, 9, false)
	a.focus_point = p + Vector3(0, 1.9, 0)

static func _choir(a) -> void:
	a.landmark_name = "Ancient pipe organ, hanging choir lights and a clear nave"
	var p: Vector3 = a.blocker_centers[2]
	a._box(p + Vector3(0, 0.24, 0), Vector3(4.44, 0.48, 2.04), 0x91947c)
	a._box(p + Vector3(0, 1.32, 0), Vector3(4.08, 1.68, 1.68), 0x4f5147)
	for i in range(13):
		var x = float(i - 6) * 0.3
		var height = 4.8 + (1.0 - absf(float(i - 6)) / 6.0) * 2.4
		a._box(p + Vector3(x, 1.8 + height * 0.5, -0.3), Vector3(0.24, height, 0.36), 0xb5a174)
		a._box(p + Vector3(x, 2.1, -0.06), Vector3(0.12, 0.6, 0.06), 0x353e39)
		a._box(p + Vector3(x, 1.8 + height, -0.3), Vector3(0.36, 0.12, 0.48), 0xd0bd86)
	a._box(p + Vector3(0, 1.56, 0.84), Vector3(3.84, 0.18, 0.48), 0xc6bc93)
	for i in range(16):
		a._box(p + Vector3(float(i - 8) * 0.24, 1.68, 0.84), Vector3(0.12, 0.06, 0.36), 0x2e3c38)
	for i in range(2):
		var column: Vector3 = a.blocker_centers[i]
		a._pillar(column, 6.3)
		a.banner(column + Vector3(0, 1.2, 0.72), 1.4, 4.2, 0x465973)
	var center: Vector3 = a.local_plan([505, 426])
	a._box(center + Vector3(0, 0.03, 0), Vector3(3.84, 0.008, 15.36), 0x52626e)
	for side in [-1, 1]:
		a._box(center + Vector3(float(side) * 1.8, 0.038, 0), Vector3(0.06, 0.008, 15.12), a.GOLD)
	for z in [-3.6, 4.8]:
		var chandelier = center + Vector3(0, 6.6, z)
		for side in [-1, 1]:
			a._box(chandelier + Vector3(float(side) * 1.8, 0, 0), Vector3(0.24, 0.24, 3.84), a.GOLD)
			a._box(chandelier + Vector3(0, 0, float(side) * 1.8), Vector3(3.84, 0.24, 0.24), a.GOLD)
			a._box(chandelier + Vector3(float(side) * 1.8, 1.2, 0), Vector3(0.12, 2.4, 0.12), 0x78816c)
			for x in [-1.2, 0, 1.2]:
				a._box(chandelier + Vector3(x, 0.36, float(side) * 1.8), Vector3(0.12, 0.6, 0.12), 0xffdca0, 0, "flame")
		a._light(chandelier - Vector3.UP, 0xffdba4, 1.5, 12, false)
	a._light(p + Vector3(0, 4, 1.8), 0xabc8d7, 1.5, 12, false)
	a.focus_point = p + Vector3(0, 3.3, 0.6)

static func _grotto(a) -> void:
	a.landmark_name = "Giant spore canopies over an open boss arena"
	for i in range(a.blocker_centers.size()):
		var p: Vector3 = a.blocker_centers[i]
		_mushroom(a, p, 7.5 + float(i) * 1.2, 5.4 + float(i) * 0.6)
		a._light(p + Vector3(0, 4.2, 1.8), 0x79cec0, 2.2, 15, true)
	for i in range(a.edge_spots.size()):
		var p: Vector3 = a.edge_spots[i]
		_mushroom(a, p, 3.2 + float(i % 3) * 0.6, 1.6 + float(i % 2) * 0.4)
		for j in range(5):
			a._mushroom(p + Vector3(float(j % 3) * 0.42 - 0.6, 0, float(j / 3) * 0.48 + 0.6))
		a._foliage(p + Vector3(0, 0.36, 0), 1.0, 20)
	var pool: Vector3 = a.local_plan([860, 60])
	a.water_basin(pool, Vector2(9.6, 6))
	var center: Vector3 = a.local_plan([705, 167])
	for i in range(96):
		var angle = TAU * float(i) / 96.0
		var p = center + Vector3(cos(angle) * 8.4, 0.032, sin(angle) * 8.4)
		a._box(p.snapped(Vector3(0.12, 0.001, 0.12)), Vector3(0.24, 0.008, 0.24), 0x738d70)
	# The arena center has no new raised obstacle, enemy, or hazard effect.
	a.focus_point = a.blocker_centers[1] + Vector3(0, 4.0, 0)

static func _mushroom(a, p: Vector3, height: float, radius: float) -> void:
	var grid: Dictionary = {}
	var cell: float = 0.24
	var stem = maxi(2, roundi(radius * 0.17 / cell))
	var top = roundi(height / cell)
	for y in range(top):
		for x in range(-stem, stem + 1):
			for z in range(-stem, stem + 1):
				if x * x + z * z <= stem * stem:
					grid[Vector3i(x, y, z)] = [0x7b8a6b, 0x95a17b, 0xb2bc8d][posmod(x + z, 3)]
	var r = ceili(radius / cell)
	for layer in range(6):
		var current = float(r) * [0.94, 1.0, 0.94, 0.8, 0.6, 0.34][layer]
		for x in range(-r, r + 1):
			for z in range(-r, r + 1):
				if float(x * x + z * z) <= current * current:
					var color: int = [0x467d6a, 0x578e75, 0x6ba387, 0x80b497][posmod(floori(float(x) / 3) + floori(float(z) / 3), 4)]
					if layer == 0:
						color = 0xb8cc99
					if layer >= 3 and posmod(x * 13 + z * 7, 19) < 2:
						color = 0xd4dcb1
					grid[Vector3i(x, top + layer, z)] = color
	a._emit_grid("SteppedSporeCanopy", grid, cell, p, false)
	for i in range(9):
		var angle = float(i) * TAU / 9.0
		for j in range(4):
			a._box(p + Vector3(cos(angle) * radius * 0.7, height - float(j) * 0.18, sin(angle) * radius * 0.7), Vector3(0.12, 0.18, 0.12), 0x83d4b3, 0, "jade")

static func _cache(a) -> void:
	a.landmark_name = "Hidden reliquary and overgrown crypt niches"
	var p: Vector3 = a.blocker_centers[0]
	a._box(p + Vector3(0, 0.18, 0), Vector3(5.04, 0.36, 2.52), 0x9a967e)
	a.chest(p + Vector3(0, 0.36, 0), 3.6, 0xa4a18a)
	for side in [-1, 1]:
		a._candles(p + Vector3(float(side) * 2.16, 0.36, 0.6))
	for i in range(a.edge_spots.size()):
		var q: Vector3 = a.edge_spots[i]
		if i % 2 == 0:
			a._box(q + Vector3(0, 0.48, 0.4), Vector3(1.2, 0.96, 1.8), 0x797a68)
			a._box(q + Vector3(0, 1.02, 0.4), Vector3(1.44, 0.12, 2.04), 0xa3a48b)
			a._solid_box("CryptCoffer", q + Vector3(0, 0.54, 0.4), Vector3(1.44, 1.08, 2.04))
			a._box(q + Vector3(0, 1.12, 0.4), Vector3(0.12, 0.08, 0.84), a.GOLD)
			a._foliage(q + Vector3(0, 5.7, 0.3), 0.8, 18)
	a._light(p + Vector3(0, 2.4, 1.3), 0xbfc1e3, 1.8, 9, false)
	a.focus_point = p + Vector3(0, 1.8, 0)

static func _ascent(a) -> void:
	a.landmark_name = "Dogleg ascent with a luminous upper threshold"
	var p: Vector3 = a.local_plan([1015, 408])
	for i in range(14):
		var h = float(i + 1) * 0.24
		var center = p + Vector3(0, h * 0.5, float(i) * 0.36)
		var size = Vector3(2.4, h, 0.36)
		a._box(center, size, a.STONE[(i + 2) % 4])
		a._box(center + Vector3(0, h * 0.5 + 0.016, 0.15), Vector3(2.4, 0.032, 0.06), 0xb9b28b)
		a._solid_box("AscentStep", center, size)
	for side in [-1, 1]:
		for i in range(7):
			var q = p + Vector3(float(side) * 1.5, 0.6 + float(i) * 0.48, float(i) * 0.72)
			a._box(q, Vector3(0.36, 1.2, 0.36), 0x8c987f)
			a._box(q + Vector3(0, 0.66, 0), Vector3(0.48, 0.12, 0.48), a.GOLD)
	var door = p + Vector3(0, 3.36, 4.86)
	for side in [-1, 1]:
		a._box(door + Vector3(float(side) * 1.44, 1.5, 0), Vector3(0.48, 3, 0.72), 0xb6b897)
	a._box(door + Vector3(0, 3.12, 0), Vector3(3.36, 0.36, 0.84), 0xc7bd8d)
	a._box(door + Vector3(0, 1.5, 0.3), Vector3(2.4, 3, 0.12), 0x99cebd, 0, "jade")
	a._light(door + Vector3(0, 2, -0.8), 0xb7e7ca, 2.4, 12, true)
	a.focus_point = p + Vector3(0, 3.4, 3.6)
