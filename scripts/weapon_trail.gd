# Procedural 3D Weapon Slash Trail & Shockwave FX
extends MeshInstance3D

@export var max_points: int = 64
@export var tip_offset: Vector3 = Vector3(0.0, 0.88, 0.0) # Tip of heavy spiked head
@export var base_offset: Vector3 = Vector3(0.0, 0.12, 0.0) # Base of club head above grip

var target_node: Node3D = null
var is_emitting: bool = false
var lifetime: float = 0.22

# Colors for gradient
var color_tip: Color = Color(1.0, 0.95, 0.45, 0.98)
var color_base: Color = Color(1.0, 0.35, 0.05, 0.85)

var segments: Array = []
var imm_mesh: ImmediateMesh = null
var trail_material: StandardMaterial3D = null

# Impact Shockwave Rings (Triple Layer + Core Flash)
var shockwave_mesh: MeshInstance3D = null
var shockwave_timer: float = 0.0
var shockwave_duration: float = 0.42
var shockwave_material: StandardMaterial3D = null

var shockwave_mesh_2: MeshInstance3D = null
var shockwave_material_2: StandardMaterial3D = null

var shockwave_mesh_3: MeshInstance3D = null
var shockwave_material_3: StandardMaterial3D = null

var shockwave_flash: MeshInstance3D = null
var shockwave_flash_mat: StandardMaterial3D = null

var shockwave_max_scale: float = 2.10
var shockwave_color: Color = Color(1.0, 0.65, 0.15)
var impact_pos_cached: Vector3 = Vector3.ZERO

# Crater Erupted Stone Slabs (8 physical ground fracture chunks)
var crater_spikes: Array = []
var crater_spike_mats: Array = []
var crater_spike_angles: Array = []
var crater_spike_dists: Array = []
var crater_spike_heights: Array = []
const NUM_CRATER_SPIKES: int = 8

# Ground Crater Debris Shards (22 Physics bursts on impact)
var debris_nodes: Array = []
var debris_velocities: Array = []
var debris_materials: Array = []
var debris_lifetimes: Array = []
const NUM_DEBRIS: int = 22

# Parry Clash Spark FX
var spark_nodes: Array = []
var spark_velocities: Array = []
var spark_materials: Array = []
var spark_lifetimes: Array = []
var spark_flash: MeshInstance3D = null
var spark_flash_mat: StandardMaterial3D = null
var spark_timer: float = 0.0
const NUM_SPARKS: int = 8

# Whirlwind 360° Multi-Tier Cyclone Aura & Swirling Tornado Storm
var vortex_mesh: MeshInstance3D = null
var vortex_material: StandardMaterial3D = null

var vortex_mesh_upper: MeshInstance3D = null
var vortex_material_upper: StandardMaterial3D = null

var vortex_mesh_core: MeshInstance3D = null
var vortex_material_core: StandardMaterial3D = null

var is_vortex_active: bool = false
var vortex_center: Vector3 = Vector3.ZERO
var vortex_radius: float = 1.75
var vortex_color: Color = Color(1.0, 0.78, 0.25)
var vortex_alpha: float = 0.0
var vortex_time: float = 0.0

# 16 Swirling Tornado Debris & Wind Spores
var vortex_particles: Array = []
var vortex_particle_mats: Array = []
var vortex_particle_angles: Array = []
var vortex_particle_radii: Array = []
var vortex_particle_speeds: Array = []
var vortex_particle_heights: Array = []
const NUM_VORTEX_PARTICLES: int = 16

func _ready() -> void:
	imm_mesh = ImmediateMesh.new()
	mesh = imm_mesh
	
	trail_material = StandardMaterial3D.new()
	trail_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	trail_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	trail_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	trail_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	trail_material.vertex_color_use_as_albedo = true
	material_override = trail_material
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	_create_shockwave_effect()
	_create_crater_spikes()
	_create_debris_effect()
	_create_parry_spark_effect()
	_create_vortex_effect()

