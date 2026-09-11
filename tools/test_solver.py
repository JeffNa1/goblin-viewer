import math

# We want to find left_arm_rot, left_forearm_rot, and bow_rot such that:
# 1. The left arm extends towards the target (say World +Z, or World (sin(-20°), 0, cos(-20°)))
# 2. The bow is vertical (bow local Y is parallel to World Y)
# 3. The bow string is on the side facing the archer (-Z relative to aim direction)
# 4. The arrow points in the aim direction

print("Starting solver script...")
