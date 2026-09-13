extends "res://Rootbound_Sanctum/Art_Dungeon/room_art.gd"

# Packed room geometry is prepared offline. Restore only review metadata at startup.
func restore(grid) -> void:
	plan = grid
	var data: Dictionary = get_meta("review_data")
	room_data = data["source"]
	source_room_id = data["id"]
	anchor_cell = Vector2i(roundi(position.x / CELL), roundi(position.z / CELL))
	extent = Vector2(data["extent"][0], data["extent"][1])
	focus_point = Vector3(data["focus"][0], data["focus"][1], data["focus"][2])
	landmark_name = data["landmark"]
	geometry_stats = data["geometry"]
	for p in data["blockers"]:
		blocker_centers.append(Vector3(p[0],p[1],p[2]))
	for cell in plan.by_room[source_room_id]:
		floor_cells[cell-anchor_cell] = true
	room_cell_count = floor_cells.size()