func _create_shockwave_effect() -> void:
	# 1. Primary Inner Blast Ring
	shockwave_mesh = MeshInstance3D.new()
	var torus1 = TorusMesh.new()
	torus1.inner_radius = 0.65
	torus1.outer_radius = 0.95
	torus1.rings = 32
	torus1.ring_segments = 6
	shockwave_mesh.mesh = torus1
	
	shockwave_material = StandardMaterial3D.new()
	shockwave_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material.albedo_color = Color(1.0, 0.85, 0.35, 0.0)
	shockwave_mesh.material_override = shockwave_material
	shockwave_mesh.visible = false
	add_child(shockwave_mesh)
	
	# 2. Secondary Fiery Magma Ring
	shockwave_mesh_2 = MeshInstance3D.new()
	var torus2 = TorusMesh.new()
	torus2.inner_radius = 0.78
	torus2.outer_radius = 1.02
	torus2.rings = 32
	torus2.ring_segments = 6
	shockwave_mesh_2.mesh = torus2
	
	shockwave_material_2 = StandardMaterial3D.new()
	shockwave_material_2.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material_2.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material_2.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material_2.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material_2.albedo_color = Color(1.0, 0.40, 0.05, 0.0)
	shockwave_mesh_2.material_override = shockwave_material_2
	shockwave_mesh_2.visible = false
	add_child(shockwave_mesh_2)
	
	# 3. Tertiary Heavy Ground Dust Ring
	shockwave_mesh_3 = MeshInstance3D.new()
	var torus3 = TorusMesh.new()
	torus3.inner_radius = 0.85
	torus3.outer_radius = 1.10
	torus3.rings = 32
	torus3.ring_segments = 6
	shockwave_mesh_3.mesh = torus3
	
	shockwave_material_3 = StandardMaterial3D.new()
	shockwave_material_3.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material_3.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material_3.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material_3.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material_3.albedo_color = Color(0.95, 0.70, 0.35, 0.0)
	shockwave_mesh_3.material_override = shockwave_material_3
	shockwave_mesh_3.visible = false
	add_child(shockwave_mesh_3)
	
	# 4. Instant Impact Flash Disc
	shockwave_flash = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.65
	cyl.bottom_radius = 0.65
	cyl.height = 0.05
	cyl.radial_segments = 24
	shockwave_flash.mesh = cyl
	
	shockwave_flash_mat = StandardMaterial3D.new()
	shockwave_flash_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_flash_mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_flash_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_flash_mat.albedo_color = Color(1.0, 0.95, 0.80, 0.0)
	shockwave_flash.material_override = shockwave_flash_mat
	shockwave_flash.visible = false
	add_child(shockwave_flash)

func _create_crater_spikes() -> void:
	for i in range(NUM_CRATER_SPIKES):
		var mi = MeshInstance3D.new()
		var box = BoxMesh.new()
		var sz_w = randf_range(0.18, 0.30)
		var sz_h = randf_range(0.28, 0.48)
		var sz_d = randf_range(0.16, 0.28)
		box.size = Vector3(sz_w, sz_h, sz_d)
		mi.mesh = box
		
		var mat = StandardMaterial3D.new()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		mat.albedo_color = Color(1.0, 0.65, 0.20, 0.0)
		mi.material_override = mat
		mi.visible = false
		add_child(mi)
		
		crater_spikes.append(mi)
		crater_spike_mats.append(mat)
		crater_spike_angles.append((float(i) / float(NUM_CRATER_SPIKES)) * TAU + randf_range(-0.15, 0.15))
		crater_spike_dists.append(randf_range(0.55, 0.95))
		crater_spike_heights.append(sz_h * 0.75)

func _create_debris_effect() -> void:
	for i in range(NUM_DEBRIS):
		var mi = MeshInstance3D.new()
		var box = BoxMesh.new()
		var sz = randf_range(0.045, 0.11)
		box.size = Vector3(sz, sz, sz)
		mi.mesh = box
		
		var mat = StandardMaterial3D.new()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.albedo_color = Color(1.0, 0.8, 0.3, 0.0)
		mi.material_override = mat
		mi.visible = false
		add_child(mi)
		
		debris_nodes.append(mi)
		debris_materials.append(mat)
		debris_velocities.append(Vector3.ZERO)
		debris_lifetimes.append(0.0)

