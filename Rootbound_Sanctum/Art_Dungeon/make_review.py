from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageStat
import hashlib
import html
import json

ROOT = Path(__file__).resolve().parent
PROJECT = ROOT.parent.parent
VIEWS = ['shoulder', 'eye_level', 'overview']


def font(size, bold=False):
    name = 'segoeuib.ttf' if bold else 'segoeui.ttf'
    return ImageFont.truetype(str(Path('C:/Windows/Fonts') / name), size)


def make_review():
    layout = json.loads((PROJECT / 'data/rootbound_layout.json').read_text())
    rooms = sorted(layout['rooms'], key=lambda room: room['id'])
    records = json.loads((ROOT / 'Renders/manifest.json').read_text())
    expected = {(room['id'], view) for room in rooms for view in VIEWS} | {('map', 'overview')}
    assert len(records) == len(expected), 'Unexpected capture total'
    assert {(r['id'], r['view']) for r in records} == expected, 'Missing or duplicate room views'
    hashes = set()
    for record in records:
        path = ROOT / 'Renders' / f"{record['id']}_{record['view']}.png"
        with Image.open(path) as image:
            assert image.size == (1600, 900), str(path)
            assert max(ImageStat.Stat(image.convert('RGB')).stddev) > 12, str(path)
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        assert digest not in hashes, 'A capture duplicates another view'
        hashes.add(digest)
    review = ROOT / 'Review'
    review.mkdir(exist_ok=True)
    cards = []
    for room in rooms:
        id = room['id']
        sheet = Image.new('RGB', (1648, 1500), '#10272a')
        draw = ImageDraw.Draw(sheet)
        draw.text((24, 12), id + ' / ' + room['name'].upper(), font=font(30, True), fill='#dfc797')
        draw.text((24, 55), 'Actual Godot captures | Close shoulder, eye level, whole room | Art review only', font=font(20), fill='#a8bfb3')
        for view, x, y, width, height in [('shoulder', 24, 98, 1600, 900), ('eye_level', 24, 1040, 788, 443), ('overview', 836, 1040, 788, 443)]:
            with Image.open(ROOT / 'Renders' / f'{id}_{view}.png') as source:
                sheet.paste(source.convert('RGB').resize((width, height), Image.Resampling.LANCZOS), (x, y))
            if view != 'shoulder':
                draw.text((x, y - 32), view.replace('_', ' ').upper(), font=font(20, True), fill='#dfc797')
        sheet.save(review / f'Room_{id}.png')
        cards.append(f'<a class="card" href="Room_{id}.png"><img loading="lazy" src="../Renders/{id}_shoulder.png" alt="{html.escape(room["name"])}"><h2>{id} / {html.escape(room["name"])}</h2><p>Open all three views</p></a>')
    columns = 3
    rows = (len(rooms) + columns - 1) // columns
    poster = Image.new('RGB', (1712, 114 + rows * 354), '#10272a')
    draw = ImageDraw.Draw(poster)
    draw.text((24, 14), 'ROOTBOUND SANCTUM / ALL ROOM ART', font=font(34, True), fill='#dfc797')
    draw.text((24, 65), '14 original footprints | 13 new room treatments | Actual Godot close-shoulder captures', font=font(22), fill='#a8bfb3')
    for index, room in enumerate(rooms):
        x, y = 24 + (index % columns) * 562, 114 + (index // columns) * 354
        with Image.open(ROOT / 'Renders' / f"{room['id']}_shoulder.png") as source:
            poster.paste(source.convert('RGB').resize((540, 304), Image.Resampling.LANCZOS), (x, y))
        draw.text((x, y + 312), room['id'] + ' / ' + room['name'], font=font(21, True), fill='#dfc797')
    poster.save(review / 'All_Rooms.png')
    page = '''<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Rootbound Sanctum / Art Review</title><style>body{margin:0;background:#10272a;color:#e8dcc4;font:16px system-ui}main{max-width:1400px;margin:auto;padding:30px}h1{font-size:clamp(28px,5vw,54px);margin-bottom:12px}p{color:#a8bfb3;line-height:1.6}a{color:inherit;text-decoration:none}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:24px}.card{background:#183336;overflow:hidden;border:1px solid #35544e;border-radius:8px}.card img{width:100%;display:block}.card h2,.card p{margin:16px}.card h2{font-size:20px}header{margin-bottom:30px}.map img{max-width:100%;border-radius:8px}.map{display:block;margin:24px 0 36px}</style><main><header><p>ROOTBOUND SANCTUM B / VOXEL ENVIRONMENT ART</p><h1>Ruins, roots, and forgotten sanctums.</h1><p>All 14 room footprints and the original 15 connections. Each room has three real 1600 x 900 Godot captures. Room 07 retains its approved sample source.</p><p>This is an art viewer, not a combat build. The red figure is only a scale proxy. Open the room cards for full review sheets.</p></header><a class="map" href="../Renders/map_overview.png"><img src="../Renders/map_overview.png" alt="Connected dungeon art overview"></a><section class="grid">'''
    page += ''.join(cards) + '</section></main></html>'
    (review / 'Gallery.html').write_text(page, encoding='utf-8')
    summary = {'rooms': len(rooms), 'new_rooms': len([room for room in rooms if room['id'] != '07']), 'renders': len(records), 'new_room_renders': len([r for r in records if r['id'] not in ['07', 'map']]), 'dimensions': [1600, 900], 'unique_images': len(hashes), 'review_sheets': len(rooms)}
    (ROOT / 'Evidence/render-verification.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
    print(json.dumps(summary))


if __name__ == '__main__':
    make_review()
