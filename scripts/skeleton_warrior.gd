class_name SkeletonWarrior
extends Node3D

# --- SKELETON WARRIOR CONTROLLER ---
# Ancient undead warrior wielding a shoddy notched sword and splintered wooden shield

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var shield: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Shield
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var sword: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Sword
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var shield_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Shield/ShieldMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var sword_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/Sword/SwordMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

# State
var current_anim: String = "idle" # "idle", "walk", "run", "slash", "thrust", "block", "hurt", "stunned"
var base_anim: String = "idle"
var current_stance: String = "ready" # "ready", "high_guard", "low_drag"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const SLASH_DURATION: float = 1.15
const THRUST_DURATION: float = 1.25
const BLOCK_DURATION: float = 1.20
const HURT_DURATION: float = 0.48

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.22
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

# Stance Config & Ground Height
var ground_hips_y: float = 0.64
var default_stance_configs: Dictionary = {}
var stance_configs: Dictionary = {}

# Stun Stars & Weapon Trail
const StunStarsScript = preload("res://scripts/stun_stars.gd")
const WeaponTrailScript = preload("res://scripts/weapon_trail.gd")
var stun_stars: Node3D = null
var weapon_trail: Node3D = null

signal anim_changed(anim_name: String)

func _init() -> void:
	_init_default_stances()

func _ready() -> void:
	generate_voxel_meshes()
	load_stance_config()
	current_pose = _compute_pose(current_anim, 0.0)
	_apply_pose(current_pose)
	_init_weapon_trail()
	_init_stun_stars()

func generate_voxel_meshes() -> void:
	head_mesh.mesh = VoxelBuilder.build_skeleton_head_mesh()
	torso_mesh.mesh = VoxelBuilder.build_skeleton_torso_mesh()
	left_arm_mesh.mesh = VoxelBuilder.build_skeleton_upper_arm_mesh()
	left_forearm_mesh.mesh = VoxelBuilder.build_skeleton_forearm_mesh(false)
	shield_mesh.mesh = VoxelBuilder.build_wooden_shield_mesh()
	right_arm_mesh.mesh = VoxelBuilder.build_skeleton_upper_arm_mesh()
	right_forearm_mesh.mesh = VoxelBuilder.build_skeleton_forearm_mesh(true)
	sword_mesh.mesh = VoxelBuilder.build_shoddy_sword_mesh()
	left_thigh_mesh.mesh = VoxelBuilder.build_skeleton_thigh_mesh()
	left_shin_mesh.mesh = VoxelBuilder.build_skeleton_shin_mesh()
	right_thigh_mesh.mesh = VoxelBuilder.build_skeleton_thigh_mesh()
	right_shin_mesh.mesh = VoxelBuilder.build_skeleton_shin_mesh()

func _init_default_stances() -> void:
	default_stance_configs = {
		"ready": {
			"right_arm_rot": Vector3(18.0, 5.0, 22.0),
			"right_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"sword_rot": Vector3(68.0, -8.0, -28.0),
			"left_arm_rot": Vector3(-20.0, 15.0, -26.0),
			"left_forearm_rot": Vector3(-65.0, 0.0, 0.0),
			"shield_rot": Vector3(68.0, -15.0, 5.0),
			"torso_rot": Vector3(8.0, -12.0, 0.0),
			"head_rot": Vector3(-4.0, 12.0, 0.0)
		},
		"high_guard": {
			"right_arm_rot": Vector3(-65.0, 25.0, 35.0),
			"right_forearm_rot": Vector3(-75.0, 0.0, 0.0),
			"sword_rot": Vector3(78.0, -10.0, -22.0),
			"left_arm_rot": Vector3(-35.0, 20.0, -20.0),
			"left_forearm_rot": Vector3(-80.0, 0.0, 0.0),
			"shield_rot": Vector3(82.0, -20.0, 10.0),
			"torso_rot": Vector3(12.0, -18.0, 0.0),
			"head_rot": Vector3(-6.0, 18.0, 0.0)
		},
		"low_drag": {
			"right_arm_rot": Vector3(32.0, -15.0, 20.0),
			"right_forearm_rot": Vector3(-15.0, 0.0, 0.0),
			"sword_rot": Vector3(115.0, -25.0, -10.0),
			"left_arm_rot": Vector3(-10.0, 10.0, -28.0),
			"left_forearm_rot": Vector3(-45.0, 0.0, 0.0),
			"shield_rot": Vector3(48.0, -10.0, 0.0),
			"torso_rot": Vector3(14.0, -8.0, 0.0),
			"head_rot": Vector3(-2.0, 8.0, 0.0)
		}
	}