func _create_parry_spark_effect() -> void:
	spark_flash = MeshInstance3D.new()
	var sp_sphere = SphereMesh.new()
	sp_sphere.radius = 0.22
	sp_sphere.height = 0.44
	sp_sphere.radial_segments = 16
	sp_sphere.rings = 8
	spark_flash.mesh = sp_sphere
	
	spark_flash_mat = StandardMaterial3D.new()
	spark_flash_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	spark_flash_mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	spark_flash_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	spark_flash_mat.albedo_color = Color(1.0, 1.0, 0.85, 0.0)
	spark_flash.material_override = spark_flash_mat
	spark_flash.visible = false
	add_child(spark_flash)
	
	for i in range(NUM_SPARKS):
		var mi = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.035, 0.035, 0.035)
		mi.mesh = box
		
		var mat = StandardMaterial3D.new()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.albedo_color = Color(1.0, 0.95, 0.5, 0.0)
		mi.material_override = mat
		mi.visible = false
		add_child(mi)
		
		spark_nodes.append(mi)
		spark_materials.append(mat)
		spark_velocities.append(Vector3.ZERO)
		spark_lifetimes.append(0.0)

func _create_vortex_effect() -> void:
	# 1. Lower Ground Vortex Ring
	vortex_mesh = MeshInstance3D.new()
	var v_torus = TorusMesh.new()
	v_torus.inner_radius = 0.82
	v_torus.outer_radius = 1.08
	v_torus.rings = 36
	v_torus.ring_segments = 5
	vortex_mesh.mesh = v_torus
	
	vortex_material = StandardMaterial3D.new()
	vortex_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	vortex_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	vortex_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	vortex_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	vortex_material.albedo_color = Color(1.0, 0.82, 0.25, 0.0)
	vortex_mesh.material_override = vortex_material
	vortex_mesh.visible = false
	add_child(vortex_mesh)
	
	# 2. Upper Hurricane Vortex Ring (Torso height, counter-rotating)
	vortex_mesh_upper = MeshInstance3D.new()
	var v_torus_up = TorusMesh.new()
	v_torus_up.inner_radius = 0.90
	v_torus_up.outer_radius = 1.15
	v_torus_up.rings = 36
	v_torus_up.ring_segments = 5
	vortex_mesh_upper.mesh = v_torus_up
	
	vortex_material_upper = StandardMaterial3D.new()
	vortex_material_upper.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	vortex_material_upper.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	vortex_material_upper.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	vortex_material_upper.cull_mode = BaseMaterial3D.CULL_DISABLED
	vortex_material_upper.albedo_color = Color(1.0, 0.45, 0.08, 0.0)
	vortex_mesh_upper.material_override = vortex_material_upper
	vortex_mesh_upper.visible = false
	add_child(vortex_mesh_upper)
	
	# 3. Core Eye-Of-The-Storm Concentrated Ring
	vortex_mesh_core = MeshInstance3D.new()
	var v_torus_core = TorusMesh.new()
	v_torus_core.inner_radius = 0.55
	v_torus_core.outer_radius = 0.72
	v_torus_core.rings = 28
	v_torus_core.ring_segments = 4
	vortex_mesh_core.mesh = v_torus_core
	
	vortex_material_core = StandardMaterial3D.new()
	vortex_material_core.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	vortex_material_core.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	vortex_material_core.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	vortex_material_core.cull_mode = BaseMaterial3D.CULL_DISABLED
	vortex_material_core.albedo_color = Color(1.0, 0.95, 0.55, 0.0)
	vortex_mesh_core.material_override = vortex_material_core
	vortex_mesh_core.visible = false
	add_child(vortex_mesh_core)
	
	# 4. 16 Swirling Tornado Debris & Wind Spores
	for i in range(NUM_VORTEX_PARTICLES):
		var mi = MeshInstance3D.new()
		var box = BoxMesh.new()
		var sz = randf_range(0.04, 0.075)
		box.size = Vector3(sz, sz, sz)
		mi.mesh = box
		
		var mat = StandardMaterial3D.new()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		mat.albedo_color = Color(1.0, randf_range(0.6, 0.9), 0.2, 0.0)
		mi.material_override = mat
		mi.visible = false
		add_child(mi)
		
		vortex_particles.append(mi)
		vortex_particle_mats.append(mat)
		vortex_particle_angles.append((float(i) / float(NUM_VORTEX_PARTICLES)) * TAU)
		vortex_particle_radii.append(randf_range(1.25, 2.15))
		vortex_particle_speeds.append(randf_range(12.0, 18.0))
		vortex_particle_heights.append(randf_range(0.05, 1.35))

