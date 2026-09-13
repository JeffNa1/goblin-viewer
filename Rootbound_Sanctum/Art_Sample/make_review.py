from pathlib import Path
from urllib.request import Request, urlopen
from PIL import Image, ImageDraw, ImageFont, ImageOps
import hashlib
import json
import zipfile

ROOT = Path(__file__).resolve().parent
FONT = Path('C:/Windows/Fonts/segoeui.ttf')
BOLD = Path('C:/Windows/Fonts/segoeuib.ttf')


def font(size, bold=False):
    return ImageFont.truetype(str(BOLD if bold else FONT), size)


def make_contact_sheet():
    records = json.loads((ROOT / 'Renders/manifest.json').read_text())
    expected = ['shoulder', 'corridor', 'eye_level', 'overview', 'detail']
    assert len(records) == len(expected)
    assert {r['view'] for r in records} == set(expected)
    sheet = Image.new('RGB', (1664, 1630), '#0e2428')
    draw = ImageDraw.Draw(sheet)
    draw.text((32, 20), 'ROOTBOUND SANCTUM  /  ROOM 07', font=font(34, True), fill='#e1c999')
    draw.text((32, 69), 'Actual Godot captures | One isolated sanctuary and corridor | Scale figure only', font=font(20), fill='#9fbcb3')
    labels = {
        'shoulder': '01  CLOSE SHOULDER',
        'corridor': '02  CORRIDOR APPROACH',
        'eye_level': '03  EYE LEVEL',
        'overview': '04  FULL SAMPLE FOOTPRINT',
        'detail': '05  SHRINE DETAIL',
    }
    for index, name in enumerate(expected):
        x = 32 + (index % 2) * 816
        y = 120 + (index // 2) * 500
        image = Image.open(ROOT / 'Renders' / f'{name}.png').convert('RGB')
        assert image.size == (1600, 900)
        sheet.paste(image.resize((800, 450), Image.Resampling.LANCZOS), (x, y))
        draw.text((x, y + 462), labels[name], font=font(18, True), fill='#d6c79f')
    x, y = 848, 1140
    for index, text in enumerate([
        'REVIEW GATE',
        'Stone ruins / root shrine / jade water / warm fire',
        '90 walking samples and 5 camera poses passed.',
        'Original map files remain unchanged.',
        'No character-source dependencies.',
        'Not a combat test or the complete 14-room dungeon.',
    ]):
        draw.text((x, y + index * 43), text, font=font(23 if index == 0 else 19, index == 0), fill='#d6c79f' if index == 0 else '#a7beb1')
    sheet.save(ROOT / 'Review_Sheet.png')


def make_reference_board():
    refs = [
        {'id': 12, 'file': 'jungle-awakens.jpg', 'title': 'MINECRAFT DUNGEONS / JUNGLE AWAKENS', 'credit': 'Official Minecraft artwork', 'note': 'Study: block foliage, stepped stone, palette clusters.', 'image_url': 'https://www.minecraft.net/content/dam/minecraftnet/franchise/component-library/carouselN/jungle-awakens/MinecraftDungeons_JungleAwakens_2880x1320.jpg'},
        {'id': 6, 'file': 'stylized-ruins.jpg', 'title': 'STYLIZED MODULAR RUINS', 'credit': '80 Level / source artist credited in article', 'note': 'Study: ruin silhouettes, pale stone and moss placement.', 'image_url': 'https://cdn.80.lv/api/upload/content/e5/images/679135b067e26/widen_920x0.jpeg'},
        {'id': 7, 'file': 'forest-ruins.jpg', 'title': 'DARK FANTASY FOREST RUINS', 'credit': '80 Level / source artist credited in article', 'note': 'Study: a clear focal point and foreground framing.', 'image_url': 'https://cdn.80.lv/api/upload/content/68/images/6a35eaa797b7b/widen_920x0.jpg'},
    ]
    ledger = json.loads((ROOT / 'References/sources.json').read_text())
    urls = {v['id']: v['url'] for v in ledger['sources']}
    board = Image.new('RGB', (1600, 1075), '#0e2428')
    draw = ImageDraw.Draw(board)
    draw.text((30, 24), 'ROOTBOUND SANCTUM / VISUAL REFERENCES', font=font(32, True), fill='#e1c999')
    draw.text((30, 75), 'Source artwork for study only. These are NOT project renders. No source models or textures were copied.', font=font(20), fill='#a7beb1')
    for index, ref in enumerate(refs):
        path = ROOT / 'References' / ref['file']
        if not path.exists():
            with urlopen(Request(ref['image_url'], headers={'User-Agent': 'Mozilla/5.0'}), timeout=60) as response:
                path.write_bytes(response.read())
        image = Image.open(path).convert('RGB')
        panel = ImageOps.contain(image, (480, 300), Image.Resampling.LANCZOS)
        x, y = 30 + index * 520, 140
        board.paste(panel, (x + (480 - panel.width) // 2, y + (300 - panel.height) // 2))
        draw.text((x, 462), ref['title'], font=font(18, True), fill='#e1c999')
        draw.text((x, 495), ref['credit'], font=font(17), fill='#a7beb1')
        draw.text((x, 528), ref['note'], font=font(17), fill='#a7beb1')
        ref['page_url'] = urls[ref['id']]
        ref['sha256'] = hashlib.sha256(path.read_bytes()).hexdigest()
    draw.line((30, 590, 1570, 590), fill='#3d5a51', width=2)
    draw.text((30, 616), 'APPLICATION TO ROOM 07', font=font(26, True), fill='#e1c999')
    notes = [
        'Architecture: stepped portals, broken vault ribs, carved guardian panels, thinner slab joints.',
        'Focal point: one branching heartwood shrine, jade light, shallow water, candles.',
        'Close camera: physical corridor masonry; edge dressing stays outside the approach.',
        'Scope: art review only. Gameplay camera, enemies and combat remain outside this sample.',
    ]
    for index, note in enumerate(notes):
        draw.text((30, 665 + index * 42), note, font=font(21), fill='#a7beb1')
    draw.text((30, 865), 'SOURCE PAGES', font=font(22, True), fill='#e1c999')
    for index, ref in enumerate(refs):
        draw.text((30, 906 + index * 42), f"[{ref['id']}] {ref['page_url']}", font=font(17), fill='#a7beb1')
    board.save(ROOT / 'References/Reference_Board.png')
    (ROOT / 'References/manifest.json').write_text(json.dumps(refs, indent=2), encoding='utf-8')


def make_review_pack():
    files = [ROOT / 'README.md', ROOT / 'Review_Sheet.png', ROOT / 'References/Reference_Board.png', ROOT / 'References/manifest.json']
    files.extend(sorted((ROOT / 'Renders').glob('*.png')))
    files.append(ROOT / 'Renders/manifest.json')
    files.extend(ROOT / 'Evidence' / name for name in ['acceptance.json', 'acceptance-run.json', 'render-run.json', 'map-preservation.json'])
    target = ROOT / 'Sanctuary_Review_Pack.zip'
    with zipfile.ZipFile(target, 'w', zipfile.ZIP_DEFLATED) as archive:
        for path in files:
            archive.write(path, path.relative_to(ROOT))
    with zipfile.ZipFile(target) as archive:
        assert archive.testzip() is None
        assert len(archive.namelist()) == len(files)
    print(json.dumps({'review_pack': str(target), 'files': len(files), 'bytes': target.stat().st_size, 'renders': 5}))


if __name__ == '__main__':
    make_contact_sheet()
    make_reference_board()
    make_review_pack()
