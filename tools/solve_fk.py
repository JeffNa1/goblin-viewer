import math

# Full FK solver for Goblin Archer
def rot_y(deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return [[c, 0, s], [0, 1, 0], [-s, 0, c]]

def rot_x(deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return [[1, 0, 0], [0, c, -s], [0, s, c]]

def rot_z(deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return [[c, -s, 0], [s, c, 0], [0, 0, 1]]

def mat_mul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)]
        for i in range(3)
    ]

def mat_vec(m, v):
    return [sum(m[i][j] * v[j] for j in range(3)) for i in range(3)]

def vec_add(a, b):
    return [a[i] + b[i] for i in range(3)]

def euler_yxz(rx, ry, rz):
    # Godot Euler order YXZ: R = Ry * Rx * Rz
    mx = rot_x(rx)
    my = rot_y(ry)
    mz = rot_z(rz)
    return mat_mul(my, mat_mul(mx, mz))

class Transform3D:
    def __init__(self, basis=None, origin=None):
        self.basis = basis if basis else [[1,0,0],[0,1,0],[0,0,1]]
        self.origin = origin if origin else [0,0,0]
        
    def mul(self, other):
        new_basis = mat_mul(self.basis, other.basis)
        new_origin = vec_add(self.origin, mat_vec(self.basis, other.origin))
        return Transform3D(new_basis, new_origin)
        
    def xform(self, pt):
        return vec_add(self.origin, mat_vec(self.basis, pt))

def solve():
    # Fix body stance:
    # Archer stands with hips turned -45 deg, torso turned +15 deg inside hips (total body yaw = -30 deg)
    # Target line is straight forward (+Z) or slightly left (-10 deg)
    hips_pos = [0.0, 0.618 - 0.03, 0.0]
    hips_rot = [0.0, -35.0, 0.0]
    torso_rot = [2.0, -15.0, 0.0] # Total torso yaw = -50 deg
    
    t_hips = Transform3D(euler_yxz(*hips_rot), hips_pos)
    t_torso = t_hips.mul(Transform3D(euler_yxz(*torso_rot), [0, 0, 0]))
    
    # We want left arm to extend towards target: say around yaw = -10 deg in world space
    # Left shoulder is at [-0.27, 0.48, 0] in torso
    # In torso space, target is at -10 - (-50) = +40 deg
    # Left arm: rx around -85, ry around 35..45, rz around 0..10
    best_err = 999.0
    best_params = None
    
    # Left arm pose candidates
    for l_rx in [-86, -88, -84]:
        for l_ry in [20, 25, 30, 35]:
            for l_rz in [-5, 0, 5]:
                t_l_arm = t_torso.mul(Transform3D(euler_yxz(l_rx, l_ry, l_rz), [-0.27, 0.48, 0]))
                t_l_fore = t_l_arm.mul(Transform3D(euler_yxz(-5, 0, 0), [0, -0.27, 0]))
                # Bow rotation in forearm space:
                # We need bow to be vertical in world space!
                # Bow local Y -> World Up (0, 1, 0)
                # Bow local Z -> Aim direction
                # Let's test bow rotations
                for b_rx in [-90]:
                    for b_rz in [170, 175, 180, 185]:
                        t_bow = t_l_fore.mul(Transform3D(euler_yxz(b_rx, 0, b_rz), [0, -0.24, 0]))
                        
                        # Nock position on drawn bow (8 voxels back = -0.24m)
                        nock_world = t_bow.xform([0.03, 0.0, -0.24])
                        
                        # Now search right arm rotations so hand meets nock_world!
                        # Right shoulder is at [0.27, 0.48, 0] in torso
                        t_r_sh = t_torso.mul(Transform3D([[1,0,0],[0,1,0],[0,0,1]], [0.27, 0.48, 0]))
                        
                        for r_rx in range(-90, -40, 5):
                            for r_ry in range(10, 60, 5):
                                for r_rz in range(30, 90, 5):
                                    t_r_arm = t_torso.mul(Transform3D(euler_yxz(r_rx, r_ry, r_rz), [0.27, 0.48, 0]))
                                    for r_f_rx in range(-140, -80, 5):
                                        t_r_fore = t_r_arm.mul(Transform3D(euler_yxz(r_f_rx, 0, 0), [0, -0.27, 0]))
                                        hand_world = t_r_fore.xform([0.0, -0.24, 0.0])
                                        
                                        dist = math.dist(nock_world, hand_world)
                                        if dist < best_err:
                                            best_err = dist
                                            best_params = {
                                                "err": dist,
                                                "l_arm": (l_rx, l_ry, l_rz),
                                                "bow": (b_rx, 0, b_rz),
                                                "r_arm": (r_rx, r_ry, r_rz),
                                                "r_fore": r_f_rx,
                                                "nock": nock_world,
                                                "hand": hand_world
                                            }

    print(f"Best distance: {best_params['err']:.4f} m ({best_params['err']*100:.1f} cm)")
    print(f"Left Arm Rot: {best_params['l_arm']}")
    print(f"Bow Rot: {best_params['bow']}")
    print(f"Right Arm Rot: {best_params['r_arm']}")
    print(f"Right Forearm Rot: Vector3({best_params['r_fore']}, 0, 0)")
    print(f"Nock World: {best_params['nock']}")
    print(f"Hand World: {best_params['hand']}")

solve()
