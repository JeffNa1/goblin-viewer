"""Create review-only map documents outside the game repository."""
from pathlib import Path
from html import escape
import json
import re
import xml.etree.ElementTree as ET

OUT = Path(__file__).resolve().parent
ROOMS = [
    dict(id='01', name='Boat Landing', kind='start', box=[440,1350,180,100], role='Arrive; learn movement without pressure.', pack='None.', layout='Boat, shallow edge water, and a clear northbound landing.', rule='No damage hazards or random enemies. The landing must identify the return point.'),
    dict(id='02', name='Sluice Gate', kind='combat', box=[400,1120,260,160], role='Introduce the first melee and ranged pairing.', pack='Suggested: warriors first; one archer in a later wave.', layout='Two low cover blocks; a wide center lane and two flanks.', rule='No ranged enemy on an unreachable ledge. Keep the entrance landing clear.'),
    dict(id='03', name='Root Court', kind='combat', box=[365,840,330,210], role='First landmark encounter; reveal the route decision.', pack='Suggested: warriors and one shaman. Do not introduce all roles together.', layout='A low root island creates a broad circulation ring.', rule='Open the west and east exits after combat. Show shop and elite-reward symbols before the choice.'),
    dict(id='04', name='Barracks', kind='combat', box=[65,900,220,170], role='Practice flanking around low obstacles.', pack='Suggested: warriors with one archer.', layout='Bunks sit at the edges. Short cover strips divide sightlines, not the whole room.', rule='Every ranged position needs a melee approach. A clue marks the optional secret door.'),
    dict(id='05', name='Ember Smithy', kind='shop', box=[65,710,220,120], role='Offer a predictable spending opportunity on the safer route.', pack='None.', layout='Forge and counter against the west wall; clear passage east of the counter.', rule='Optional purchases never block progression. This room is not on the risky route.'),
    dict(id='06', name='Hunter Cloister', kind='combat', box=[65,460,230,170], role='Test target selection and pursuit.', pack='Suggested: archers with one rogue after an arrival pause.', layout='Two pillars break long sightlines; the exit opens toward the recovery room.', rule='No immediate surround on entry. Keep flank paths wider than the player footprint.'),
    dict(id='07', name='Quiet Sanctuary', kind='rest', box=[380,490,280,130], role='Merge the routes and provide a one-use recovery offer.', pack='None.', layout='Small fountain near the north wall. The south lever opens a return shortcut.', rule='G1 opens only when reached from a valid branch. The recovery cannot be farmed by re-entry.'),
    dict(id='08', name='Flooded Archive', kind='combat', box=[785,870,250,180], role='Offer a clearly signposted environmental risk.', pack='Suggested: warriors and an archer; add the hazard only after the basic encounter works.', layout='Water occupies edge recesses; the center and both approaches remain dry.', rule='Bright shallow water is decorative in the first graybox. Any future damage zone needs a distinct warning.'),
    dict(id='09', name='Blood Vault', kind='elite', box=[785,640,250,150], role='Optional harder encounter that earns the branch reward.', pack='Suggested: one enhanced warrior with shaman support. Exact tuning is untested.', layout='An open center and edge monuments; no pillar maze.', rule='Clearing this encounter unlocks both the reward in 10 and G2. The safer route must not bypass the elite.'),
    dict(id='10', name='Sealed Spoils', kind='reward', box=[805,500,220,90], role='Pay off the elite commitment before route convergence.', pack='None.', layout='A single reward dais and a short passage to the sanctuary.', rule='The chest and G2 stay locked until 09 is cleared. Re-entry does not create more rewards.'),
    dict(id='11', name='Choir Hall', kind='combat', box=[380,250,290,180], role='Final normal encounter; combine previously taught roles.', pack='Suggested: staged warrior, archer, and rogue groups.', layout='Edge columns and an unobstructed north-south lane.', rule='Do not spawn every group at once. Give a quiet interval before the boss door.'),
    dict(id='12', name='Spore Grotto', kind='boss', box=[350,20,350,180], role='A visually distinct finale with a Chieftain encounter.', pack='Suggested: Chieftain. Add helpers only after the solo pattern is readable.', layout='Stepped cave outline, shallow edge pools, broad dry arena.', rule='Keep the center mostly empty. Show attack warnings beneath effects. The exit unlocks after the boss.'),
    dict(id='13', name='Hidden Cache', kind='secret', box=[65,1140,180,100], role='Reward exploration without making it mandatory.', pack='None.', layout='A recessed vault behind a visibly unusual wall panel.', rule='Use a deliberate interaction, not an assumed terrain-destruction system. Secret access cannot gate the boss.'),
    dict(id='14', name='Ascent', kind='exit', box=[800,120,170,100], role='Finish the floor and mark the next destination.', pack='None.', layout='A short upward stair with a strong light cue.', rule='Entry requires the Chieftain clear flag. Do not put another combat encounter here.'),
]
LINKS = [
    dict(a='01',b='02',route='shared',points=[[530,1350],[530,1280]]),
    dict(a='02',b='03',route='shared',points=[[530,1120],[530,1050]]),
    dict(a='03',b='04',route='safe',points=[[365,955],[285,955]]),
    dict(a='04',b='05',route='safe',points=[[175,900],[175,830]]),
    dict(a='05',b='06',route='safe',points=[[175,710],[175,630]]),
    dict(a='06',b='07',route='safe',points=[[295,550],[380,550]]),
    dict(a='03',b='08',route='risk',points=[[695,955],[785,955]]),
    dict(a='08',b='09',route='risk',points=[[910,870],[910,790]]),
    dict(a='09',b='10',route='risk',points=[[910,640],[910,590]],gate='elite09'),
    dict(a='10',b='07',route='risk',points=[[805,550],[660,550]],gate='elite09',label='G2'),
    dict(a='07',b='03',route='shortcut',points=[[520,620],[520,840]],gate='sanctuary07',label='G1'),
    dict(a='07',b='11',route='shared',points=[[520,490],[520,430]]),
    dict(a='11',b='12',route='shared',points=[[520,250],[520,200]]),
    dict(a='12',b='14',route='shared',points=[[700,120],[750,120],[750,170],[800,170]],gate='boss12'),
    dict(a='04',b='13',route='secret',points=[[175,1070],[175,1140]],gate='discover13'),
]
GEOMETRY = json.loads((OUT/'shape-layout.json').read_text(encoding='utf-8'))
for r in ROOMS:
    r.update(GEOMETRY['rooms'][r['id']])
