# Test orientations in Forearm local space where:
# Forearm has rotated -90 on X, so:
# Forearm local axes in Torso space are:
# Forearm X = Torso X (Right)
# Forearm Y = Torso Z (Forward)
# Forearm Z = Torso Y (Up)

# We want the Bow mesh to end up in Torso space as:
# Limbs (Bow local Y) -> Torso Up (Forearm Z) = (0, 0, 1)
# Curve (Bow local Z) -> Torso Forward (Forearm Y) = (0, 1, 0)
# String (Bow local -Z) -> Torso Backward = (0, -1, 0)

import math

def rot_matrix(rx, ry, rz):
    # Godot Euler order YXZ
    # Angles in degrees
    rad_x = math.radians(rx)
    rad_y = math.radians(ry)
    rad_z = math.radians(rz)
    
    cx, sx = math.cos(rad_x), math.sin(rad_x)
    cy, sy = math.cos(rad_y), math.sin(rad_y)
    cz, sz = math.cos(rad_z), math.sin(rad_z)
    
    # R = Ry * Rx * Rz
    # Rx:
    # [ 1,   0,   0 ]
    # [ 0,  cx, -sx ]
    # [ 0,  sx,  cx ]
    # Ry:
    # [ cy,  0,  sy ]
    # [  0,  1,   0 ]
    # [-sy,  0,  cy ]
    # Rz:
    # [ cz, -sz,  0 ]
    # [ sz,  cz,  0 ]
    # [  0,   0,  1 ]
    
    # Let's multiply:
    # First R_xz = Rx * Rz
    rxz = [
        [cz, -sz, 0],
        [cx*sz, cx*cz, -sx],
        [sx*sz, sx*cz, cx]
    ]
    # Then R = Ry * rxz
    r = [
        [cy*rxz[0][0] + sy*rxz[2][0], cy*rxz[0][1] + sy*rxz[2][1], cy*rxz[0][2] + sy*rxz[2][2]],
        [rxz[1][0], rxz[1][1], rxz[1][2]],
        [-sy*rxz[0][0] + cy*rxz[2][0], -sy*rxz[0][1] + cy*rxz[2][1], -sy*rxz[0][2] + cy*rxz[2][2]]
    ]
    return r

def mat_mul_vec(m, v):
    return [
        m[0][0]*v[0] + m[0][1]*v[1] + m[0][2]*v[2],
        m[1][0]*v[0] + m[1][1]*v[1] + m[1][2]*v[2],
        m[2][0]*v[0] + m[2][1]*v[1] + m[2][2]*v[2]
    ]

# Find rx, ry, rz in multiples of 90 degrees
candidates = []
for rx in [0, 90, -90, 180]:
    for ry in [0, 90, -90, 180]:
        for rz in [0, 90, -90, 180]:
            m = rot_matrix(rx, ry, rz)
            # Check Bow local Y = (0, 1, 0) -> Forearm (0, 0, 1)
            # Check Bow local Z = (0, 0, 1) -> Forearm (0, 1, 0)
            target_y = mat_mul_vec(m, [0, 1, 0])
            target_z = mat_mul_vec(m, [0, 0, 1])
            
            err_y = sum(abs(a - b) for a, b in zip(target_y, [0, 0, 1]))
            err_z = sum(abs(a - b) for a, b in zip(target_z, [0, 1, 0]))
            
            if err_y < 1e-4 and err_z < 1e-4:
                candidates.append((rx, ry, rz))

print("Found matching rotations (rx, ry, rz):")
for c in candidates:
    print(f"  bow_rot = Vector3({c[0]}, {c[1]}, {c[2]})")
