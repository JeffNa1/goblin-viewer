from pathlib import Path
import json,hashlib,html
from PIL import Image,ImageDraw,ImageFont
HERE=Path(__file__).resolve().parent
R=HERE/'Renders'; OUT=HERE/'Review'; OUT.mkdir(exist_ok=True)
manifest=json.loads((R/'manifest.json').read_text())
expected={(f"{i:02d}",v) for i in range(1,15) for v in ['shoulder','eye_level','overview','detail']}|{('map','overview')}
assert {(r['id'],r['view']) for r in manifest}==expected and len(manifest)==len(expected)
hashes=[]
for r in manifest:
    path=R/(r['id']+'_'+r['view']+'.png'); image=Image.open(path)
    assert image.size==(1600,900)
    hashes.append(hashlib.sha256(path.read_bytes()).hexdigest())
assert len(set(hashes))==len(expected)
font=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',22)
small=ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',16)
meta=json.loads((HERE/'Evidence/baseline-rooms.json').read_text())
cards=[]
for room in meta:
    id=room['id'];sheet=Image.new('RGB',(1648,1040),'#13231e');draw=ImageDraw.Draw(sheet)
    draw.text((18,10),id+' | '+room['name']+' | CARVED ROOM REVIEW',font=font,fill='#ded6b3')
    for j,view in enumerate(['shoulder','eye_level','detail','overview']):
        image=Image.open(R/(id+'_'+view+'.png')).resize((800,450),Image.Resampling.LANCZOS)
        x=16+(j%2)*816;y=76+(j//2)*480
        sheet.paste(image,(x,y));draw.text((x,y-24),view.upper(),font=small,fill='#b5cbb8')
    sheet.save(OUT/('Room_'+id+'.png'))
    cards.append('<section><h2>'+html.escape(id+' '+room['name'])+'</h2>'+''.join('<figure><a href="../Renders/'+id+'_'+v+'.png"><img src="../Renders/'+id+'_'+v+'.png"></a><figcaption>'+v+'</figcaption></figure>' for v in ['shoulder','eye_level','detail','overview'])+'</section>')
board=Image.new('RGB',(1648,1940),'#13231e');draw=ImageDraw.Draw(board)
draw.text((18,12),'ROOTBOUND SANCTUM | 14 CARVED ROOMS',font=font,fill='#ded6b3')
for j,room in enumerate(meta):
    image=Image.open(R/(room['id']+'_eye_level.png')).resize((528,297),Image.Resampling.LANCZOS)
    x=16+(j%3)*544;y=94+(j//3)*360
    board.paste(image,(x,y));draw.text((x,y-28),room['id']+' '+room['name'],font=small,fill='#ded6b3')
board.save(OUT/'All_Rooms.png')
(OUT/'Gallery.html').write_text('<!doctype html><meta charset="utf-8"><title>Rootbound Carved Rooms</title><style>body{background:#13231e;color:#ded6b3;font:18px system-ui;margin:24px}section{display:flex;flex-wrap:wrap;border-bottom:1px solid #65776b;margin-bottom:30px}h2{width:100%}figure{width:46%;margin:1%}img{width:100%}figcaption{padding:8px}a{color:inherit}</style><h1>Rootbound Sanctum — all carved rooms</h1><p>Real Godot renders. Room 07 retains its approved cubic geometry. The red figure is a review scale proxy, not the player.</p><p>Arrow keys: rooms. 1 shoulder, 2 eye level, 3 overview, 4 detail. M all rooms, H labels. Art viewer only; not a gameplay build.</p>'+''.join(cards),encoding='utf-8')
report={'rooms':len(meta),'views':len(manifest),'unique_images':len(set(hashes)),'room_sheets':len(meta),'dimensions':[1600,900],'startup_captures':[p.name for p in R.glob('loading_*.png')]}
(OUT/'counts.json').write_text(json.dumps(report,indent=2));print(json.dumps(report))