for e in LINKS:
    e['points'] = next(v['points'] for v in GEOMETRY['links'] if (v['a'],v['b']) == (e['a'],e['b']))

COL = {'shared':'#e0c785','safe':'#e0c785','risk':'#ec8a66','shortcut':'#71c9bf','secret':'#bca0d2'}
KINDCOL = {'start':'#71c9bf','combat':'#d7c196','shop':'#edba60','rest':'#89c9b0','elite':'#ec8a66','reward':'#edba60','boss':'#ec8a66','secret':'#bca0d2','exit':'#c3dac4'}

def path(points):
    return 'M'+' L'.join(f'{x},{y}' for x,y in points)

def text(x,y,s,size=14,fill='#d7ccb4',anchor='start',extra=''):
    return f'<text x="{x}" y="{y}" fill="{fill}" font-size="{size}" text-anchor="{anchor}" {extra}>{escape(s)}</text>'

def rect(x,y,w,h,fill,stroke='none',rx=0,extra=''):
    return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{rx}" fill="{fill}" stroke="{stroke}" {extra}/>'

def circle(x,y,r,fill,stroke='none',extra=''):
    return f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" stroke="{stroke}" {extra}/>'

def pillar(x,y):
    return rect(x-12,y-12,24,24,'#7b7960','#b9ae80',3)+rect(x-7,y-7,14,14,'#4b5444')

def torch(x,y):
    return circle(x,y,13,'#d59232',extra='opacity=".13"')+circle(x,y,5,'#e8ad51')+circle(x,y,2,'#fff0b5')

def shape(r):
    return r['outline']

