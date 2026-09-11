extends Node3D

var stars: Array = []
var orbit_angle: float = 0.0
var is_active: bool = false
const NUM_STARS: int = 3
const ORBIT_RADIUS: float = 0.29
const ORBIT_HEIGHT: float = 0.46
const ORBIT_SPEED: float = 5.5

var star_material: StandardMaterial3D = null

func _ready() -> void:
	star_material = StandardMaterial3D.new()
	star_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	star_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	star_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	star_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	star_material.albedo_color = Color(1.0, 0.95, 0.22, 0.98)
	
	_create_stars()
	visible = false

func _create_stars() -> void:
	for i in range(NUM_STARS):
		var star_mesh = MeshInstance3D.new()
		star_mesh.mesh = _build_star_mesh()
		star_mesh.material_override = star_material
		add_child(star_mesh)
		stars.append(star_mesh)

func _build_star_mesh() -> ArrayMesh:
	# 3D 4-Pointed Stylized Voxel Star
	var arr_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var normals = PackedVector3Array()
	var uvs = PackedVector2Array()
	
	# Stylized 4-point diamond star (radius ~ 0.072m, thickness ~ 0.024m)
	var tip_len = 0.072
	var core_rad = 0.024
	var depth = 0.022
	
	var pts = [
		Vector3(0, tip_len, 0),       # 0: Top tip
		Vector3(core_rad, core_rad, 0), # 1: Top-right corner
		Vector3(tip_len, 0, 0),       # 2: Right tip
		Vector3(core_rad, -core_rad, 0),# 3: Bottom-right corner
		Vector3(0, -tip_len, 0),      # 4: Bottom tip
		Vector3(-core_rad, -core_rad, 0),# 5: Bottom-left corner
		Vector3(-tip_len, 0, 0),      # 6: Left tip
		Vector3(-core_rad, core_rad, 0) # 7: Top-left corner
	]
	
	var f_front = Vector3(0, 0, depth)
	var f_back = Vector3(0, 0, -depth)
	
	# Front Pyramids
	for j in range(8):
		var p_cur = pts[j]
		var p_nxt = pts[(j + 1) % 8]
		vertices.append_array([f_front, p_cur, p_nxt])
		var n = (p_cur - f_front).cross(p_nxt - f_front).normalized()
		normals.append_array([n, n, n])
		uvs.append_array([Vector2(0.5, 0.5), Vector2(0.0, 0.0), Vector2(1.0, 0.0)])
		
	# Back Pyramids
	for j in range(8):
		var p_cur = pts[j]
		var p_nxt = pts[(j + 1) % 8]
		vertices.append_array([f_back, p_nxt, p_cur])
		var n = (p_nxt - f_back).cross(p_cur - f_back).normalized()
		normals.append_array([n, n, n])
		uvs.append_array([Vector2(0.5, 0.5), Vector2(1.0, 0.0), Vector2(0.0, 0.0)])
		
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh

func set_active(active: bool) -> void:
	is_active = active
	visible = active
	if active:
		orbit_angle = 0.0

func _process(delta: float) -> void:
	if not is_active:
		return
		
	orbit_angle += delta * ORBIT_SPEED
	
	# Halo tilt: 15 degrees tilt in Z/X plane
	var tilt = 0.25 # radians (~14 degrees)
	
	for i in range(stars.size()):
		var star = stars[i]
		var phi = orbit_angle + float(i) * (TAU / float(NUM_STARS))
		
		var lx = cos(phi) * ORBIT_RADIUS
		var lz = sin(phi) * ORBIT_RADIUS
		# Tilted plane + subtle harmonic vertical bobbing
		var ly = ORBIT_HEIGHT + lz * sin(tilt) + sin(phi * 2.0 + float(i)) * 0.025
		lz = lz * cos(tilt)
		
		star.position = Vector3(lx, ly, lz)
		# Rapid spin on own axis for sparkling effect
		star.rotation.y += delta * 12.0
		star.rotation.z += delta * 8.0
