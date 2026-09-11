class_name GoblinShaman
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var staff: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Staff
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var staff_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Staff/StaffMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

@onready var totem_spawn: Node3D = $TotemSpawn
@onready var totem_mesh: MeshInstance3D = $TotemSpawn/TotemMesh

# State
var current_anim: String = "idle" # "idle", "walk", "run", "chant", "summon", "hex", "hurt", "stunned"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const SUMMON_DURATION: float = 1.45
const HEX_DURATION: float = 0.95
const HURT_DURATION: float = 0.50

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.22
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

var ground_hips_y: float = 0.618
var current_stance: String = "idle"
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Stun Stars
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

signal anim_changed(anim_name: String)

func _ready() -> void:
	generate_voxel_meshes()
	_init_stun_stars()
	_init_default_stances()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)

func _init_default_stances() -> void:
	default_stance_configs = {
		"idle": {
			"right_arm_rot": Vector3(-12.0, 6.0, 20.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"staff_rot": Vector3(12.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-25.0, 15.0, -26.0),
			"left_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(-14.0, 10.0, 22.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"staff_rot": Vector3(14.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-25.0, 12.0, -22.0),
			"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-2.0, 0.0, 0.0)
		},
		"run": {
			"right_arm_rot": Vector3(-25.0, 15.0, 24.0),
			"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"staff_rot": Vector3(48.0, 18.0, -12.0),
			"left_arm_rot": Vector3(-38.0, -12.0, -24.0),
			"left_forearm_rot": Vector3(-60.0, 0.0, 0.0),
			"torso_rot": Vector3(16.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"chant": {
			"right_arm_rot": Vector3(-128.0, 15.0, 32.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"staff_rot": Vector3(88.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-118.0, -18.0, -36.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(-18.0, 0.0, 0.0),
			"head_rot": Vector3(-28.0, 0.0, 0.0)
		},
		"summon": {
			"right_arm_rot": Vector3(-38.0, 8.0, 24.0),
			"right_forearm_rot": Vector3(-50.0, 0.0, 0.0),
			"staff_rot": Vector3(15.0, 10.0, -6.0),
			"left_arm_rot": Vector3(-25.0, 0.0, -30.0),
			"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
			"torso_rot": Vector3(26.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		},
		"hex": {
			"right_arm_rot": Vector3(-88.0, -10.0, 18.0),
			"right_forearm_rot": Vector3(-10.0, 0.0, 0.0),
			"staff_rot": Vector3(88.0, 10.0, 0.0),
			"left_arm_rot": Vector3(28.0, 0.0, -26.0),
			"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, -22.0, 0.0),
			"head_rot": Vector3(-4.0, 12.0, 0.0)
		},
		"hurt": {
			"right_arm_rot": Vector3(-36.0, 0.0, 28.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"staff_rot": Vector3(15.0, 10.0, 0.0),
			"left_arm_rot": Vector3(24.0, 0.0, -32.0),
			"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"torso_rot": Vector3(-26.0, -12.0, 0.0),
			"head_rot": Vector3(22.0, -14.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(-18.0, 6.0, 22.0),
			"right_forearm_rot": Vector3(-47.0, 0.0, 0.0),
			"staff_rot": Vector3(20.0, 10.0, -8.0),
			"left_arm_rot": Vector3(16.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, 0.0, 6.0),
			"head_rot": Vector3(-8.0, 0.0, 0.0)
		}
	}

func load_stance_config() -> void:
	stance_configs = {}
	for k in default_stance_configs:
		stance_configs[k] = default_stance_configs[k].duplicate()
		
	var path = "res://data/stance_config.json"
	if not FileAccess.file_exists(path):
		path = "user://stance_config.json"
		
	if FileAccess.file_exists(path):
		var f = FileAccess.open(path, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				var d: Dictionary = json.data
				if d.has("shaman") and d["shaman"] is Dictionary:
					d = d["shaman"]
				if d.has("ground_hips_y"):
					ground_hips_y = float(d["ground_hips_y"])
				for s_key in d:
					if s_key == "ground_hips_y":
						continue
					if d[s_key] is Dictionary:
						var s_dict = d[s_key]
						if not stance_configs.has(s_key):
							stance_configs[s_key] = {}
						for prop in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
							if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
								stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Idle", "shortcut": "[ 1 ]"},
		{"id": "walk", "name": "Walk", "shortcut": "[ 2 ]"},
		{"id": "run", "name": "Run", "shortcut": "[ 3 ]"},
		{"id": "chant", "name": "Niệm Chú", "shortcut": "[ 4 ]"},
		{"id": "summon", "name": "Gọi Totem", "shortcut": "[ 5 ]"},
		{"id": "hex", "name": "Phóng Phép", "shortcut": "[ 6 ]"},
		{"id": "hurt", "name": "Trúng Đòn", "shortcut": "[ 7 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 8 ]"}
	]

func get_weapon_info() -> Dictionary:
	return {
		"title": "🦯 QUYỀN TRƯỢNG (HƯỚNG TRƯỢNG)",
		"prop": "staff_rot"
	}

func serialize_stances() -> Dictionary:
	var out: Dictionary = {
		"ground_hips_y": ground_hips_y
	}
	for s_key in stance_configs:
		out[s_key] = _serialize_stance(stance_configs[s_key])
	return out

func save_stance_config() -> bool:
	var path = "res://data/stance_config.json"
	var all_cfg: Dictionary = {}
	if FileAccess.file_exists(path):
		var f_in = FileAccess.open(path, FileAccess.READ)
		if f_in:
			var json = JSON.new()
			if json.parse(f_in.get_as_text()) == OK and json.data is Dictionary:
				all_cfg = json.data
			f_in.close()
	all_cfg["shaman"] = serialize_stances()
	
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(all_cfg, "\t"))
		f.close()
	var f2 = FileAccess.open("user://stance_config.json", FileAccess.WRITE)
	if f2:
		f2.store_string(JSON.stringify(all_cfg, "\t"))
		f2.close()
	return true

func _serialize_stance(s: Dictionary) -> Dictionary:
	var out = {}
	for k in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
		var v: Vector3 = s.get(k, Vector3.ZERO)
		out[k] = [snappedf(v.x, 0.1), snappedf(v.y, 0.1), snappedf(v.z, 0.1)]
	return out

func copy_weapon_from_idle(target_anim: String) -> void:
	var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	if not stance_configs.has(target_anim):
		stance_configs[target_anim] = default_stance_configs.get(target_anim, {}).duplicate()
	if idle_cfg.has("staff_rot"):
		stance_configs[target_anim]["staff_rot"] = idle_cfg["staff_rot"]
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func set_stance(st_name: String) -> void:
	if current_stance == st_name and current_anim == st_name:
		return
	current_stance = st_name
	play_anim(st_name)

func reset_stance_to_default(s_name: String) -> void:
	if default_stance_configs.has(s_name):
		stance_configs[s_name] = default_stance_configs[s_name].duplicate()
		if current_stance == s_name or current_anim == s_name:
			current_pose = _compute_pose(current_anim, anim_time)
			_apply_pose(current_pose)

func update_live_stance(s_name: String, prop: String, val: Variant) -> void:
	if not stance_configs.has(s_name):
		stance_configs[s_name] = {}
	stance_configs[s_name][prop] = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		rad_to_deg(lerp_angle(deg_to_rad(a.x), deg_to_rad(b.x), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.y), deg_to_rad(b.y), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.z), deg_to_rad(b.z), weight))
	)

func generate_voxel_meshes() -> void:
	head_mesh.mesh = VoxelBuilder.build_shaman_head_mesh()
	torso_mesh.mesh = VoxelBuilder.build_shaman_torso_mesh()
	staff_mesh.mesh = VoxelBuilder.build_shaman_staff_mesh()
	totem_mesh.mesh = VoxelBuilder.build_totem_mesh()
	left_arm_mesh.mesh = VoxelBuilder.build_shaman_upper_arm_mesh()
	left_forearm_mesh.mesh = VoxelBuilder.build_shaman_forearm_mesh(false)
	right_arm_mesh.mesh = VoxelBuilder.build_shaman_upper_arm_mesh()
	right_forearm_mesh.mesh = VoxelBuilder.build_shaman_forearm_mesh(true)
	left_thigh_mesh.mesh = VoxelBuilder.build_shaman_thigh_mesh()
	left_shin_mesh.mesh = VoxelBuilder.build_shaman_shin_mesh()
	right_thigh_mesh.mesh = VoxelBuilder.build_shaman_thigh_mesh()
	right_shin_mesh.mesh = VoxelBuilder.build_shaman_shin_mesh()

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and current_anim not in ["summon", "hex", "hurt"]:
		return
	_start_blend()
	current_anim = anim_name
	action_time = 0.0
	
	if current_anim in ["idle", "walk", "run", "chant", "stunned"]:
		base_anim = current_anim
		
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	if current_anim != "summon" and totem_mesh:
		totem_mesh.visible = false
		
	emit_signal("anim_changed", current_anim)

func set_speed(val: float) -> void:
	anim_speed = clampf(val, 0.2, 3.0)

func _start_blend() -> void:
	source_pose = current_pose.duplicate(true)
	blend_timer = 0.0
	is_blending = true

func _process(delta: float) -> void:
	var dt = delta * anim_speed
	anim_time += dt
	
	if current_anim == "summon":
		action_time += dt
		_update_totem_spawn(action_time)
		if action_time >= SUMMON_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "hex":
		action_time += dt
		if action_time >= HEX_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
	elif current_anim == "hurt":
		action_time += dt
		if action_time >= HURT_DURATION:
			current_anim = base_anim
			action_time = 0.0
			_start_blend()
			emit_signal("anim_changed", current_anim)
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var target_pose = _compute_pose(current_anim, anim_time)
	
	if is_blending:
		blend_timer += dt
		var factor = clampf(blend_timer / BLEND_DURATION, 0.0, 1.0)
		var smooth_f = smoothstep(0.0, 1.0, factor)
		current_pose = _blend_poses(source_pose, target_pose, smooth_f)
		if factor >= 1.0:
			is_blending = false
	else:
		current_pose = target_pose
		
	_apply_pose(current_pose)

func _update_totem_spawn(t_s: float) -> void:
	var tau = clampf(t_s / SUMMON_DURATION, 0.0, 1.0)
	# Totem erupts right as staff slams the ground at tau = 0.36
	if tau >= 0.36 and tau < 0.94:
		totem_mesh.visible = true
		var rise_s = clampf((tau - 0.36) / 0.18, 0.0, 1.0)
		var smooth_rise = smoothstep(0.0, 1.0, rise_s)
		# Erupts from Y = -1.2m below ground to Y = 0.0m
		totem_spawn.position.y = lerp(-1.2, 0.0, smooth_rise)
		if rise_s < 1.0:
			totem_spawn.position.x = 0.55 + sin(t_s * 55.0) * 0.02
		else:
			totem_spawn.position.x = 0.55
	elif tau >= 0.94:
		var sink_s = clampf((tau - 0.94) / 0.06, 0.0, 1.0)
		totem_spawn.position.y = lerp(0.0, -1.2, smoothstep(0.0, 1.0, sink_s))
		if tau >= 0.99:
			totem_mesh.visible = false
	else:
		totem_mesh.visible = false

func _compute_pose(anim: String, time_val: float) -> Dictionary:
	match anim:
		"idle": return _compute_idle(time_val)
		"ward": return _compute_ward(time_val)
		"walk": return _compute_walk(time_val)
		"run": return _compute_run(time_val)
		"chant": return _compute_chant(time_val)
		"summon": return _compute_summon(action_time)
		"hex": return _compute_hex(action_time)
		"hurt": return _compute_hurt(action_time)
		"stunned": return _compute_stunned(time_val)
		_: return _compute_idle(time_val)

# --- 1. IDLE (Occult Ritual Stance: Propagating Spine Breath, Outward-Flared Grounded Staff, Flowing Mudra) ---
func _compute_idle(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 1.8
	var b_hips = sin(t)
	var b_torso = sin(t - 0.25)
	var b_head = sin(t - 0.45)
	var cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var cfg_torso = cfg.get("torso_rot", Vector3(6.0, 0.0, 0.0))
	var cfg_head = cfg.get("head_rot", Vector3(-4.0, 0.0, 0.0))
	var cfg_r_arm = cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 18.0))
	var cfg_r_fore = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var cfg_staff = cfg.get("staff_rot", Vector3(12.0, 0.0, -8.0))
	var cfg_l_arm = cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var cfg_l_fore = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	
	# Fluid undulating breathing wave (Hips -> Lumbar -> Chest -> Cervical)
	p["hips_pos"] = Vector3(0.0, ground_hips_y + b_hips * 0.005, 0.0)
	p["hips_rot"] = Vector3(3.5 + b_hips * 1.0, sin(t * 0.4) * 2.5, 0.0)
	p["torso_rot"] = cfg_torso + Vector3(-b_torso * 2.5, sin(t * 0.4) * -2.0, b_torso * 0.8)
	p["head_rot"] = cfg_head + Vector3(b_head * 2.0, sin(t * 0.4) * 3.5, 0.0)
	
	# Right arm held outward (roll z = 20.0) so staff is 15cm clear of hip and skirt
	p["right_arm_rot"] = Vector3(cfg_r_arm.x + b_torso * 1.2, cfg_r_arm.y, cfg_r_arm.z)
	p["right_forearm_rot"] = cfg_r_fore
	# Staff planted outward (yaw 12, roll -8) so top and bottom never intersect body
	p["staff_rot"] = Vector3(cfg_staff.x - b_torso * 1.0, cfg_staff.y, cfg_staff.z)
	
	# Left arm flowing secondary mudra (shoulder + elbow + wrist wave)
	p["left_arm_rot"] = Vector3(cfg_l_arm.x + sin(t + 0.6) * 4.0, 15.0 + cos(t * 0.6) * 3.0, -26.0)
	p["left_forearm_rot"] = Vector3(cfg_l_fore.x + sin(t + 1.2) * 6.0, cos(t * 0.7) * 4.0, 0.0)
	
	# Wide stable base, flat grounded soles at y = -10
	p["left_thigh_rot"] = Vector3(-4.0, 0.0, -3.5)
	p["left_shin_rot"] = Vector3(6.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(4.0, 0.0, 3.5)
	p["right_shin_rot"] = Vector3(4.0, 0.0, 0.0)
	return p

# --- WARD (Thế Ấn Hộ Mệnh) ---
func _compute_ward(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.0
	var pulse = sin(t)
	var cfg = stance_configs.get("ward", default_stance_configs.get("ward", {}))
	var cfg_torso = cfg.get("torso_rot", Vector3(10.0, -10.0, 0.0))
	var cfg_head = cfg.get("head_rot", Vector3(-6.0, 10.0, 0.0))
	var cfg_r_arm = cfg.get("right_arm_rot", Vector3(-42.0, 20.0, 15.0))
	var cfg_r_fore = cfg.get("right_forearm_rot", Vector3(-75.0, 0.0, 0.0))
	var cfg_staff = cfg.get("staff_rot", Vector3(75.0, 25.0, -15.0))
	var cfg_l_arm = cfg.get("left_arm_rot", Vector3(-48.0, -25.0, -20.0))
	var cfg_l_fore = cfg.get("left_forearm_rot", Vector3(-85.0, 0.0, 0.0))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.014 + pulse * 0.004, 0.0)
	p["hips_rot"] = Vector3(2.0, 10.0 + pulse * 1.5, 0.0)
	p["torso_rot"] = cfg_torso + Vector3(pulse * 1.5, 0.0, 0.0)
	p["head_rot"] = cfg_head + Vector3(-pulse * 1.5, 0.0, 0.0)
	
	# Arm flared outward in defensive projection
	p["right_arm_rot"] = Vector3(cfg_r_arm.x + pulse * 2.0, 18.0, 22.0)
	p["right_forearm_rot"] = cfg_r_fore
	p["staff_rot"] = Vector3(cfg_staff.x + pulse * 2.0, 22.0, -15.0)
	
	p["left_arm_rot"] = Vector3(cfg_l_arm.x + cos(t) * 3.0, cfg_l_arm.y, cfg_l_arm.z)
	p["left_forearm_rot"] = cfg_l_fore
	
	p["left_thigh_rot"] = Vector3(-8.0, 0.0, -5.0)
	p["left_shin_rot"] = Vector3(14.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(10.0, 0.0, 0.0)
	return p

# --- 2. WALK (Pilgrim Shaman Stride: 3D Pelvis, Active Elbows, Contralateral Cane Step, Zero Clipping) ---
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.6
	var s_leg = sin(t)
	var c_leg = cos(t)
	var c_2t = cos(2.0 * t)
	
	# Smooth continuous knee flexion curves
	var knee_l = pow(maxf(0.0, -s_leg), 1.35) * 36.0
	var knee_r = pow(maxf(0.0, s_leg), 1.35) * 36.0
	
	# 3D Pelvis kinematics: Yaw rotation into step, roll for weight transfer, 2-beat vertical bob
	p["hips_pos"] = Vector3(s_leg * 0.018, ground_hips_y - 0.008 + c_2t * 0.015, 0.0)
	p["hips_rot"] = Vector3(6.0 + c_2t * 1.5, s_leg * 8.0, -s_leg * 3.5)
	
	# Torso counter-rotation and elastic spinal sway
	p["torso_rot"] = Vector3(8.0 + sin(2.0 * t - 0.2) * 2.0, -s_leg * 7.0, s_leg * 2.5)
	p["head_rot"] = Vector3(-8.0, s_leg * 3.5, -s_leg * 1.5)
	
	# Leg strides with lateral clearance flare
	p["left_thigh_rot"] = Vector3(-s_leg * 26.0, 0.0, -3.5 - abs(s_leg) * 1.5)
	p["left_shin_rot"] = Vector3(knee_l + 4.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 26.0, 0.0, 3.5 + abs(s_leg) * 1.5)
	p["right_shin_rot"] = Vector3(knee_r + 4.0, 0.0, 0.0)
	
	# Left arm: Shoulder pump AND active elbow flexion/extension!
	var cfg = stance_configs.get("walk", default_stance_configs.get("walk", {}))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-14.0, 10.0, 22.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(14.0, 12.0, -8.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 12.0, -22.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-40.0, 0.0, 0.0))
	
	var l_pitch = base_l_arm.x + s_leg * 18.0
	var l_elbow = base_l_fore.x + s_leg * 18.0
	p["left_arm_rot"] = Vector3(l_pitch, base_l_arm.y, base_l_arm.z)
	p["left_forearm_rot"] = Vector3(l_elbow, 0.0, 0.0)
	
	# Right arm & Staff: Outward shoulder flare (Z = 22 deg), active shoulder/elbow cadence
	var r_pitch = base_r_arm.x - s_leg * 10.0
	var r_elbow = base_r_fore.x - s_leg * 8.0
	p["right_arm_rot"] = Vector3(r_pitch, base_r_arm.y, base_r_arm.z + c_leg * 2.0)
	p["right_forearm_rot"] = Vector3(r_elbow, 0.0, 0.0)
	p["staff_rot"] = Vector3(base_staff.x + s_leg * 8.0, base_staff.y, base_staff.z)
	return p

# --- 3. RUN (Dynamic Goblin Scamper: Full 3D Pelvis, Spine Wave, High Knee Drive, Aerodynamic Outward Staff Trail) ---
func _compute_run(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 6.2
	var s_leg = sin(t)
	var c_leg = cos(t)
	var c_2t = cos(2.0 * t)
	
	# High-performance knee flexion curve (deep back-kick up to 58 deg, smooth forward extension)
	var knee_l = pow(maxf(0.0, -s_leg), 1.25) * 58.0 + maxf(0.0, s_leg) * 8.0
	var knee_r = pow(maxf(0.0, s_leg), 1.25) * 58.0 + maxf(0.0, -s_leg) * 8.0
	
	# 1. Full 3D Pelvis Articulation:
	# Pitch: forward drive (14 deg) + dynamic step compression
	# Yaw: rotates with stride (14 deg)
	# Roll: Trendelenburg tilt (5 deg)
	p["hips_pos"] = Vector3(s_leg * 0.024, ground_hips_y - 0.028 + c_2t * 0.032, c_2t * 0.012)
	p["hips_rot"] = Vector3(14.0 + c_2t * 2.5, s_leg * 14.0, -s_leg * 5.0)
	
	# 2. Spine & Torso: Counter-rotation + propagating spinal flexion wave
	p["torso_rot"] = Vector3(16.0 + sin(2.0 * t - 0.3) * 3.5, -s_leg * 11.0, s_leg * 3.5)
	
	# 3. Head: Stabilizing gaze forward, compensating for body rotation
	p["head_rot"] = Vector3(-16.0 - c_2t * 2.0, s_leg * 6.0, -s_leg * 2.0)
	
	# 4. Legs: High forward knee drive + thigh flare clearing skirt and opposite leg
	p["left_thigh_rot"] = Vector3(-s_leg * 42.0, -s_leg * 4.0, -5.0 - abs(s_leg) * 3.0)
	p["left_shin_rot"] = Vector3(knee_l + 4.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s_leg * 42.0, s_leg * 4.0, 5.0 + abs(s_leg) * 3.0)
	p["right_shin_rot"] = Vector3(knee_r + 4.0, 0.0, 0.0)
	
	var cfg = stance_configs.get("run", default_stance_configs.get("run", {}))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-25.0, 15.0, 24.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-45.0, 0.0, 0.0))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(48.0, 18.0, -12.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-38.0, -12.0, -24.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-60.0, 0.0, 0.0))
	
	# 5. Left Arm: Full athletic running pump (Shoulder pitch +-32 deg, Elbow flexes to -88 deg!)
	var l_arm_pitch = base_l_arm.x - s_leg * 32.0
	var l_elbow_flex = base_l_fore.x - s_leg * 28.0
	p["left_arm_rot"] = Vector3(l_arm_pitch, base_l_arm.y, base_l_arm.z)
	p["left_forearm_rot"] = Vector3(l_elbow_flex, 0.0, 0.0)
	
	# 6. Right Arm & Staff: Active shoulder/elbow carriage, Outward Aerodynamic Trail (ZERO CLIPPING!)
	var r_arm_pitch = base_r_arm.x + c_leg * 10.0
	var r_elbow_flex = base_r_fore.x + s_leg * 10.0
	p["right_arm_rot"] = Vector3(r_arm_pitch, base_r_arm.y, base_r_arm.z + c_leg * 3.0)
	p["right_forearm_rot"] = Vector3(r_elbow_flex, 0.0, 0.0)
	p["staff_rot"] = Vector3(base_staff.x + c_leg * 6.0, base_staff.y, base_staff.z)
	return p

# --- 4. CHANT (Ground-Rooted Mystic Ritual: Wide Stance, Spine Wave, Outward Skyward Staff, ZERO CLIPPING) ---
func _compute_chant(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.4
	var surge = sin(t)
	var trem = sin(time_val * 32.0) * 1.5
	
	var cfg = stance_configs.get("chant", default_stance_configs.get("chant", {}))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-128.0, 15.0, 32.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-20.0, 0.0, 0.0))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(88.0, 12.0, -8.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-118.0, -18.0, -36.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	
	# 100% Grounded wide ritual stance, flat soles firmly at y = -10
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.030 + surge * 0.008, 0.0)
	p["hips_rot"] = Vector3(4.0 + surge * 2.0, sin(t * 0.5) * 5.0, 0.0)
	
	# Spine rocks in trance, arching back to channel dark mana to the heavens
	p["torso_rot"] = Vector3(-18.0 + surge * 7.0, sin(t * 0.5) * -7.0, cos(t) * 3.0)
	p["head_rot"] = Vector3(-28.0 + surge * 9.0, sin(t * 0.5) * 5.0, 0.0)
	
	# Right arm flared wide outward and high: completely clear of head/shoulders
	p["right_arm_rot"] = Vector3(base_r_arm.x + surge * 8.0, base_r_arm.y, base_r_arm.z)
	p["right_forearm_rot"] = Vector3(base_r_fore.x + cos(t) * 4.0, base_r_fore.y, base_r_fore.z)
	# Staff crown and glowing soul orb point proudly to the sky
	p["staff_rot"] = Vector3(base_staff.x + trem * 1.2, base_staff.y, base_staff.z)
	
	# Left arm splayed in wide occult arc
	p["left_arm_rot"] = Vector3(base_l_arm.x + cos(t) * 10.0, base_l_arm.y, base_l_arm.z + surge * 8.0)
	p["left_forearm_rot"] = Vector3(base_l_fore.x + sin(t) * 12.0, 0.0, 0.0)
	
	# Deep rooted legs absorbing ground tremor
	p["left_thigh_rot"] = Vector3(-14.0 + surge * 3.0, 0.0, -9.0)
	p["left_shin_rot"] = Vector3(22.0 - surge * 3.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(12.0 - surge * 3.0, 0.0, 9.0)
	p["right_shin_rot"] = Vector3(20.0 + surge * 3.0, 0.0, 0.0)
	return p

# --- 5. SUMMON TOTEM (Cinematic Earth Shatter: Windup -> Vertical Slam -> Totem Eruption -> Recovery, ZERO CLIPPING) ---
func _compute_summon(t_s: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_s / SUMMON_DURATION, 0.0, 1.0)
	var cfg = stance_configs.get("summon", default_stance_configs.get("summon", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(15.0, 10.0, -6.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-38.0, 8.0, 24.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-50.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(-25.0, 0.0, -30.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-55.0, 0.0, 0.0))
	
	if tau < 0.24:
		# PHASE 1: Dramatic Windup (0.0s - 0.35s): Arches back gathering lightning
		var s = smoothstep(0.0, 1.0, tau / 0.24)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y, ground_hips_y + 0.02, s), lerp(0.0, -0.05, s))
		p["hips_rot"] = Vector3(lerp(0.0, -8.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(0.0, -18.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(0.0, -20.0, s), 0.0, 0.0)
		
		# Staff raised high, flared outward
		p["right_arm_rot"] = _lerp_angles(base_r_arm, Vector3(-138.0, 10.0, 32.0), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, Vector3(-18.0, 0.0, 0.0), s)
		p["staff_rot"] = _lerp_angles(base_staff, Vector3(88.0, 10.0, -8.0), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, Vector3(-118.0, -15.0, -35.0), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, Vector3(-35.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-6.0, 0.0, -5.0)
		p["left_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(4.0, 0.0, 5.0)
		p["right_shin_rot"] = Vector3(10.0, 0.0, 0.0)
		
	elif tau < 0.36:
		# PHASE 2: Cataclysmic Ground Slam (0.24s - 0.52s): Staff driven vertically down at X = 0.36m (23cm clear of leg!)
		var s = smoothstep(0.0, 1.0, (tau - 0.24) / 0.12)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.02, ground_hips_y - 0.055, s), lerp(-0.05, 0.10, s))
		p["hips_rot"] = Vector3(lerp(-8.0, 14.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-18.0, 26.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-20.0, -6.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-138.0, base_r_arm.x, s), base_r_arm.y, base_r_arm.z)
		p["right_forearm_rot"] = Vector3(lerp(-18.0, base_r_fore.x, s), 0.0, 0.0)
		p["staff_rot"] = _lerp_angles(Vector3(88.0, 10.0, -6.0), base_staff, s)
		
		p["left_arm_rot"] = Vector3(lerp(-118.0, base_l_arm.x, s), base_l_arm.y, base_l_arm.z)
		p["left_forearm_rot"] = Vector3(lerp(-35.0, base_l_fore.x, s), 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-6.0, -22.0, s), 0.0, -8.0)
		p["left_shin_rot"] = Vector3(lerp(12.0, 34.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(4.0, 14.0, s), 0.0, 8.0)
		p["right_shin_rot"] = Vector3(lerp(10.0, 30.0, s), 0.0, 0.0)
		
	elif tau < 0.77:
		# PHASE 3: Totem Eruption & Spirit Binding (0.52s - 1.12s): Left arm channels dark energy
		var trem = sin(t_s * 48.0) * 1.2
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.04, 0.08)
		p["hips_rot"] = Vector3(10.0, 0.0, 0.0)
		p["torso_rot"] = Vector3(16.0 + trem, 0.0, 0.0)
		p["head_rot"] = Vector3(-4.0, 0.0, 0.0)
		
		# Staff held as an iron ground anchor at X = 0.36m
		p["right_arm_rot"] = base_r_arm
		p["right_forearm_rot"] = base_r_fore
		p["staff_rot"] = base_staff
		
		# Left arm commanding the Totem with active elbow tremor
		p["left_arm_rot"] = Vector3(-90.0 + trem, -15.0, -14.0)
		p["left_forearm_rot"] = Vector3(-18.0 + trem * 0.5, 0.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(-18.0, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(28.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(12.0, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(24.0, 0.0, 0.0)
		
	else:
		# PHASE 4: Recovery (1.12s - 1.45s): Majestic rise back to stance
		var s = smoothstep(0.0, 1.0, (tau - 0.77) / 0.23)
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.04, ground_hips_y, s), lerp(0.08, 0.0, s))
		p["hips_rot"] = Vector3(lerp(10.0, 0.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(16.0, 6.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, 0.0, s), 0.0, 0.0)
		
		var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
		p["right_arm_rot"] = _lerp_angles(base_r_arm, idle_cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 20.0)), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore, idle_cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0)), s)
		p["staff_rot"] = _lerp_angles(base_staff, idle_cfg.get("staff_rot", Vector3(12.0, 12.0, -8.0)), s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-90.0, -15.0, -14.0), idle_cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0)), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-18.0, 0.0, 0.0), idle_cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0)), s)
		
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, -3.5)
		p["left_shin_rot"] = Vector3(lerp(28.0, 6.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 4.0, s), 0.0, 3.5)
		p["right_shin_rot"] = Vector3(lerp(24.0, 4.0, s), 0.0, 0.0)
		
	return p