def decor(r):
    i=r['id'];x,y,w,h=r['box'];d=''
    for bx,by,bw,bh in r['blockers']:
        fill='#6c7858' if i=='03' else '#7f7658'
        d+=rect(bx,by,bw,bh,fill,'#aaa27b',3)
        d+=rect(bx+4,by+4,bw-8,bh-8,'#485541')
    if i=='01':
        d+='<path d="M472,1590 l38,-5 17,13 -16,17 -38,-3 -12,-10 Z" fill="#946d42" stroke="#d1aa70" stroke-width="2"/>'
        for n in range(5):d+=rect(518+n*8,1579,4,31,'#9a835a')
    elif i=='02':
        d+='<path d="M577,1313 L640,1350 694,1410" fill="none" stroke="#a09364" stroke-width="2" stroke-dasharray="4 8" opacity=".5"/>'
    elif i=='03':
        d+='<path d="M548,1060 l-6,18 8,18 -3,11 m-3,-25 -17,13 m21,-8 24,8 m-24,-13 20,-18" stroke="#b79965" stroke-width="7" fill="none"/>'
        d+='<path d="M433,1035 Q464,991 508,991 M632,1015 Q667,1035 679,1070 M423,1131 Q449,1173 484,1176" fill="none" stroke="#778666" stroke-width="3" opacity=".7"/>'
    elif i=='04':
        d+='<path d="M96,1046 L176,1021" stroke="#b09968" stroke-width="4"/>'
    elif i=='05':
        d+=circle(137,847,12,'#d5953e')+circle(137,847,5,'#f1c66b')
    elif i=='06':
        d+='<path d="M87,514 V623 H137" fill="none" stroke="#858767" stroke-width="3" opacity=".55"/>'
    elif i=='07':
        d+=rect(485,638,30,22,'#6eb4a1',rx=6)+circle(500,770,5,'#8dd2c0')
        d+='<path d="M433,665 Q438,635 460,627 M540,627 Q565,636 570,665" fill="none" stroke="#a6b99a" stroke-width="2" opacity=".6"/>'
    elif i=='08':
        d+='<path d="M1022,1017 Q961,1041 930,1090 Q916,1147 953,1207" fill="none" stroke="#6dbaa3" stroke-width="5" opacity=".7"/>'
        d+='<path d="M1025,1028 Q976,1050 952,1085" fill="none" stroke="#397765" stroke-width="14" opacity=".5"/>'
    elif i=='09':
        d+='<path d="M915,750 l43,35 -43,33 -43,-33 Z M915,765 l25,20 -25,19 -25,-19 Z" fill="none" stroke="#b98b5d" stroke-width="2"/>'
    elif i in ('10','13'):
        bx,by,bw,bh=r['blockers'][0];d+=rect(bx+bw/2-3,by+3,6,bh-6,'#dfbd70')
    elif i=='11':
        d+=rect(477,352,56,128,'#685238',rx=2,extra='opacity=".55"')
        d+='<path d="M455,335 Q505,300 555,335" fill="none" stroke="#b4a276" stroke-width="2"/>'
    elif i=='12':
        for bx,by,bw,bh in r['blockers']:d+=rect(bx+2,by+2,bw-4,bh-4,'#3f8570',rx=8)
        d+='<path d="M578,118 Q650,65 724,85 Q780,68 824,110 M566,185 Q580,207 603,208" fill="none" stroke="#92a077" stroke-width="3" opacity=".55"/>'
        d+='<path d="M696,130 l12,12 13,-23 13,23 12,-12 -6,35 h-39 Z" fill="#d5ad66" stroke="#eed297" stroke-width="2"/>'
    elif i=='14':
        for n in range(5):d+=rect(981+n*4,385+n*8,51-n*4,5,'#9ca485')
    return d

parts=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1100 1830" width="1100" height="1830" role="img" aria-labelledby="map-title map-desc">',
'<title id="map-title">The Rootbound Sanctum — review floor plan</title><desc id="map-desc">Fourteen spaces. Start at the boat landing at the bottom. Choose the western shop branch or the eastern elite branch. Both join the sanctuary. The northern boss gates the exit. Cyan is a locked return shortcut, not an initial bypass.</desc>',
'<defs><pattern id="grid" width="20" height="20" patternUnits="userSpaceOnUse"><path d="M20,0 H0 V20" fill="none" stroke="#bfb78f" stroke-width=".45" opacity=".13"/></pattern>',
'<pattern id="rock" width="52" height="46" patternUnits="userSpaceOnUse"><path d="M0,12 L18,4 38,12 51,0 M18,4 L15,30 36,44 52,32 M15,30 L0,38" fill="none" stroke="#716955" stroke-width="1" opacity=".18"/></pattern>',
'<style>text{font-family:Segoe UI,Arial,sans-serif}.room{cursor:pointer}.room:hover .outline{stroke:#eee0b9;stroke-width:10}.room.selected .outline{stroke:#f1d392;stroke-width:10}.route-line{fill:none;stroke-width:3;stroke-dasharray:7 6}.room-name{font-weight:600}.markers{display:none}</style>']
for typ,c in COL.items():
    parts.append(f'<marker id="arrow-{typ}" markerWidth="7" markerHeight="7" refX="5" refY="3.5" orient="auto"><path d="M0,0 L6,3.5 0,7 Z" fill="{c}"/></marker>')
for r in ROOMS:
    parts.append(f'<clipPath id="clip-{r["id"]}"><path d="{shape(r)}"/></clipPath>')
parts+=['</defs>',rect(0,0,1100,1830,'#171b17'),rect(0,0,1100,1830,'url(#rock)'),text(40,37,'FIELD ATLAS  /  FLOOR 01',13,'#adad92',extra='letter-spacing="3"'),text(40,76,'THE ROOTBOUND SANCTUM',30,'#eee1c5',extra='font-family="Georgia,serif"'),text(1060,37,'REVISION B / SHAPES',13,'#d6c69b','end'),text(1060,65,'Not a playable build',13,'#969e8a','end'),'<g transform="translate(0,100)">']
# Background river and annotations do not represent navigable routes.
parts.append('<path d="M320,1630 Q415,1515 525,1595 T785,1620 Q865,1545 880,1650" fill="none" stroke="#254c42" stroke-width="82" opacity=".75"/>')
parts.append('<path d="M320,1625 Q415,1510 525,1590 T785,1615 Q865,1540 880,1645" fill="none" stroke="#548977" stroke-width="2" opacity=".5"/>')
parts += [text(45,58,'N',15,'#d4c297'),'<path d="M50,110 V72 m-8,12 8,-13 8,13" stroke="#c5b88f" fill="none" stroke-width="2"/>',text(45,155,'Stone → roots → grotto',13,'#919b87'),text(45,179,'Single traversable level',12,'#778571')]
# True corridor geometry, then room geometry, then door apertures.
for e in LINKS:
    d=path(e['points']);parts.append(f'<path d="{d}" fill="none" stroke="#706e55" stroke-width="58" stroke-linejoin="round"/>')
    parts.append(f'<path d="{d}" fill="none" stroke="#343d30" stroke-width="40" stroke-linejoin="round"/>')
    parts.append(f'<path d="{d}" fill="none" stroke="url(#grid)" stroke-width="40"/>')
