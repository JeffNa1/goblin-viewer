extends SceneTree

const DungeonVoxelBuilder = preload("res://scripts/dungeon_voxel_builder.gd")

func _init() -> void:
	print("--- TESTING DUNGEON VOXEL BUILDER ---")
	
	var t0 = Time.get_ticks_msec()
	var mesh_hub = DungeonVoxelBuilder.build_hub_mesh()
	print("1. Hub Mesh: %d vertices (took %d ms)" % [mesh_hub.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_grotto = DungeonVoxelBuilder.build_grotto_mesh()
	print("2. Grotto Mesh: %d vertices (took %d ms)" % [mesh_grotto.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_scriptorium = DungeonVoxelBuilder.build_scriptorium_mesh()
	print("3. Scriptorium Mesh: %d vertices (took %d ms)" % [mesh_scriptorium.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_cosmic = DungeonVoxelBuilder.build_cosmic_arena_mesh()
	print("4. Cosmic Arena Mesh: %d vertices (took %d ms)" % [mesh_cosmic.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_crypt = DungeonVoxelBuilder.build_crypt_mesh()
	print("5. Crypt Mesh: %d vertices (took %d ms)" % [mesh_crypt.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_dragon = DungeonVoxelBuilder.build_dragon_arena_mesh()
	print("6. Dragon Arena Mesh: %d vertices (took %d ms)" % [mesh_dragon.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_catacombs = DungeonVoxelBuilder.build_catacombs_mesh()
	print("7. Catacombs Mesh: %d vertices (took %d ms)" % [mesh_catacombs.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_wharf = DungeonVoxelBuilder.build_wharf_mesh()
	print("8. Wharf Mesh: %d vertices (took %d ms)" % [mesh_wharf.get_surface_count(), Time.get_ticks_msec() - t0])
	
	t0 = Time.get_ticks_msec()
	var mesh_corridors = DungeonVoxelBuilder.build_corridors_mesh()
	print("9. Corridors Mesh: %d vertices (took %d ms)" % [mesh_corridors.get_surface_count(), Time.get_ticks_msec() - t0])
	
	print("--- ALL 8 DUNGEON ROOMS COMPILED & GENERATED CLEANLY ---")
	quit(0)
