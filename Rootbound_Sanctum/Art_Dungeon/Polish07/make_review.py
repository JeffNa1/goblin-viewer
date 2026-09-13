"""Validate real captures and create the room 07 before/after review package."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageStat, ImageChops
import hashlib
import json
import zipfile
import difflib

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
ART = HERE.parent
REVIEW = HERE / 'Review'
REVIEW.mkdir(exist_ok=True)
(REVIEW / '.gdignore').touch()
VIEWS = ['shoulder', 'eye_level', 'overview', 'carving', 'fountain', 'corridor']
font = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', 25)
title_font = ImageFont.truetype('C:/Windows/Fonts/segoeuib.ttf', 30)
records = {}
checks = []
all_hashes = []
for phase in ['before', 'after']:
    manifest = json.loads((HERE / 'Renders' / phase / 'manifest.json').read_text())
    assert len(manifest) == len(VIEWS), (phase, len(manifest))
    assert {r['view'] for r in manifest} == set(VIEWS)
    records[phase] = {r['view']: r for r in manifest}

for view in VIEWS:
    for field in ['camera', 'basis', 'fov', 'width', 'height', 'adapter']:
        assert records['before'][view][field] == records['after'][view][field], (view, field)
    images = []
    pair = Image.new('RGB', (3200, 972), '#101f20')
    draw = ImageDraw.Draw(pair)
    draw.text((26, 17), 'BEFORE  /  ' + view.replace('_', ' ').upper(), font=title_font, fill='#b9c8bc')
    draw.text((1626, 17), 'AFTER  /  ROOM 07 CARVED PASS', font=title_font, fill='#e4c78e')
    for column, phase in enumerate(['before', 'after']):
        path = HERE / 'Renders' / phase / (view + '.png')
        with Image.open(path) as source:
            image = source.convert('RGB')
        assert image.size == (1600, 900), (path, image.size)
        assert max(ImageStat.Stat(image).stddev) > 8, path
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        all_hashes.append(digest)
        checks.append({'phase': phase, 'view': view, 'size': image.size, 'sha256': digest})
        images.append(image)
        pair.paste(image, (column * 1600, 72))
    assert ImageChops.difference(images[0], images[1]).getbbox(), view
    pair.save(REVIEW / ('Comparison_' + view + '.png'))

assert len(set(all_hashes)) == len(all_hashes)
sheet = Image.new('RGB', (1600, 1580), '#101f20')
draw = ImageDraw.Draw(sheet)
draw.text((22, 18), 'ROOM 07 / QUIET SANCTUARY', font=title_font, fill='#e4c78e')
draw.text((22, 61), 'Actual Godot captures. Existing light rig. Art review, not a gameplay build.', font=font, fill='#b9c8bc')
for i, view in enumerate(VIEWS):
    x = (i % 2) * 800
    y = 124 + (i // 2) * 480
    with Image.open(HERE / 'Renders/after' / (view + '.png')) as image:
        sheet.paste(image.resize((800, 450), Image.Resampling.LANCZOS), (x, y))
    draw.text((x + 12, y + 450), view.replace('_', ' ').upper(), font=font, fill='#b9c8bc')
sheet.save(REVIEW / 'Room07_All_Views.png')

before_rooms = {r['id']: r for r in json.loads((HERE / 'Evidence/before/rooms.json').read_text())}
after_rooms = {r['id']: r for r in json.loads((HERE / 'Evidence/after/rooms.json').read_text())}
assert before_rooms.keys() == after_rooms.keys()
unchanged = [key for key in before_rooms if key != '07' and before_rooms[key] == after_rooms[key]]
assert len(unchanged) == len(before_rooms) - 1
for key in ['floor_cells', 'views']:
    assert before_rooms['07'][key] == after_rooms['07'][key], key
preservation = json.loads((HERE / 'Evidence/preservation.json').read_text())
assert preservation['passed'], preservation
for path in ['sculpt-acceptance.json', 'after/acceptance.json', 'original-sample.json', 'launcher.json']:
    assert json.loads((HERE / 'Evidence' / path).read_text())['passed'], path
old = (HERE / 'Evidence/before-dungeon.gd.txt').read_text().splitlines(keepends=True)
new = (ART / 'dungeon.gd').read_text().splitlines(keepends=True)
diff = ''.join(difflib.unified_diff(old, new, fromfile='baseline/dungeon.gd', tofile='current/dungeon.gd'))
(HERE / 'Evidence/integration.diff').write_text(diff, encoding='utf-8')
summary = {'capture_count': len(checks), 'before_count': len(records['before']),
           'after_count': len(records['after']), 'matched_camera_pairs': len(VIEWS),
           'unchanged_other_room_ids': unchanged, 'unchanged_other_room_count': len(unchanged),
           'protected_file_count': preservation['immutable_checked'],
           'concurrent_changed': preservation['concurrent_changed'], 'captures': checks}
(HERE / 'Evidence/render-verification.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')

package = HERE / 'Room07_Carved_Review.zip'
with zipfile.ZipFile(package, 'w', zipfile.ZIP_DEFLATED) as archive:
    archive.write(HERE / 'README.md', 'README.md')
    for directory in ['Review', 'Renders', 'Evidence']:
        for path in sorted((HERE / directory).rglob('*')):
            if path.is_file() and path.name not in {'.gdignore', 'package-verification.json'}:
                archive.write(path, path.relative_to(HERE).as_posix())
    for name in ['Reference_Board.png', 'sources.json', 'manifest.json']:
        archive.write(ART / 'References' / name, 'External_References/' + name)
    dependencies = ['data/rootbound_layout.json', 'Rootbound_Sanctum/Art_Sample/sanctuary.gd',
                    *['Rootbound_Sanctum/Art_Dungeon/' + name for name in
                      ['dungeon.gd', 'dungeon.tscn', 'room_art.gd', 'layout_grid.gd', 'early_rooms.gd', 'late_rooms.gd']]]
    for name in dependencies:
        archive.write(PROJECT / name, 'Source/' + name)
    for path in sorted(HERE.iterdir()):
        if path.is_file() and path.suffix in ['.gd', '.py', '.bat', '.md']:
            archive.write(path, 'Source/' + path.relative_to(PROJECT).as_posix())
with zipfile.ZipFile(package) as archive:
    assert archive.testzip() is None
    names = archive.namelist()
    assert len(names) == len(set(names))
    assert all('Renders/after/' + view + '.png' in names for view in VIEWS)
package_check = {'path': str(package), 'bytes': package.stat().st_size,
                 'sha256': hashlib.sha256(package.read_bytes()).hexdigest(),
                 'entries': len(names), 'crc_passed': True}
(HERE / 'Evidence/package-verification.json').write_text(json.dumps(package_check, indent=2), encoding='utf-8')
print(json.dumps({key: value for key, value in summary.items() if key != 'captures'}, indent=2))
print(json.dumps(package_check, indent=2))
print(diff)
