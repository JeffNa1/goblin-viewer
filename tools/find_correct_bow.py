from check_bow_axes import *

# Search bow rotations where:
# Limbs is along UP (Y > 0.8)
# Curve is along FORWARD (Z > 0.5)
# String is along BACKWARD (Z < -0.5)

for rx in range(-180, 181, 10):
    for ry in range(-180, 181, 10):
        for rz in range(-180, 181, 10):
            r_b = euler_yxz(rx, ry, rz)
            r_tot = mat_mul(r_arm, mat_mul(r_fore, r_b))
            
            limbs = mat_vec(r_tot, [0, 1, 0])
            curve = mat_vec(r_tot, [0, 0, 1])
            string = mat_vec(r_tot, [0, 0, -1])
            
            # We want limbs Y ~ 1.0 (vertical)
            # We want curve Z > 0.5 (pointing forward towards target)
            # We want curve X close to 0 or slightly negative (aligned with aim)
            if limbs[1] > 0.95 and curve[2] > 0.5 and curve[0] < 0.1:
                print(f"Candidate: bow_rot = Vector3({rx}, {ry}, {rz})")
                print(f"  Limbs:  [{limbs[0]:.2f}, {limbs[1]:.2f}, {limbs[2]:.2f}]")
                print(f"  Curve:  [{curve[0]:.2f}, {curve[1]:.2f}, {curve[2]:.2f}]")
                print(f"  String: [{string[0]:.2f}, {string[1]:.2f}, {string[2]:.2f}]")
                break
        else:
            continue
        break
