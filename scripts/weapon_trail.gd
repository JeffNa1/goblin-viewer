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

# Impact Shockwave Rings (Dual Layer)
var shockwave_mesh: MeshInstance3D = null
var shockwave_timer: float = 0.0
var shockwave_duration: float = 0.28
var shockwave_material: StandardMaterial3D = null

var shockwave_mesh_2: MeshInstance3D = null
var shockwave_material_2: StandardMaterial3D = null
var shockwave_max_scale: float = 1.15
var shockwave_color: Color = Color(1.0, 0.65, 0.15)

# Ground Crater Debris Shards (Physics burst on impact)
var debris_nodes: Array = []
var debris_velocities: Array = []
var debris_materials: Array = []
var debris_lifetimes: Array = []
const NUM_DEBRIS: int = 10

# Whirlwind 360° Ground Vortex Aura
var vortex_mesh: MeshInstance3D = null
var vortex_material: StandardMaterial3D = null
var is_vortex_active: bool = false
var vortex_center: Vector3 = Vector3.ZERO
var vortex_radius: float = 1.4
var vortex_color: Color = Color(1.0, 0.78, 0.25)
var vortex_alpha: float = 0.0
var vortex_time: float = 0.0

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
	_create_debris_effect()
	_create_vortex_effect()

func _create_shockwave_effect() -> void:
	# Primary Torus Ring
	shockwave_mesh = MeshInstance3D.new()
	var torus1 = TorusMesh.new()
	torus1.inner_radius = 0.75
	torus1.outer_radius = 0.92
	torus1.rings = 28
	torus1.ring_segments = 4
	shockwave_mesh.mesh = torus1
	
	shockwave_material = StandardMaterial3D.new()
	shockwave_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material.albedo_color = Color(1.0, 0.7, 0.2, 0.0)
	shockwave_mesh.material_override = shockwave_material
	shockwave_mesh.visible = false
	add_child(shockwave_mesh)
	
	# Secondary Outer Expansion Ring
	shockwave_mesh_2 = MeshInstance3D.new()
	var torus2 = TorusMesh.new()
	torus2.inner_radius = 0.88
	torus2.outer_radius = 0.98
	torus2.rings = 28
	torus2.ring_segments = 4
	shockwave_mesh_2.mesh = torus2
	
	shockwave_material_2 = StandardMaterial3D.new()
	shockwave_material_2.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material_2.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material_2.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material_2.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material_2.albedo_color = Color(1.0, 0.4, 0.05, 0.0)
	shockwave_mesh_2.material_override = shockwave_material_2
	shockwave_mesh_2.visible = false
	add_child(shockwave_mesh_2)

func _create_debris_effect() -> void:
	for i in range(NUM_DEBRIS):
		var mi = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.06, 0.06, 0.06)
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

func _create_vortex_effect() -> void:
	vortex_mesh = MeshInstance3D.new()
	var v_torus = TorusMesh.new()
	v_torus.inner_radius = 0.85
	v_torus.outer_radius = 1.05
	v_torus.rings = 32
	v_torus.ring_segments = 4
	vortex_mesh.mesh = v_torus
	
	vortex_material = StandardMaterial3D.new()
	vortex_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	vortex_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	vortex_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	vortex_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	vortex_material.albedo_color = Color(1.0, 0.8, 0.25, 0.0)
	vortex_mesh.material_override = vortex_material
	vortex_mesh.visible = false
	add_child(vortex_mesh)

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

func set_vortex_active(active: bool, p_center: Vector3 = Vector3.ZERO, p_radius: float = 1.4, p_color: Color = Color(1.0, 0.78, 0.25)) -> void:
	is_vortex_active = active
	vortex_center = p_center
	vortex_radius = p_radius
	vortex_color = p_color
	if active and vortex_mesh:
		vortex_mesh.global_position = Vector3(p_center.x, 0.025, p_center.z)
		vortex_mesh.visible = true

func trigger_ground_impact(pos: Vector3, p_max_scale: float = 1.15, p_duration: float = 0.28, p_color: Color = Color(1.0, 0.65, 0.15)) -> void:
	shockwave_max_scale = p_max_scale
	shockwave_duration = p_duration
	shockwave_color = p_color
	shockwave_timer = shockwave_duration
	
	if shockwave_mesh:
		shockwave_mesh.global_position = Vector3(pos.x, 0.02, pos.z)
		shockwave_mesh.scale = Vector3(0.12, 0.04, 0.12)
		shockwave_mesh.visible = true
		
	if shockwave_mesh_2:
		shockwave_mesh_2.global_position = Vector3(pos.x, 0.025, pos.z)
		shockwave_mesh_2.scale = Vector3(0.08, 0.04, 0.08)
		shockwave_mesh_2.visible = true
		
	# Spawn radial debris shards
	for i in range(NUM_DEBRIS):
		var mi: MeshInstance3D = debris_nodes[i]
		mi.global_position = Vector3(pos.x, 0.06, pos.z)
		mi.visible = true
		var angle = (float(i) / float(NUM_DEBRIS)) * TAU + randf_range(-0.25, 0.25)
		var spd = randf_range(2.8, 4.8) * (p_max_scale / 1.15)
		debris_velocities[i] = Vector3(cos(angle) * spd, randf_range(1.8, 3.4), sin(angle) * spd)
		debris_lifetimes[i] = p_duration * 1.25

