extends RefCounted

static func build(a) -> void:
	match a.source_room_id:
		"01": _landing(a)
		"02": _sluice(a)
		"03": _court(a)
		"04": _barracks(a)
		"05": _smithy(a)
		"06": _cloister(a)

static func _landing(a) -> void:
	a.landmark_name = "Lantern dock and carved river skiff"
	var boat: Vector3 = a.local_plan([462, 1638])
	a.water_basin(a.local_plan([590, 1640]), Vector2(20.4, 7.68))
	var voxels: Dictionary = {}
	for z in range(-21, 22):
		var width = 8 - maxi(0, absi(z) - 13)
		for x in range(-width, width + 1):
			voxels[Vector3i(x, 0, z)] = 0x765438
			if absi(x) == width:
				for y in range(1, 6):
					voxels[Vector3i(x, y, z)] = 0xaa8455 if y == 5 else 0x88613e
			elif absi(z) == 7:
				voxels[Vector3i(x, 4, z)] = 0xb89964
	a._emit_grid("RiverSkiff", voxels, 0.12, boat + Vector3(0, -0.18, 0), false)
	a._box(boat + Vector3(0, 0.5, 1.8), Vector3(1.68, 0.12, 0.12), 0xc5aa72)
	a._box(boat + Vector3(0, 0.5, -1.8), Vector3(1.68, 0.12, 0.12), 0xc5aa72)
	var dock: Vector3 = a.local_plan([480, 1623])
	for i in range(14):
		a._box(dock + Vector3(-float(i) * 0.36, 0.12, 0), Vector3(0.33, 0.24, 2.64), [0x856544, 0x98744d, 0xa48359][i % 3])
	for side in [-1, 1]:
		for x in [0.0, -4.32]:
			a._box(dock + Vector3(x, 0.12, float(side) * 1.32), Vector3(0.36, 1.68, 0.36), 0x5f4c35)
			a._box(dock + Vector3(x, 0.98, float(side) * 1.32), Vector3(0.48, 0.12, 0.48), a.GOLD)
	a._torch(dock + Vector3(0, 2.1, -1.32))
	var beacon: Vector3 = a.local_plan([537, 1561])
	for tier in range(4):
		a._box(beacon + Vector3(0, 0.24 + float(tier) * 0.36, 0), Vector3(1.8 - float(tier) * 0.24, 0.48, 1.8 - float(tier) * 0.24), a.STONE[tier])
	a._box(beacon + Vector3(0, 2.22, 0), Vector3(0.48, 1.2, 0.48), a.GOLD)
	a._box(beacon + Vector3(0, 3, 0), Vector3(0.72, 0.6, 0.72), a.JADE, 0, "jade")
	a._light(beacon + Vector3(0, 3, 0), 0x94dbc1, 1.8, 9, true)
	for p in a.edge_spots:
		a._foliage(p + Vector3(0, 0.12, 0), 0.7, 22)
		for j in range(7):
			a._box(p + Vector3(float(j % 3) * 0.18, 0.6 + float(j % 2) * 0.18, float(j / 3) * 0.18), Vector3(0.06, 1.2, 0.06), 0x7d8d4c)
	a.focus_point = dock + Vector3(0, 1.1, -0.7)

static func _sluice(a) -> void:
	a.landmark_name = "Bronze sluice wheel and raised watergate"
	var p: Vector3 = a.blocker_centers[0]
	a._box(p + Vector3(0, 0.24, 0), Vector3(3.48, 0.48, 2.88), 0x778473)
	a._box(p + Vector3(0, 1.56, -0.42), Vector3(0.72, 2.4, 0.84), 0x465a52)
	for i in range(24):
		var angle = TAU * float(i) / 24.0
		var tooth = p + Vector3(cos(angle) * 1.2, 2.1 + sin(angle) * 1.2, 0.3)
		a._box(tooth.snapped(Vector3.ONE * 0.12), Vector3(0.36, 0.36, 0.36), 0xb49b68)
	for i in range(-7, 8):
		a._box(p + Vector3(float(i) * 0.12, 2.1, 0.3), Vector3(0.12, 0.24, 0.36), 0x8e7c55)
		a._box(p + Vector3(0, 2.1 + float(i) * 0.12, 0.3), Vector3(0.24, 0.12, 0.36), 0x8e7c55)
	a._box(p + Vector3(0, 2.1, 0.66), Vector3(0.6, 0.6, 0.36), a.GOLD)
	var gate: Vector3 = a.local_plan([590, 1286])
	a._box(gate + Vector3(0, 6, 0), Vector3(9.6, 0.72, 1.44), 0x435b51)
	for i in range(-8, 9):
		a._box(gate + Vector3(float(i) * 0.48, 4.92, 0), Vector3(0.18, 1.44, 0.36), 0x9b956e)
	a.banner(gate + Vector3(-4.4, 1.5, 0.75), 1.2, 3.2, 0x365f60)
	a.banner(gate + Vector3(4.4, 1.5, 0.75), 1.2, 3.2, 0x365f60)
	var basin: Vector3 = a.blocker_centers[1]
	a._box(basin + Vector3(0, 0.24, 0), Vector3(3, 0.48, 2.88), 0x89967e)
	a._box(basin + Vector3(0, 0.5, 0), Vector3(2.52, 0.06, 2.4), 0x469986, 0, "water")
	for sign_value in [-1, 1]:
		a._box(basin + Vector3(float(sign_value) * 1.32, 0.72, 0), Vector3(0.24, 0.48, 2.88), 0x9da78b)
	a._light(p + Vector3(0, 3.4, 1.5), 0xffd296, 1.7, 9, false)
	a.focus_point = p + Vector3(0, 2.1, 0)

