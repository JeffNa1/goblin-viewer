from check_bow_axes import *

class Transform3D:
    def __init__(self, basis=None, origin=None):
        self.basis = basis if basis else [[1,0,0],[0,1,0],[0,0,1]]
        self.origin = origin if origin else [0,0,0]
        
    def mul(self, other):
        new_basis = mat_mul(self.basis, other.basis)
        new_origin = [self.origin[i] + sum(self.basis[i][j]*other.origin[j] for j in range(3)) for i in range(3)]
        return Transform3D(new_basis, new_origin)
        
    def xform(self, pt):
        return [self.origin[i] + sum(self.basis[i][j]*pt[j] for j in range(3)) for i in range(3)]

r_arm = euler_yxz(-86, 45, 6)
r_fore = euler_yxz(-6, 0, 0)
r_bow = euler_yxz(90, 0, 0)

r_total = mat_mul(r_arm, mat_mul(r_fore, r_bow))

limbs = mat_vec(r_total, [0, 1, 0])
curve = mat_vec(r_total, [0, 0, 1])
string = mat_vec(r_total, [0, 0, -1])

print(f"Limbs in Torso space:  [{limbs[0]:.2f}, {limbs[1]:.2f}, {limbs[2]:.2f}]")
print(f"Curve (Forward):       [{curve[0]:.2f}, {curve[1]:.2f}, {curve[2]:.2f}]")
print(f"String (Backward):     [{string[0]:.2f}, {string[1]:.2f}, {string[2]:.2f}]")

t_arm = Transform3D(r_arm, [-0.27, 0.48, 0])
t_fore = t_arm.mul(Transform3D(r_fore, [0, -0.27, 0]))
t_bow = t_fore.mul(Transform3D(r_bow, [0, -0.24, 0]))

nock_torso = t_bow.xform([0.03, 0.0, -0.24])
bow_grip_torso = t_bow.xform([0.0, 0.0, 0.0])
arrowhead_torso = t_bow.xform([0.03, 0.0, 0.51])

print(f"\nTorso Space Coordinates:")
print(f"  Bow Grip:  [{bow_grip_torso[0]:.2f}, {bow_grip_torso[1]:.2f}, {bow_grip_torso[2]:.2f}]")
print(f"  Arrowhead: [{arrowhead_torso[0]:.2f}, {arrowhead_torso[1]:.2f}, {arrowhead_torso[2]:.2f}]")
print(f"  Nock:      [{nock_torso[0]:.2f}, {nock_torso[1]:.2f}, {nock_torso[2]:.2f}]")

r_shoulder = [0.27, 0.48, 0.0]
dist_sh_to_nock = math.dist(r_shoulder, nock_torso)
print(f"  Right Shoulder: {r_shoulder}")
print(f"  Distance Shoulder to Nock: {dist_sh_to_nock:.3f} m")