func _process(delta: float) -> void:
	# 1. Update shockwaves
	if shockwave_timer > 0.0:
		shockwave_timer -= delta
		var prog = 1.0 - clampf(shockwave_timer / shockwave_duration, 0.0, 1.0)
		var scale_val = lerpf(0.18, shockwave_max_scale, sqrt(prog))
		var alpha = (1.0 - prog) * 0.95
		
		if shockwave_mesh:
			shockwave_mesh.scale = Vector3(scale_val, 0.04, scale_val)
			shockwave_material.albedo_color = Color(shockwave_color.r, shockwave_color.g, shockwave_color.b, alpha)
			
		if shockwave_mesh_2:
			var scale_val2 = lerpf(0.10, shockwave_max_scale * 1.35, pow(prog, 0.7))
			shockwave_mesh_2.scale = Vector3(scale_val2, 0.04, scale_val2)
			var alpha2 = (1.0 - prog) * 0.70
			shockwave_material_2.albedo_color = Color(shockwave_color.r * 0.9, shockwave_color.g * 0.5, shockwave_color.b * 0.2, alpha2)
			
		if shockwave_timer <= 0.0:
			if shockwave_mesh: shockwave_mesh.visible = false
			if shockwave_mesh_2: shockwave_mesh_2.visible = false
			
	# 2. Update debris shards
	for i in range(NUM_DEBRIS):
		if debris_lifetimes[i] > 0.0:
			debris_lifetimes[i] -= delta
			var mi: MeshInstance3D = debris_nodes[i]
			var vel: Vector3 = debris_velocities[i]
			vel.y -= 9.8 * delta # gravity
			debris_velocities[i] = vel
			mi.global_position += vel * delta
			if mi.global_position.y <= 0.02:
				mi.global_position.y = 0.02
				debris_velocities[i].y = -debris_velocities[i].y * 0.35 # ground bounce
				debris_velocities[i].x *= 0.8
				debris_velocities[i].z *= 0.8
			var alpha_d = clampf(debris_lifetimes[i] / (shockwave_duration * 1.25), 0.0, 1.0)
			debris_materials[i].albedo_color = Color(shockwave_color.r, shockwave_color.g * 0.85, shockwave_color.b * 0.4, alpha_d * 0.9)
			if debris_lifetimes[i] <= 0.0:
				mi.visible = false
				
	# 3. Update Whirlwind ground vortex
	vortex_time += delta
	if is_vortex_active:
		vortex_alpha = lerpf(vortex_alpha, 0.85, delta * 8.0)
		if vortex_mesh:
			vortex_mesh.global_position = Vector3(vortex_center.x, 0.025, vortex_center.z)
			var pulse = 1.0 + sin(vortex_time * 18.0) * 0.06
			vortex_mesh.scale = Vector3(vortex_radius * pulse, 0.04, vortex_radius * pulse)
			vortex_mesh.rotation.y += delta * 14.0
			vortex_material.albedo_color = Color(vortex_color.r, vortex_color.g, vortex_color.b, vortex_alpha)
	else:
		if vortex_alpha > 0.01:
			vortex_alpha = lerpf(vortex_alpha, 0.0, delta * 6.0)
			if vortex_mesh:
				vortex_material.albedo_color = Color(vortex_color.r, vortex_color.g, vortex_color.b, vortex_alpha)
				vortex_mesh.rotation.y += delta * 8.0
		else:
			vortex_alpha = 0.0
			if vortex_mesh:
				vortex_mesh.visible = false
			
	# 2. Age existing ribbon segments
	var i = 0
	while i < segments.size():
		segments[i]["life"] -= delta
		if segments[i]["life"] <= 0.0:
			segments.remove_at(i)
		else:
			i += 1
			
	# 3. Sample new segment if emitting and target valid
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
				
	# 4. Render smooth ribbon
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
	var n = segments.size()
	if n < 2:
		return out
		
	for i in range(n):
		var seg = segments[i]
		var norm_age = 1.0 - clampf(seg["life"] / seg["max_life"], 0.0, 1.0)
		var alpha = pow(1.0 - norm_age, 1.5)
		
		if i == n - 1:
			out.append({
				"tip": seg["tip"],
				"base": seg["base"],
				"alpha": alpha
			})
			break
			
		var seg_next = segments[i + 1]
		var norm_age_next = 1.0 - clampf(seg_next["life"] / seg_next["max_life"], 0.0, 1.0)
		var alpha_next = pow(1.0 - norm_age_next, 1.5)
		
		# 2 spline subdivisions between consecutive points
		for step in range(2):
			var t = float(step) / 2.0
			var p_tip = _catmull_rom(
				_get_seg_tip(i - 1),
				seg["tip"],
				seg_next["tip"],
				_get_seg_tip(i + 2),
				t
			)
			var p_base = _catmull_rom(
				_get_seg_base(i - 1),
				seg["base"],
				seg_next["base"],
				_get_seg_base(i + 2),
				t
			)
			var cur_alpha = lerpf(alpha, alpha_next, t)
			out.append({
				"tip": p_tip,
				"base": p_base,
				"alpha": cur_alpha
			})
			
	return out

func _get_seg_tip(idx: int) -> Vector3:
	var clamped = clampi(idx, 0, segments.size() - 1)
	return segments[clamped]["tip"]

func _get_seg_base(idx: int) -> Vector3:
	var clamped = clampi(idx, 0, segments.size() - 1)
	return segments[clamped]["base"]

func _catmull_rom(p0: Vector3, p1: Vector3, p2: Vector3, p3: Vector3, t: float) -> Vector3:
	var t2 = t * t
	var t3 = t2 * t
	return 0.5 * (
		(2.0 * p1) +
		(-p0 + p2) * t +
		(2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 +
		(-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3
	)
