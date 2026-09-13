class_name ShamanProjectile
extends Node3D

# --- Shaman Glowing Magic Projectile VFX ---

var velocity: Vector3 = Vector3.ZERO
var flight_time: float = 0.0
var max_lifetime: float = 0.75 # Flies ~ 8 meters at 11 m/s
var is_exploding: bool = false
var explode_time: float = 0.0
const EXPLODE_DURATION: float = 0.32

var outfit: int = 1
var primary_color: Color = Color(0.2, 0.85, 1.0)
var secondary_color: Color = Color(0.7, 0.25, 1.0)
var spark_color: Color = Color(1.0, 0.95, 0.4)

# Visual Nodes
var core_mesh: MeshInstance3D = null
var aura_mesh: MeshInstance3D = null
var light: OmniLight3D = null
var orbiting_shards: Array = []
var shard_nodes: Array = []
var trail_history: Array = []
var trail_meshes: Array = []
const NUM_TRAIL_NODES: int = 10
const NUM_SHARDS: int = 4

# Impact Ring & Sparks
var impact_ring: MeshInstance3D = null
var impact_sparks: Array = []
var spark_velocities: Array = []

func _ready() -> void:
	pass

func launch(start_pos: Vector3, direction: Vector3, p_outfit: int = 1) -> void:
	outfit = p_outfit
	global_position = start_pos
	velocity = direction.normalized() * 11.5 # 11.5 m/s
	flight_time = 0.0
	is_exploding = false
	explode_time = 0.0
	
	if outfit == 3:
		# Imperial Golden Arch-Shaman: Radiant Solar Gold & Molten Ruby Flare
		primary_color = Color(1.0, 0.86, 0.15, 0.99)   # Radiant solar imperial gold
		secondary_color = Color(1.0, 0.22, 0.2, 0.95)  # Molten ruby flare
		spark_color = Color(1.0, 0.98, 0.7, 1.0)       # Brilliant diamond gold glint
	elif outfit == 2:
		# Grand Arch-Shaman: Imperial Radiant Magenta & Soul Cyan
		primary_color = Color(0.98, 0.15, 0.65, 0.98) # Hot magenta glow
		secondary_color = Color(0.1, 0.9, 1.0, 0.95)   # Radiant soul cyan
		spark_color = Color(1.0, 0.84, 0.15, 0.98)     # Imperial gold
	else:
		# Tribal Witch-Doctor: Spectral Teal & Cursed Purple
		primary_color = Color(0.12, 0.95, 0.92, 0.98) # Bright cyan-teal
		secondary_color = Color(0.68, 0.25, 0.98, 0.95)# Dark purple magic
		spark_color = Color(0.95, 0.95, 0.95, 0.95)    # Bone white
		
	_setup_visuals()