func set_target(node: Node3D) -> void:
	target_node = node

func start_trail(p_color_tip: Color, p_color_base: Color, p_lifetime: float = 0.22) -> void:
	color_tip = p_color_tip
	color_base = p_color_base
	lifetime = p_lifetime
	is_emitting = true
	segments.clear()
	if imm_mesh:
		imm_mesh.clear_surfaces()

func stop_trail() -> void:
	is_emitting = false

func set_vortex_active(active: bool, p_center: Vector3 = Vector3.ZERO, p_radius: float = 1.75, p_color: Color = Color(1.0, 0.78, 0.25)) -> void:
	is_vortex_active = active
	vortex_center = p_center
	vortex_radius = p_radius
	vortex_color = p_color
	if active:
		if vortex_mesh:
			vortex_mesh.global_position = Vector3(p_center.x, 0.025, p_center.z)
			vortex_mesh.visible = true
		if vortex_mesh_upper:
			vortex_mesh_upper.global_position = Vector3(p_center.x, 0.65, p_center.z)
			vortex_mesh_upper.visible = true
		if vortex_mesh_core:
			vortex_mesh_core.global_position = Vector3(p_center.x, 0.35, p_center.z)
			vortex_mesh_core.visible = true
		for p in vortex_particles:
			p.visible = true

func trigger_ground_impact(pos: Vector3, p_max_scale: float = 2.10, p_duration: float = 0.42, p_color: Color = Color(1.0, 0.70, 0.18)) -> void:
	shockwave_max_scale = p_max_scale
	shockwave_duration = p_duration
	shockwave_color = p_color
	shockwave_timer = shockwave_duration
	impact_pos_cached = pos
	
	var ground_y: float = 0.068
	
	# Primary Blast Ring
	if shockwave_mesh:
		shockwave_mesh.global_position = Vector3(pos.x, ground_y, pos.z)
		shockwave_mesh.scale = Vector3(0.12, 0.16, 0.12)
		shockwave_mesh.visible = true
		
	# Secondary Magma Ring
	if shockwave_mesh_2:
		shockwave_mesh_2.global_position = Vector3(pos.x, ground_y + 0.005, pos.z)
		shockwave_mesh_2.scale = Vector3(0.08, 0.16, 0.08)
		shockwave_mesh_2.visible = true
		
	# Tertiary Outer Dust Wave
	if shockwave_mesh_3:
		shockwave_mesh_3.global_position = Vector3(pos.x, ground_y - 0.004, pos.z)
		shockwave_mesh_3.scale = Vector3(0.05, 0.14, 0.05)
		shockwave_mesh_3.visible = true
		
	# Instant Impact Flash Disc
	if shockwave_flash:
		shockwave_flash.global_position = Vector3(pos.x, ground_y + 0.010, pos.z)
		shockwave_flash.scale = Vector3(0.3, 1.0, 0.3)
		shockwave_flash_mat.albedo_color = Color(1.0, 0.98, 0.85, 1.0)
		shockwave_flash.visible = true
		
	# Erupt 8 Radial Crater Stone Slabs
	for i in range(NUM_CRATER_SPIKES):
		var mi: MeshInstance3D = crater_spikes[i]
		var ang = crater_spike_angles[i]
		var dst = crater_spike_dists[i] * (p_max_scale / 1.85)
		var sp_x = pos.x + cos(ang) * dst
		var sp_z = pos.z + sin(ang) * dst
		mi.global_position = Vector3(sp_x, ground_y, sp_z)
		mi.rotation = Vector3(randf_range(-0.25, 0.25), ang, randf_range(0.20, 0.40))
		mi.scale = Vector3(1.0, 1.0, 1.0)
		mi.visible = true
		
	# Spawn 22 Radial Debris Shards
	for i in range(NUM_DEBRIS):
		var mi: MeshInstance3D = debris_nodes[i]
		mi.global_position = Vector3(pos.x, ground_y + 0.02, pos.z)
		mi.visible = true
		var angle = (float(i) / float(NUM_DEBRIS)) * TAU + randf_range(-0.25, 0.25)
		var spd = randf_range(3.2, 5.8) * (p_max_scale / 1.85)
		debris_velocities[i] = Vector3(cos(angle) * spd, randf_range(2.2, 4.4), sin(angle) * spd)
		debris_lifetimes[i] = p_duration * 1.35