for r in ROOMS:
    i=r['id'];x,y,w,h=r['box'];c=KINDCOL[r['kind']];fill={'boss':'#344534','elite':'#49372c','rest':'#364c40','shop':'#494030','secret':'#3c3541'}.get(r['kind'],'#37412f')
    parts.append(f'<g class="room" id="room-{i}" data-room="{i}" tabindex="0" role="button" aria-label="{i} {escape(r["name"])}"><title>{i} — {escape(r["name"])}: {escape(r["role"])}</title>')
    parts.append(f'<path class="outline" d="{shape(r)}" fill="{fill}" stroke="#90866a" stroke-width="8"/>')
    parts.append(f'<path d="{shape(r)}" fill="url(#grid)"/>')
    parts.append(f'<g clip-path="url(#clip-{i})">'+decor(r)+'</g>')
    lx,ly=r['label']
    size=13 if i in ('01','10','13','14') else 15
    ink='style="paint-order:stroke;stroke:#243024;stroke-width:5;stroke-linejoin:round"'
    parts += ['<g class="labels">',text(lx,ly,i+'  '+r['name'],size,'#eee4cb','middle',extra='class="room-name" '+ink),text(lx,ly+15,r['family'].upper(),9.5,c,'middle',extra=ink),'</g>']
    if r['kind'] in ('combat','elite'):
        spots={'02':[(600,1340),(695,1348)],'03':[(455,1050),(625,1085)],'04':[(165,1090),(270,1100)],'06':[(120,618),(235,600)],'08':[(873,1060),(888,1210)],'09':[(878,775),(967,827)],'11':[(470,390),(636,429)]}[i]
        parts.append('<g class="markers">'+''.join(circle(mx,my,8,'#e58661')+text(mx,my+4,letter,9,'#172119','middle') for (mx,my),letter in zip(spots,['W','A']))+'</g>')
    parts.append('</g>')
for e in LINKS:
    for n,(x,y) in enumerate(e['points'][::len(e['points'])-1]):
        p=e['points'];q=p[1] if n==0 else p[-2]
        horizontal=q[1]==y
        parts.append(rect(x-6 if horizontal else x-19,y-19 if horizontal else y-6,12 if horizontal else 38,38 if horizontal else 12,'#343d30'))
    parts.append(f'<path class="route-line route-{e["route"]}" d="{path(e["points"])}" stroke="{COL[e["route"]]}" marker-end="url(#arrow-{e["route"]})"/>')
# Gate and annotation positions follow the revised connector geometry.
parts += [rect(492,848,46,25,'#172822','#71c9bf',3),text(515,866,'G1',14,'#92d6ca','middle'),text(550,855,'RETURN GATE',12,'#92d6ca'),text(550,873,'Opens from 07 only',11,'#a1bba8'),rect(684,621,42,26,'#30231e','#ec8a66',3),text(705,639,'G2',13,'#f0ac85','middle'),text(718,722,'Requires 09 clear',11,'#c9a38a','middle'),text(885,278,'Boss seal',11,'#c9c197','middle')]
parts += [text(45,340,'WESTERN ROUTE',13,'#dfc487',extra='letter-spacing="2"'),text(45,364,'Shop • normal encounters',13,'#a9ae97'),text(780,482,'EASTERN ROUTE',13,'#e9956b',extra='letter-spacing="2"'),text(780,504,'Elite • earned reward',13,'#b6a58d'),text(780,525,'Optional; not a free chest',12,'#89907d'),text(65,1490,'Secret: optional clue',12,'#b6a0c7'),text(820,1370,'ARCHITECTURE PASS',12,'#adad92',extra='letter-spacing="2"'),text(820,1394,'Oval court · apse · transept',13,'#979f8a'),text(820,1416,'Crescent shore · eroded cave',13,'#979f8a'),text(820,1438,'Same routes; distinct spaces',13,'#979f8a'),text(620,1695,'ENTER FROM THE RIVER',13,'#9dc6b2','middle',extra='letter-spacing="3"'),'</g>']
parts.append('</svg>')
SVG=''.join(parts)
ET.fromstring(SVG)
(OUT/'floorplan.svg').write_text(SVG,encoding='utf-8')