func _setup_visuals() -> void:
	# 1. CORE CRYSTAL ORB (Diamond / Octahedron with High-Emission Additive Glow)
	core_mesh = MeshInstance3D.new()
	core_mesh.mesh = _create_diamond_mesh(0.09, 0.05)
	
	var mat_core = StandardMaterial3D.new()
	mat_core.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_core.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat_core.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_core.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat_core.albedo_color = primary_color
	core_mesh.material_override = mat_core
	add_child(core_mesh)
	
	# 2. INNER AURA / STAR HALO
	aura_mesh = MeshInstance3D.new()
	aura_mesh.mesh = _create_diamond_mesh(0.16, 0.16)
	var mat_aura = StandardMaterial3D.new()
	mat_aura.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_aura.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat_aura.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_aura.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat_aura.albedo_color = Color(secondary_color.r, secondary_color.g, secondary_color.b, 0.45)
	aura_mesh.material_override = mat_aura
	add_child(aura_mesh)
	
	# 3. HIGH-SPEED ORBITING RUNIC SHARDS (4 Crystals spinning around core)
	for i in range(NUM_SHARDS):
		var shard = MeshInstance3D.new()
		shard.mesh = _create_diamond_mesh(0.038, 0.018)
		var mat_shard = StandardMaterial3D.new()
		mat_shard.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat_shard.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat_shard.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat_shard.cull_mode = BaseMaterial3D.CULL_DISABLED
		mat_shard.albedo_color = spark_color if (i % 2 == 0) else secondary_color
		shard.material_override = mat_shard
		add_child(shard)
		shard_nodes.append(shard)
		
	# 4. REALTIME DYNAMIC LIGHTING
	light = OmniLight3D.new()
	light.light_color = primary_color
	light.light_energy = 3.2
	light.omni_range = 4.8
	light.omni_attenuation = 1.4
	add_child(light)
	
	# 5. ETHEREAL TAPERING TRAIL NODES (Trailing Nebula Ghost Orbs)
	for i in range(NUM_TRAIL_NODES):
		var trail = MeshInstance3D.new()
		var frac = float(i) / float(NUM_TRAIL_NODES)
		var rad = lerpf(0.065, 0.012, frac)
		trail.mesh = _create_diamond_mesh(rad, rad * 0.7)
		
		var mat_t = StandardMaterial3D.new()
		mat_t.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat_t.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat_t.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat_t.cull_mode = BaseMaterial3D.CULL_DISABLED
		var t_col = primary_color.lerp(secondary_color, frac)
		t_col.a = lerpf(0.7, 0.0, frac)
		mat_t.albedo_color = t_col
		trail.material_override = mat_t
		
		# Trail nodes live in global world space
		get_parent().add_child(trail)
		trail.global_position = global_position
		trail_meshes.append(trail)
		trail_history.append(global_position)
		
	# 6. IMPACT RING (EXPANDING SHOCKWAVE)
	impact_ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.15
	torus.outer_radius = 0.22
	torus.rings = 24
	torus.ring_segments = 4
	impact_ring.mesh = torus
	var mat_ring = StandardMaterial3D.new()
	mat_ring.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_ring.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	mat_ring.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat_ring.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat_ring.albedo_color = Color(primary_color.r, primary_color.g, primary_color.b, 0.0)
	impact_ring.material_override = mat_ring
	impact_ring.visible = false
	add_child(impact_ring)
	
	# 7. IMPACT SPARKS (10 Radiant exploding motes)
	for i in range(12):
		var spk = MeshInstance3D.new()
		spk.mesh = _create_diamond_mesh(0.024, 0.012)
		var mat_spk = StandardMaterial3D.new()
		mat_spk.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat_spk.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat_spk.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat_spk.cull_mode = BaseMaterial3D.CULL_DISABLED
		mat_spk.albedo_color = spark_color if i % 2 == 0 else primary_color
		spk.material_override = mat_spk
		spk.visible = false
		add_child(spk)
		impact_sparks.append(spk)
		
		# Random radial velocity sphere
		var phi = randf() * TAU
		var theta = randf() * PI
		var v_dir = Vector3(sin(theta) * cos(phi), cos(theta), sin(theta) * sin(phi))
		spark_velocities.append(v_dir * randf_range(2.5, 6.0))

func _create_diamond_mesh(length: float, radius: float) -> ArrayMesh:
	var arr_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var normals = PackedVector3Array()
	
	var top = Vector3(0, length, 0)
	var bottom = Vector3(0, -length, 0)
	var ring = [
		Vector3(radius, 0, 0),
		Vector3(0, 0, radius),
		Vector3(-radius, 0, 0),
		Vector3(0, 0, -radius)
	]
	
	for i in range(4):
		var p1 = ring[i]
		var p2 = ring[(i + 1) % 4]
		# Upper cone
		vertices.append_array([top, p1, p2])
		var n_up = (p1 - top).cross(p2 - top).normalized()
		normals.append_array([n_up, n_up, n_up])
		# Lower cone
		vertices.append_array([bottom, p2, p1])
		var n_down = (p2 - bottom).cross(p1 - bottom).normalized()
		normals.append_array([n_down, n_down, n_down])
		
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return arr_mesh