func trigger_parry_spark(pos: Vector3) -> void:
	spark_timer = 0.16
	if spark_flash:
		spark_flash.global_position = pos
		spark_flash.scale = Vector3(0.25, 0.25, 0.25)
		spark_flash_mat.albedo_color = Color(1.0, 1.0, 0.9, 0.98)
		spark_flash.visible = true
		
	for i in range(NUM_SPARKS):
		var mi: MeshInstance3D = spark_nodes[i]
		mi.global_position = pos
		mi.visible = true
		var angle = randf_range(0.0, TAU)
		var elevation = randf_range(-0.4, 0.8)
		var spd = randf_range(3.5, 6.2)
		spark_velocities[i] = Vector3(cos(angle) * spd, elevation * spd, sin(angle) * spd)
		spark_lifetimes[i] = randf_range(0.12, 0.22)

func _process(delta: float) -> void:
	# 1. Update Parry Sparks
	if spark_timer > 0.0:
		spark_timer -= delta
		if spark_flash:
			var s_prog = 1.0 - (spark_timer / 0.16)
			var s_scale = lerpf(0.25, 0.85, s_prog)
			spark_flash.scale = Vector3(s_scale, s_scale, s_scale)
			spark_flash_mat.albedo_color = Color(1.0, 1.0, 0.9, (1.0 - s_prog) * 0.98)
			if spark_timer <= 0.0:
				spark_flash.visible = false
	for i in range(NUM_SPARKS):
		if spark_lifetimes[i] > 0.0:
			spark_lifetimes[i] -= delta
			var mi: MeshInstance3D = spark_nodes[i]
			var vel: Vector3 = spark_velocities[i]
			vel.y -= 9.8 * delta
			spark_velocities[i] = vel
			mi.global_position += vel * delta
			var alpha_s = clampf(spark_lifetimes[i] / 0.20, 0.0, 1.0)
			spark_materials[i].albedo_color = Color(1.0, 0.95, 0.5, alpha_s * 0.95)
			if spark_lifetimes[i] <= 0.0:
				mi.visible = false
				
	# 2. Update Shockwaves & Ground Ruptures
	if shockwave_timer > 0.0:
		shockwave_timer -= delta
		var prog = 1.0 - clampf(shockwave_timer / shockwave_duration, 0.0, 1.0)
		
		# Flash fades fast in first 25% of duration
		if shockwave_flash:
			if prog < 0.28:
				var f_prog = prog / 0.28
				var f_scale = lerpf(0.3, 1.45 * (shockwave_max_scale / 1.85), f_prog)
				shockwave_flash.scale = Vector3(f_scale, 1.0, f_scale)
				shockwave_flash_mat.albedo_color = Color(1.0, 0.98, 0.85, (1.0 - f_prog) * 0.95)
			else:
				shockwave_flash.visible = false
				
		# Primary Blast Ring
		var scale_val1 = lerpf(0.18, shockwave_max_scale, sqrt(prog))
		var alpha1 = (1.0 - prog) * 0.98
		if shockwave_mesh:
			shockwave_mesh.scale = Vector3(scale_val1, 0.16, scale_val1)
			shockwave_material.albedo_color = Color(shockwave_color.r, shockwave_color.g * 1.1, shockwave_color.b * 1.3, alpha1)
			
		# Secondary Outer Magma Ring
		var scale_val2 = lerpf(0.12, shockwave_max_scale * 1.38, pow(prog, 0.68))
		var alpha2 = (1.0 - prog) * 0.85
		if shockwave_mesh_2:
			shockwave_mesh_2.scale = Vector3(scale_val2, 0.16, scale_val2)
			shockwave_material_2.albedo_color = Color(shockwave_color.r * 1.0, shockwave_color.g * 0.45, shockwave_color.b * 0.15, alpha2)
			
		# Tertiary Outer Ground Dust Wave
		var scale_val3 = lerpf(0.08, shockwave_max_scale * 1.75, pow(prog, 0.55))
		var alpha3 = (1.0 - prog) * 0.65
		if shockwave_mesh_3:
			shockwave_mesh_3.scale = Vector3(scale_val3, 0.14, scale_val3)
			shockwave_material_3.albedo_color = Color(0.92, 0.65, 0.32, alpha3)
			
		# Crater Fracture Stone Slabs (Burst up on impact, hold, then crumble back down)
		for i in range(NUM_CRATER_SPIKES):
			var mi: MeshInstance3D = crater_spikes[i]
			var max_h = crater_spike_heights[i]
			var cur_h = 0.0
			var alpha_crater = 1.0
			if prog < 0.22:
				# Explosive upward rupture
				var r_prog = prog / 0.22
				cur_h = lerpf(0.01, max_h, 1.0 - pow(1.0 - r_prog, 2.5))
				alpha_crater = 0.95
			elif prog < 0.65:
				# Sustained jagged peak hold with micro shake
				cur_h = max_h + sin(prog * 40.0) * 0.008
				alpha_crater = 0.95
			else:
				# Crumble and sink back into the earth
				var s_prog = (prog - 0.65) / 0.35
				cur_h = lerpf(max_h, 0.01, s_prog)
				alpha_crater = (1.0 - s_prog) * 0.95
				
			var ang = crater_spike_angles[i]
			var dst = crater_spike_dists[i] * (shockwave_max_scale / 1.85)
			mi.global_position = Vector3(impact_pos_cached.x + cos(ang) * dst, 0.068 + cur_h, impact_pos_cached.z + sin(ang) * dst)
			crater_spike_mats[i].albedo_color = Color(shockwave_color.r, shockwave_color.g * 0.65, shockwave_color.b * 0.25, alpha_crater)
			
		if shockwave_timer <= 0.0:
			if shockwave_mesh: shockwave_mesh.visible = false
			if shockwave_mesh_2: shockwave_mesh_2.visible = false
			if shockwave_mesh_3: shockwave_mesh_3.visible = false
			if shockwave_flash: shockwave_flash.visible = false
			for mi in crater_spikes: mi.visible = false
			
	# 3. Update Debris Shards
	for i in range(NUM_DEBRIS):
		if debris_lifetimes[i] > 0.0:
			debris_lifetimes[i] -= delta
			var mi: MeshInstance3D = debris_nodes[i]
			var vel: Vector3 = debris_velocities[i]
			vel.y -= 9.8 * delta
			debris_velocities[i] = vel
			mi.global_position += vel * delta
			if mi.global_position.y <= 0.065:
				mi.global_position.y = 0.065
				debris_velocities[i].y = -debris_velocities[i].y * 0.35
				debris_velocities[i].x *= 0.8
				debris_velocities[i].z *= 0.8
			var alpha_d = clampf(debris_lifetimes[i] / (shockwave_duration * 1.35), 0.0, 1.0)
			debris_materials[i].albedo_color = Color(shockwave_color.r, shockwave_color.g * 0.85, shockwave_color.b * 0.4, alpha_d * 0.95)
			if debris_lifetimes[i] <= 0.0:
				mi.visible = false
				
	# 4. Update Whirlwind Intimidating Cyclone Storm
	vortex_time += delta
	if is_vortex_active:
		vortex_alpha = lerpf(vortex_alpha, 0.92, delta * 8.0)
		
		# Ground Vortex Ring
		if vortex_mesh:
			vortex_mesh.global_position = Vector3(vortex_center.x, 0.068, vortex_center.z)
			var pulse1 = 1.0 + sin(vortex_time * 16.0) * 0.07
			vortex_mesh.scale = Vector3(vortex_radius * pulse1, 0.10, vortex_radius * pulse1)
			vortex_mesh.rotation.y += delta * 15.0
			vortex_material.albedo_color = Color(vortex_color.r, vortex_color.g, vortex_color.b, vortex_alpha)
			
		# Upper Torso Hurricane Ring (Counter-rotating + tilted dynamic pitch)
		if vortex_mesh_upper:
			vortex_mesh_upper.global_position = Vector3(vortex_center.x, 0.68, vortex_center.z)
			var pulse2 = 1.0 + cos(vortex_time * 14.0) * 0.08
			vortex_mesh_upper.scale = Vector3(vortex_radius * 1.18 * pulse2, 0.12, vortex_radius * 1.18 * pulse2)
			vortex_mesh_upper.rotation = Vector3(deg_to_rad(6.0 * sin(vortex_time * 4.0)), -vortex_time * 12.0, deg_to_rad(4.0 * cos(vortex_time * 4.0)))
			vortex_material_upper.albedo_color = Color(vortex_color.r, vortex_color.g * 0.55, vortex_color.b * 0.12, vortex_alpha * 0.85)
			
		# Core Eye-of-the-Storm Ring (Ultra fast spin + high radiant core)
		if vortex_mesh_core:
			vortex_mesh_core.global_position = Vector3(vortex_center.x, 0.38, vortex_center.z)
			var pulse3 = 1.0 + sin(vortex_time * 24.0) * 0.05
			vortex_mesh_core.scale = Vector3(vortex_radius * 0.68 * pulse3, 0.10, vortex_radius * 0.68 * pulse3)
			vortex_mesh_core.rotation.y += delta * 24.0
			vortex_material_core.albedo_color = Color(1.0, 0.95, 0.60, vortex_alpha * 0.95)
			
		# 16 Swirling Tornado Debris & Wind Spores
		for i in range(NUM_VORTEX_PARTICLES):
			var mi: MeshInstance3D = vortex_particles[i]
			var spd = vortex_particle_speeds[i]
			vortex_particle_angles[i] += delta * spd
			var ang = vortex_particle_angles[i]
			var r = vortex_particle_radii[i] * (vortex_radius / 1.75) + sin(vortex_time * 6.0 + i) * 0.18
			
			# Upward spiral motion
			var h = fmod(vortex_particle_heights[i] + vortex_time * 1.6, 1.40) + 0.04
			var px = vortex_center.x + cos(ang) * r
			var pz = vortex_center.z + sin(ang) * r
			mi.global_position = Vector3(px, h, pz)
			mi.rotation.y += delta * 12.0
			mi.rotation.x += delta * 8.0
			
			var h_ratio = h / 1.40
			var p_alpha = sin(h_ratio * PI) * vortex_alpha * 0.92
			vortex_particle_mats[i].albedo_color = Color(1.0, lerpf(0.9, 0.45, h_ratio), 0.15, p_alpha)
			
	else:
		if vortex_alpha > 0.01:
			vortex_alpha = lerpf(vortex_alpha, 0.0, delta * 6.0)
			if vortex_mesh:
				vortex_material.albedo_color = Color(vortex_color.r, vortex_color.g, vortex_color.b, vortex_alpha)
				vortex_mesh.rotation.y += delta * 8.0
			if vortex_mesh_upper:
				vortex_material_upper.albedo_color = Color(vortex_color.r, vortex_color.g * 0.55, vortex_color.b * 0.12, vortex_alpha * 0.85)
				vortex_mesh_upper.rotation.y -= delta * 6.0
			if vortex_mesh_core:
				vortex_material_core.albedo_color = Color(1.0, 0.95, 0.60, vortex_alpha * 0.95)
			for i in range(NUM_VORTEX_PARTICLES):
				vortex_particle_mats[i].albedo_color = Color(1.0, 0.7, 0.2, vortex_alpha * 0.5)
		else:
			vortex_alpha = 0.0
			if vortex_mesh: vortex_mesh.visible = false
			if vortex_mesh_upper: vortex_mesh_upper.visible = false
			if vortex_mesh_core: vortex_mesh_core.visible = false
			for p in vortex_particles: p.visible = false
			
	# 5. Age existing ribbon segments
	var i_seg = 0
	while i_seg < segments.size():
		segments[i_seg]["life"] -= delta
		if segments[i_seg]["life"] <= 0.0:
			segments.remove_at(i_seg)
		else:
			i_seg += 1
			
	# 6. Sample new segment if emitting and target valid
	if is_emitting and is_instance_valid(target_node):
		var cur_tip = target_node.to_global(tip_offset)
		var cur_base = target_node.to_global(base_offset)
		
		var should_add = true
		if segments.size() > 0:
			var prev_tip: Vector3 = segments[0]["tip"]
			if cur_tip.distance_squared_to(prev_tip) < 0.0002:
				should_add = false
				
		if should_add:
			segments.insert(0, {
				"tip": cur_tip,
				"base": cur_base,
				"life": lifetime,
				"max_life": lifetime
			})
			if segments.size() > max_points:
				segments.resize(max_points)
				
	# 7. Render smooth ribbon
	_render_trail_mesh()

