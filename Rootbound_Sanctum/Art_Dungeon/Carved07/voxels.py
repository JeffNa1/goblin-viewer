"""Cubic voxel volumes with greedy exterior meshing. All vertices stay on the grid."""
import numpy as np


class Volume:
    def __init__(self, lo, hi, step):
        self.step = float(step)
        self.lo = np.floor(np.asarray(lo, float) / step) * step
        self.hi = np.ceil(np.asarray(hi, float) / step) * step
        self.data = np.zeros(np.rint((self.hi - self.lo) / step).astype(int), np.uint32)

    def box(self, center, size, tone):
        center, size = np.asarray(center), np.asarray(size)
        a = np.maximum(0, np.ceil((center - size / 2 - self.lo) / self.step - .5).astype(int))
        b = np.minimum(self.data.shape, np.ceil((center + size / 2 - self.lo) / self.step - .5).astype(int))
        self.data[tuple(slice(x, y) for x, y in zip(a, b))] = tone

    def paint(self, lo, hi, predicate, tone):
        a = np.maximum(0, np.floor((np.asarray(lo) - self.lo) / self.step).astype(int))
        b = np.minimum(self.data.shape, np.ceil((np.asarray(hi) - self.lo) / self.step).astype(int))
        if np.any(b <= a):
            return
        region = tuple(slice(x, y) for x, y in zip(a, b))
        coordinates = np.ogrid[tuple(slice(int(x), int(y)) for x, y in zip(a, b))]
        x, y, z = [(value + .5) * self.step + self.lo[i] for i, value in enumerate(coordinates)]
        target = self.data[region]
        target[np.broadcast_to(predicate(x, y, z), target.shape)] = tone

    def mesh(self):
        positions, normals, colors, indices = [], [], [], []
        for axis in range(3):
            u, v = (axis + 1) % 3, (axis + 2) % 3
            ordered = np.transpose(self.data, (axis, u, v))
            for sign in [-1, 1]:
                normal = [0, 0, 0]
                normal[axis] = sign
                for layer in range(ordered.shape[0]):
                    current = ordered[layer]
                    neighbor = layer + sign
                    if 0 <= neighbor < ordered.shape[0]:
                        mask = np.where(ordered[neighbor] == 0, current, 0)
                    else:
                        mask = current.copy()
                    for x, y in zip(*np.nonzero(mask)):
                        tone = int(mask[x, y])
                        if not tone:
                            continue
                        width = 1
                        while x + width < mask.shape[0] and mask[x + width, y] == tone:
                            width += 1
                        height = 1
                        while y + height < mask.shape[1] and np.all(mask[x:x + width, y + height] == tone):
                            height += 1
                        mask[x:x + width, y:y + height] = 0
                        corners = []
                        for dx, dy in [(0, 0), (width, 0), (width, height), (0, height)]:
                            point = [0, 0, 0]
                            point[axis] = layer + (1 if sign > 0 else 0)
                            point[u], point[v] = x + dx, y + dy
                            corners.append(self.lo + np.asarray(point) * self.step)
                        base = len(positions)
                        positions.extend(corners)
                        normals.extend([normal] * 4)
                        rgb = np.array([(tone >> 16) & 255, (tone >> 8) & 255, tone & 255]) / 255.0
                        linear = np.where(rgb <= .04045, rgb / 12.92, ((rgb + .055) / 1.055) ** 2.4)
                        colors.extend([linear] * 4)
                        order = [0, 1, 2, 0, 2, 3] if sign > 0 else [0, 2, 1, 0, 3, 2]
                        indices.extend([base + i for i in order])
        return (np.asarray(positions, dtype='<f4').reshape(-1, 3),
                np.asarray(normals, dtype='<f4').reshape(-1, 3),
                np.asarray(colors, dtype='<f4').reshape(-1, 3),
                np.asarray(indices, dtype='<u4'))