func _init_weapon_trail() -> void:
	weapon_trail = WeaponTrailScript.new()
	weapon_trail.name = "SkeletonWeaponTrail"
	sword.add_child(weapon_trail)
	# Configure trail for notched iron sword
	weapon_trail.color_tip = Color(0.9, 0.95, 1.0, 0.85) # Pale ghostly steel
	weapon_trail.color_base = Color(0.45, 0.5, 0.55, 0.6) # Dark oxidized iron
	weapon_trail.tip_offset = Vector3(0.0, 0.72, 0.0) # Sword length
	weapon_trail.base_offset = Vector3(0.0, 0.05, 0.0)

func _init_stun_stars() -> void:
	stun_stars = StunStarsScript.new()
	stun_stars.name = "StunStarsFX"
	head.add_child(stun_stars)

func play_anim(anim_name: String) -> void:
	if current_anim == anim_name and current_anim not in ["slash", "thrust", "block", "hurt"]:
		return
	source_pose = current_pose.duplicate(true)
	is_blending = true
	blend_timer = 0.0
	current_anim = anim_name
	
	if current_anim in ["slash", "thrust", "block", "hurt"]:
		action_time = 0.0
	else:
		base_anim = anim_name
		anim_time = 0.0
		
	if stun_stars:
		stun_stars.visible = (current_anim == "stunned")
	anim_changed.emit(current_anim)

func set_stance(stance_name: String) -> void:
	current_stance = stance_name
	source_pose = current_pose.duplicate(true)
	is_blending = true
	blend_timer = 0.0

func set_speed(val: float) -> void:
	anim_speed = clamp(val, 0.1, 3.0)

func get_stance_definitions() -> Array:
	return [
		{"id": "ready", "name": "Thủ Thế", "shortcut": "[ Q ]"},
		{"id": "high_guard", "name": "Thủ Khiên", "shortcut": "[ W ]"},
		{"id": "low_drag", "name": "Kéo Kiếm", "shortcut": "[ E ]"}
	]