func _render_trail_mesh() -> void:
	imm_mesh.clear_surfaces()
	if segments.size() < 2:
		return
		
	var smooth_points: Array = _generate_smooth_ribbon()
	if smooth_points.size() < 2:
		return
		
	imm_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, trail_material)
	
	var count = smooth_points.size()
	for idx in range(count - 1):
		var p0 = smooth_points[idx]
		var p1 = smooth_points[idx + 1]
		
		var b0 = to_local(p0["base"])
		var t0 = to_local(p0["tip"])
		var b1 = to_local(p1["base"])
		var t1 = to_local(p1["tip"])
		
		var alpha0 = p0["alpha"]
		var alpha1 = p1["alpha"]
		
		var c_tip0 = Color(color_tip.r, color_tip.g, color_tip.b, color_tip.a * alpha0)
		var c_base0 = Color(color_base.r, color_base.g, color_base.b, color_base.a * alpha0)
		var c_tip1 = Color(color_tip.r, color_tip.g, color_tip.b, color_tip.a * alpha1)
		var c_base1 = Color(color_base.r, color_base.g, color_base.b, color_base.a * alpha1)
		
		var v0 = float(idx) / float(count - 1)
		var v1 = float(idx + 1) / float(count - 1)
		
		# Quad Triangle 1: b0 -> t0 -> t1
		imm_mesh.surface_set_color(c_base0)
		imm_mesh.surface_set_uv(Vector2(0.0, v0))
		imm_mesh.surface_add_vertex(b0)
		
		imm_mesh.surface_set_color(c_tip0)
		imm_mesh.surface_set_uv(Vector2(1.0, v0))
		imm_mesh.surface_add_vertex(t0)
		
		imm_mesh.surface_set_color(c_tip1)
		imm_mesh.surface_set_uv(Vector2(1.0, v1))
		imm_mesh.surface_add_vertex(t1)
		
		# Quad Triangle 2: b0 -> t1 -> b1
		imm_mesh.surface_set_color(c_base0)
		imm_mesh.surface_set_uv(Vector2(0.0, v0))
		imm_mesh.surface_add_vertex(b0)
		
		imm_mesh.surface_set_color(c_tip1)
		imm_mesh.surface_set_uv(Vector2(1.0, v1))
		imm_mesh.surface_add_vertex(t1)
		
		imm_mesh.surface_set_color(c_base1)
		imm_mesh.surface_set_uv(Vector2(0.0, v1))
		imm_mesh.surface_add_vertex(b1)
		
	imm_mesh.surface_end()