# --- 6. HEX BOLT (Spellcaster Kinetic Chain: Coil Mana -> Snap Forward Aiming Demon Skull Orb -> Recoil -> Settle, ZERO CLIPPING) ---
func _compute_hex(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HEX_DURATION, 0.0, 1.0)
	var cfg = stance_configs.get("hex", default_stance_configs.get("hex", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(88.0, 10.0, 0.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-88.0, -10.0, 18.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-10.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(28.0, 0.0, -26.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-40.0, 0.0, 0.0))
	
	if tau < 0.30:
		# PHASE 1: Siphoning Mana (0.0s - 0.28s): Twisting torso right, pulling staff back OUTSIDE shoulder
		var s = smoothstep(0.0, 1.0, tau / 0.30)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.0, -0.05, s))
		p["hips_rot"] = Vector3(0.0, lerp(0.0, 22.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(6.0, 2.0, s), lerp(0.0, 24.0, s), 0.0)
		p["head_rot"] = Vector3(0.0, lerp(0.0, -26.0, s), 0.0)
		
		# Staff drawn back outside right shoulder
		p["right_arm_rot"] = _lerp_angles(Vector3(-12.0, 6.0, 20.0), Vector3(-42.0, 28.0, 38.0), s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-35.0, 0.0, 0.0), Vector3(-95.0, 0.0, 0.0), s)
		p["staff_rot"] = _lerp_angles(Vector3(12.0, 12.0, -8.0), Vector3(65.0, 12.0, -8.0), s)
		
		# Left hand locks onto the target
		p["left_arm_rot"] = _lerp_angles(Vector3(-25.0, 15.0, -26.0), Vector3(-75.0, -18.0, -10.0), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), Vector3(-20.0, 0.0, 0.0), s)
		
		p["left_thigh_rot"] = Vector3(-10.0, 0.0, -4.0)
		p["left_shin_rot"] = Vector3(16.0, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(8.0, 0.0, 4.0)
		p["right_shin_rot"] = Vector3(12.0, 0.0, 0.0)
		
	elif tau < 0.50:
		# PHASE 2: Eldritch Snap Cast (0.28s - 0.48s): Uncoil forward pointing soul orb directly at foe!
		var s = smoothstep(0.0, 1.0, (tau - 0.30) / 0.20)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(-0.05, 0.10, s))
		p["hips_rot"] = Vector3(0.0, lerp(22.0, -16.0, s), 0.0)
		p["torso_rot"] = Vector3(12.0, lerp(24.0, -22.0, s), 0.0)
		p["head_rot"] = Vector3(-4.0, lerp(-26.0, 12.0, s), 0.0)
		
		# Staff thrust forward, pointing along the line of fire
		p["right_arm_rot"] = _lerp_angles(Vector3(-42.0, 28.0, 38.0), base_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-95.0, 0.0, 0.0), base_r_fore, s)
		p["staff_rot"] = _lerp_angles(Vector3(65.0, 12.0, -8.0), base_staff, s)
		
		# Left arm sweeps back with flexing elbow
		p["left_arm_rot"] = _lerp_angles(Vector3(-75.0, -18.0, -10.0), base_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-20.0, 0.0, 0.0), base_l_fore, s)
		
		p["left_thigh_rot"] = Vector3(lerp(-10.0, -24.0, s), 0.0, -4.0)
		p["left_shin_rot"] = Vector3(lerp(16.0, 30.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(8.0, 14.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 20.0, s), 0.0, 0.0)
		
	elif tau < 0.70:
		# PHASE 3: Magic Recoil (0.48s - 0.68s): Rebound shockwave pushes body back
		var s = smoothstep(0.0, 1.0, (tau - 0.50) / 0.20)
		var recoil_trem = sin(t_h * 50.0) * 1.5
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.10, 0.02, s))
		p["hips_rot"] = Vector3(0.0, lerp(-16.0, -4.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(12.0, 4.0, s) + recoil_trem, lerp(-22.0, -6.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(-4.0, 2.0, s), lerp(12.0, 4.0, s), 0.0)
		
		p["right_arm_rot"] = base_r_arm + Vector3(lerp(0.0, 23.0, s), 0.0, 0.0)
		p["right_forearm_rot"] = base_r_fore + Vector3(lerp(0.0, -20.0, s), 0.0, 0.0)
		p["staff_rot"] = base_staff + Vector3(lerp(0.0, -18.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = base_l_arm
		p["left_forearm_rot"] = base_l_fore
		
		p["left_thigh_rot"] = Vector3(lerp(-24.0, -12.0, s), 0.0, -4.0)
		p["left_shin_rot"] = Vector3(lerp(30.0, 16.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(14.0, 8.0, s), 0.0, 4.0)
		p["right_shin_rot"] = Vector3(lerp(20.0, 12.0, s), 0.0, 0.0)
		
	else:
		# PHASE 4: Settling Back to Stance (0.68s - 0.95s)
		var s = smoothstep(0.0, 1.0, (tau - 0.70) / 0.30)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, lerp(0.02, 0.0, s))
		p["hips_rot"] = Vector3(0.0, lerp(-4.0, 0.0, s), 0.0)
		p["torso_rot"] = Vector3(lerp(4.0, 6.0, s), lerp(-6.0, 0.0, s), 0.0)
		p["head_rot"] = Vector3(lerp(2.0, 0.0, s), lerp(4.0, 0.0, s), 0.0)
		
		var idle_cfg = stance_configs.get("idle", default_stance_configs.get("idle", {}))
		p["right_arm_rot"] = _lerp_angles(base_r_arm + Vector3(23.0, 0.0, 0.0), idle_cfg.get("right_arm_rot", Vector3(-12.0, 6.0, 20.0)), s)
		p["right_forearm_rot"] = _lerp_angles(base_r_fore + Vector3(-20.0, 0.0, 0.0), idle_cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0)), s)
		p["staff_rot"] = _lerp_angles(base_staff + Vector3(-18.0, 0.0, 0.0), idle_cfg.get("staff_rot", Vector3(12.0, 12.0, -8.0)), s)
		
		p["left_arm_rot"] = _lerp_angles(base_l_arm, idle_cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0)), s)
		p["left_forearm_rot"] = _lerp_angles(base_l_fore, idle_cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0)), s)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, -4.0, s), 0.0, -3.5)
		p["left_shin_rot"] = Vector3(lerp(16.0, 6.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(8.0, 4.0, s), 0.0, 3.5)
		p["right_shin_rot"] = Vector3(lerp(12.0, 4.0, s), 0.0, 0.0)
	return p

# --- 7. HURT (Visceral Elastic Shockwave, ZERO CLIPPING) ---
func _compute_hurt(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HURT_DURATION, 0.0, 1.0)
	var s = sin(tau * PI) * (1.0 - tau * 0.35)
	var cfg = stance_configs.get("hurt", default_stance_configs.get("hurt", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(15.0, 10.0, 0.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-36.0, 0.0, 28.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-20.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(24.0, 0.0, -32.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-45.0, 0.0, 0.0))
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.035, -s * 0.12)
	p["hips_rot"] = Vector3(-s * 10.0, s * 5.0, 0.0)
	p["torso_rot"] = Vector3(-s * 26.0, -s * 12.0, 0.0)
	p["head_rot"] = Vector3(s * 22.0, -s * 14.0, 0.0)
	
	# Staff jolts outward away from body (Z = 28 deg), zero clipping
	p["right_arm_rot"] = base_r_arm + Vector3(-s * 15.0, 0.0, s * 10.0)
	p["right_forearm_rot"] = base_r_fore + Vector3(-s * 10.0, 0.0, 0.0)
	p["staff_rot"] = base_staff + Vector3(s * 15.0, 0.0, 0.0)
	
	p["left_arm_rot"] = base_l_arm
	p["left_forearm_rot"] = base_l_fore
	
	p["left_thigh_rot"] = Vector3(-s * 15.0, 0.0, -5.0)
	p["left_shin_rot"] = Vector3(s * 25.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(s * 10.0, 0.0, 5.0)
	p["right_shin_rot"] = Vector3(s * 20.0, 0.0, 0.0)
	return p

# --- 8. STUNNED (Grounded Dazed Gyro-Sway: Leaning on Staff as a Crutch, Dizzy Head Loll, Feet Grounded, ZERO CLIPPING) ---
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.2
	var cfg = stance_configs.get("stunned", default_stance_configs.get("stunned", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(20.0, 10.0, -8.0))
	var base_r_arm: Vector3 = cfg.get("right_arm_rot", Vector3(-18.0, 6.0, 22.0))
	var base_r_fore: Vector3 = cfg.get("right_forearm_rot", Vector3(-47.0, 0.0, 0.0))
	var base_l_arm: Vector3 = cfg.get("left_arm_rot", Vector3(16.0, 0.0, -15.0))
	var base_l_fore: Vector3 = cfg.get("left_forearm_rot", Vector3(-12.0, 0.0, 0.0))
	
	# Weight tilted to the right leaning on staff, hips grounded
	p["hips_pos"] = Vector3(cos(t) * 0.015 + 0.02, ground_hips_y - 0.026, sin(t * 0.7) * 0.012)
	p["hips_rot"] = Vector3(cos(t) * 2.5, sin(t * 0.7) * 5.0, 7.0 + sin(t) * 2.5)
	p["torso_rot"] = Vector3(12.0 + cos(t) * 3.5, sin(t * 0.8) * 7.0, 6.0 + sin(t) * 3.5)
	
	# Head lolls in a dizzy circular orbit
	p["head_rot"] = Vector3(-8.0 + sin(t) * 12.0, cos(t) * 14.0, sin(t * 1.4) * 8.0)
	
	# Staff planted firmly acting as a cane/crutch, flared outward (Z = 22 deg) to prevent touching hip/thigh
	p["right_arm_rot"] = base_r_arm + Vector3(0.0, 0.0, sin(t) * 2.5)
	p["right_forearm_rot"] = base_r_fore
	p["staff_rot"] = base_staff + Vector3(cos(t) * 2.0, 0.0, 0.0)
	
	# Left arm hangs limp and dangling
	p["left_arm_rot"] = base_l_arm + Vector3(sin(t) * 4.0, 0.0, 0.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(cos(t) * 3.0, 0.0, 0.0)
	
	# Stable wide base, soles grounded at y = -10 (0.000m contact)
	p["left_thigh_rot"] = Vector3(-14.0 + sin(t) * 2.5, 0.0, -8.0)
	p["left_shin_rot"] = Vector3(20.0 - sin(t) * 2.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(10.0 - sin(t) * 2.0, 0.0, 8.0)
	p["right_shin_rot"] = Vector3(16.0 + sin(t) * 2.0, 0.0, 0.0)
	return p

func _blend_poses(a: Dictionary, b: Dictionary, f: float) -> Dictionary:
	var out: Dictionary = {}
	for k in b:
		if a.has(k):
			if k == "hips_pos":
				out[k] = a[k].lerp(b[k], f)
			elif b[k] is Vector3:
				out[k] = _lerp_angles(a[k], b[k], f)
			elif b[k] is float:
				out[k] = lerpf(a[k], b[k], f)
		else:
			out[k] = b[k]
	return out

func _apply_pose(p: Dictionary) -> void:
	if p.has("hips_pos"): hips.position = p["hips_pos"]
	if p.has("hips_rot"): hips.rotation_degrees = p["hips_rot"]
	if p.has("torso_rot"): torso.rotation_degrees = p["torso_rot"]
	if p.has("head_rot"): head.rotation_degrees = p["head_rot"]
	
	if p.has("left_arm_rot"): left_arm.rotation_degrees = p["left_arm_rot"]
	if p.has("left_forearm_rot"): left_forearm.rotation_degrees = p["left_forearm_rot"]
	if p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
	if p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
	if p.has("staff_rot"): staff.rotation_degrees = p["staff_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