# A separate progression drawing is explicitly not a floor plan.
flow=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1100 370" role="img" aria-label="Progression: landing, gate, court, two branches, sanctuary, choir, boss and exit">',rect(0,0,1100,370,'#1c241d')]
pos={'01':(70,185),'02':(180,185),'03':(290,185),'04':(425,85),'05':(540,85),'06':(655,85),'08':(425,260),'09':(540,260),'10':(655,260),'07':(780,185),'11':(895,185),'12':(1000,185),'14':(1000,65),'13':(425,20)}
for e in LINKS:
    a=pos[e['a']];b=pos[e['b']]
    if e['route']=='shortcut':
        d=path([a,(780,335),(290,335),b])
    else:d=path([a,b])
    flow.append(f'<path d="{d}" fill="none" stroke="{COL[e["route"]]}" stroke-width="2" '+('stroke-dasharray="5 5"' if e.get('gate') else '')+'/>')
for r in ROOMS:
    x,y=pos[r['id']];c=KINDCOL[r['kind']]
    flow+= [rect(x-35,y-17,70,34,'#293529',c,5),text(x,y+5,r['id'],14,c,'middle')]
    if r['id']!='13':flow.append(text(x,y+37,r['name'],10,'#d6cdb8','middle'))
flow += [text(555,356,'G1: optional return shortcut after reaching 07',12,'#71c9bf','middle'),text(740,267,'G2',12,'#ec8a66'),text(480,23,'13 — optional secret',11,'#bca0d2'),'</svg>']
FLOW=''.join(flow);ET.fromstring(FLOW)
(OUT/'progression.svg').write_text(FLOW,encoding='utf-8')

DATA={'status':'REVIEW ONLY — no playable game implementation','unit':'U = provisional player-footprint planning unit; not a voxel','rooms':ROOMS,'links':LINKS,'routes':{'safe':['01','02','03','04','05','06','07','11','12','14'],'risk':['01','02','03','08','09','10','07','11','12','14']},'assumptions':{'camera':'Fixed elevated three-quarter view; north stays consistent','player_footprint_U':1,'dash_U':4,'door_width_U':4,'corridor_width_U':4,'target_floor_minutes':[12,18],'verified_in_game':False}}
(OUT/'design.json').write_text(json.dumps(DATA,indent=2),encoding='utf-8')

research=(OUT/'research.md').read_text(encoding='utf-8').split('\n## Sources\n')[0]
def md_simple(md):
    html=[]; inlist=False
    for line in md.splitlines():
        if re.match(r'^\d+\. ',line):
            if not inlist:html.append('<ol>');inlist=True
            html.append('<li>'+escape(re.sub(r'^\d+\. ','',line))+'</li>');continue
        if inlist:html.append('</ol>');inlist=False
        if not line:continue
        match=re.match(r'^(#{1,4}) (.*)',line)
        if match:
            n=min(len(match[1])+1,5);html.append(f'<h{n}>'+escape(match[2])+f'</h{n}>')
        else:html.append('<p>'+escape(line)+'</p>')
    if inlist:html.append('</ol>')
    result=''.join(html)
    result=re.sub(r'\*\*(.*?)\*\*',r'<strong>\1</strong>',result)
    result=re.sub(r'\[(\d+)\]',r'<a href="#source-\1">[\1]</a>',result)
    return result

sources=json.loads((OUT/'sources.json').read_text(encoding='utf-8'))
if isinstance(sources,dict):
    source_list=sources.get('sources',[])
else:source_list=sources
if isinstance(source_list,dict):source_list=[dict(v,id=k) for k,v in source_list.items()]
used={1,2,3,4,5,7,8,9,10,11,12,14}
refs=[]
for s in source_list:
    sid=int(s['id'])
    if sid in used:
        u=s['url'];refs.append(f'<p id="source-{sid}"><b>[{sid}]</b> <a href="{escape(u)}" target="_blank" rel="noreferrer">{escape(s.get("title") or u)}</a></p>')
reference_html=''.join(refs)

