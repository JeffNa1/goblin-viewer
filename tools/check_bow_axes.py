import math

def rot_x(deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return [[1, 0, 0], [0, c, -s], [0, s, c]]

def rot_y(deg):
    r = math.radians(deg)
    c, s = math.cos(r), math.sin(r)
    return [[c, 0, s], [0, 1, 0], [-s, 0, c]]

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

def euler_yxz(rx, ry, rz):
    mx = rot_x(rx)
    my = rot_y(ry)
    mz = rot_z(rz)
    return mat_mul(my, mat_mul(mx, mz))

# Left arm in Torso space:
# LeftArm rot = (-86, 45, 6)
# LeftForearm rot = (-6, 0, 0)
# Bow rot = (-90, 0, 180)

r_arm = euler_yxz(-86, 45, 6)
r_fore = euler_yxz(-6, 0, 0)
r_bow = euler_yxz(-90, 0, 180)

r_total = mat_mul(r_arm, mat_mul(r_fore, r_bow))

# Bow local axes in Torso space:
# Bow Y is limbs
# Bow Z is curve (front)
# Bow -Z is string (back)
limbs_torso = mat_vec(r_total, [0, 1, 0])
curve_torso = mat_vec(r_total, [0, 0, 1])
string_torso = mat_vec(r_total, [0, 0, -1])

print(f"Limbs in Torso space:  [{limbs_torso[0]:.2f}, {limbs_torso[1]:.2f}, {limbs_torso[2]:.2f}]")
print(f"Curve in Torso space:  [{curve_torso[0]:.2f}, {curve_torso[1]:.2f}, {curve_torso[2]:.2f}]")
print(f"String in Torso space: [{string_torso[0]:.2f}, {string_torso[1]:.2f}, {string_torso[2]:.2f}]")
