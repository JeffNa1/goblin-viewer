"""Compare the built voxel floor against the approved gated route graph."""

import argparse
import itertools
import json
import math
from collections import deque
from pathlib import Path


def check_routes(data):
    cell_m = data['cell_m']
    radius_cells = 3
    floor = {(x, z) for x, z, _, _ in data['cells']}
    obstacles = {(x, z) for x, z, _, blocked in data['cells'] if blocked}
    raw = floor - obstacles
    disk = [(x, z) for x in range(-radius_cells, radius_cells + 1)
            for z in range(-radius_cells, radius_cells + 1)
            if x * x + z * z <= radius_cells * radius_cells]
    walkable = {(x, z) for x, z in raw
                if all((x + dx, z + dz) in raw for dx, dz in disk)}

    def grid(point):
        coordinates = [(p - o) * data['pixel_scale'] / cell_m
                       for p, o in zip(point, data['origin'])]
        return tuple(int(math.copysign(math.floor(abs(v) + 0.5), v)) for v in coordinates)

    labels = {room['id']: grid(room['label']) for room in data['rooms']}
    assert len(labels) == 14
    assert all(p in walkable for p in labels.values()), 'A room interior cannot fit the test body'
    gated = {}
    for link in data['links']:
        if 'gate' not in link:
            continue
        a, b = link['points'][:2]
        center = [((a[i] + b[i]) * 0.5 - data['origin'][i]) * data['pixel_scale'] / cell_m
                  for i in range(2)]
        delta = [b[i] - a[i] for i in range(2)]
        length = math.hypot(*delta)
        tangent = [v / length for v in delta]
        blocked = set()
        for x in range(math.floor(center[0]) - 16, math.ceil(center[0]) + 17):
            for z in range(math.floor(center[1]) - 16, math.ceil(center[1]) + 17):
                dx, dz = x - center[0], z - center[1]
                along = abs(dx * tangent[0] + dz * tangent[1])
                across = abs(dx * tangent[1] - dz * tangent[0])
                if along <= 0.5 + radius_cells and across <= 10.5 + radius_cells:
                    blocked.add((x, z))
        gated.setdefault(link['gate'], set()).update(blocked)

    def graph_reachable(flags):
        neighbors = {room: set() for room in labels}
        for link in data['links']:
            if link.get('gate') and link['gate'] not in flags:
                continue
            neighbors[link['a']].add(link['b'])
            neighbors[link['b']].add(link['a'])
        seen, queue = {'01'}, deque(['01'])
        while queue:
            for neighbor in neighbors[queue.popleft()] - seen:
                seen.add(neighbor)
                queue.append(neighbor)
        return seen

    results = []
    names = sorted(gated)
    for bits in itertools.product((False, True), repeat=len(names)):
        flags = {name for name, enabled in zip(names, bits) if enabled}
        forbidden = set().union(*(cells for name, cells in gated.items() if name not in flags))
        available = walkable - forbidden
        seen, queue = {labels['01']}, deque([labels['01']])
        while queue:
            x, z = queue.popleft()
            for neighbor in ((x - 1, z), (x + 1, z), (x, z - 1), (x, z + 1)):
                if neighbor in available and neighbor not in seen:
                    seen.add(neighbor)
                    queue.append(neighbor)
        reached = {room for room, point in labels.items() if point in seen}
        expected = graph_reachable(flags)
        assert reached == expected, f'Voxel routes differ from graph: flags={flags}, actual={reached}, expected={expected}'
        results.append({'flags': sorted(flags), 'rooms': sorted(reached), 'matches_graph': True})
    assert len(results) == 16
    assert len(results[-1]['rooms']) == 14
    return {'floor_cells': len(floor), 'clearance_radius_m': radius_cells * cell_m,
            'room_count': len(labels), 'link_count': len(data['links']),
            'gate_states_checked': len(results), 'states': results,
            'scope': 'Grid reachability around built obstacles with a circular regular-monster footprint. Gates use their built center and width. Physics capsule tests are separate.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('grid', type=Path)
    parser.add_argument('--out', type=Path)
    args = parser.parse_args()
    report = check_routes(json.loads(args.grid.read_text(encoding='utf-8')))
    text = json.dumps(report, indent=2)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding='utf-8')
    print(text)


if __name__ == '__main__':
    main()