CSS='''
:root{color-scheme:dark;--ink:#eee3cb;--muted:#a8b09a;--line:#465240;--gold:#d9bd7e;--paper:#192119;--card:#232d22;--teal:#81c8b6;--risk:#e99872}
*{box-sizing:border-box}body{margin:0;background:var(--paper);color:var(--ink);font-family:Segoe UI,Arial,sans-serif;line-height:1.6}a{color:var(--gold)}button{font:inherit;cursor:pointer}button:focus-visible,a:focus-visible,[tabindex]:focus-visible{outline:3px solid var(--teal);outline-offset:4px}header{padding:35px 5vw 26px;border-bottom:1px solid var(--line);background:linear-gradient(115deg,#303b29,#18231d)}.eyebrow{font-size:12px;letter-spacing:3px;text-transform:uppercase;color:var(--gold)}h1{font:clamp(30px,4vw,53px)/1.15 Georgia,serif;max-width:950px;margin:12px 0}header p{max-width:780px;color:#c6cdb7;margin:14px 0}h2{font:30px Georgia,serif;margin:0 0 18px}h3{font:23px Georgia,serif;margin:24px 0 10px}h4{font-size:19px;color:var(--gold);margin:24px 0 8px}p{margin:10px 0}nav{display:flex;gap:8px;flex-wrap:wrap;margin-top:24px}.tab,.toggle{background:transparent;border:1px solid var(--line);color:var(--muted);padding:9px 16px;border-radius:4px}.tab[aria-selected=true],.toggle[aria-pressed=true]{background:#d9bd7e;color:#20251b;border-color:#d9bd7e}main{padding:25px 4vw 45px}.panel[hidden]{display:none}.layout{display:grid;grid-template-columns:minmax(480px,1fr) 320px;gap:25px;max-width:1480px}.map-shell{border:1px solid var(--line);background:#171b17;overflow:auto}.map-shell>svg{display:block;width:100%;height:auto;min-width:480px}.toolbar{display:flex;align-items:center;gap:8px;flex-wrap:wrap;padding:12px 16px;border-bottom:1px solid var(--line)}.toggle{font-size:12px;padding:5px 10px}.sidebar{position:sticky;top:20px;align-self:start}.card{border:1px solid var(--line);background:var(--card);padding:20px;margin-bottom:18px;border-radius:3px}.card h3{margin-top:0}.mini{font-size:12px;color:var(--muted)}.tag{font-size:11px;letter-spacing:2px;color:var(--gold);text-transform:uppercase}.metric{font:37px Georgia,serif}.legend{display:grid;grid-template-columns:12px 1fr;gap:8px 12px;font-size:13px}.swatch{height:3px;align-self:center}.warn{border-left:3px solid var(--risk);padding:12px 16px;background:#342c22;font-size:14px}.route{padding:9px 0;color:#d0cab4;font-size:13px}.route strong{color:var(--gold)}.roomgrid{display:grid;grid-template-columns:repeat(auto-fit,minmax(270px,1fr));gap:16px;max-width:1350px}.roomgrid .card{margin:0}.roomgrid h3{font-size:24px}.prose{max-width:950px}.prose p{color:#c4cbb7}.prose a{overflow-wrap:anywhere}.prose li{margin:10px 0}.figure{border:1px solid var(--line);padding:15px;margin:20px 0;overflow:auto}.figure>svg{min-width:780px;width:100%;height:auto;display:block}.design-cols{display:grid;grid-template-columns:1fr 1fr;gap:24px;max-width:1100px}.pill{display:inline-block;border:1px solid #6e7455;border-radius:20px;padding:3px 10px;font-size:12px;margin:4px 5px 4px 0;color:#cec9ae}.hide-routes .route-line{display:none}.hide-labels .labels{display:none}.show-markers .markers{display:block}.footer{border-top:1px solid var(--line);padding:22px 5vw;color:var(--muted);font-size:13px}@media(max-width:900px){.layout{grid-template-columns:minmax(0,1fr)}.sidebar{position:static;display:grid;grid-template-columns:1fr 1fr;gap:15px}.sidebar .card{margin:0}.sidebar .card:first-child{grid-column:1/-1}.design-cols{grid-template-columns:1fr}.map-shell>svg{min-width:0}}@media(max-width:520px){main{padding:16px 10px}.sidebar{display:block}.sidebar .card{margin-bottom:12px}.toolbar{gap:6px}.tab{padding:8px 10px}header{padding:25px 18px}}@media print{body{background:white;color:#222}header,nav,.toolbar,.sidebar,.footer{display:none}main{padding:0}.layout{display:block}.map-shell{border:0}.map-shell>svg{width:100%;max-height:270mm}.panel:not(#layout){display:none!important}.panel#layout{display:block!important}}
'''
roomcards=''.join(f'<article class="card"><span class="tag">{r["id"]} / {r["kind"]}</span><h3>{escape(r["name"])}</h3><p>{escape(r["role"])}</p><p class="mini">{escape(r["layout"])}</p><p><strong>Encounter idea.</strong> {escape(r["pack"])}</p><p class="mini"><strong>Guardrail.</strong> {escape(r["rule"])}</p></article>' for r in ROOMS)
HTML='''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Rootbound Sanctum — shape revision B</title><style>'''+CSS+'''</style></head><body><header><div class="eyebrow">Goblin Viewer / a voxel action-roguelike direction</div><h1>The Rootbound Sanctum</h1><p>Shape revision B: an oval court, a cruciform hall, a crescent shoreline, and an eroded grotto. The approved progression and gate rules remain unchanged.</p><span class="pill">14 reshaped spaces</span><span class="pill">2 primary route choices</span><span class="pill">1 gated return shortcut</span><span class="pill">10-game research study</span><nav role="tablist" aria-label="Review sections"><button class="tab" role="tab" aria-selected="true" aria-controls="layout" data-tab="layout">Floor plan</button><button class="tab" role="tab" aria-selected="false" aria-controls="progression" data-tab="progression">Routes & generation</button><button class="tab" role="tab" aria-selected="false" aria-controls="rooms" data-tab="rooms">Room briefs</button><button class="tab" role="tab" aria-selected="false" aria-controls="research" data-tab="research">Research & sources</button></nav></header><main>
<section id="layout" class="panel" role="tabpanel"><div class="layout"><div class="map-shell"><div class="toolbar"><span class="mini">Click a room to inspect.</span><button class="toggle" data-toggle="hide-routes" aria-pressed="true">Routes</button><button class="toggle" data-toggle="hide-labels" aria-pressed="true">Labels</button><button class="toggle" data-toggle="show-markers" aria-pressed="false">Example markers</button></div>'''+SVG+'''</div><aside class="sidebar"><div class="card" id="detail" aria-live="polite"></div><div class="card"><h3>Read the plan</h3><div class="legend"><span class="swatch" style="background:#e0c785"></span><span>Shared / shop route</span><span class="swatch" style="background:#ec8a66"></span><span>Elite route / earned reward</span><span class="swatch" style="background:#71c9bf"></span><span>G1: shortcut, initially locked</span><span class="swatch" style="background:#bca0d2"></span><span>Optional secret connection</span></div><p class="mini">Arrows indicate first-pass intent. Cleared corridors permit return travel unless a gate remains locked. Example markers show illustrative warrior (W) and archer (A) positions, not final encounters.</p></div><div class="card"><h3>Two honest choices</h3><p class="route"><strong>West:</strong> 03 → 04 → 05 → 06 → 07<br>Normal encounters and a shop.</p><p class="route"><strong>East:</strong> 03 → 08 → 09 → 10 → 07<br>Harder encounter and an earned reward.</p><p class="mini">Both routes reach recovery. No mandatory key is hidden in the secret room. The map does not promise that every room must be visited.</p></div><div class="warn">All dimensions are provisional. U means a future player-footprint unit, not a voxel. The project has no verified playable dungeon to calibrate these measurements.</div></aside></div></section>
<section id="progression" class="panel" role="tabpanel" hidden><div class="prose"><div class="eyebrow">A route diagram is not a floor plan</div><h2>Structure before randomness</h2><p>One opening, two branches, a guaranteed recovery point, and a final push. Revision B changes silhouettes and room placement, not the connection graph. Curves express architectural intent; a later voxel build must translate them into stepped contours. This is not output from a working generator.</p></div><div class="figure">'''+FLOW+'''</div><div class="design-cols"><div><h3>Why this shape</h3><p>Choose a connected miniature dungeon for the first floor. The reference image suggests exploration and place; this proposal preserves that identity without a maze of narrow corridors.</p><p>A Hades-like forward-only sequence is the simpler alternative. It offers stronger pace control but less spatial exploration. A large free-form maze is not recommended for the first playable slice.</p><h3>Gate logic</h3><p><strong>G1:</strong> reach 07 via either valid branch, then use its lever. This opens the 07 ↔ 03 return shortcut. It is not an initial escape from the route choice.</p><p><strong>G2:</strong> clear 09 before the 10 ↔ 07 connection opens. Room 10's reward also requires that clear flag. The west route cannot enter the reward room from behind for free.</p><p><strong>Boss seal:</strong> 12 → 14 opens after the Chieftain encounter. Normal combat seals release after their room is clear.</p><p>Backtracking remains possible after a clear. Rewards and recovery are one-use. There is no enemy respawn farm in this proposal.</p></div><div><h3>Generation proposal — later, after approval</h3><ol><li>Choose a small approved route skeleton. Fix entrance, recovery, boss, and exit roles.</li><li>Select authored room variants that support their door directions and combat needs.</li><li>Place rooms without overlaps. Join compatible sockets with short, wide corridors.</li><li>Reserve a continuous walking lane. Add a curated encounter pack outside the entry buffer.</li><li>Add edge decoration and limited hazards. Never cover door landings or attack warnings.</li><li>Check connectivity, gate state, reward access, player clearance, melee reachability, and camera obstruction. Reject invalid layouts; fall back to a known-good layout.</li></ol><p class="mini">Use separate random choices for structure, encounters, and decoration so a visual change does not unexpectedly change the critical path. This is a proposed reproducibility rule, not code that exists now.</p></div><div><h3>Fixed versus variable</h3><p><strong>Fixed:</strong> functional room roles, a reachable exit, recovery before the final stretch, and earned elite rewards.</p><p><strong>Variable:</strong> compatible room silhouettes, valid door variants, encounter packs, reward offers, and edge decoration. Keep a landmark recognizable.</p><p><strong>Not random:</strong> every floor voxel, arbitrary mandatory keys, spawn points anywhere, or camera-occluding walls in the combat lane.</p></div><div><h3>First graybox acceptance — not yet authorized</h3><p>Assume a fixed elevated camera, a 1 U footprint, a 4 U dash, and 4 U doors and corridors. Each is a hypothesis to check, not a measured gameplay value.</p><p>Walk and dash through every socket. Reach every mandatory enemy with melee. Check both routes with a weak melee loadout. Confirm G1 and G2 cannot skip their prerequisites.</p><p>Target 12–18 minutes for one floor only as an initial pacing goal. If travel dominates combat, shorten connectors before adding more rooms.</p><p>The player may clear both branches, so total duration and resources need separate tests. Do not advertise the time target as achieved.</p></div></div></section>
<section id="rooms" class="panel" role="tabpanel" hidden><div class="prose"><div class="eyebrow">Authored room library / proposal</div><h2>Each room earns its footprint</h2><p>These are combat intentions, not working AI specifications. Current goblin models suggest roles; their playable behavior still needs a separate implementation and test.</p></div><div class="roomgrid">'''+roomcards+'''</div></section>
<section id="research" class="panel prose" role="tabpanel" hidden>'''+md_simple(research)+'''<h2>Sources</h2>'''+reference_html+'''</section></main><footer class="footer">Review only. No Godot scene, game script, generated level, or repository asset was changed. Floor plan and route diagram are original proposals. Approval still required before a playable graybox.</footer><script>
const rooms='''+json.dumps(ROOMS)+''';
function selectRoom(id){const r=rooms.find(x=>x.id===id);if(!r)return;document.querySelectorAll('.room').forEach(n=>n.classList.toggle('selected',n.dataset.room===id));const box=document.getElementById('detail');box.replaceChildren();const fields=[['span',r.id+' / '+r.kind,'tag'],['h3',r.name,''],['p',r.role,''],['p',r.layout,'mini'],['p','Encounter idea: '+r.pack,'mini'],['p','Guardrail: '+r.rule,'mini'],['p',(r.box[2]/10)+' × '+(r.box[3]/10)+' U envelope. Placeholder scale; no playtest yet.','mini']];for(const [tag,value,cls] of fields){const n=document.createElement(tag);n.className=cls;n.textContent=value;box.append(n)}}
document.querySelectorAll('[data-room]').forEach(n=>{n.addEventListener('click',()=>selectRoom(n.dataset.room));n.addEventListener('keydown',e=>{if(e.key==='Enter'||e.key===' '){e.preventDefault();selectRoom(n.dataset.room)}})});
document.querySelectorAll('[data-tab]').forEach(b=>b.addEventListener('click',()=>{document.querySelectorAll('[data-tab]').forEach(t=>t.setAttribute('aria-selected',String(t===b)));document.querySelectorAll('.panel').forEach(p=>p.hidden=p.id!==b.dataset.tab)}));
document.querySelectorAll('[data-toggle]').forEach(b=>b.addEventListener('click',()=>{const shell=document.querySelector('.map-shell');shell.classList.toggle(b.dataset.toggle);b.setAttribute('aria-pressed',String(b.getAttribute('aria-pressed')!=='true'))}));
selectRoom('03');
</script></body></html>'''
(OUT/'review.html').write_text(HTML,encoding='utf-8')

