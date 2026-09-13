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

@onready var cloak: Node3D = $VisualRoot/Hips/Torso/Cloak
@onready var cloak_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Cloak/CloakMesh
var cloak_current_rot: Vector3 = Vector3.ZERO

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
var is_in_editor: bool = false
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Stun Stars
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

# Magic Projectile
const ShamanProjectileScript = preload("res://scripts/shaman_projectile.gd")
var hex_projectile_launched: bool = false

# Outfit System
var current_outfit: int = 1
var outfit_meshes: Dictionary = {}
signal outfit_changed(outfit_id: int)

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
			"staff_rot": Vector3(81.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-25.0, 15.0, -26.0),
			"left_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-4.0, 0.0, 0.0)
		},
		"walk": {
			"right_arm_rot": Vector3(-14.0, 10.0, 22.0),
			"right_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"staff_rot": Vector3(87.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-25.0, 12.0, -22.0),
			"left_forearm_rot": Vector3(-40.0, 0.0, 0.0),
			"torso_rot": Vector3(6.0, 0.0, 0.0),
			"head_rot": Vector3(-2.0, 0.0, 0.0)
		},
		"run": {
			"right_arm_rot": Vector3(-25.0, 15.0, 24.0),
			"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"staff_rot": Vector3(89.0, 0.0, -2.0),
			"left_arm_rot": Vector3(-38.0, -12.0, -24.0),
			"left_forearm_rot": Vector3(-60.0, 0.0, 0.0),
			"torso_rot": Vector3(16.0, 0.0, 0.0),
			"head_rot": Vector3(-16.0, 0.0, 0.0)
		},
		"chant": {
			"right_arm_rot": Vector3(-128.0, 15.0, 32.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"staff_rot": Vector3(180.0, 12.0, -8.0),
			"left_arm_rot": Vector3(-118.0, -18.0, -36.0),
			"left_forearm_rot": Vector3(-35.0, 0.0, 0.0),
			"torso_rot": Vector3(-18.0, 0.0, 0.0),
			"head_rot": Vector3(-28.0, 0.0, 0.0)
		},
		"summon": {
			"right_arm_rot": Vector3(-38.0, 8.0, 24.0),
			"right_forearm_rot": Vector3(-50.0, 0.0, 0.0),
			"staff_rot": Vector3(44.0, 18.0, -6.0),
			"left_arm_rot": Vector3(-25.0, 0.0, -30.0),
			"left_forearm_rot": Vector3(-55.0, 0.0, 0.0),
			"torso_rot": Vector3(26.0, 0.0, 0.0),
			"head_rot": Vector3(-6.0, 0.0, 0.0)
		},
		"hex": {
			"right_arm_rot": Vector3(-88.0, -10.0, 18.0),
			"right_forearm_rot": Vector3(-10.0, 0.0, 0.0),
			"staff_rot": Vector3(88.0, 10.0, 0.0),
			"left_arm_rot": Vector3(-62.0, -18.0, -16.0),
			"left_forearm_rot": Vector3(-25.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, -20.0, 0.0),
			"head_rot": Vector3(-4.0, 14.0, 0.0)
		},
		"hurt": {
			"right_arm_rot": Vector3(-36.0, 0.0, 28.0),
			"right_forearm_rot": Vector3(-20.0, 0.0, 0.0),
			"staff_rot": Vector3(73.0, 10.0, -1.0),
			"left_arm_rot": Vector3(24.0, 0.0, -32.0),
			"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"torso_rot": Vector3(-26.0, -12.0, 0.0),
			"head_rot": Vector3(22.0, -14.0, 0.0)
		},
		"stunned": {
			"right_arm_rot": Vector3(-18.0, 6.0, 22.0),
			"right_forearm_rot": Vector3(-47.0, 0.0, 0.0),
			"staff_rot": Vector3(129.0, -50.0, -55.0),
			"left_arm_rot": Vector3(16.0, 0.0, -15.0),
			"left_forearm_rot": Vector3(-12.0, 0.0, 0.0),
			"torso_rot": Vector3(12.0, 0.0, 6.0),
			"head_rot": Vector3(-8.0, 0.0, 0.0)
		},
		"ward": {
			"right_arm_rot": Vector3(-42.0, 20.0, 15.0),
			"right_forearm_rot": Vector3(-75.0, 0.0, 0.0),
			"staff_rot": Vector3(75.0, 25.0, -15.0),
			"left_arm_rot": Vector3(-48.0, -25.0, -20.0),
			"left_forearm_rot": Vector3(-85.0, 0.0, 0.0),
			"torso_rot": Vector3(10.0, -10.0, 0.0),
			"head_rot": Vector3(-6.0, 10.0, 0.0)
		}
	}

