from verify_fixed_bow import *

# In IDLE:
# Left arm hangs down beside body
r_arm_idle = euler_yxz(4, 0, -10)
r_fore_idle = euler_yxz(-8, 0, 0)

for test_rot in [
    (0, 0, 0),
    (0, 180, 0),
    (10, 0, 0),
    (-10, 0, 0),
    (0, 0, 10),
    (5, 0, -5)
]:
    r_b = euler_yxz(*test_rot)
    r_tot = mat_mul(r_arm_idle, mat_mul(r_fore_idle, r_b))
    limbs = mat_vec(r_tot, [0, 1, 0])
    curve = mat_vec(r_tot, [0, 0, 1])
    string = mat_vec(r_tot, [0, 0, -1])
    print(f"idle bow_rot {test_rot}:")
    print(f"  Limbs:  [{limbs[0]:.2f}, {limbs[1]:.2f}, {limbs[2]:.2f}]")
    print(f"  Curve:  [{curve[0]:.2f}, {curve[1]:.2f}, {curve[2]:.2f}]")
    print(f"  String: [{string[0]:.2f}, {string[1]:.2f}, {string[2]:.2f}]")