func _process(delta: float) -> void:
	if is_exploding:
		_process_explosion(delta)
		return
		
	flight_time += delta
	
	# 1. Flight movement with arcane subtle corkscrew wave
	var forward = velocity.normalized()
	var right = forward.cross(Vector3.UP).normalized()
	var up = right.cross(forward).normalized()
	
	var spiral = (right * cos(flight_time * 22.0) + up * sin(flight_time * 22.0)) * 0.035
	global_position += (velocity + spiral) * delta
	
	# 2. Spin Core & Pulsate Aura
	if core_mesh:
		core_mesh.rotate_y(delta * 14.0)
		core_mesh.rotate_z(delta * 8.0)
	if aura_mesh:
		aura_mesh.rotate_y(-delta * 9.0)
		var aura_scale = 1.0 + sin(flight_time * 26.0) * 0.18
		aura_mesh.scale = Vector3.ONE * aura_scale
		
	# 3. High-Speed Orbiting Runic Shards
	var shard_time = flight_time * 18.0
	for i in range(shard_nodes.size()):
		var s_node: MeshInstance3D = shard_nodes[i]
		var angle = shard_time + (float(i) / float(NUM_SHARDS)) * TAU
		var orb_rad = 0.12 + sin(flight_time * 12.0 + i) * 0.02
		var sx = cos(angle) * orb_rad
		var sz = sin(angle) * orb_rad
		var sy = sin(angle * 2.0) * 0.05
		s_node.position = Vector3(sx, sy, sz)
		s_node.rotate_x(delta * 12.0)
		s_node.rotate_y(delta * 16.0)
		
	# 4. Update Trail Ribbon Nodes
	trail_history.push_front(global_position)
	if trail_history.size() > NUM_TRAIL_NODES:
		trail_history.pop_back()
		
	for i in range(trail_meshes.size()):
		if i < trail_history.size():
			trail_meshes[i].global_position = trail_history[i]
			trail_meshes[i].rotate_y(delta * 8.0)
			
	# 5. Check Maximum Range Detonation
	if flight_time >= max_lifetime:
		_trigger_impact()

func _trigger_impact() -> void:
	is_exploding = true
	explode_time = 0.0
	
	# Hide Core & Orbiting Shards
	if core_mesh: core_mesh.visible = false
	if aura_mesh: aura_mesh.visible = false
	for s in shard_nodes: s.visible = false
	
	# Show Impact Ring & Flash Light
	if impact_ring:
		impact_ring.visible = true
		impact_ring.scale = Vector3(0.3, 0.3, 0.3)
	if light:
		light.light_energy = 5.5
		light.omni_range = 6.0
		
	# Spawn sparks
	for i in range(impact_sparks.size()):
		impact_sparks[i].visible = true
		impact_sparks[i].position = Vector3.ZERO

func _process_explosion(delta: float) -> void:
	explode_time += delta
	var prog = clampf(explode_time / EXPLODE_DURATION, 0.0, 1.0)
	var smooth_p = smoothstep(0.0, 1.0, prog)
	
	# 1. Expanding Shockwave Ring
	if impact_ring:
		var ring_scale = lerpf(0.4, 2.4, sqrt(prog))
		impact_ring.scale = Vector3(ring_scale, ring_scale, ring_scale)
		impact_ring.rotate_y(delta * 6.0)
		impact_ring.rotate_x(delta * 4.0)
		var r_alpha = (1.0 - smooth_p) * 0.95
		var mat = impact_ring.material_override as StandardMaterial3D
		if mat:
			mat.albedo_color = Color(primary_color.r, primary_color.g, primary_color.b, r_alpha)
			
	# 2. Dispersing Radial Sparks
	for i in range(impact_sparks.size()):
		var spk: MeshInstance3D = impact_sparks[i]
		spk.position += spark_velocities[i] * delta
		spark_velocities[i] *= 0.92 # Aerodynamic drag
		var spk_scale = lerpf(1.0, 0.0, prog)
		spk.scale = Vector3.ONE * spk_scale
		
	# 3. Light Fade
	if light:
		light.light_energy = lerpf(5.5, 0.0, prog)
		
	# 4. Fade Trail
	for tm in trail_meshes:
		var mat_t = tm.material_override as StandardMaterial3D
		if mat_t:
			mat_t.albedo_color.a *= 0.88
			
	if explode_time >= EXPLODE_DURATION:
		_cleanup()

func _cleanup() -> void:
	for tm in trail_meshes:
		if is_instance_valid(tm):
			tm.queue_free()
	trail_meshes.clear()
	queue_free()
