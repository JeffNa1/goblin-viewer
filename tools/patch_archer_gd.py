import os

PROJECT_DIR = r"C:\Users\Administrator\.gemini\antigravity\scratch\goblin_viewer"
archer_gd_path = os.path.join(PROJECT_DIR, "scripts", "goblin_archer.gd")

new_archer_code = """class_name GoblinArcher
extends Node3D

@onready var hips: Node3D = $VisualRoot/Hips
@onready var torso: Node3D = $VisualRoot/Hips/Torso
@onready var head: Node3D = $VisualRoot/Hips/Torso/Head
@onready var left_arm: Node3D = $VisualRoot/Hips/Torso/LeftArm
@onready var left_forearm: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm
@onready var bow: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow
@onready var arrow: Node3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/Arrow
@onready var quiver: Node3D = $VisualRoot/Hips/Torso/Quiver
@onready var right_arm: Node3D = $VisualRoot/Hips/Torso/RightArm
@onready var right_forearm: Node3D = $VisualRoot/Hips/Torso/RightArm/RightForearm
@onready var left_thigh: Node3D = $VisualRoot/Hips/LeftThigh
@onready var left_shin: Node3D = $VisualRoot/Hips/LeftThigh/LeftShin
@onready var right_thigh: Node3D = $VisualRoot/Hips/RightThigh
@onready var right_shin: Node3D = $VisualRoot/Hips/RightThigh/RightShin

@onready var torso_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/TorsoMesh
@onready var quiver_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Quiver/QuiverMesh
@onready var head_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/Head/HeadMesh
@onready var left_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftArmMesh
@onready var left_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/LeftForearmMesh
@onready var bow_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/BowMesh
@onready var arrow_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/LeftArm/LeftForearm/Bow/Arrow/ArrowMesh
@onready var right_arm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightArmMesh
@onready var right_forearm_mesh: MeshInstance3D = $VisualRoot/Hips/Torso/RightArm/RightForearm/RightForearmMesh
@onready var left_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftThighMesh
@onready var left_shin_mesh: MeshInstance3D = $VisualRoot/Hips/LeftThigh/LeftShin/LeftShinMesh
@onready var right_thigh_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightThighMesh
@onready var right_shin_mesh: MeshInstance3D = $VisualRoot/Hips/RightThigh/RightShin/RightShinMesh

# Meshes
var bow_rest_mesh: ArrayMesh = null
var bow_drawn_mesh: ArrayMesh = null

# State
var current_anim: String = "idle"
var base_anim: String = "idle"
var anim_time: float = 0.0
var anim_speed: float = 1.0

# Action Timers
var action_time: float = 0.0
const SHOOT_DURATION: float = 0.95
const BACKSTEP_DURATION: float = 0.80
const HURT_DURATION: float = 0.50

# Blending
var is_blending: bool = false
var blend_timer: float = 0.0
const BLEND_DURATION: float = 0.18
var source_pose: Dictionary = {}
var current_pose: Dictionary = {}

const ground_hips_y: float = 0.618

# Stun Stars
const StunStarsScript = preload("res://scripts/stun_stars.gd")
var stun_stars: Node3D = null

# Arrow Projectile
var flying_arrow: Node3D = null
var arrow_velocity: Vector3 = Vector3.ZERO
var arrow_timer: float = 0.0

signal anim_changed(anim_name: String)

func _ready() -> void:
\tgenerate_voxel_meshes()
\t_init_stun_stars()
\t_init_flying_arrow()
\tcurrent_pose = _compute_pose("idle", 0.0)
\t_apply_pose(current_pose)

func generate_voxel_meshes() -> void:
\thead_mesh.mesh = VoxelBuilder.build_archer_head_mesh()
\ttorso_mesh.mesh = VoxelBuilder.build_torso_mesh()
\tquiver_mesh.mesh = VoxelBuilder.build_quiver_mesh()
\t
\tbow_rest_mesh = VoxelBuilder.build_bow_mesh(false)
\tbow_drawn_mesh = VoxelBuilder.build_bow_mesh(true)
\tbow_mesh.mesh = bow_rest_mesh
\t
\tarrow_mesh.mesh = VoxelBuilder.build_arrow_mesh()
\tarrow.visible = false # Hidden in quiver by default
\t
\tleft_arm_mesh.mesh = VoxelBuilder.build_upper_arm_mesh()
\tleft_forearm_mesh.mesh = VoxelBuilder.build_forearm_mesh(false)
\tright_arm_mesh.mesh = VoxelBuilder.build_upper_arm_mesh()
\tright_forearm_mesh.mesh = VoxelBuilder.build_forearm_mesh(false)
\tleft_thigh_mesh.mesh = VoxelBuilder.build_thigh_mesh()
\tleft_shin_mesh.mesh = VoxelBuilder.build_shin_mesh()
\tright_thigh_mesh.mesh = VoxelBuilder.build_thigh_mesh()
\tright_shin_mesh.mesh = VoxelBuilder.build_shin_mesh()

func _init_stun_stars() -> void:
\tstun_stars = StunStarsScript.new()
\tstun_stars.name = "StunStarsFX"
\thead.add_child(stun_stars)

func _init_flying_arrow() -> void:
\tflying_arrow = MeshInstance3D.new()
\tflying_arrow.mesh = VoxelBuilder.build_arrow_mesh()
\tflying_arrow.visible = false
\tadd_child(flying_arrow)

func play_anim(anim_name: String) -> void:
\tif current_anim == anim_name and current_anim not in ["shoot", "backstep", "hurt"]:
\t\treturn
\t_start_blend()
\tcurrent_anim = anim_name
\taction_time = 0.0
\t
\tif current_anim in ["idle", "walk", "run", "aim", "stunned"]:
\t\tbase_anim = current_anim
\t\t
\tif stun_stars:
\t\tstun_stars.set_active(current_anim == "stunned")
\t\t
\tif current_anim != "shoot" and flying_arrow:
\t\tflying_arrow.visible = false
\t\t
\temit_signal("anim_changed", current_anim)

func set_speed(val: float) -> void:
\tanim_speed = clampf(val, 0.2, 3.0)

func _start_blend() -> void:
\tsource_pose = current_pose.duplicate(true)
\tblend_timer = 0.0
\tis_blending = true

func _process(delta: float) -> void:
\tvar dt = delta * anim_speed
\tanim_time += dt
\t
\tif current_anim == "shoot":
\t\taction_time += dt
\t\t_update_shooting_fx(action_time, dt)
\t\tif action_time >= SHOOT_DURATION:
\t\t\tcurrent_anim = "aim"
\t\t\taction_time = 0.0
\t\t\t_start_blend()
\t\t\temit_signal("anim_changed", current_anim)
\telif current_anim == "backstep":
\t\taction_time += dt
\t\tif action_time >= BACKSTEP_DURATION:
\t\t\tcurrent_anim = base_anim
\t\t\taction_time = 0.0
\t\t\t_start_blend()
\t\t\temit_signal("anim_changed", current_anim)
\telif current_anim == "hurt":
\t\taction_time += dt
\t\tif action_time >= HURT_DURATION:
\t\t\tcurrent_anim = base_anim
\t\t\taction_time = 0.0
\t\t\t_start_blend()
\t\t\temit_signal("anim_changed", current_anim)
\t\t\t
\tif stun_stars:
\t\tstun_stars.set_active(current_anim == "stunned")
\t\t
\tvar target_pose = _compute_pose(current_anim, anim_time)
\t
\tif is_blending:
\t\tblend_timer += dt
\t\tvar factor = clampf(blend_timer / BLEND_DURATION, 0.0, 1.0)
\t\tvar smooth_f = smoothstep(0.0, 1.0, factor)
\t\tcurrent_pose = _blend_poses(source_pose, target_pose, smooth_f)
\t\tif factor >= 1.0:
\t\t\tis_blending = false
\telse:
\t\tcurrent_pose = target_pose
\t\t
\t_apply_pose(current_pose)
\t
\t# Update in-flight arrow
\tif flying_arrow and flying_arrow.visible:
\t\tflying_arrow.position += arrow_velocity * delta
\t\tarrow_timer -= delta
\t\tif arrow_timer <= 0.0:
\t\tflying_arrow.visible = false

func _update_shooting_fx(t_shot: float, _dt: float) -> void:
\tvar tau = t_shot / SHOOT_DURATION
\t# At tau = 0.06, release arrow!
\tif tau >= 0.06 and tau < 0.50:
\t\tif not flying_arrow.visible and arrow_timer <= 0.0:
\t\t\tarrow.visible = false
\t\t\tflying_arrow.visible = true
\t\t\tflying_arrow.global_position = bow.to_global(Vector3(0.03, 0.0, 0.20))
\t\t\tflying_arrow.global_transform.basis = bow.global_transform.basis
\t\t\tarrow_velocity = bow.global_transform.basis.z * 22.0
\t\t\tarrow_timer = 0.75
\telif tau >= 0.70:
\t\t# Re-nock arrow from quiver
\t\tarrow.visible = true

func _compute_pose(anim: String, time_val: float) -> Dictionary:
\tmatch anim:
\t\t"idle": return _compute_idle(time_val)
\t\t"walk": return _compute_walk(time_val)
\t\t"run": return _compute_run(time_val)
\t\t"aim": return _compute_aim(time_val)
\t\t"shoot": return _compute_shoot(action_time)
\t\t"backstep": return _compute_backstep(action_time)
\t\t"hurt": return _compute_hurt(action_time)
\t\t"stunned": return _compute_stunned(time_val)
\t\t_: return _compute_idle(time_val)

# --- 1. IDLE (Bow at Side, Free Right Hand, Scouting) ---
func _compute_idle(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 2.2
\tvar breath = sin(t) * 0.008
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y + breath, 0.0)
\tp["hips_rot"] = Vector3(0.0, sin(t * 0.5) * 4.0, 0.0)
\tp["torso_rot"] = Vector3(sin(t) * 2.0, 0.0, 0.0)
\tp["head_rot"] = Vector3(-2.0, sin(t * 0.7) * 14.0, 0.0)
\t
\t# Left arm holds bow vertically at the hip
\tp["left_arm_rot"] = Vector3(-14.0 + breath * 60.0, 6.0, -18.0)
\tp["left_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(20.0, 0.0, -5.0)
\t
\t# Right arm relaxed at side
\tp["right_arm_rot"] = Vector3(6.0 - breath * 50.0, -4.0, 14.0)
\tp["right_forearm_rot"] = Vector3(-18.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-2.0, 0.0, -2.0)
\tp["left_shin_rot"] = Vector3(4.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(2.0, 0.0, 2.0)
\tp["right_shin_rot"] = Vector3(3.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

# --- 2. WALK (Scout Stride, Bow Swinging Rhythmically) ---
func _compute_walk(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 4.5
\tvar s_leg = sin(t)
\tvar c_leg = cos(t)
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y + abs(sin(t * 2.0)) * 0.02, 0.0)
\tp["hips_rot"] = Vector3(2.0, s_leg * 6.0, 0.0)
\tp["torso_rot"] = Vector3(4.0, -s_leg * 5.0, 0.0)
\tp["head_rot"] = Vector3(-2.0, -s_leg * 3.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-s_leg * 26.0, 0.0, 0.0)
\tp["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 32.0), 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(s_leg * 26.0, 0.0, 0.0)
\tp["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 32.0), 0.0, 0.0)
\t
\tp["left_arm_rot"] = Vector3(-20.0 + c_leg * 8.0, 8.0, -18.0)
\tp["left_forearm_rot"] = Vector3(-40.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(22.0, 0.0, -5.0)
\t
\tp["right_arm_rot"] = Vector3(s_leg * 20.0, 0.0, 12.0)
\tp["right_forearm_rot"] = Vector3(-20.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

# --- 3. RUN (Forward Leaning Skirmish Dash) ---
func _compute_run(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 7.5
\tvar s_leg = sin(t)
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.02 + abs(sin(t * 2.0)) * 0.035, 0.0)
\tp["hips_rot"] = Vector3(14.0, s_leg * 12.0, 0.0)
\tp["torso_rot"] = Vector3(8.0, -s_leg * 10.0, 0.0)
\tp["head_rot"] = Vector3(-12.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-s_leg * 42.0, 0.0, 0.0)
\tp["left_shin_rot"] = Vector3(maxf(0.0, s_leg * 55.0), 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(s_leg * 42.0, 0.0, 0.0)
\tp["right_shin_rot"] = Vector3(maxf(0.0, -s_leg * 55.0), 0.0, 0.0)
\t
\tp["left_arm_rot"] = Vector3(-35.0, 12.0, -15.0)
\tp["left_forearm_rot"] = Vector3(-55.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(30.0, 0.0, 10.0)
\t
\tp["right_arm_rot"] = Vector3(s_leg * 35.0, 0.0, 15.0)
\tp["right_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

# --- 4. AIM (Sideways Tension Stance, Bow Vertical, String Drawn to Cheek) ---
func _compute_aim(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar tremor = sin(time_val * 38.0) * 0.35 # Muscle tremor under draw weight
\t
\t# Body turned sideways to target line
\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
\tp["hips_rot"] = Vector3(0.0, -42.0, 0.0)
\tp["torso_rot"] = Vector3(2.0, -22.0, 0.0) # Total torso yaw = -64 deg
\t
\t# Staggered feet for solid archer foundation
\tp["left_thigh_rot"] = Vector3(-14.0, 0.0, -10.0)
\tp["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(12.0, 0.0, 10.0)
\tp["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
\t
\t# Head turned to sight down arrow (-64 + 46 = -18 deg towards front)
\tp["head_rot"] = Vector3(-3.0, 46.0, 0.0)
\t
\t# Left Arm: Fully extended toward target line
\t# LeftArm hangs down at rest. X = -86 raises it level with chest/eyes.
\t# Y = -18 brings it forward to align with torso yaw.
\tp["left_arm_rot"] = Vector3(-86.0 + tremor, -18.0, 6.0)
\tp["left_forearm_rot"] = Vector3(-6.0, 0.0, 0.0)
\t
\t# Bow: Rotated -90 on X, 180 on Z to stand vertically with string facing rear!
\t# Slightly canted 8 degrees outward for natural tactical bow grip
\tp["bow_rot"] = Vector3(-90.0, 0.0, 172.0)
\t
\t# Right Arm: Drawing bowstring back to right cheek/chin
\t# Right shoulder back, elbow high and in line with arrow
\tp["right_arm_rot"] = Vector3(-68.0 + tremor, 32.0, 64.0)
\tp["right_forearm_rot"] = Vector3(-118.0, 0.0, 0.0)
\t
\tp["is_drawn"] = true
\tp["arrow_visible"] = true
\treturn p

# --- 5. SHOOT (Release Snapping Recoil, Follow-Through, Quiver Draw) ---
func _compute_shoot(t_shot: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar tau = clampf(t_shot / SHOOT_DURATION, 0.0, 1.0)
\t
\tif tau < 0.12:
\t\t# SNAP RELEASE (0.0s - 0.11s)
\t\tvar s = tau / 0.12
\t\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
\t\tp["hips_rot"] = Vector3(0.0, -42.0, 0.0)
\t\tp["torso_rot"] = Vector3(lerp(2.0, 6.0, s), lerp(-22.0, -18.0, s), 0.0)
\t\tp["head_rot"] = Vector3(-3.0, 46.0, 0.0)
\t\t
\t\t# Bow kicks slightly up/back on release
\t\tp["left_arm_rot"] = Vector3(lerp(-86.0, -94.0, s), -18.0, 6.0)
\t\tp["left_forearm_rot"] = Vector3(lerp(-6.0, -14.0, s), 0.0, 0.0)
\t\tp["bow_rot"] = Vector3(lerp(-90.0, -102.0, s), 0.0, 172.0)
\t\t
\t\t# Right hand flings backwards on release recoil
\t\tp["right_arm_rot"] = Vector3(lerp(-68.0, -56.0, s), lerp(32.0, 48.0, s), lerp(64.0, 92.0, s))
\t\tp["right_forearm_rot"] = Vector3(lerp(-118.0, -82.0, s), 0.0, 0.0)
\t\t
\t\tp["left_thigh_rot"] = Vector3(-14.0, 0.0, -10.0)
\t\tp["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
\t\tp["right_thigh_rot"] = Vector3(12.0, 0.0, 10.0)
\t\tp["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
\t\t
\t\tp["is_drawn"] = false
\t\tp["arrow_visible"] = false
\t\t
\telif tau < 0.48:
\t\t# FOLLOW-THROUGH (0.12s - 0.47s): Watching arrow impact
\t\tvar s = smoothstep(0.0, 1.0, (tau - 0.12) / 0.36)
\t\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
\t\tp["hips_rot"] = Vector3(0.0, lerp(-42.0, -30.0, s), 0.0)
\t\tp["torso_rot"] = Vector3(lerp(6.0, 3.0, s), lerp(-18.0, -12.0, s), 0.0)
\t\tp["head_rot"] = Vector3(-3.0, lerp(46.0, 35.0, s), 0.0)
\t\t
\t\tp["left_arm_rot"] = Vector3(lerp(-94.0, -70.0, s), lerp(-18.0, -10.0, s), 6.0)
\t\tp["left_forearm_rot"] = Vector3(lerp(-14.0, -22.0, s), 0.0, 0.0)
\t\tp["bow_rot"] = Vector3(lerp(-102.0, -90.0, s), 0.0, 172.0)
\t\t
\t\t# Right hand begins reaching up towards quiver on back
\t\tp["right_arm_rot"] = Vector3(lerp(-56.0, -30.0, s), lerp(48.0, 25.0, s), lerp(92.0, 55.0, s))
\t\tp["right_forearm_rot"] = Vector3(lerp(-82.0, -100.0, s), 0.0, 0.0)
\t\t
\t\tp["left_thigh_rot"] = Vector3(-14.0, 0.0, -10.0)
\t\tp["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
\t\tp["right_thigh_rot"] = Vector3(12.0, 0.0, 10.0)
\tp["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
\t\t
\t\tp["is_drawn"] = false
\t\tp["arrow_visible"] = false
\t\t
\telse:
\t\t# RELOAD / NOCK (0.48s - 0.95s): Plucks arrow from quiver and settles into aim
\t\tvar s = smoothstep(0.0, 1.0, (tau - 0.48) / 0.47)
\t\tp["hips_pos"] = Vector3(0.0, ground_hips_y - 0.03, 0.0)
\t\tp["hips_rot"] = Vector3(0.0, lerp(-30.0, -42.0, s), 0.0)
\t\tp["torso_rot"] = Vector3(3.0, lerp(-12.0, -22.0, s), 0.0)
\t\tp["head_rot"] = Vector3(-3.0, lerp(35.0, 46.0, s), 0.0)
\t\t
\t\tp["left_arm_rot"] = Vector3(lerp(-70.0, -86.0, s), lerp(-10.0, -18.0, s), 6.0)
\t\tp["left_forearm_rot"] = Vector3(lerp(-22.0, -6.0, s), 0.0, 0.0)
\t\tp["bow_rot"] = Vector3(-90.0, 0.0, 172.0)
\t\t
\t\tp["right_arm_rot"] = Vector3(lerp(-30.0, -68.0, s), lerp(25.0, 32.0, s), lerp(55.0, 64.0, s))
\t\tp["right_forearm_rot"] = Vector3(lerp(-100.0, -118.0, s), 0.0, 0.0)
\t\t
\t\tp["left_thigh_rot"] = Vector3(-14.0, 0.0, -10.0)
\t\tp["left_shin_rot"] = Vector3(20.0, 0.0, 0.0)
\t\tp["right_thigh_rot"] = Vector3(12.0, 0.0, 10.0)
\t\tp["right_shin_rot"] = Vector3(16.0, 0.0, 0.0)
\t\t
\t\tp["is_drawn"] = (s > 0.6)
\t\tp["arrow_visible"] = (s > 0.4)
\t
\treturn p

# --- 6. BACKSTEP (Nimble Evasive Kiting Hop) ---
func _compute_backstep(t_step: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar tau = clampf(t_step / BACKSTEP_DURATION, 0.0, 1.0)
\t
\tvar z_disp = -sin(tau * PI * 0.5) * 0.45
\tvar y_rise = sin(tau * PI) * 0.14
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y + y_rise, z_disp)
\tp["hips_rot"] = Vector3(sin(tau * PI) * 12.0, 0.0, 0.0)
\tp["torso_rot"] = Vector3(sin(tau * PI) * 16.0, 0.0, 0.0)
\tp["head_rot"] = Vector3(-10.0, 0.0, 0.0)
\t
\tif tau < 0.6:
\t\tp["left_thigh_rot"] = Vector3(-35.0, 0.0, -6.0)
\t\tp["left_shin_rot"] = Vector3(45.0, 0.0, 0.0)
\t\tp["right_thigh_rot"] = Vector3(-25.0, 0.0, 6.0)
\t\tp["right_shin_rot"] = Vector3(50.0, 0.0, 0.0)
\telse:
\t\tvar land_s = (tau - 0.6) / 0.4
\t\tp["left_thigh_rot"] = Vector3(lerp(-35.0, -8.0, land_s), 0.0, -4.0)
\t\tp["left_shin_rot"] = Vector3(lerp(45.0, 14.0, land_s), 0.0, 0.0)
\t\tp["right_thigh_rot"] = Vector3(lerp(-25.0, 8.0, land_s), 0.0, 4.0)
\t\tp["right_shin_rot"] = Vector3(lerp(50.0, 16.0, land_s), 0.0, 0.0)
\t\t
\tp["left_arm_rot"] = Vector3(-45.0, 10.0, -22.0)
\tp["left_forearm_rot"] = Vector3(-50.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(15.0, 0.0, 0.0)
\t
\tp["right_arm_rot"] = Vector3(20.0, 0.0, 25.0)
\tp["right_forearm_rot"] = Vector3(-35.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

# --- 7. HURT (Hit-React Flinch) ---
func _compute_hurt(t_hurt: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar tau = clampf(t_hurt / HURT_DURATION, 0.0, 1.0)
\tvar s = sin(tau * PI)
\t
\tp["hips_pos"] = Vector3(0.0, ground_hips_y - s * 0.04, -s * 0.12)
\tp["hips_rot"] = Vector3(-s * 10.0, s * 8.0, 0.0)
\tp["torso_rot"] = Vector3(-s * 22.0, -s * 12.0, 0.0)
\tp["head_rot"] = Vector3(s * 18.0, -s * 15.0, 0.0)
\t
\tp["left_arm_rot"] = Vector3(-s * 30.0, 0.0, -25.0 - s * 15.0)
\tp["left_forearm_rot"] = Vector3(-50.0 - s * 20.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(0.0, 0.0, 0.0)
\t
\tp["right_arm_rot"] = Vector3(s * 20.0, 0.0, 20.0 + s * 20.0)
\tp["right_forearm_rot"] = Vector3(-40.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-s * 15.0, 0.0, -6.0)
\tp["left_shin_rot"] = Vector3(s * 25.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(s * 10.0, 0.0, 6.0)
\tp["right_shin_rot"] = Vector3(s * 20.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

# --- 8. STUNNED (Limp Sway with Orbiting Stars) ---
func _compute_stunned(time_val: float) -> Dictionary:
\tvar p: Dictionary = {}
\tvar t = time_val * 2.8
\t
\tp["hips_pos"] = Vector3(sin(t) * 0.03, ground_hips_y - 0.035, cos(t) * 0.024)
\tp["hips_rot"] = Vector3(cos(t) * 3.0, sin(t) * 8.0, -sin(t) * 4.0)
\tp["torso_rot"] = Vector3(12.0 + sin(t) * 8.0, cos(t) * 14.0, sin(t) * 7.0)
\tp["head_rot"] = Vector3(-8.0 + cos(t * 1.4) * 12.0, -sin(t) * 18.0, cos(t * 0.8) * 15.0)
\t
\tp["left_arm_rot"] = Vector3(15.0 + sin(t) * 8.0, 0.0, -18.0)
\tp["left_forearm_rot"] = Vector3(-15.0, 0.0, 0.0)
\tp["bow_rot"] = Vector3(65.0, 0.0, 0.0)
\t
\tp["right_arm_rot"] = Vector3(12.0 - sin(t) * 8.0, 0.0, 16.0)
\tp["right_forearm_rot"] = Vector3(-12.0, 0.0, 0.0)
\t
\tp["left_thigh_rot"] = Vector3(-14.0 + sin(t) * 5.0, 0.0, -4.0)
\tp["left_shin_rot"] = Vector3(22.0 + cos(t) * 6.0, 0.0, 0.0)
\tp["right_thigh_rot"] = Vector3(10.0 - sin(t) * 5.0, 0.0, 4.0)
\tp["right_shin_rot"] = Vector3(16.0 - cos(t) * 6.0, 0.0, 0.0)
\t
\tp["is_drawn"] = false
\tp["arrow_visible"] = false
\treturn p

func _blend_poses(a: Dictionary, b: Dictionary, f: float) -> Dictionary:
\tvar out: Dictionary = {}
\tfor k in b:
\t\tif a.has(k):
\t\t\tif b[k] is Vector3:
\t\t\t\tout[k] = a[k].lerp(b[k], f)
\t\t\telif b[k] is float:
\t\t\t\tout[k] = lerpf(a[k], b[k], f)
\t\t\telse:
\t\t\t\tout[k] = b[k] if f >= 0.5 else a[k]
\t\telse:
\t\t\tout[k] = b[k]
\treturn out

func _apply_pose(p: Dictionary) -> void:
\tif p.has("hips_pos"): hips.position = p["hips_pos"]
\tif p.has("hips_rot"): hips.rotation_degrees = p["hips_rot"]
\tif p.has("torso_rot"): torso.rotation_degrees = p["torso_rot"]
\tif p.has("head_rot"): head.rotation_degrees = p["head_rot"]
\t
\tif p.has("left_arm_rot"): left_arm.rotation_degrees = p["left_arm_rot"]
\tif p.has("left_forearm_rot"): left_forearm.rotation_degrees = p["left_forearm_rot"]
\tif p.has("bow_rot"): bow.rotation_degrees = p["bow_rot"]
\t
\tif p.has("right_arm_rot"): right_arm.rotation_degrees = p["right_arm_rot"]
\tif p.has("right_forearm_rot"): right_forearm.rotation_degrees = p["right_forearm_rot"]
\t
\tif p.has("left_thigh_rot"): left_thigh.rotation_degrees = p["left_thigh_rot"]
\tif p.has("left_shin_rot"): left_shin.rotation_degrees = p["left_shin_rot"]
\tif p.has("right_thigh_rot"): right_thigh.rotation_degrees = p["right_thigh_rot"]
\tif p.has("right_shin_rot"): right_shin.rotation_degrees = p["right_shin_rot"]
\t
\tif p.has("is_drawn"):
\t\tif p["is_drawn"]:
\t\t\tif bow_mesh.mesh != bow_drawn_mesh: bow_mesh.mesh = bow_drawn_mesh
\t\telse:
\t\t\tif bow_mesh.mesh != bow_rest_mesh: bow_mesh.mesh = bow_rest_mesh
\t\t\t
\tif p.has("arrow_visible"):
\t\tarrow.visible = p["arrow_visible"]
"""

with open(archer_gd_path, "w", encoding="utf-8") as f:
    f.write(new_archer_code)
print("[OK] goblin_archer.gd updated with perfect archery physics and mechanics.")