func get_weapon_info() -> Dictionary:
	return {
		"title": "🗡 KIẾM SỨT MẺ (VỊ TRÍ & GÓC)",
		"prop": "sword_rot"
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
		var f_read = FileAccess.open(path, FileAccess.READ)
		if f_read:
			var txt = f_read.get_as_text()
			f_read.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				all_cfg = json.data
	all_cfg["skeleton"] = serialize_stances()
	var f_write = FileAccess.open(path, FileAccess.WRITE)
	if f_write:
		f_write.store_string(JSON.stringify(all_cfg, "\t"))
		f_write.close()
		return true
	return false

func load_stance_config() -> void:
	var path = "res://data/stance_config.json"
	if FileAccess.file_exists(path):
		var f = FileAccess.open(path, FileAccess.READ)
		if f:
			var txt = f.get_as_text()
			f.close()
			var json = JSON.new()
			if json.parse(txt) == OK and json.data is Dictionary:
				var d: Dictionary = json.data
				if d.has("skeleton") and d["skeleton"] is Dictionary:
					var sk_cfg = d["skeleton"]
					if sk_cfg.has("ground_hips_y"):
						ground_hips_y = float(sk_cfg["ground_hips_y"])
					for s_key in sk_cfg:
						if s_key == "ground_hips_y": continue
						if sk_cfg[s_key] is Dictionary:
							stance_configs[s_key] = _deserialize_stance(sk_cfg[s_key])

func _serialize_stance(s: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for k in s:
		if s[k] is Vector3:
			out[k] = [snapped(s[k].x, 0.1), snapped(s[k].y, 0.1), snapped(s[k].z, 0.1)]
	return out

func _deserialize_stance(d: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for k in d:
		if d[k] is Array and d[k].size() == 3:
			out[k] = Vector3(float(d[k][0]), float(d[k][1]), float(d[k][2]))
	return out

func set_live_bone_transform(s_name: String, prop: String, val: Vector3) -> void:
	if not stance_configs.has(s_name):
		stance_configs[s_name] = {}
	stance_configs[s_name][prop] = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func set_live_ground_hips_y(val: float) -> void:
	ground_hips_y = val
	current_pose = _compute_pose(current_anim, anim_time)
	_apply_pose(current_pose)

func _process(delta: float) -> void:
	delta *= anim_speed
	anim_time += delta
	
	if current_anim in ["slash", "thrust", "block", "hurt"]:
		action_time += delta
		var max_dur = SLASH_DURATION
		if current_anim == "thrust": max_dur = THRUST_DURATION
		elif current_anim == "block": max_dur = BLOCK_DURATION
		elif current_anim == "hurt": max_dur = HURT_DURATION
		
		# Manage weapon trail during attack swings
		if weapon_trail:
			if current_anim == "slash":
				weapon_trail.is_emitting = (action_time >= 0.25 and action_time <= 0.75)
			elif current_anim == "thrust":
				weapon_trail.is_emitting = (action_time >= 0.30 and action_time <= 0.80)
			else:
				weapon_trail.is_emitting = false
				
		if action_time >= max_dur:
			play_anim(base_anim)
			return

	var target_pose = _compute_pose(current_anim, anim_time if current_anim in ["idle", "walk", "run", "stunned"] else action_time)
	
	if is_blending:
		blend_timer += delta
		var f = clamp(blend_timer / BLEND_DURATION, 0.0, 1.0)
		var s = smoothstep(0.0, 1.0, f)
		current_pose = _blend_poses(source_pose, target_pose, s)
		if f >= 1.0:
			is_blending = false
	else:
		current_pose = target_pose
		
	_apply_pose(current_pose)

func _compute_pose(anim_name: String, time_val: float) -> Dictionary:
	match anim_name:
		"idle": return _compute_idle(time_val)
		"walk": return _compute_walk(time_val)
		"run": return _compute_run(time_val)
		"slash": return _compute_slash(time_val)
		"thrust": return _compute_thrust(time_val)
		"block": return _compute_block(time_val)
		"hurt": return _compute_hurt(time_val)
		"stunned": return _compute_stunned(time_val)
	return _compute_idle(time_val)

# --- ANIMATION DEFINITIONS ---

# 1. IDLE: Eerie Unholy Bone-Rattling Sway
func _compute_idle(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.2
	var cfg = default_stance_configs.get("ready", {})
	if default_stance_configs.has(current_stance):
		cfg = default_stance_configs[current_stance]
	if stance_configs.has(current_stance):
		cfg = stance_configs[current_stance]
	
	var base_r_arm = cfg.get("right_arm_rot", Vector3(15.0, 10.0, 24.0))
	var base_r_fore = cfg.get("right_forearm_rot", Vector3(-35.0, 0.0, 0.0))
	var base_sword = cfg.get("sword_rot", Vector3(68.0, -8.0, -28.0))
	var base_l_arm = cfg.get("left_arm_rot", Vector3(-20.0, 15.0, -26.0))
	var base_l_fore = cfg.get("left_forearm_rot", Vector3(-65.0, 0.0, 0.0))
	var base_shield = cfg.get("shield_rot", Vector3(68.0, -15.0, 5.0))
	var base_torso = cfg.get("torso_rot", Vector3(8.0, -12.0, 0.0))
	var base_head = cfg.get("head_rot", Vector3(-4.0, 12.0, 0.0))
	
	# Hips subtle rattling vibration & breathing bob
	var rattle = sin(time_val * 14.0) * 0.003
	p["hips_pos"] = Vector3(0.0, ground_hips_y + sin(t) * 0.012 + rattle, 0.0)
	p["hips_rot"] = Vector3(sin(t) * 2.0, cos(t * 0.5) * 3.0, sin(t * 0.7) * 2.0)
	
	p["torso_rot"] = base_torso + Vector3(sin(t) * 3.0, cos(t * 0.7) * 4.0, 0.0)
	p["head_rot"] = base_head + Vector3(-sin(t) * 2.5 + sin(time_val * 18.0) * 0.8, -cos(t * 0.7) * 4.0, 0.0)
	
	p["right_arm_rot"] = base_r_arm + Vector3(cos(t) * 3.5, 0.0, sin(t) * 2.5)
	p["right_forearm_rot"] = base_r_fore + Vector3(sin(t) * 3.0, 0.0, 0.0)
	p["sword_rot"] = base_sword + Vector3(sin(t) * 2.0, 0.0, 0.0)
	
	p["left_arm_rot"] = base_l_arm + Vector3(-cos(t) * 3.0, 0.0, -sin(t) * 2.0)
	p["left_forearm_rot"] = base_l_fore + Vector3(-sin(t) * 2.5, 0.0, 0.0)
	p["shield_rot"] = base_shield + Vector3(cos(t) * 2.0, 0.0, 0.0)
	
	# Slight knee flex for unholy stance
	p["left_thigh_rot"] = Vector3(-6.0 + sin(t) * 1.5, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(10.0 - sin(t) * 1.5, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(6.0 - sin(t) * 1.5, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(8.0 + sin(t) * 1.5, 0.0, 0.0)
	return p

# 2. WALK: Menacing Undead Stride
func _compute_walk(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 3.6
	var s = sin(t)
	var c = cos(t)
	
	p["hips_pos"] = Vector3(c * 0.02, ground_hips_y + abs(s) * 0.022, 0.0)
	p["hips_rot"] = Vector3(8.0, -s * 6.0, c * 3.0)
	p["torso_rot"] = Vector3(10.0 + abs(s) * 2.0, s * 8.0, -c * 3.0)
	p["head_rot"] = Vector3(-6.0, -s * 6.0, 0.0)
	
	# Legs alternate in crisp skeletal gait
	p["left_thigh_rot"] = Vector3(s * 28.0, 0.0, -4.0)
	p["left_shin_rot"] = Vector3(clamp(-s * 32.0, 0.0, 45.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(-s * 28.0, 0.0, 4.0)
	p["right_shin_rot"] = Vector3(clamp(s * 32.0, 0.0, 45.0), 0.0, 0.0)
	
	# Shield held steady facing front, sword arm swings rhythmically
	p["right_arm_rot"] = Vector3(12.0 - s * 22.0, 8.0, 22.0)
	p["right_forearm_rot"] = Vector3(-40.0 - s * 10.0, 0.0, 0.0)
	p["sword_rot"] = Vector3(45.0 - s * 8.0, -10.0, -15.0)
	
	p["left_arm_rot"] = Vector3(-24.0 + s * 12.0, 15.0, -22.0)
	p["left_forearm_rot"] = Vector3(-70.0, 0.0, 0.0)
	p["shield_rot"] = Vector3(72.0, -15.0 + s * 6.0, 5.0)
	return p

# 3. RUN: Hunched Aggressive Undead Charge
func _compute_run(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 6.8
	var s = sin(t)
	var c = cos(t)
	
	p["hips_pos"] = Vector3(c * 0.03, ground_hips_y - 0.02 + abs(s) * 0.045, 0.0)
	p["hips_rot"] = Vector3(18.0, -s * 8.0, c * 4.0)
	p["torso_rot"] = Vector3(22.0, s * 12.0, -c * 4.0)
	p["head_rot"] = Vector3(-16.0, -s * 8.0, 0.0)
	
	# High-pumping skeletal legs
	p["left_thigh_rot"] = Vector3(s * 48.0, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(clamp(-s * 55.0, 0.0, 75.0), 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(-s * 48.0, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(clamp(s * 55.0, 0.0, 75.0), 0.0, 0.0)
	
	# Shield pushed forward as a ram, sword trailed back for heavy strike
	p["left_arm_rot"] = Vector3(-45.0 + s * 10.0, 20.0, -18.0)
	p["left_forearm_rot"] = Vector3(-85.0, 0.0, 0.0)
	p["shield_rot"] = Vector3(85.0, -25.0, 10.0)
	
	p["right_arm_rot"] = Vector3(28.0 - s * 32.0, 15.0, 28.0)
	p["right_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
	p["sword_rot"] = Vector3(80.0, -20.0, -15.0)
	return p

# 4. SLASH: Vicious Horizontal Sweeping Cleave
func _compute_slash(t: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = t / SLASH_DURATION
	
	if tau < 0.32:
		# PHASE 1: Windup & Torso Coiling (0.0s - 0.37s)
		var prog = tau / 0.32
		var s = smoothstep(0.0, 1.0, prog)
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03 * s, 0.0)
		p["hips_rot"] = Vector3(8.0, lerp(0.0, -32.0, s), 0.0)
		p["torso_rot"] = Vector3(12.0, lerp(0.0, -45.0, s), 0.0)
		p["head_rot"] = Vector3(-4.0, lerp(0.0, 35.0, s), 0.0)
		
		# Sword arm cocks high and far behind right shoulder
		p["right_arm_rot"] = Vector3(lerp(15.0, -55.0, s), lerp(10.0, 48.0, s), lerp(24.0, 65.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -95.0, s), 0.0, 0.0)
		p["sword_rot"] = Vector3(lerp(68.0, 42.0, s), lerp(-8.0, 28.0, s), -28.0)
		
		# Shield braced at chest
		p["left_arm_rot"] = Vector3(-15.0, 25.0, -22.0)
		p["left_forearm_rot"] = Vector3(-75.0, 0.0, 0.0)
		p["shield_rot"] = Vector3(75.0, -20.0, 5.0)
		
		p["left_thigh_rot"] = Vector3(-12.0 * s, 0.0, -6.0)
		p["left_shin_rot"] = Vector3(18.0 * s, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(8.0 * s, 0.0, 6.0)
		p["right_shin_rot"] = Vector3(12.0 * s, 0.0, 0.0)
		
	elif tau < 0.62:
		# PHASE 2: Explosive Sweeping Horizontal Slash (0.37s - 0.71s)
		var prog = (tau - 0.32) / 0.30
		var s = 1.0 - pow(1.0 - prog, 3.0) # Explosive ease-out
		
		p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02, lerp(0.0, 0.08, s))
		p["hips_rot"] = Vector3(10.0, lerp(-32.0, 28.0, s), 0.0)
		p["torso_rot"] = Vector3(14.0, lerp(-45.0, 52.0, s), 0.0)
		p["head_rot"] = Vector3(-6.0, lerp(35.0, -35.0, s), 0.0)
		
		# Sword slices in wide horizontal arc across the front
		p["right_arm_rot"] = Vector3(lerp(-55.0, 10.0, s), lerp(48.0, -65.0, s), lerp(65.0, 20.0, s))
		p["right_forearm_rot"] = Vector3(lerp(-95.0, -25.0, s), 0.0, 0.0)
		p["sword_rot"] = Vector3(lerp(42.0, 92.0, s), lerp(28.0, -65.0, s), lerp(-28.0, 0.0, s))
		
		# Shield balances recoil on left flank
		p["left_arm_rot"] = Vector3(lerp(-15.0, 25.0, s), lerp(25.0, -15.0, s), -28.0)
		p["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
		p["shield_rot"] = Vector3(65.0, -10.0, 0.0)
		
		p["left_thigh_rot"] = Vector3(lerp(-12.0, 18.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(18.0, 14.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(8.0, -16.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(12.0, 22.0, s), 0.0, 0.0)
		
	else:
		# PHASE 3: Recovery to Stance (0.71s - 1.15s)
		var prog = (tau - 0.62) / 0.38
		var s = smoothstep(0.0, 1.0, prog)
		var idle_p = _compute_idle(0.0)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.02, ground_hips_y, s), lerp(0.08, 0.0, s))
		p["hips_rot"] = Vector3(lerp(10.0, 0.0, s), lerp(28.0, 0.0, s), 0.0)
		p["torso_rot"] = _lerp_angles(Vector3(14.0, 52.0, 0.0), idle_p["torso_rot"], s)
		p["head_rot"] = _lerp_angles(Vector3(-6.0, -35.0, 0.0), idle_p["head_rot"], s)
		
		p["right_arm_rot"] = _lerp_angles(Vector3(10.0, -65.0, 20.0), idle_p["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-25.0, 0.0, 0.0), idle_p["right_forearm_rot"], s)
		p["sword_rot"] = _lerp_angles(Vector3(92.0, -65.0, 0.0), idle_p["sword_rot"], s)
		
		p["left_arm_rot"] = _lerp_angles(Vector3(25.0, -15.0, -28.0), idle_p["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-55.0, 0.0, 0.0), idle_p["left_forearm_rot"], s)
		p["shield_rot"] = _lerp_angles(Vector3(65.0, -10.0, 0.0), idle_p["shield_rot"], s)
		
		p["left_thigh_rot"] = _lerp_angles(Vector3(18.0, 0.0, -6.0), idle_p["left_thigh_rot"], s)
		p["left_shin_rot"] = _lerp_angles(Vector3(14.0, 0.0, 0.0), idle_p["left_shin_rot"], s)
		p["right_thigh_rot"] = _lerp_angles(Vector3(-16.0, 0.0, 6.0), idle_p["right_thigh_rot"], s)
		p["right_shin_rot"] = _lerp_angles(Vector3(22.0, 0.0, 0.0), idle_p["right_shin_rot"], s)
		
	return p

# 5. THRUST / OVERHEAD CHOP: Powerful Downward Plunge
func _compute_thrust(t: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = t / THRUST_DURATION
	
	if tau < 0.35:
		# Raise sword overhead with both arms raised
		var prog = tau / 0.35
		var s = smoothstep(0.0, 1.0, prog)
		p["hips_pos"] = Vector3(0.0, ground_hips_y + 0.03 * s, 0.0)
		p["hips_rot"] = Vector3(-8.0 * s, 0.0, 0.0)
		p["torso_rot"] = Vector3(-18.0 * s, 0.0, 0.0)
		p["head_rot"] = Vector3(12.0 * s, 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(15.0, -105.0, s), 15.0, 32.0)
		p["right_forearm_rot"] = Vector3(lerp(-35.0, -75.0, s), 0.0, 0.0)
		p["sword_rot"] = Vector3(lerp(45.0, -35.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-20.0, -55.0, s), 15.0, -26.0)
		p["left_forearm_rot"] = Vector3(lerp(-65.0, -85.0, s), 0.0, 0.0)
		p["shield_rot"] = Vector3(lerp(68.0, 88.0, s), -15.0, 5.0)
		
		p["left_thigh_rot"] = Vector3(8.0 * s, 0.0, -4.0)
		p["left_shin_rot"] = Vector3(6.0 * s, 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(-12.0 * s, 0.0, 4.0)
		p["right_shin_rot"] = Vector3(14.0 * s, 0.0, 0.0)
		
	elif tau < 0.65:
		# Heavy Downward Chop / Impale with full body drop
		var prog = (tau - 0.35) / 0.30
		var s = 1.0 - pow(1.0 - prog, 3.5)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y + 0.03, ground_hips_y - 0.05, s), lerp(0.0, 0.12, s))
		p["hips_rot"] = Vector3(lerp(-8.0, 22.0, s), 0.0, 0.0)
		p["torso_rot"] = Vector3(lerp(-18.0, 38.0, s), 0.0, 0.0)
		p["head_rot"] = Vector3(lerp(12.0, -18.0, s), 0.0, 0.0)
		
		p["right_arm_rot"] = Vector3(lerp(-105.0, 42.0, s), 8.0, 18.0)
		p["right_forearm_rot"] = Vector3(lerp(-75.0, -15.0, s), 0.0, 0.0)
		p["sword_rot"] = Vector3(lerp(-35.0, 95.0, s), 0.0, 0.0)
		
		p["left_arm_rot"] = Vector3(lerp(-55.0, -15.0, s), 20.0, -22.0)
		p["left_forearm_rot"] = Vector3(lerp(-85.0, -65.0, s), 0.0, 0.0)
		p["shield_rot"] = Vector3(lerp(88.0, 68.0, s), -15.0, 5.0)
		
		p["left_thigh_rot"] = Vector3(lerp(8.0, -22.0, s), 0.0, -6.0)
		p["left_shin_rot"] = Vector3(lerp(6.0, 32.0, s), 0.0, 0.0)
		p["right_thigh_rot"] = Vector3(lerp(-12.0, 18.0, s), 0.0, 6.0)
		p["right_shin_rot"] = Vector3(lerp(14.0, 26.0, s), 0.0, 0.0)
		
	else:
		# Recovery
		var prog = (tau - 0.65) / 0.35
		var s = smoothstep(0.0, 1.0, prog)
		var idle_p = _compute_idle(0.0)
		
		p["hips_pos"] = Vector3(0.0, lerp(ground_hips_y - 0.05, ground_hips_y, s), lerp(0.12, 0.0, s))
		p["hips_rot"] = Vector3(lerp(22.0, 0.0, s), 0.0, 0.0)
		p["torso_rot"] = _lerp_angles(Vector3(38.0, 0.0, 0.0), idle_p["torso_rot"], s)
		p["head_rot"] = _lerp_angles(Vector3(-18.0, 0.0, 0.0), idle_p["head_rot"], s)
		p["right_arm_rot"] = _lerp_angles(Vector3(42.0, 8.0, 18.0), idle_p["right_arm_rot"], s)
		p["right_forearm_rot"] = _lerp_angles(Vector3(-15.0, 0.0, 0.0), idle_p["right_forearm_rot"], s)
		p["sword_rot"] = _lerp_angles(Vector3(95.0, 0.0, 0.0), idle_p["sword_rot"], s)
		p["left_arm_rot"] = _lerp_angles(Vector3(-15.0, 20.0, -22.0), idle_p["left_arm_rot"], s)
		p["left_forearm_rot"] = _lerp_angles(Vector3(-65.0, 0.0, 0.0), idle_p["left_forearm_rot"], s)
		p["shield_rot"] = _lerp_angles(Vector3(68.0, -15.0, 5.0), idle_p["shield_rot"], s)
		p["left_thigh_rot"] = _lerp_angles(Vector3(-22.0, 0.0, -6.0), idle_p["left_thigh_rot"], s)
		p["left_shin_rot"] = _lerp_angles(Vector3(32.0, 0.0, 0.0), idle_p["left_shin_rot"], s)
		p["right_thigh_rot"] = _lerp_angles(Vector3(18.0, 0.0, 6.0), idle_p["right_thigh_rot"], s)
		p["right_shin_rot"] = _lerp_angles(Vector3(26.0, 0.0, 0.0), idle_p["right_shin_rot"], s)
		
	return p

# 6. BLOCK: Splintered Wooden Shield Parry & Brace
func _compute_block(t: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = t / BLOCK_DURATION
	
	var block_weight = 1.0
	if tau < 0.2:
		block_weight = smoothstep(0.0, 1.0, tau / 0.2)
	elif tau > 0.75:
		block_weight = 1.0 - smoothstep(0.0, 1.0, (tau - 0.75) / 0.25)
		
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03 * block_weight, -0.04 * block_weight)
	p["hips_rot"] = Vector3(8.0 * block_weight, -18.0 * block_weight, 0.0)
	p["torso_rot"] = Vector3(14.0 * block_weight, -24.0 * block_weight, 0.0)
	p["head_rot"] = Vector3(-6.0 * block_weight, 24.0 * block_weight, 0.0)
	
	# Shield locked directly in front of head/sternum!
	p["left_arm_rot"] = Vector3(lerp(-20.0, -42.0, block_weight), lerp(15.0, 32.0, block_weight), lerp(-26.0, -15.0, block_weight))
	p["left_forearm_rot"] = Vector3(lerp(-65.0, -95.0, block_weight), 0.0, 0.0)
	p["shield_rot"] = Vector3(lerp(68.0, 92.0, block_weight), lerp(-15.0, -35.0, block_weight), lerp(5.0, 15.0, block_weight))
	
	# Sword arm held close in high guard ready to counter
	p["right_arm_rot"] = Vector3(lerp(15.0, -35.0, block_weight), 15.0, 28.0)
	p["right_forearm_rot"] = Vector3(lerp(-35.0, -75.0, block_weight), 0.0, 0.0)
	p["sword_rot"] = Vector3(lerp(68.0, 55.0, block_weight), -8.0, -28.0)
	
	p["left_thigh_rot"] = Vector3(-14.0 * block_weight, 0.0, -6.0)
	p["left_shin_rot"] = Vector3(22.0 * block_weight, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(12.0 * block_weight, 0.0, 6.0)
	p["right_shin_rot"] = Vector3(18.0 * block_weight, 0.0, 0.0)
	return p

# 7. HURT: Bone Impact Recoil & Spine Wrench
func _compute_hurt(t: float) -> Dictionary:
	var p: Dictionary = {}
	var tau = t / HURT_DURATION
	var snap = 1.0 - pow(1.0 - clamp(tau / 0.35, 0.0, 1.0), 3.0)
	var recovery = smoothstep(0.0, 1.0, clamp((tau - 0.35) / 0.65, 0.0, 1.0))
	var weight = snap * (1.0 - recovery)
	
	p["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03 * weight, -0.08 * weight)
	p["hips_rot"] = Vector3(-12.0 * weight, 8.0 * weight, 0.0)
	p["torso_rot"] = Vector3(-24.0 * weight, -16.0 * weight, 0.0)
	p["head_rot"] = Vector3(22.0 * weight, 18.0 * weight, -8.0 * weight)
	
	p["right_arm_rot"] = Vector3(lerp(15.0, 35.0, weight), 10.0, 42.0 * weight)
	p["right_forearm_rot"] = Vector3(-45.0, 0.0, 0.0)
	p["sword_rot"] = Vector3(65.0, -20.0, -25.0)
	
	p["left_arm_rot"] = Vector3(lerp(-20.0, 10.0, weight), 15.0, -45.0 * weight)
	p["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
	p["shield_rot"] = Vector3(0.0, 15.0, -15.0)
	
	p["left_thigh_rot"] = Vector3(-18.0 * weight, 0.0, -8.0)
	p["left_shin_rot"] = Vector3(28.0 * weight, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(12.0 * weight, 0.0, 8.0)
	p["right_shin_rot"] = Vector3(16.0 * weight, 0.0, 0.0)
	return p

# 8. STUNNED: Dazed Skeletal Sway & Buckling Knees
func _compute_stunned(time_val: float) -> Dictionary:
	var p: Dictionary = {}
	var t = time_val * 2.8
	
	p["hips_pos"] = Vector3(sin(t) * 0.025, ground_hips_y - 0.035 + cos(t * 2.0) * 0.008, cos(t) * 0.02)
	p["hips_rot"] = Vector3(cos(t) * 4.0, sin(t) * 8.0, sin(t) * 5.0)
	p["torso_rot"] = Vector3(14.0 + sin(t) * 8.0, -cos(t) * 12.0, -sin(t) * 6.0)
	p["head_rot"] = Vector3(-6.0 + cos(t * 1.3) * 14.0, sin(t) * 16.0, -cos(t * 0.7) * 15.0)
	
	# Buckling skeletal knees
	p["left_thigh_rot"] = Vector3(-12.0 + sin(t) * 6.0, 0.0, -6.0 + cos(t) * 3.0)
	p["left_shin_rot"] = Vector3(18.0 + cos(t) * 7.0, 0.0, 0.0)
	p["right_thigh_rot"] = Vector3(8.0 - sin(t) * 6.0, 0.0, 6.0 - cos(t) * 3.0)
	p["right_shin_rot"] = Vector3(14.0 - cos(t) * 7.0, 0.0, 0.0)
	
	# Loose hanging arms, zero body clipping
	p["right_arm_rot"] = Vector3(8.0 + sin(t) * 6.0, 10.0, 24.0 + cos(t) * 4.0)
	p["right_forearm_rot"] = Vector3(-25.0, 0.0, 0.0)
	p["sword_rot"] = Vector3(85.0 + sin(t) * 5.0, -10.0, -10.0)
	
	p["left_arm_rot"] = Vector3(-8.0 - sin(t) * 6.0, -10.0, -26.0 - cos(t) * 4.0)
	p["left_forearm_rot"] = Vector3(-45.0, 0.0, 0.0)
	p["shield_rot"] = Vector3(5.0 + cos(t) * 4.0, 0.0, 0.0)
	return p

func _blend_poses(a: Dictionary, b: Dictionary, f: float) -> Dictionary:
	var out: Dictionary = {}
	var all_keys = a.keys()
	for k in b.keys():
		if not all_keys.has(k): all_keys.append(k)
	for k in all_keys:
		var va = a.get(k, b.get(k))
		var vb = b.get(k, a.get(k))
		if va is Vector3 and vb is Vector3:
			if k.ends_with("_pos"):
				out[k] = va.lerp(vb, f)
			else:
				out[k] = _lerp_angles(va, vb, f)
		else:
			out[k] = vb
	return out

func _lerp_angles(a: Vector3, b: Vector3, weight: float) -> Vector3:
	return Vector3(
		rad_to_deg(lerp_angle(deg_to_rad(a.x), deg_to_rad(b.x), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.y), deg_to_rad(b.y), weight)),
		rad_to_deg(lerp_angle(deg_to_rad(a.z), deg_to_rad(b.z), weight))
	)

func _apply_pose(p: Dictionary) -> void:
	if not is_inside_tree() or not hips:
		return
	if p.has("hips_pos"): hips.position = p["hips_pos"]
	if p.has("hips_rot"): hips.rotation_degrees = p["hips_rot"]
	if p.has("torso_rot"): torso.rotation_degrees = p["torso_rot"]
	if p.has("head_rot"): head.rotation_degrees = p["head_rot"]
	
	if p.has("left_arm_rot"): left_arm.rotation_degrees = p["left_arm_rot"]
	if p.has("left_forearm_rot"): left_forearm.rotation_degrees = p["left_forearm_rot"]
	if p.has("shield_rot"): shield.rotation_degrees = p["shield_rot"]
	
	if p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
	if p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
	if p.has("sword_rot"): sword.rotation_degrees = p["sword_rot"]
	
	if p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
	if p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
	if p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
	if p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
