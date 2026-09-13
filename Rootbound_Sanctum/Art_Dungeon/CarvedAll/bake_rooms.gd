extends SceneTree

const BASE = preload("res://Rootbound_Sanctum/Art_Dungeon/room_art.gd")
const APPROVED = preload("res://Rootbound_Sanctum/Art_Dungeon/Carved07/room_07.gd")
const ROOM = preload("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/room.gd")
const GRID = preload("res://Rootbound_Sanctum/Art_Dungeon/layout_grid.gd")
const OUT = "res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Assets/"
var library: Node3D
var records: Array = []

func _init() -> void: call_deferred("run")

func read_glb(path: String) -> Node3D:
	var document = GLTFDocument.new()
	var state = GLTFState.new()
	var error = document.append_from_file(path,state)
	if error != OK:
		printerr("GLB_LOAD_FAILED ",path," ",error)
		quit(1)
		return null
	var node = document.generate_scene(state)
	for mesh in node.find_children("*","MeshInstance3D",true,false):
		for i in range(mesh.mesh.get_surface_count()):
			var material = mesh.mesh.surface_get_material(i)
			if material is StandardMaterial3D:
				material.vertex_color_is_srgb = false
				material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return node

func own(node: Node, owner_root: Node) -> void:
	for child in node.get_children():
		child.owner = owner_root
		own(child,owner_root)

func save_scene(node: Node3D, name: String) -> void:
	own(node,node)
	var packed = PackedScene.new()
	var result = packed.pack(node)
	if result == OK: result = ResourceSaver.save(packed,OUT+name+".scn",ResourceSaver.FLAG_COMPRESS)
	if result != OK:
		printerr("BAKE_SAVE_FAILED ",name," ",result)
		quit(1)

func template(parent: Node3D, prefix: String, point: Vector3, yaw: float = 0.0) -> void:
	for original in library.find_children(prefix+"*","MeshInstance3D",true,false):
		var mesh = MeshInstance3D.new()
		mesh.name = "Shared_"+prefix
		mesh.mesh = original.mesh
		mesh.position = point
		mesh.rotation.y = yaw
		parent.add_child(mesh)
		return

func clean_legacy_geometry(node: Node) -> void:
	for child in node.get_children():
		if child is MeshInstance3D:
			var name = str(child.name)
			if not name.begins_with("Floor_") and not name.begins_with("DecorativeWater"):
				# Keep the original collision proxy, not its coarse visible mesh.
				child.visible = false
		elif child is MultiMeshInstance3D:
			var mm = child.multimesh
			for i in range(mm.instance_count):
				var t = mm.get_instance_transform(i)
				if t.origin.y + t.basis.y.length()*.5 > .065:
					t.basis = Basis(Vector3.ZERO,Vector3.ZERO,Vector3.ZERO)
					mm.set_instance_transform(i,t)
		else:
			clean_legacy_geometry(child)

func run() -> void:
	var grid = GRID.new()
	var metadata = JSON.parse_string(FileAccess.get_file_as_string("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Evidence/baseline-rooms.json"))
	library = read_glb("res://Rootbound_Sanctum/Art_Dungeon/Carved07/Assets/sanctuary.glb")
	if library == null: return
	var chosen = OS.get_cmdline_user_args()
	for source in grid.data["rooms"]:
		var id: String = source["id"]
		if not chosen.is_empty() and not chosen.has(id): continue
		print("BAKING_ROOM ",id)
		var old = APPROVED.new() if id=="07" else BASE.new()
		root.add_child(old)
		old.configure(source,grid)
		for batch in old.find_children("*","MultiMeshInstance3D",true,false):
			if batch.multimesh.instance_count>0 and batch.multimesh.buffer.is_empty():
				printerr("BAKE_REQUIRES_REAL_RENDERER: MultiMesh data is empty; use Forward+ without --headless.")
				quit(1)
				return
		var node = ROOM.new()
		node.name = "Room_"+id
		node.position = old.position
		var datum = metadata[int(id)-1].duplicate(true)
		datum["source"] = source
		datum["geometry"] = old.geometry_stats.duplicate(true)
		node.set_meta("review_data",datum)
		if id != "07": clean_legacy_geometry(old)
		for child in old.get_children():
			old.remove_child(child)
			node.add_child(child)
		old.queue_free()
		if id != "07":
			var sculpture = read_glb(OUT+id+".glb")
			if sculpture == null: return
			sculpture.name = "AuthoredRoomArt"
			node.add_child(sculpture)
			var edges = datum["edges"]
			for i in range(edges.size()):
				# Keep the archive water sight line free of raised fire bowls.
				if id=="08" and i==1: continue
				var p = Vector3(edges[i][0],0,edges[i][2])
				var inward = Vector3(-p.x,0,-p.z).normalized()
				if id != "01" and id != "12" and i%2==0:
					template(sculpture,"Columns",p)
				if i%2==0:
					template(sculpture,"Vessels",p+inward*.80+Vector3(.50,0,0))
					template(sculpture,"Ferns",p+Vector3(-.70,0,.60))
					template(sculpture,"Candles",p+Vector3(.50,0,.80))
					template(sculpture,"CandleFlames",p+Vector3(.50,0,.80))
				else:
					template(sculpture,"Braziers",p+inward*1.15)
					template(sculpture,"Flames",p+inward*1.15)
				if i in [0,4] and id not in ["01","12"]:
					template(sculpture,"WallRoots",p)
					template(sculpture,"WallIvy",p)
			for portal in datum["portals"]:
				var p = Vector3(portal.point[0],0,portal.point[2])
				var yaw = PI*.5 if absf(portal.direction[0])>.5 else 0.0
				template(sculpture,"Portals",p,yaw)
			var art_data = JSON.parse_string(FileAccess.get_file_as_string(OUT.replace("Assets/","Evidence/")+"art-"+id+".json"))
			datum["geometry"]["authored_triangles"] = art_data["triangles"]
			node.set_meta("review_data",datum)
		save_scene(node,id)
		records.append({"id":id,"file":OUT+id+".scn","landmark":datum["landmark"]})
		var f = FileAccess.open("res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/Evidence/bake-rooms.json",FileAccess.WRITE)
		f.store_string(JSON.stringify(records,"  "))
		node.free()
		await process_frame
	# Prebake shared collision and floor/passage geometry too; no runtime rebuild.
	var floor = Node3D.new()
	floor.name = "PlanningCollision"
	grid.add_floor_collision(floor)
	save_scene(floor,"floor")
	floor.free()
	var passages = BASE.new()
	root.add_child(passages)
	passages.configure({"id":"00","box":[0,0,1200,1700],"blockers":[]},grid)
	save_scene(passages,"passages")
	passages.free()
	var light = BASE.new()
	root.add_child(light)
	light._setup_lighting()
	light._make_scale_figure()
	light.actor.name = "ScaleProxy"
	save_scene(light,"lighting")
	light.free()
	library.free()
	print("BAKE_COMPLETE ",records.size())
	quit()
