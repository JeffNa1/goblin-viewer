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

# Impact Shockwave Ring
var shockwave_mesh: MeshInstance3D = null
var shockwave_timer: float = 0.0
const SHOCKWAVE_DURATION: float = 0.28
var shockwave_material: StandardMaterial3D = null

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

func _create_shockwave_effect() -> void:
	shockwave_mesh = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.75
	torus.outer_radius = 0.90
	torus.rings = 24
	torus.ring_segments = 4
	shockwave_mesh.mesh = torus
	
	shockwave_material = StandardMaterial3D.new()
	shockwave_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave_material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shockwave_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shockwave_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	shockwave_material.albedo_color = Color(1.0, 0.7, 0.2, 0.0)
	shockwave_mesh.material_override = shockwave_material
	shockwave_mesh.visible = false
	add_child(shockwave_mesh)

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

func trigger_ground_impact(pos: Vector3) -> void:
	if shockwave_mesh:
		shockwave_mesh.global_position = pos
		shockwave_mesh.scale = Vector3(0.15, 0.05, 0.15)
		shockwave_mesh.visible = true
		shockwave_timer = SHOCKWAVE_DURATION

func _process(delta: float) -> void:
	# 1. Update shockwave
	if shockwave_timer > 0.0:
		shockwave_timer -= delta
		var prog = 1.0 - clampf(shockwave_timer / SHOCKWAVE_DURATION, 0.0, 1.0)
		var scale_val = lerpf(0.2, 1.15, sqrt(prog))
		shockwave_mesh.scale = Vector3(scale_val, 0.04, scale_val)
		var alpha = (1.0 - prog) * 0.9
		shockwave_material.albedo_color = Color(1.0, 0.65, 0.15, alpha)
		if shockwave_timer <= 0.0:
			shockwave_mesh.visible = false
			
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
