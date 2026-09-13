"""Build exact before/after sheets from the incrementally recorded Godot captures."""
from pathlib import Path
import hashlib
import json
from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
VIEWS = ['shoulder', 'eye_level', 'carving', 'fountain', 'vessels', 'portal', 'overview', 'corridor']
OUT = HERE / 'Review'
OUT.mkdir(exist_ok=True)
FONT = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', 23)
SMALL = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', 17)
records = {phase: json.loads((HERE / 'Renders' / phase / 'manifest.json').read_text()) for phase in ['before','after']}
checks=[]
for phase in records:
    assert len(records[phase]) == len(VIEWS)
    assert sorted(r['view'] for r in records[phase]) == sorted(VIEWS)
for view in VIEWS:
    a = next(r for r in records['before'] if r['view']==view)
    b = next(r for r in records['after'] if r['view']==view)
    for key in ['camera','basis','fov','projection','size','width','height']:
        assert a[key]==b[key], (view,key,a[key],b[key])
    images=[]
    hashes=[]
    for phase in ['before','after']:
        path=HERE/'Renders'/phase/(view+'.png')
        image=Image.open(path).convert('RGB')
        assert image.size==(1600,900)
        assert image.getextrema()!=((0,0),(0,0),(0,0))
        images.append(image)
        hashes.append(hashlib.sha256(path.read_bytes()).hexdigest())
    assert hashes[0]!=hashes[1], view
    # Full width views, stacked, retain useful detail without skewing camera comparisons.
    sheet=Image.new('RGB',(1648,1940),'#112521')
    draw=ImageDraw.Draw(sheet)
    draw.text((24,12),'ROOM 07  /  '+view.replace('_',' ').upper(),font=FONT,fill='#dfcb9d')
    for index,(phase,image) in enumerate(zip(['BASELINE — PREVIOUS SESSION','NEW — TRUE CUBIC CARVING'],images)):
        y=52+index*940
        draw.text((24,y),phase,font=SMALL,fill='#b2c8b9')
        sheet.paste(image,(24,y+28))
    sheet.save(OUT/('Compare_'+view+'.png'))
    checks.append({'view':view,'matching_camera':True,'before_sha256':hashes[0],'after_sha256':hashes[1]})
board=Image.new('RGB',(1648,1992),'#112521')
draw=ImageDraw.Draw(board)
draw.text((24,16),'QUIET SANCTUARY / AUTHORED CUBIC CARVING',font=FONT,fill='#dfcb9d')
for index,view in enumerate(VIEWS):
    x=24+(index%2)*812
    y=64+(index//2)*482
    draw.text((x,y),view.replace('_',' ').upper(),font=SMALL,fill='#c5d5c3')
    im=Image.open(HERE/'Renders/after'/(view+'.png')).convert('RGB').resize((800,450))
    board.paste(im,(x,y+26))
board.save(OUT/'All_Views.png')
report={'room':'07','views':len(VIEWS),'captures':sum(len(r) for r in records.values()),'dimensions':[1600,900],'all_camera_pairs_match':True,'unique_images':len({r[k] for r in checks for k in ['before_sha256','after_sha256']}),'comparisons':checks}
assert report['unique_images']==report['captures']
(HERE/'Evidence/render-verification.json').write_text(json.dumps(report,indent=2))
html='<!doctype html><meta charset="utf-8"><title>Room 07 cubic carving</title><style>body{background:#112521;color:#dacda8;font:18px system-ui;margin:30px}img{max-width:100%;height:auto}a{color:#b4dbc4}section{margin-bottom:40px}</style><h1>Room 07 — true cubic carving</h1><p>Actual Godot renders. Each pair has the same camera and resolution. Baseline is the previous session, not the original coarse sample.</p>'
for view in VIEWS:
    html+='<section><h2>'+view.replace('_',' ').title()+'</h2><img src="Compare_'+view+'.png"></section>'
(OUT/'Gallery.html').write_text(html,encoding='utf-8')
print(json.dumps({k:v for k,v in report.items() if k!='comparisons'}))
