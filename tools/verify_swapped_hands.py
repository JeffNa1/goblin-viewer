from verify_fixed_bow import *

# Symmetrical setup:
# Right arm holds bow (at [+0.27, 0.48, 0])
# Left arm draws string (at [-0.27, 0.48, 0])

r_arm_r = euler_yxz(-88, -12, -4)
r_fore_r = euler_yxz(-4, 0, 0)
r_bow = euler_yxz(90, 0, 0)

t_arm_r = Transform3D(r_arm_r, [0.27, 0.48, 0])
t_fore_r = t_arm_r.mul(Transform3D(r_fore_r, [0, -0.27, 0]))
t_bow = t_fore_r.mul(Transform3D(r_bow, [0, -0.24, 0]))

bow_grip = t_bow.xform([0, 0, 0])
nock = t_bow.xform([-0.03, 0, -0.24])
arrowhead = t_bow.xform([-0.03, 0, 0.51])

print(f"RIGHT HAND (Bow Grip): [{bow_grip[0]:.2f}, {bow_grip[1]:.2f}, {bow_grip[2]:.2f}]")
print(f"ARROWHEAD:             [{arrowhead[0]:.2f}, {arrowhead[1]:.2f}, {arrowhead[2]:.2f}]")
print(f"NOCK (String apex):    [{nock[0]:.2f}, {nock[1]:.2f}, {nock[2]:.2f}]")

# Left arm (draw arm):
r_arm_l = euler_yxz(-74, 44, 16)
r_fore_l = euler_yxz(-30, 0, 0)

t_arm_l = Transform3D(r_arm_l, [-0.27, 0.48, 0])
t_fore_l = t_arm_l.mul(Transform3D(r_fore_l, [0, -0.27, 0]))
l_hand = t_fore_l.xform([0, -0.24, 0])

print(f"LEFT HAND (Draw):      [{l_hand[0]:.2f}, {l_hand[1]:.2f}, {l_hand[2]:.2f}]")
print(f"Distance Nock to Left Hand: {math.dist(nock, l_hand):.3f} m ({math.dist(nock, l_hand)*100:.1f} cm)")
