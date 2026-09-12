extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _compute_dagger_flip(base_rot: Vector3, mid_rot: Vector3, fwd_rot: Vector3, t: float) -> Vector3:
	var q_start = Basis.from_euler(Vector3(deg_to_rad(base_rot.x), deg_to_rad(base_rot.y), deg_to_rad(base_rot.z))).get_rotation_quaternion()
	var q_mid = Basis.from_euler(Vector3(deg_to_rad(mid_rot.x), deg_to_rad(mid_rot.y), deg_to_rad(mid_rot.z))).get_rotation_quaternion()
	var q_end = Basis.from_euler(Vector3(deg_to_rad(fwd_rot.x), deg_to_rad(fwd_rot.y), deg_to_rad(fwd_rot.z))).get_rotation_quaternion()
	
	var q: Quaternion
	if t < 0.5:
		var s = smoothstep(0.0, 1.0, t * 2.0)
		q = q_start.slerp(q_mid, s)
	else:
		var s = smoothstep(0.0, 1.0, (t - 0.5) * 2.0)
		q = q_mid.slerp(q_end, s)
	
	var euler = Basis(q).get_euler()
	return Vector3(rad_to_deg(euler.x), rad_to_deg(euler.y), rad_to_deg(euler.z))

func _run() -> void:
	var base_r = Vector3(-85.0, 15.0, -15.0)
	var mid_r = Vector3(10.0, 15.0, -95.0)
	var fwd_r = Vector3(88.0, -10.0, 12.0)
	
	print("Testing _compute_dagger_flip output:")
	for step in range(11):
		var t = float(step) / 10.0
		var deg = _compute_dagger_flip(base_r, mid_r, fwd_r, t)
		print("t=%.1f -> deg=(%.1f, %.1f, %.1f)" % [t, deg.x, deg.y, deg.z])
		
	quit(0)