static func _court(a) -> void:
	a.landmark_name = "Ancient root island and branching heraldry"
	var p: Vector3 = a.blocker_centers[0]
	for tier in range(3):
		a._box(p + Vector3(0, 0.12 + float(tier) * 0.24, 0), Vector3(6.72 - float(tier) * 0.72, 0.24, 6.6 - float(tier) * 0.72), a.STONE[4 - tier])
	a.tree(p + Vector3(0, 0.72, 0), 9.3, 9, 1.08)
	for i in range(12):
		var angle = float(i) * TAU / 12.0
		var center = p + Vector3(cos(angle) * 2.9, 0.76, sin(angle) * 2.8)
		a._foliage(center, 0.65, 14)
		if i % 3 == 0:
			a._candles(center)
	for side in [-1, 1]:
		var arch = p + Vector3(float(side) * 10, 0, -5)
		a._relief(arch)
		a.banner(arch + Vector3(float(side) * 2.1, 0.6, 0), 1.3, 4.2, 0x8b713d if side < 0 else 0x79494b)
	for r in [5.8, 6.1]:
		for i in range(96):
			var angle = float(i) * TAU / 96.0
			var point = p + Vector3(cos(angle) * r, 0.032, sin(angle) * r)
			a._box(point.snapped(Vector3(0.12, 0.001, 0.12)), Vector3(0.12, 0.008, 0.12), a.GOLD)
	a._light(p + Vector3(0, 4, 2), 0xa4d5a5, 1.1, 15, false)
	a.focus_point = p + Vector3(0, 3.4, 0)

static func _barracks(a) -> void:
	a.landmark_name = "Double bunks, weapon racks and faded company banners"
	for i in range(2):
		var p: Vector3 = a.blocker_centers[i]
		for x in [-1.1, 1.1]:
			for z in [-1.0, 1.0]:
				a._box(p + Vector3(x, 1.44, z), Vector3(0.18, 2.88, 0.18), 0x67503a)
		for level in [0.6, 1.92]:
			a._box(p + Vector3(0, level, 0), Vector3(2.4, 0.18, 2.16), 0x9e815a)
			a._box(p + Vector3(0, level + 0.18, 0.12), Vector3(2.16, 0.18, 1.56), 0x73805a if i == 0 else 0x7c5748)
			a._box(p + Vector3(0, level + 0.24, -0.72), Vector3(1.92, 0.24, 0.36), 0xc1b78c)
		for step in range(5):
			a._box(p + Vector3(1.15, 0.4 + float(step) * 0.42, 1.15), Vector3(0.54, 0.12, 0.18), a.GOLD)
	var rack: Vector3 = a.blocker_centers[2]
	a._box(rack + Vector3(0, 0.96, 0), Vector3(5.7, 0.24, 1.68), 0x8b6b48)
	for x in [-2.5, 2.5]:
		a._box(rack + Vector3(x, 0.48, 0), Vector3(0.24, 0.96, 1.32), 0x5b4634)
	for i in range(8):
		var weapon = rack + Vector3(-2.28 + float(i) * 0.66, 1.08, -0.4)
		a._box(weapon + Vector3(0, 0.78, 0), Vector3(0.12, 1.56, 0.12), 0x9f9274)
		a._box(weapon + Vector3(0, 1.44, 0), Vector3(0.48, 0.6, 0.12), 0x91a39b)
		a._box(weapon + Vector3(0, 0.72, 0), Vector3(0.48, 0.12, 0.24), a.GOLD)
	for i in range(a.edge_spots.size()):
		if i % 2 == 0:
			a.banner(a.edge_spots[i] + Vector3(0, 1.2, 0.72), 1.44, 3.6, 0x8b573f)
	a.focus_point = a.blocker_centers[0] + Vector3(0, 1.6, 0)