# The artifact checks only its schematic graph and document consistency.
ids={r['id'] for r in ROOMS}
assert len(ids)==len(ROOMS)==14
assert all(e['a'] in ids and e['b'] in ids for e in LINKS)
for route in DATA['routes'].values():
    assert route[0]=='01' and route[-1]=='14'
    assert all(any({a,b}=={e['a'],e['b']} for e in LINKS) for a,b in zip(route,route[1:]))
for i,a in enumerate(ROOMS):
    ax,ay,aw,ah=a['box']
    for b in ROOMS[i+1:]:
        bx,by,bw,bh=b['box']
        assert ax+aw<=bx or bx+bw<=ax or ay+ah<=by or by+bh<=ay,(a['id'],b['id'])

def reachable(flags,start='01'):
    reached={start}
    while True:
        previous=set(reached)
        for e in LINKS:
            if e.get('gate') and e['gate'] not in flags:continue
            if e['a'] in reached or e['b'] in reached:reached.update([e['a'],e['b']])
        if reached==previous:return reached
assert '07' in reachable(set())
assert '10' not in reachable(set())
assert '14' not in reachable(set())
assert '13' not in reachable(set())
assert '10' in reachable({'elite09'})
assert '14' in reachable({'boss12'})
assert len(reachable({'elite09','boss12','sanctuary07','discover13'}))==14
# Check that both shortcut edges are locked at the beginning.
assert all(e.get('gate') for e in LINKS if e.get('label') in ('G1','G2'))
checks={'rooms':len(ROOMS),'links':len(LINKS),'primary_routes':len(DATA['routes']),'room_envelope_overlaps':0,'all_rooms_reachable_with_prerequisites':True,'elite_reward_blocked_without_clear':True,'boss_exit_blocked_without_clear':True,'svg_xml_parses':True,'gameplay_tested':False}
(OUT/'design-checks.json').write_text(json.dumps(checks,indent=2),encoding='utf-8')
print(json.dumps(checks,indent=2))
print('Created review.html, floorplan.svg, progression.svg, design.json, and design-checks.json outside the game repository.')
