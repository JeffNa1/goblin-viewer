from check_bow_axes import *

for test_rot in [
    Vector3_test := (-90, 180, 180),
    (-90, 0, 0),
    (90, 0, 0),
    (90, 180, 0),
    (90, 0, 180),
    (0, 90, 0),
    (0, 0, 90),
    (-90, 180, 0)
]:
    r_b = euler_yxz(*test_rot)
    r_tot = mat_mul(r_arm, mat_mul(r_fore, r_b))
    limbs = mat_vec(r_tot, [0, 1, 0])
    curve = mat_vec(r_tot, [0, 0, 1])
    string = mat_vec(r_tot, [0, 0, -1])
    print(f"rot {test_rot}:")
    print(f"  Limbs:  [{limbs[0]:.2f}, {limbs[1]:.2f}, {limbs[2]:.2f}]")
    print(f"  Curve:  [{curve[0]:.2f}, {curve[1]:.2f}, {curve[2]:.2f}]")
    print(f"  String: [{string[0]:.2f}, {string[1]:.2f}, {string[2]:.2f}]")