func load_stance_config() -> void:
	if default_stance_configs.is_empty() and has_method("_init_default_stances"):
		_init_default_stances()
	stance_configs = {}
	for k in default_stance_configs:
		stance_configs[k] = default_stance_configs[k].duplicate()
		
	var s_cfg: Dictionary = {}
	
	# 1. Check res://data/stance_config.json
	var res_path = "res://data/stance_config.json"
	if FileAccess.file_exists(res_path):
		var f = FileAccess.open(res_path, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				var d: Dictionary = json.data
				if d.has("shaman") and d["shaman"] is Dictionary:
					s_cfg = d["shaman"].duplicate()
					
	# 2. Check user://stance_config.json for overrides
	var user_path = "user://stance_config.json"
	if FileAccess.file_exists(user_path):
		var f_u = FileAccess.open(user_path, FileAccess.READ)
		if f_u:
			var txt_u = f_u.get_as_text()
			f_u.close()
			var json_u = JSON.new()
			if json_u.parse(txt_u) == OK and json_u.data is Dictionary:
				var d_u: Dictionary = json_u.data
				if d_u.has("shaman") and d_u["shaman"] is Dictionary:
					for k in d_u["shaman"]:
						s_cfg[k] = d_u["shaman"][k]
						
	if s_cfg.has("ground_hips_y"):
		ground_hips_y = float(s_cfg["ground_hips_y"])
		
	for s_key in s_cfg:
		if s_key == "ground_hips_y":
			continue
		if s_cfg[s_key] is Dictionary:
			var s_dict = s_cfg[s_key]
			if not stance_configs.has(s_key):
				stance_configs[s_key] = {}
			for prop in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
				if s_dict.has(prop) and s_dict[prop] is Array and s_dict[prop].size() == 3:
					stance_configs[s_key][prop] = Vector3(float(s_dict[prop][0]), float(s_dict[prop][1]), float(s_dict[prop][2]))

func get_stance_definitions() -> Array:
	return [
		{"id": "idle", "name": "Nghỉ", "shortcut": "[ Q ]"},
		{"id": "chant", "name": "Niệm Chú", "shortcut": "[ W ]"},
		{"id": "ward", "name": "Hộ Mệnh", "shortcut": "[ E ]"},
		{"id": "walk", "name": "Bước Đi", "shortcut": "[ 1 ]"},
		{"id": "run", "name": "Chạy Lao", "shortcut": "[ 2 ]"},
		{"id": "summon", "name": "Gọi Totem", "shortcut": "[ 3 ]"},
		{"id": "hex", "name": "Phóng Phép", "shortcut": "[ 4 ]"},
		{"id": "hurt", "name": "Trúng Đòn", "shortcut": "[ 5 ]"},
		{"id": "stunned", "name": "Choáng", "shortcut": "[ 6 ]"}
	]

func set_editor_mode(val: bool) -> void:
	is_in_editor = val
	if is_in_editor:
		is_blending = false
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func get_weapon_info() -> Dictionary:
	var title = "🦯 QUYỀN TRƯỢNG BỘ LẠC (HƯỚNG TRƯỢNG)"
	if current_outfit == 3:
		title = "☀️ QUYỀN TRƯỢNG THÁI DƯƠNG HOÀNG KIM (HƯỚNG TRƯỢNG)"
	elif current_outfit == 2:
		title = "🔮 VƯƠNG TRƯỢNG RỒNG TÍM (HƯỚNG TRƯỢNG)"
	return {
		"title": title,
		"prop": "staff_rot"
	}

func serialize_stances() -> Dictionary:
	if default_stance_configs.is_empty() and has_method("_init_default_stances"):
		_init_default_stances()
	var out: Dictionary = {
		"ground_hips_y": ground_hips_y
	}
	for s_key in stance_configs:
		out[s_key] = _serialize_stance(stance_configs[s_key])
	return out

func save_stance_config() -> bool:
	var master_cfg: Dictionary = {}
	
	# 1. Read existing from res://data/stance_config.json if available
	var res_path = "res://data/stance_config.json"
	if FileAccess.file_exists(res_path):
		var f_in = FileAccess.open(res_path, FileAccess.READ)
		if f_in:
			var json = JSON.new()
			if json.parse(f_in.get_as_text()) == OK and json.data is Dictionary:
				master_cfg = json.data
			f_in.close()
			
	# 2. Merge user://stance_config.json if available
	var user_path = "user://stance_config.json"
	if FileAccess.file_exists(user_path):
		var f_u = FileAccess.open(user_path, FileAccess.READ)
		if f_u:
			var txt_u = f_u.get_as_text()
			f_u.close()
			var json_u = JSON.new()
			if json_u.parse(txt_u) == OK and json_u.data is Dictionary:
				for k in json_u.data:
					master_cfg[k] = json_u.data[k]
					
	# 3. Save shaman stances
	master_cfg["shaman"] = serialize_stances()
	
	# 4. Save to user:// (guaranteed writable)
	var f_out_user = FileAccess.open(user_path, FileAccess.WRITE)
	if f_out_user:
		f_out_user.store_string(JSON.stringify(master_cfg, "\t"))
		f_out_user.close()
		
	# 5. Save to res:// (dev environment)
	var f_out_res = FileAccess.open(res_path, FileAccess.WRITE)
	if f_out_res:
		f_out_res.store_string(JSON.stringify(master_cfg, "\t"))
		f_out_res.close()
		
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
	if s_name in ["idle", "chant", "ward"]:
		current_stance = s_name
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
	# Pre-build meshes for Outfit 1 (Thầy Mo Bộ Lạc / Feral Tribal Witch Doctor)
	outfit_meshes[1] = {
		"head": VoxelBuilder.build_shaman_head_mesh(1),
		"torso": VoxelBuilder.build_shaman_torso_mesh(1),
		"upper_arm": VoxelBuilder.build_shaman_upper_arm_mesh(1),
		"left_forearm": VoxelBuilder.build_shaman_forearm_mesh(false, 1),
		"right_forearm": VoxelBuilder.build_shaman_forearm_mesh(true, 1),
		"staff": VoxelBuilder.build_shaman_staff_mesh(1),
		"thigh": VoxelBuilder.build_shaman_thigh_mesh(1),
		"shin": VoxelBuilder.build_shaman_shin_mesh(1),
		"cloak": null,
		"totem": VoxelBuilder.build_totem_mesh(1)
	}
	
	# Pre-build meshes for Outfit 2 (Đại Pháp Sư Tím / Grand Arch-Shaman Magenta)
	outfit_meshes[2] = {
		"head": VoxelBuilder.build_shaman_head_mesh(2),
		"torso": VoxelBuilder.build_shaman_torso_mesh(2),
		"upper_arm": VoxelBuilder.build_shaman_upper_arm_mesh(2),
		"left_forearm": VoxelBuilder.build_shaman_forearm_mesh(false, 2),
		"right_forearm": VoxelBuilder.build_shaman_forearm_mesh(true, 2),
		"staff": VoxelBuilder.build_shaman_staff_mesh(2),
		"thigh": VoxelBuilder.build_shaman_thigh_mesh(2),
		"shin": VoxelBuilder.build_shaman_shin_mesh(2),
		"cloak": VoxelBuilder.build_shaman_cloak_mesh(2),
		"totem": VoxelBuilder.build_totem_mesh(2)
	}
	
	# Pre-build meshes for Outfit 3 (Pháp Vương Hoàng Kim Đế Quốc / Imperial Sovereign Golden Archon)
	outfit_meshes[3] = {
		"head": VoxelBuilder.build_shaman_head_mesh(3),
		"torso": VoxelBuilder.build_shaman_torso_mesh(3),
		"upper_arm": VoxelBuilder.build_shaman_upper_arm_mesh(3),
		"left_forearm": VoxelBuilder.build_shaman_forearm_mesh(false, 3),
		"right_forearm": VoxelBuilder.build_shaman_forearm_mesh(true, 3),
		"staff": VoxelBuilder.build_shaman_staff_mesh(3),
		"thigh": VoxelBuilder.build_shaman_thigh_mesh(3),
		"shin": VoxelBuilder.build_shaman_shin_mesh(3),
		"cloak": VoxelBuilder.build_shaman_cloak_mesh(3),
		"totem": VoxelBuilder.build_totem_mesh(3)
	}
	
	apply_outfit(current_outfit)

func set_outfit(outfit_id: int) -> void:
	current_outfit = clamp(outfit_id, 1, 3)
	apply_outfit(current_outfit)
	outfit_changed.emit(current_outfit)

func apply_outfit(outfit_id: int) -> void:
	if not outfit_meshes.has(outfit_id):
		return
	var m: Dictionary = outfit_meshes[outfit_id]
	head_mesh.mesh = m["head"]
	torso_mesh.mesh = m["torso"]
	left_arm_mesh.mesh = m["upper_arm"]
	left_forearm_mesh.mesh = m["left_forearm"]
	right_arm_mesh.mesh = m["upper_arm"]
	right_forearm_mesh.mesh = m["right_forearm"]
	staff_mesh.mesh = m["staff"]
	left_thigh_mesh.mesh = m["thigh"]
	left_shin_mesh.mesh = m["shin"]
	right_thigh_mesh.mesh = m["thigh"]
	right_shin_mesh.mesh = m["shin"]
	if cloak_mesh:
		var cm = m.get("cloak", null)
		cloak_mesh.mesh = cm
		cloak_mesh.visible = (cm != null)
	if totem_mesh and m.has("totem"):
		totem_mesh.mesh = m["totem"]

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
		
	if current_anim == "hex":
		hex_projectile_launched = false
		
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
	
	if current_anim in ["summon", "hex", "hurt"]:
		if not is_in_editor:
			action_time += dt
			if current_anim == "summon":
				_update_totem_spawn(action_time)
				if action_time >= SUMMON_DURATION:
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
			elif current_anim == "hex":
				if not hex_projectile_launched and action_time >= 0.38:
					hex_projectile_launched = true
					_spawn_hex_projectile()
				if action_time >= HEX_DURATION:
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
			elif current_anim == "hurt":
				if action_time >= HURT_DURATION:
					current_anim = base_anim
					action_time = 0.0
					_start_blend()
					emit_signal("anim_changed", current_anim)
		else:
			action_time = 0.45 # Hold apex pose in editor
			
	if stun_stars:
		stun_stars.set_active(current_anim == "stunned")
		
	var target_pose = _compute_pose(current_anim, anim_time)
	
	if is_blending and not is_in_editor:
		blend_timer += dt
		var factor = clampf(blend_timer / BLEND_DURATION, 0.0, 1.0)
		var smooth_f = smoothstep(0.0, 1.0, factor)
		current_pose = _blend_poses(source_pose, target_pose, smooth_f)
		if factor >= 1.0:
			is_blending = false
	else:
		current_pose = target_pose
		
	_apply_pose(current_pose)
	_update_cloak_physics(dt)

func _update_cloak_physics(delta: float) -> void:
	if not cloak or not cloak_mesh or not cloak_mesh.visible:
		return
		
	var target_rot = Vector3.ZERO
	
	match current_anim:
		"idle":
			# Majestic slow breathing and gentle ambient breeze
			var t = anim_time * 2.2
			target_rot.x = 5.0 + sin(t) * 3.2 + sin(t * 0.45) * 1.5
			target_rot.z = sin(t * 0.7) * 2.5
			target_rot.y = cos(t * 0.35) * 1.8
		"walk":
			# Pacing stride: trailing behind with rhythmic step counter-sway
			var t = anim_time * 4.5
			target_rot.x = 13.0 + sin(t * 2.0) * 4.5
			target_rot.z = sin(t) * 6.5
			target_rot.y = cos(t) * 3.5
		"run":
			# High speed charging sprint: lifted high backward with aerodynamic wave ripples
			var t = anim_time * 5.5
			target_rot.x = 28.0 + sin(t * 2.2) * 6.5 + sin(t * 3.7) * 2.8
			target_rot.z = sin(t) * 8.0
			target_rot.y = cos(t) * 4.5
		"chant":
			# Levitation mana vortex: floats outward and up as mystical energy surges
			var t = anim_time * 3.0
			target_rot.x = -9.0 + sin(t) * 5.5
			target_rot.z = sin(t * 0.8) * 4.0
			target_rot.y = cos(t * 0.5) * 3.0
		"summon":
			# Wind shockwave during totem ground slam
			var tau = clampf(action_time / SUMMON_DURATION, 0.0, 1.0)
			if tau < 0.36:
				target_rot.x = 10.0 + sin(tau / 0.36 * PI) * 8.0
				target_rot.z = sin(tau * 15.0) * 3.0
			elif tau < 0.70:
				var shock_u = (tau - 0.36) / 0.34
				target_rot.x = 30.0 * (1.0 - shock_u) + 6.0
				target_rot.z = sin(shock_u * PI * 3.5) * 9.0 * (1.0 - shock_u)
			else:
				var settle_u = (tau - 0.70) / 0.30
				target_rot.x = lerpf(6.0, 5.0, settle_u)
				target_rot.z = sin(settle_u * PI) * 2.0
		"hex":
			# Snap thrust backward trail then recoil settle
			var tau = clampf(action_time / HEX_DURATION, 0.0, 1.0)
			if tau < 0.30:
				target_rot.x = -4.0 * (tau / 0.30)
			elif tau < 0.50:
				var snap_u = (tau - 0.30) / 0.20
				target_rot.x = lerpf(-4.0, 26.0, snap_u)
				target_rot.z = snap_u * 6.0
			elif tau < 0.75:
				var recoil_u = (tau - 0.50) / 0.25
				target_rot.x = 26.0 * (1.0 - recoil_u) + 5.0
				target_rot.z = 6.0 * (1.0 - recoil_u)
			else:
				target_rot.x = 5.0
		"hurt":
			var tau = clampf(action_time / HURT_DURATION, 0.0, 1.0)
			target_rot.x = 20.0 * sin(tau * PI)
			target_rot.z = -12.0 * sin(tau * PI)
		"stunned":
			var t = anim_time * 2.5
			target_rot.x = 3.0 + sin(t) * 2.5
			target_rot.z = sin(t * 0.8) * 5.0
		_:
			target_rot.x = 5.0
			
	# Smooth physical damping with inertia
	var follow_speed = 8.0
	cloak_current_rot = cloak_current_rot.lerp(target_rot, clampf(delta * follow_speed, 0.0, 1.0))
	cloak.rotation_degrees = cloak_current_rot

func _update_totem_spawn(t_s: float) -> void:
	var tau = clampf(t_s / SUMMON_DURATION, 0.0, 1.0)
	# Totem erupts right as staff slams the ground at tau = 0.36
	if tau >= 0.36 and tau < 0.94:
		totem_mesh.visible = true
		var rise_s = clampf((tau - 0.36) / 0.18, 0.0, 1.0)
		var smooth_rise = smoothstep(0.0, 1.0, rise_s)
		# Erupts from Y = -1.5m below ground to Y = 0.0m
		totem_spawn.position.y = lerp(-1.5, 0.0, smooth_rise)
		var tremor = (1.0 - rise_s) * 0.015
		totem_spawn.position.x = 0.40 + sin(t_s * 55.0) * tremor
		totem_spawn.position.z = 0.90 + cos(t_s * 45.0) * tremor
	elif tau >= 0.94:
		var sink_s = clampf((tau - 0.94) / 0.06, 0.0, 1.0)
		totem_spawn.position.y = lerp(0.0, -1.5, smoothstep(0.0, 1.0, sink_s))
		totem_spawn.position.x = 0.40
		totem_spawn.position.z = 0.90
		if tau >= 0.99:
			totem_mesh.visible = false
	else:
		totem_mesh.visible = false

func _spawn_hex_projectile() -> void:
	var tip_pos: Vector3
	if staff:
		# Staff top is at approx y = 1.02m along local staff Y axis
		tip_pos = staff.global_transform * Vector3(0.0, 1.02, 0.0)
	else:
		tip_pos = global_transform.origin + Vector3(0.0, 1.0, 0.8)
		
	# Forward direction in world coordinates with subtle upward elevation
	var fwd = global_transform.basis.z.normalized()
	var launch_dir = Vector3(fwd.x, fwd.y + 0.04, fwd.z).normalized()
	
	var proj = ShamanProjectileScript.new()
	var target_parent = get_parent() if get_parent() else self
	target_parent.add_child(proj)
	proj.launch(tip_pos, launch_dir, current_outfit)

func _compute_pose(anim: String, time_val: float) -> Dictionary:
	var p: Dictionary = {}
	match anim:
		"idle": p = _compute_idle(time_val)
		"ward": p = _compute_ward(time_val)
		"walk": p = _compute_walk(time_val)
		"run": p = _compute_run(time_val)
		"chant": p = _compute_chant(time_val)
		"summon": p = _compute_summon(action_time)
		"hex": p = _compute_hex(action_time)
		"hurt": p = _compute_hurt(action_time)
		"stunned": p = _compute_stunned(time_val)
		_: p = _compute_idle(time_val)

	if is_in_editor and stance_configs.has(anim):
		var cfg = stance_configs[anim]
		for k in ["right_arm_rot", "right_forearm_rot", "staff_rot", "left_arm_rot", "left_forearm_rot", "torso_rot", "head_rot"]:
			if cfg.has(k):
				p[k] = cfg[k]
		p["hips_pos"] = Vector3(p.get("hips_pos", Vector3.ZERO).x, ground_hips_y, p.get("hips_pos", Vector3.ZERO).z)

	return p

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
	var cfg_staff = cfg.get("staff_rot", Vector3(81.0, 12.0, -8.0))
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
	p["left_arm_rot"] = Vector3(cfg_l_arm.x + sin(t + 0.6) * 4.0, cfg_l_arm.y + cos(t * 0.6) * 3.0, cfg_l_arm.z)
	p["left_forearm_rot"] = Vector3(cfg_l_fore.x + sin(t + 1.2) * 6.0, cfg_l_fore.y + cos(t * 0.7) * 4.0, cfg_l_fore.z)
	
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
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(87.0, 12.0, -8.0))
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
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(89.0, 0.0, -2.0))
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
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(180.0, 12.0, -8.0))
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
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(44.0, 18.0, -6.0))
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
		p["staff_rot"] = _lerp_angles(base_staff, Vector3(180.0, 10.0, -8.0), s)
		
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
		p["staff_rot"] = _lerp_angles(Vector3(180.0, 10.0, -6.0), base_staff, s)
		
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
		p["staff_rot"] = _lerp_angles(base_staff, idle_cfg.get("staff_rot", Vector3(81.0, 12.0, -8.0)), s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(-90.0, -15.0, -14.0), idle_cfg.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0)), s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-18.0, 0.0, 0.0), idle_cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0)), s)
		
		p["left_thigh_rot"] = Vector3(lerp(-18.0, -4.0, s), 0.0, -3.5)
		p["left_shin_rot"] = Vector3(lerp(28.0, 6.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(12.0, 4.0, s), 0.0, 3.5)
		p["right_shin_rot"] = Vector3(lerp(24.0, 4.0, s), 0.0, 0.0)
		
	return p

# --- 6. HEX BOLT (Spellcaster Kinetic Chain: Coil Mana -> Snap Forward Aiming Demon Skull Orb -> Damped Recoil -> Settle, ZERO CLIPPING) ---
func _compute_hex(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HEX_DURATION, 0.0, 1.0)
	
	# Base Stance (Idle / Recovery Target)
	var cfg_idle = stance_configs.get("idle", default_stance_configs.get("idle", {}))
	var idle_r_arm: Vector3 = cfg_idle.get("right_arm_rot", Vector3(-12.0, 6.0, 20.0))
	var idle_r_fore: Vector3 = cfg_idle.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var idle_staff: Vector3 = cfg_idle.get("staff_rot", Vector3(81.0, 12.0, -8.0))
	var idle_l_arm: Vector3 = cfg_idle.get("left_arm_rot", Vector3(-25.0, 15.0, -26.0))
	var idle_l_fore: Vector3 = cfg_idle.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	var idle_torso: Vector3 = cfg_idle.get("torso_rot", Vector3(6.0, 0.0, 0.0))
	var idle_head: Vector3 = cfg_idle.get("head_rot", Vector3(-4.0, 0.0, 0.0))
	var idle_l_thigh: Vector3 = Vector3(-4.0, 0.0, -3.5)
	var idle_l_shin: Vector3 = Vector3(6.0, 0.0, 0.0)
	var idle_r_thigh: Vector3 = Vector3(4.0, 0.0, 3.5)
	var idle_r_shin: Vector3 = Vector3(4.0, 0.0, 0.0)
	
	# Configured Hex Apex Cast Pose
	var cfg_hex = stance_configs.get("hex", default_stance_configs.get("hex", {}))
	var cast_staff: Vector3 = cfg_hex.get("staff_rot", Vector3(88.0, 10.0, 0.0))
	var cast_r_arm: Vector3 = cfg_hex.get("right_arm_rot", Vector3(-88.0, -10.0, 18.0))
	var cast_r_fore: Vector3 = cfg_hex.get("right_forearm_rot", Vector3(-10.0, 0.0, 0.0))
	var cast_l_arm: Vector3 = cfg_hex.get("left_arm_rot", Vector3(-62.0, -18.0, -16.0))
	var cast_l_fore: Vector3 = cfg_hex.get("left_forearm_rot", Vector3(-25.0, 0.0, 0.0))
	var cast_torso: Vector3 = cfg_hex.get("torso_rot", Vector3(12.0, -20.0, 0.0))
	var cast_head: Vector3 = cfg_hex.get("head_rot", Vector3(-4.0, 14.0, 0.0))
	
	# Key Pose 1: Windup / Mana Coil Peak (tau = 0.30)
	var windup_hips_pos = Vector3(0.0, ground_hips_y - 0.015, -0.045)
	var windup_hips_rot = Vector3(0.0, 20.0, 0.0)
	var windup_torso_rot = Vector3(4.0, 22.0, 0.0)
	var windup_head_rot = Vector3(-2.0, -20.0, 0.0)
	var windup_r_arm = Vector3(-38.0, 24.0, 32.0)
	var windup_r_fore = Vector3(-60.0, 0.0, 0.0)
	var windup_staff = Vector3(55.0, 12.0, -8.0)
	var windup_l_arm = Vector3(-70.0, -16.0, -10.0)
	var windup_l_fore = Vector3(-25.0, 0.0, 0.0)
	var windup_l_thigh = Vector3(-12.0, 0.0, -4.0)
	var windup_l_shin = Vector3(18.0, 0.0, 0.0)
	var windup_r_thigh = Vector3(8.0, 0.0, 4.0)
	var windup_r_shin = Vector3(12.0, 0.0, 0.0)
	
	# Key Pose 2: Snap Cast Apex (tau = 0.50)
	var cast_hips_pos = Vector3(0.0, ground_hips_y - 0.026, 0.09)
	var cast_hips_rot = Vector3(2.0, -14.0, 0.0)
	var cast_l_thigh = Vector3(-22.0, 0.0, -5.0)
	var cast_l_shin = Vector3(28.0, 0.0, 0.0)
	var cast_r_thigh = Vector3(14.0, 0.0, 5.0)
	var cast_r_shin = Vector3(20.0, 0.0, 0.0)
	
	# Key Pose 3: Recoil Absorption Peak (tau = 0.72)
	var recoil_hips_pos = Vector3(0.0, ground_hips_y - 0.012, 0.025)
	var recoil_hips_rot = Vector3(-1.0, -4.0, 0.0)
	var recoil_torso_rot = Vector3(5.0, -6.0, 0.0)
	var recoil_head_rot = Vector3(2.0, 4.0, 0.0)
	var recoil_r_arm = cast_r_arm + Vector3(20.0, 0.0, 2.0)
	var recoil_r_fore = cast_r_fore + Vector3(-18.0, 0.0, 0.0)
	var recoil_staff = cast_staff + Vector3(-16.0, 0.0, 0.0)
	var recoil_l_arm = cast_l_arm + Vector3(12.0, 6.0, -8.0)
	var recoil_l_fore = cast_l_fore + Vector3(-14.0, 0.0, 0.0)
	var recoil_l_thigh = Vector3(-14.0, 0.0, -4.0)
	var recoil_l_shin = Vector3(18.0, 0.0, 0.0)
	var recoil_r_thigh = Vector3(8.0, 0.0, 4.0)
	var recoil_r_shin = Vector3(12.0, 0.0, 0.0)
	
	if tau < 0.30:
		# PHASE 1: Mana Coil (0.0s - 0.285s)
		var s = smoothstep(0.0, 1.0, tau / 0.30)
		p["hips_pos"] = Vector3(0.0, ground_hips_y, 0.0).lerp(windup_hips_pos, s)
		p["hips_rot"] = _lerp_angles(Vector3.ZERO, windup_hips_rot, s)
		p["torso_rot"] = _lerp_angles(idle_torso, windup_torso_rot, s)
		p["head_rot"] = _lerp_angles(idle_head, windup_head_rot, s)
		
		p["right_arm_rot"] = _lerp_angles(idle_r_arm, windup_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(idle_r_fore, windup_r_fore, s)
		p["staff_rot"] = _lerp_angles(idle_staff, windup_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(idle_l_arm, windup_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(idle_l_fore, windup_l_fore, s)
		
		p["left_thigh_rot"] = _lerp_angles(idle_l_thigh, windup_l_thigh, s)
		p["left_shin_rot"] = _lerp_angles(idle_l_shin, windup_l_shin, s)
		p["right_thigh_rot"] = _lerp_angles(idle_r_thigh, windup_r_thigh, s)
		p["right_shin_rot"] = _lerp_angles(idle_r_shin, windup_r_shin, s)
		
	elif tau < 0.50:
		# PHASE 2: Snap Eldritch Thrust (0.285s - 0.475s)
		var s = smoothstep(0.0, 1.0, (tau - 0.30) / 0.20)
		p["hips_pos"] = windup_hips_pos.lerp(cast_hips_pos, s)
		p["hips_rot"] = _lerp_angles(windup_hips_rot, cast_hips_rot, s)
		p["torso_rot"] = _lerp_angles(windup_torso_rot, cast_torso, s)
		p["head_rot"] = _lerp_angles(windup_head_rot, cast_head, s)
		
		p["right_arm_rot"] = _lerp_angles(windup_r_arm, cast_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(windup_r_fore, cast_r_fore, s)
		p["staff_rot"] = _lerp_angles(windup_staff, cast_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(windup_l_arm, cast_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(windup_l_fore, cast_l_fore, s)
		
		p["left_thigh_rot"] = _lerp_angles(windup_l_thigh, cast_l_thigh, s)
		p["left_shin_rot"] = _lerp_angles(windup_l_shin, cast_l_shin, s)
		p["right_thigh_rot"] = _lerp_angles(windup_r_thigh, cast_r_thigh, s)
		p["right_shin_rot"] = _lerp_angles(windup_r_shin, cast_r_shin, s)
		
	elif tau < 0.72:
		# PHASE 3: Damped Recoil & Mana Shockwave (0.475s - 0.684s)
		var u = (tau - 0.50) / 0.22
		var s = smoothstep(0.0, 1.0, u)
		# Damped envelope ensures tremor starts and ends smoothly at 0.0
		var envelope = sin(u * PI)
		var recoil_trem = sin((tau - 0.50) * 48.0) * envelope * 1.2
		
		p["hips_pos"] = cast_hips_pos.lerp(recoil_hips_pos, s)
		p["hips_rot"] = _lerp_angles(cast_hips_rot, recoil_hips_rot, s)
		p["torso_rot"] = _lerp_angles(cast_torso, recoil_torso_rot, s) + Vector3(recoil_trem, 0.0, 0.0)
		p["head_rot"] = _lerp_angles(cast_head, recoil_head_rot, s)
		
		p["right_arm_rot"] = _lerp_angles(cast_r_arm, recoil_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(cast_r_fore, recoil_r_fore, s)
		p["staff_rot"] = _lerp_angles(cast_staff, recoil_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(cast_l_arm, recoil_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(cast_l_fore, recoil_l_fore, s)
		
		p["left_thigh_rot"] = _lerp_angles(cast_l_thigh, recoil_l_thigh, s)
		p["left_shin_rot"] = _lerp_angles(cast_l_shin, recoil_l_shin, s)
		p["right_thigh_rot"] = _lerp_angles(cast_r_thigh, recoil_r_thigh, s)
		p["right_shin_rot"] = _lerp_angles(cast_r_shin, recoil_r_shin, s)
		
	else:
		# PHASE 4: Smooth Recovery Settle to Stance (0.684s - 0.950s)
		var s = smoothstep(0.0, 1.0, (tau - 0.72) / 0.28)
		p["hips_pos"] = recoil_hips_pos.lerp(Vector3(0.0, ground_hips_y, 0.0), s)
		p["hips_rot"] = _lerp_angles(recoil_hips_rot, Vector3.ZERO, s)
		p["torso_rot"] = _lerp_angles(recoil_torso_rot, idle_torso, s)
		p["head_rot"] = _lerp_angles(recoil_head_rot, idle_head, s)
		
		p["right_arm_rot"] = _lerp_angles(recoil_r_arm, idle_r_arm, s)
		p["right_forearm_rot"] = _lerp_angles(recoil_r_fore, idle_r_fore, s)
		p["staff_rot"] = _lerp_angles(recoil_staff, idle_staff, s)
		
		p["left_arm_rot"] = _lerp_angles(recoil_l_arm, idle_l_arm, s)
		p["left_forearm_rot"] = _lerp_angles(recoil_l_fore, idle_l_fore, s)
		
		p["left_thigh_rot"] = _lerp_angles(recoil_l_thigh, idle_l_thigh, s)
		p["left_shin_rot"] = _lerp_angles(recoil_l_shin, idle_l_shin, s)
		p["right_thigh_rot"] = _lerp_angles(recoil_r_thigh, idle_r_thigh, s)
		p["right_shin_rot"] = _lerp_angles(recoil_r_shin, idle_r_shin, s)
		
	return p

# --- 7. HURT (Visceral Elastic Shockwave, ZERO CLIPPING) ---
func _compute_hurt(t_h: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = clampf(t_h / HURT_DURATION, 0.0, 1.0)
	var s = sin(tau * PI) * (1.0 - tau * 0.35)
	var cfg = stance_configs.get("hurt", default_stance_configs.get("hurt", {}))
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(73.0, 10.0, -1.0))
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
	var base_staff: Vector3 = cfg.get("staff_rot", Vector3(129.0, -50.0, -55.0))
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
	if not is_inside_tree() or not hips:
		return
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