func _generate_smooth_ribbon() -> Array:
	var out: Array = []
	if segments.size() < 2:
		return out
		
	# Catmull-Rom spline interpolation between sampled weapon poses
	var n = segments.size()
	var subdivisions = 3
	
	for i in range(n - 1):
		var p0 = segments[max(0, i - 1)]
		var p1 = segments[i]
		var p2 = segments[i + 1]
		var p3 = segments[min(n - 1, i + 2)]
		
		for sub in range(subdivisions):
			var t = float(sub) / float(subdivisions)
			var cur_tip = _catmull_rom(p0["tip"], p1["tip"], p2["tip"], p3["tip"], t)
			var cur_base = _catmull_rom(p0["base"], p1["base"], p2["base"], p3["base"], t)
			
			var life_interp = lerpf(p1["life"], p2["life"], t)
			var max_l = p1["max_life"]
			var alpha_interp = clampf(life_interp / max_l, 0.0, 1.0)
			
			out.append({
				"tip": cur_tip,
				"base": cur_base,
				"alpha": alpha_interp
			})
			
	var last = segments[n - 1]
	out.append({
		"tip": last["tip"],
		"base": last["base"],
		"alpha": clampf(last["life"] / last["max_life"], 0.0, 1.0)
	})
	return out

func _catmull_rom(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: float) -> Vector3:
	var t2 = t * t
	var t3 = t2 * t
	return 0.5 * (
		(2.0 * p1) +
		(-p0 + p2) * t +
		(2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 +
		(-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3
	)
