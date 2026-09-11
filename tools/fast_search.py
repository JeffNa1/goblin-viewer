from verify_fixed_bow import *

r_arm_l = euler_yxz(-88, 12, 4)
r_fore_l = euler_yxz(-4, 0, 0)
r_bow = euler_yxz(90, 0, 0)

t_arm_l = Transform3D(r_arm_l, [-0.27, 0.48, 0])
t_fore_l = t_arm_l.mul(Transform3D(r_fore_l, [0, -0.27, 0]))
t_bow = t_fore_l.mul(Transform3D(r_bow, [0, -0.24, 0]))

nock = t_bow.xform([0.03, 0, -0.24])

best_dist = 999.0
best_rot = None

for rx in range(-90, 10, 10):
    for ry in range(-40, 90, 10):
        for rz in range(-20, 90, 10):
            r_arm_r = euler_yxz(rx, ry, rz)
            t_arm_r = Transform3D(r_arm_r, [0.27, 0.48, 0])
            for r_fore_rx in range(-140, -30, 10):
                r_fore_r = euler_yxz(r_fore_rx, 0, 0)
                t_fore_r = t_arm_r.mul(Transform3D(r_fore_r, [0, -0.27, 0]))
                hand = t_fore_r.xform([0, -0.24, 0])
                
                d = math.dist(nock, hand)
                if d < best_dist:
                    best_dist = d
                    best_rot = (rx, ry, rz, r_fore_rx, hand)

# Fine pass around best
brx, bry, brz, brf, _ = best_rot
for rx in range(brx - 10, brx + 11, 2):
    for ry in range(bry - 10, bry + 11, 2):
        for rz in range(brz - 10, brz + 11, 2):
            r_arm_r = euler_yxz(rx, ry, rz)
            t_arm_r = Transform3D(r_arm_r, [0.27, 0.48, 0])
            for r_fore_rx in range(brf - 10, brf + 11, 2):
                r_fore_r = euler_yxz(r_fore_rx, 0, 0)
                t_fore_r = t_arm_r.mul(Transform3D(r_fore_r, [0, -0.27, 0]))
                hand = t_fore_r.xform([0, -0.24, 0])
                
                d = math.dist(nock, hand)
                if d < best_dist:
                    best_dist = d
                    best_rot = (rx, ry, rz, r_fore_rx, hand)

print(f"Optimal match distance: {best_dist*100:.1f} cm")
print(f"Right Arm Rot: Vector3({best_rot[0]}, {best_rot[1]}, {best_rot[2]})")
print(f"Right Forearm Rot: Vector3({best_rot[3]}, 0, 0)")
print(f"Hand pos: [{best_rot[4][0]:.2f}, {best_rot[4][1]:.2f}, {best_rot[4][2]:.2f}]")
print(f"Nock pos: [{nock[0]:.2f}, {nock[1]:.2f}, {nock[2]:.2f}]")
