import shutil
import subprocess

shutil.copy("scripts/voxel_builder.gd", "scripts/voxel_builder_test.gd")
# test if add_archer_outfit3.py can run
with open(r"C:\Users\Administrator\.gemini\antigravity\brain\dee0e0b1-646b-4b32-99e0-a9b632535458\scratch\add_archer_outfit3.py", "r", encoding="utf-8") as f:
    code = f.read()

# Replace VB_PATH with voxel_builder_test.gd
test_code = code.replace('"voxel_builder.gd"', '"voxel_builder_test.gd"')
with open("tools/test_add_archer.py", "w", encoding="utf-8") as f:
    f.write(test_code)

print("Created tools/test_add_archer.py")