static func _smithy(a) -> void:
	a.landmark_name = "Open ember furnace, anvils and trading counter"
	var p: Vector3 = a.blocker_centers[0]
	a._box(p + Vector3(0, 0.24, 0), Vector3(4.08, 0.48, 4.32), 0x574e40)
	for side in [-1, 1]:
		for row in range(6):
			a._box(p + Vector3(float(side) * 1.62, 0.66 + float(row) * 0.48, 0), Vector3(0.6, 0.44, 3.96), [0x685845, 0x7b6650, 0x897455][row % 3])
	a._box(p + Vector3(0, 1.92, -1.62), Vector3(3.48, 2.88, 0.6), 0x625442)
	a._box(p + Vector3(0, 3.6, 0), Vector3(4.08, 0.96, 4.08), 0x958061)
	a._box(p + Vector3(0, 5.7, -0.84), Vector3(1.92, 3.6, 1.92), 0x594e40)
	for i in range(26):
		var ember = p + Vector3(a.rng.randf_range(-1.1, 1.1), 0.7 + a.rng.randf_range(0, 0.36), a.rng.randf_range(-0.7, 1.3))
		a._box(ember, Vector3(0.24, 0.24, 0.24), [0xea7137, 0xffb653, 0xffd78a][i % 3], 0, "flame")
	a._light(p + Vector3(0, 1.8, 1.2), 0xff8c43, 3, 10, true)
	var counter: Vector3 = a.blocker_centers[1]
	a._box(counter + Vector3(0, 0.54, 0), Vector3(4.32, 1.08, 1.8), 0x694d33)
	a._box(counter + Vector3(0, 1.14, 0), Vector3(4.56, 0.24, 2.04), 0xaa895b)
	a._box(counter + Vector3(-0.6, 1.44, 0), Vector3(1.08, 0.36, 0.72), 0x596366)
	a._box(counter + Vector3(-0.6, 1.74, 0), Vector3(1.56, 0.24, 0.84), 0x91a09a)
	for i in range(6):
		a._box(counter + Vector3(0.6 + float(i % 3) * 0.42, 1.38 + float(i / 3) * 0.18, 0.12), Vector3(0.36, 0.18, 0.72), 0xb9a976)
	for i in range(a.edge_spots.size()):
		if i % 3 == 0:
			a.shelf(a.edge_spots[i] + Vector3(0, 0, 0.6), 1.8, 2.4)
	a.focus_point = p + Vector3(0, 2.0, 0.8)

static func _cloister(a) -> void:
	a.landmark_name = "Hunter effigies and a broken garden colonnade"
	for p in a.blocker_centers:
		a._relief(p)
		a._box(p + Vector3(0.84, 2.4, 0.36), Vector3(0.12, 4.8, 0.12), a.GOLD)
		a._box(p + Vector3(0.84, 4.8, 0.36), Vector3(0.36, 0.48, 0.36), 0xc0cab0)
	var garden: Vector3 = a.local_plan([247, 545])
	a.water_basin(garden, Vector2(5.4, 5.4))
	a.tree(garden + Vector3(1.2, 0, -1.2), 7.5, 5.8, 0.72)
	for i in range(a.edge_spots.size()):
		var p: Vector3 = a.edge_spots[i]
		a.banner(p + Vector3(0, 1, 0.72), 1.08, 3.6, 0x657246)
		for j in range(7):
			a._box(p + Vector3(0.3, 5.5 - float(j) * 0.3, 0.6), Vector3(0.36, 0.3, 0.18), a.LEAF[j % 4])
		if i + 1 < a.edge_spots.size():
			var other: Vector3 = a.edge_spots[i + 1]
			if p.distance_to(other) < 10.0:
				for step in range(16):
					var t = float(step) / 15.0
					var point = p.lerp(other, t) + Vector3.UP * (6.6 + sin(t * PI) * 1.2)
					a._box(point.snapped(Vector3.ONE * 0.12), Vector3(0.6, 0.48, 0.6), a.STONE[step % 4])
	a.focus_point = a.blocker_centers[0] + Vector3(0, 2.7, 0.3)
