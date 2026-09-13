"""Behavior tests for true cubic geometry and face merging."""
import importlib.util
import unittest
from pathlib import Path
import numpy as np

class VoxelTests(unittest.TestCase):
    def test_joined_cubes_merge_without_internal_faces(self):
        source = Path(__file__).with_name('voxels.py')
        self.assertTrue(source.exists(), 'Fine cubic voxel mesher is missing')
        spec = importlib.util.spec_from_file_location('voxels', source)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        v = module.Volume((0, 0, 0), (2, 1, 1), 1.0)
        v.box((1, .5, .5), (2, 1, 1), 0x778866)
        p, n, c, indices = v.mesh()
        self.assertEqual(len(indices), 36, 'A joined solid cuboid needs only twelve triangles')
        np.testing.assert_allclose(np.min(p, axis=0), [0, 0, 0])
        np.testing.assert_allclose(np.max(p, axis=0), [2, 1, 1])
        self.assertTrue(np.all(np.count_nonzero(n, axis=1) == 1))
        for a, b, c in np.asarray(indices).reshape(-1, 3):
            self.assertGreater(np.dot(np.cross(p[b]-p[a], p[c]-p[a]), n[a]), 0)

class CarvingTests(unittest.TestCase):
    def test_carve_removes_volume_not_a_dark_overlay(self):
        from voxels import Volume
        self.assertTrue(hasattr(Volume, 'paint'), 'Subtractive voxel sculpting is missing')
        v = Volume((-1, -1, -1), (1, 1, 1), .1)
        v.box((0, 0, 0), (2, 2, 2), 0x778866)
        v.paint((-.5, -.5, -.5), (.5, .5, 1), lambda x, y, z: x*x + y*y < .16, 0)
        self.assertEqual(v.data[10, 10, 18], 0)
        self.assertNotEqual(v.data[10, 10, 2], 0)
        p, n, c, indices = v.mesh()
        self.assertTrue(np.all(np.count_nonzero(n, axis=1) == 1))
        self.assertGreater(len(indices), 36)

if __name__ == '__main__':
    unittest.main()
