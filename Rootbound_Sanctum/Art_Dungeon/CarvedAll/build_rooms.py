"""Room-specific cubic art. Preserve the approved sanctuary and planning geometry."""
from pathlib import Path
import sys,json,math,struct
import numpy as np
HERE=Path(__file__).resolve().parent
PROJECT=HERE.parents[2]
sys.path.insert(0,str(HERE.parent/'Carved07'))
import build_art as art
from voxels import Volume
from build_art import ellipsoid,stroke,leaf,ring,STONE,PALE,LIGHT,DARK,GOLD,BRONZE,JADE,LEAVES,BARK
SOURCE=json.loads((PROJECT/'data/rootbound_layout.json').read_text())
META={r['id']:r for r in json.loads((HERE/'Evidence/baseline-rooms.json').read_text())}

class RoomModel(art.Model):
    def __init__(self,id):
        super().__init__()
        self.id=id
        self.offset=np.zeros(3)
    def add(self,name,v,placements=None,material=0):
        placements=placements or [((0,0,0),0)]
        super().add(name,v,[(tuple(np.asarray(p)+self.offset),yaw) for p,yaw in placements],material)
    def save(self):
        self.document['buffers']=[{'byteLength':len(self.binary)}]
        text=json.dumps(self.document,separators=(',',':')).encode(); text+=b' '*((-len(text))%4)
        self.binary+=b'\0'*((-len(self.binary))%4)
        data=struct.pack('<III',0x46546c67,2,28+len(text)+len(self.binary))
        data+=struct.pack('<II',len(text),0x4e4f534a)+text+struct.pack('<II',len(self.binary),0x004e4942)+self.binary
        (HERE/'Assets').mkdir(exist_ok=True)
        (HERE/'Assets'/f'{self.id}.glb').write_bytes(data)
        report={'id':self.id,'triangles':sum(r['triangles']*r['instances'] for r in self.records),'mesh_nodes':len(self.document['nodes']),'parts':self.records}
        (HERE/'Evidence'/f'art-{self.id}.json').write_text(json.dumps(report,indent=2))
        print('ROOM_COMPLETE',self.id,report['triangles'],flush=True)

def local(id,p):
    world=(np.array([p[0],p[1]])-[560,930])*.12
    return np.array([world[0],0,world[1]])-np.asarray(META[id]['position'])

def walls(m):
    source=next(r for r in SOURCE['rooms'] if r['id']==m.id)
    poly=(np.asarray(source['polygon'],float)-[560,930])*.12-np.asarray(META[m.id]['position'])[[0,2]]
    delta=np.roll(poly,-1,axis=0)-poly
    lengths=np.linalg.norm(delta,axis=1); cum=np.r_[0,np.cumsum(lengths)]
    poly=np.vstack([poly,poly[0]]); perimeter=cum[-1]; count=math.ceil(perimeter/1.08); unit=perimeter/count
    chunks={}; ports=[np.asarray(p['point'])[[0,2]] for p in META[m.id]['portals']]
    for row in range(12 if m.id=='12' else 11):
        for j in range(count):
            distance=(j+.5*(row%2))*unit
            a,b=[np.array([np.interp(d%perimeter,cum,poly[:,k]) for k in range(2)]) for d in [distance,distance+unit]]
            mid=(a+b)*.5
            if any(np.linalg.norm(mid-p)<3.05 for p in ports): continue
            if m.id=='01' and row>1: continue
            if m.id=='08':
                water=local('08',[1022,1134])[[0,2]]
                if np.linalg.norm((mid-water)/[11.28,14.64])<1.13 and row>1: continue
            d=(b-a)/np.linalg.norm(b-a); mid-=np.array([-d[1],d[0]])*.24
            p=np.array([mid[0],.29+row*.56,mid[1]])
            chunks.setdefault(tuple(np.floor(mid/6).astype(int)),[]).append((p,d,np.linalg.norm(b-a),row,j))
    for key,bricks in chunks.items():
        points=np.array([b[0] for b in bricks]); v=Volume(points.min(0)-[1,.3,1],points.max(0)+[1,.4,1],.06)
        for p,d,length,row,j in bricks:
            def field(x,y,z):
                a=(x-p[0])*d[0]+(z-p[2])*d[1]; b=-(x-p[0])*d[1]+(z-p[2])*d[0]
                return (np.abs(a)<(length-.025)/2)&(np.abs(y-p[1])<.26)&(np.abs(b)<.30)&(np.abs(a)+np.abs(y-p[1])<(length-.025)/2+.22)
            tone=STONE[(j+row*3)%4] if m.id!='09' else [0x615562,0x6d6069,0x786c73,0x82767c][(j+row)%4]
            v.paint(p-[1,.29,1],p+[1,.29,1],field,tone)
            if row in [0,8,10]:
                v.paint(p-[1,0,1],p+[1,.32,1],lambda x,y,z:(np.abs((x-p[0])*d[0]+(z-p[2])*d[1])<length/2)&(np.abs(-(x-p[0])*d[1]+(z-p[2])*d[0])<.38)&(np.abs(y-p[1]-.20)<.065),PALE)
            if row in [2,6] and j%7==0: ellipsoid(v,p+[-d[1]*.3,.23,d[0]*.3],(.13,.13,.13),0)
        m.add('CarvedMasonry_%d_%d'%key,v)

def emblem(m):
    v=Volume((-1.45,0,-.24),(1.45,4.95,.75),.03)
    v.box((0,2.45,0),(2.58,4.71,.30),STONE[1]); v.box((0,2.5,.18),(2.22,4.10,.12),DARK)
    for s in [-1,1]:
        v.box((s*1.21,2.4,.24),(.18,4.71,.36),PALE)
        for j in range(7): leaf(v,(s*1.21,.7+j*.52,.44),(s*1.11,1.05+j*.52,.45),.09,LIGHT,thickness=.06)
    for y in [.21,.45,4.53,4.74]: v.box((0,y,.24),(2.79,.15,.42),PALE)
    ring(v,(0,2.8,.29),(.96,1.08),.058,GOLD)
    id=m.id
    if id in ['01','02']:
        for row in range(3):
            points=[(x,1.70+row*.44+math.sin(x*4+row)*.16,.42) for x in np.linspace(-.86,.86,50)]
            stroke(v,points,.07,.07,PALE)
        if id=='01':
            stroke(v,[(0,2.6,.48),(0,3.85,.48)],.065,.06,GOLD)
            stroke(v,[(-.56,3.06,.45),(-.42,2.74,.48),(0,2.62,.48),(.42,2.74,.48),(.56,3.06,.45)],.085,.05,LIGHT)
        else:
            ring(v,(0,3.30,.48),(.51,.51),.075,PALE)
            for a in np.linspace(0,math.tau,8,endpoint=False): stroke(v,[(0,3.30,.47),(math.cos(a)*.58,3.30+math.sin(a)*.58,.47)],.05,.055,GOLD)
    elif id in ['03','06','12']:
        stroke(v,[(0,1.32,.40),(-.10,2.18,.43),(.09,3.15,.46),(0,3.99,.46)],.095,.035,PALE)
        for s in [-1,1]:
            for j in range(4): leaf(v,(0,1.74+j*.47,.43),(s*(.70-j*.08),2.10+j*.47,.46),.17,LIGHT,thickness=.09)
        if id=='12':
            ellipsoid(v,(0,3.61,.45),(.70,.37,.14),PALE)
            for x in [-.4,0,.4]: ellipsoid(v,(x,3.72,.60),(.07,.08,.06),0)
    elif id in ['04','05']:
        for s in [-1,1]:
            stroke(v,[(-s*.62,1.80,.45),(s*.59,3.81,.47)],.07,.04,PALE)
            stroke(v,[(s*.02,2.15,.50),(-s*.48,2.49,.50)],.06,.06,GOLD)
            if id=='05': v.box((s*.53,3.66,.46),(.57,.32,.18),LIGHT)
    elif id=='08':
        for s in [-1,1]:
            v.box((s*.43,2.70,.40),(.78,1.50,.18),PALE)
            for y in np.arange(2.18,3.29,.23): stroke(v,[(s*.12,y,.51),(s*.69,y+.12,.51)],.025,.025,0)
        stroke(v,[(0,1.85,.53),(0,3.62,.53)],.06,.06,GOLD)
    elif id=='09':
        for s in [-1,1]: stroke(v,[(-.79,2.76,.46),(-.32,2.76+s*.45,.46),(.32,2.76+s*.45,.46),(.79,2.76,.46)],.06,.06,PALE)
        ring(v,(0,2.76,.48),(.24,.38),.07,GOLD)
        ellipsoid(v,(0,2.76,.58),(.08,.23,.10),0)
    elif id in ['10','13']:
        ring(v,(0,3.15,.46),(.43,.43),.10,PALE)
        stroke(v,[(0,2.74,.46),(0,1.64,.46),(.57,1.64,.46)],.085,.07,GOLD)
        for x in [.24,.51]: stroke(v,[(x,1.61,.46),(x,1.95,.46)],.07,.07,PALE)
    elif id=='11':
        stroke(v,[(-.66,3.72,.45),(-.59,2.18,.45),(0,1.96,.45),(.59,2.18,.45),(.66,3.72,.45)],.09,.09,PALE)
        stroke(v,[(-.75,3.58,.45),(.75,3.58,.45)],.06,.06,GOLD)
        for x in [-.36,-.18,0,.18,.36]: stroke(v,[(x,2.25,.46),(x,3.52,.46)],.025,.025,GOLD)
    else:
        ring(v,(0,3.10,.44),(.48,.48),.085,PALE)
        for a in np.linspace(0,math.tau,12,endpoint=False): stroke(v,[(math.cos(a)*.61,3.1+math.sin(a)*.61,.43),(math.cos(a)*.84,3.1+math.sin(a)*.84,.43)],.035,.024,GOLD)
        for j in range(3): v.box((0,1.48+j*.24,.46),(1.5-j*.30,.12,.18),PALE)
    # Real dents and openings separate the relief from a flat decal.
    ellipsoid(v,(-1.23,1.40,.47),(.16,.15,.32),0)
    poses=[]
    for index in ([3,5] if id=="08" else [1,5]):
        p=np.asarray(META[id]['edges'][index]); yaw=round(math.atan2(-p[0],-p[2])/(math.pi/2))*(math.pi/2)
        if id=='01': p[1]=.10
        poses.append((tuple(p),yaw))
    m.add('Heraldry_'+id,v,poses)

def pedestal(v,w,d,h=.42):
    for y,height,shrink,tone in [(h*.22,h*.44,0,PALE),(h*.61,h*.34,.12,STONE[1]),(h*.89,h*.22,.06,LIGHT)]:
        v.box((0,y,0),(w-shrink,height,d-shrink),tone)

def blade(v,p,kind=0):
    p=np.asarray(p); stroke(v,[p,p+[0,1.68,0]],.045,.025,PALE)
    stroke(v,[p+[-.27,.70,0],p+[.27,.70,0]],.055,.055,GOLD)
    if kind%2: v.box(p+[.18,1.38,0],(.48,.48,.10),0x91a39b)
    else:
        for s in [-1,1]: stroke(v,[p+[0,1.67,0],p+[s*.13,1.27,0]],.036,.05,0x91a39b)
    stroke(v,[p,p+[0,.56,0]],.058,.05,BARK[2])

def landing(m):
    p=local('01',[462,1638]); v=Volume((-1.25,-.36,-2.85),(1.25,1.1,2.85),.03)
    for y in np.arange(-.27,.57,.12):
        def hull(x,Y,z):
            breadth=.99*np.maximum(0,1-(np.abs(z)/2.85)**2)**.6
            if y>-.1:
                return (np.abs(x)<=breadth)&(np.abs(x)>=np.maximum(0,breadth-.13))
            return x*x/1.03**2+z*z/2.8**2<1
        v.paint((-1.2,y,-2.8),(1.2,y+.10,2.8),hull,BARK[int((y+.4)*10)%3])
    for z in [-1.75,-.70,.70,1.75]: v.box((0,.34,z),(1.54,.12,.24),0xa88b61)
    for z in [-2.4,-1.2,0,1.2,2.4]:
        ring(v,(0,.30,z),(.86*(1-abs(z)/3),.42),.038,GOLD,plane='xy',start=math.pi,end=math.tau)
    stroke(v,[(0,.31,-2.78),(0,.64,-2.5),(0,.98,-2.27)],.10,.06,0xa88b61)
    for s in [-1,1]: stroke(v,[(s*.91,.65,-1.90),(s*.45,.67,1.9)],.035,.035,0xc4ad77)
    m.add('ClinkerSkiff',v,[(tuple(p),0)])
    dock=local('01',[480,1623]); v=Volume((-4.7,-.45,-1.65),(.5,1.25,1.65),.03)
    for j in range(14):
        x=-j*.36; v.box((x,.12,0),(.33,.24,2.64),[0x856544,0x98744d,0xa48359][j%3])
        for z in [-1.08,1.08]: ellipsoid(v,(x,.253,z),(.028,.018,.028),BRONZE)
        stroke(v,[(x-.06,.26,-.9),(x+.025,.26,0),(x-.02,.26,.8)],.016,.016,0)
    for x in [0,-4.32]:
        for z in [-1.32,1.32]:
            stroke(v,[(x,-.4,z),(x,1.05,z)],.13,.11,BARK[1])
            for y in [.59,.71,.83]: ring(v,(x,y,z),(.145,.145),.025,0xb7a172,'xz')
    m.add('RopeBoundDock',v,[(tuple(dock),0)])
    v=Volume((-.96,0,-.96),(.96,3.54,.96),.03); pedestal(v,1.8,1.8,.72)
    for y in [.90,1.50,2.10]: ring(v,(0,y,0),(.33,.33),.10,GOLD,'xz')
    stroke(v,[(0,.72,0),(0,2.50,0)],.17,.17,BARK[2])
    for s in [-1,1]: leaf(v,(s*.2,1.11,0),(s*.4,2.25,0),.19,PALE,thickness=.08)
    m.add('LanternBeaconCage',v,[(tuple(local('01',[537,1561])),0)])
    j=Volume((-.4,2.4,-.4),(.4,3.4,.4),.03); ellipsoid(j,(0,2.9,0),(.31,.48,.31),JADE)
    m.add('LanternBeaconHeart',j,[(tuple(local('01',[537,1561])),0)],2)

def sluice(m):
    p=META['02']['blockers'][0]; v=Volume((-1.8,0,-1.45),(1.8,3.9,1.45),.03); pedestal(v,3.48,2.88)
    v.box((0,1.60,-.48),(.60,2.4,.72),STONE[0])
    ring(v,(0,2.13,.39),(1.2,1.2),.12,GOLD)
    ring(v,(0,2.13,.39),(.91,.91),.047,BRONZE)
    for a in np.linspace(0,math.tau,12,endpoint=False):
        stroke(v,[(0,2.13,.39),(math.cos(a)*1.17,2.13+math.sin(a)*1.17,.39)],.054,.086,BRONZE)
        ellipsoid(v,(math.cos(a)*1.31,2.13+math.sin(a)*1.31,.39),(.12,.12,.13),GOLD)
    ellipsoid(v,(0,2.13,.48),(.28,.28,.23),GOLD)
    for a in np.linspace(0,math.tau,6,endpoint=False): ellipsoid(v,(math.cos(a)*.18,2.13+math.sin(a)*.18,.72),(.042,.042,.03),PALE)
    m.add('ToothedSluiceWheel',v,[(p,0)])
    gate=local('02',[590,1286]); v=Volume((-4.9,3.7,-.78),(4.9,6.8,.78),.06)
    for y in [5.88,6.36]: v.box((0,y,0),(9.6,.36,1.20),STONE[1])
    for x in np.arange(-4.2,4.21,.42):
        stroke(v,[(x,3.9,0),(x,6.4,0)],.06,.06,BRONZE)
        leaf(v,(x,4.02,.08),(x,4.45,.08),.11,GOLD,thickness=.06,vein=False)
    for x in [-4.1,4.1]:
        for y in np.arange(4.2,6.6,.25): ring(v,(x,y,.49),(.09,.12),.024,GOLD)
    m.add('RaisedPortcullis',v,[(tuple(gate),0)])
    p=META['02']['blockers'][1]; v=Volume((-1.5,0,-1.44),(1.5,.96,1.44),.03); pedestal(v,3,2.88,.38)
    for s in [-1,1]:
        v.box((s*1.33,.65,0),(.24,.48,2.64),PALE);v.box((0,.65,s*1.27),(2.88,.48,.24),PALE)
        for x in [-.84,-.42,0,.42,.84]: leaf(v,(x,.44,s*1.41),(x,.77,s*1.41),.10,LIGHT,normal=(0,0,s),thickness=.035)
    m.add('SpillwayBasin',v,[(p,0)])
    water=Volume((-1.2,.43,-1.2),(1.2,.54,1.2),.03);water.box((0,.48,0),(2.37,.06,2.37),0x469986);m.add('Spillwater',water,[(p,0)],4)

def court(m):
    p=np.asarray(META['03']['blockers'][0]);v=Volume((-3.42,0,-3.36),(3.42,.9,3.36),.03);pedestal(v,6.72,6.60,.72)
    for s in [-1,1]:
        for x in np.arange(-2.8,2.9,.55): leaf(v,(x,.24,s*3.32),(x,.58,s*3.32),.13,PALE,normal=(0,0,s),thickness=.055)
    m.add('RootIslandPlinth',v,[(tuple(p),0)])
    m.offset=p+[0,.15,4.32];art.heartwood(m);m.offset=np.zeros(3)

def barracks(m):
    v=Volume((-1.35,0,-1.27),(1.35,3.12,1.27),.03)
    for x in [-1.12,1.12]:
        for z in [-1.04,1.04]:
            v.box((x,1.50,z),(.18,2.88,.18),BARK[1]);ellipsoid(v,(x,2.98,z),(.15,.12,.15),GOLD)
            for y in [.35,1.75,2.65]: ring(v,(x,y,z),(.13,.13),.025,GOLD,'xz')
    for y in [.60,1.92]:
        for z in [-.93,.93]: v.box((0,y,z),(2.44,.24,.18),0xa08659)
        for j in range(10): v.box((-.99+j*.22,y,0),(.19,.12,1.90),BARK[2])
        v.box((0,y+.16,.12),(2.13,.20,1.50),0x6d7e55)
        for x in np.arange(-.96,.97,.18): stroke(v,[(x,y+.27,-.55),(x+.02,y+.27,.15),(x-.02,y+.27,.77)],.018,.018,0x91a070)
        ellipsoid(v,(0,y+.25,-.73),(.94,.15,.19),0xc1b78c)
    for j in range(6): v.box((1.18,.30+j*.43,1.11),(.30,.09,.24),GOLD)
    m.add('CarvedDoubleBunks',v,[(p,0) for p in META['04']['blockers'][:2]])
    v=Volume((-2.94,0,-.90),(2.94,3.0,.90),.03)
    for x in [-2.64,2.64]: v.box((x,.50,0),(.24,.96,1.50),BARK[1])
    v.box((0,.95,0),(5.70,.24,1.68),BARK[2])
    for j in range(8): blade(v,(-2.3+j*.65,1.08,-.12),j)
    for x in [-2.3,-1.65,-1,-.35,.3,.95,1.6,2.25]: ellipsoid(v,(x,.97,.87),(.046,.046,.025),GOLD)
    m.add('FittedWeaponRack',v,[(META['04']['blockers'][2],0)])

def smithy(m):
    p=META['05']['blockers'][0];v=Volume((-2.10,0,-2.25),(2.10,7.7,2.25),.03);pedestal(v,4.08,4.32,.48)
    for s in [-1,1]:
        for row in range(6):
            for j in range(5): v.box((s*1.66,.73+row*.43,-1.7+j*.79),(.64,.39,.74),[0x685845,0x7b6650,0x897455][(row+j)%3])
    v.box((0,1.78,-1.79),(3.4,2.55,.48),0x625442)
    v.paint((-2.04,2.0,-1.9),(2.04,4.0,1.95),lambda x,y,z: (x*x+(y-2.05)**2<=2.03**2)&(x*x+(y-2.05)**2>=1.34**2),0x958061)
    ring(v,(0,2.05,2.01),(1.48,1.48),.07,GOLD,start=0,end=math.pi)
    for row in range(8): v.box((0,4.20+row*.42,-.84),(1.89,.38,1.86),[0x594e40,0x6b5b47][row%2])
    for y in [4.6,6.9]: v.box((0,y,-.84),(2.04,.12,2.01),BRONZE)
    for a in np.linspace(.05,math.pi-.05,14): stroke(v,[(math.cos(a)*1.41,2.05+math.sin(a)*1.41,2.06),(math.cos(a)*1.9,2.05+math.sin(a)*1.9,2.06)],.026,.026,0)
    m.add('CarvedArchedFurnace',v,[(p,0)])
    f=Volume((-1.2,.5,-1.1),(1.2,1.65,1.45),.06)
    for j in range(24):
        q=np.array([((j*7)%11-5)*.20,.65,((j*3)%10-4)*.23]);ellipsoid(f,q,(.15,.12,.16),0xea7137)
        if j%3==0: stroke(f,[q,q+[.08,.35,.04],q+[-.04,.75,.02]],.11,.025,0xffc369)
    m.add('FurnaceEmbers',f,[(p,0)],3)
    v=Volume((-2.30,0,-1.02),(2.30,2.4,1.02),.03);v.box((0,.53,0),(4.32,1.06,1.8),BARK[1]);v.box((0,1.14,0),(4.56,.21,2.04),BARK[2])
    for x in np.arange(-1.95,2.0,.30): stroke(v,[(x,.12,.91),(x,.92,.91)],.02,.02,0)
    for y,w in [(1.30,1.10),(1.51,.66),(1.74,1.59)]:v.box((-.60,y,0),(w,.22,.72),0x7e908b)
    stroke(v,[(-1.40,1.76,0),(-1.94,1.73,0)],.19,.045,0x9eaaa0)
    for j in range(6):v.box((.45+j%3*.43,1.38+j//3*.19,.05),(.36,.18,.60),GOLD)
    stroke(v,[(1.2,1.29,.70),(1.8,1.29,.50)],.044,.044,BARK[1]);v.box((1.8,1.37,.50),(.21,.15,.42),BRONZE)
    m.add('SmithAnvilCounter',v,[(META['05']['blockers'][1],0)])

def hunter(m):
    v=Volume((-1.15,0,-1.1),(1.15,5.7,1.1),.03);pedestal(v,2.25,2.25,.57)
    for s in [-1,1]:
        stroke(v,[(s*.26,.60,0),(s*.29,1.85,0)],.19,.22,STONE[2])
        stroke(v,[(s*.48,2.87,0),(s*.71,2.28,.18),(s*.75,2.93,.45)],.18,.12,PALE)
    v.paint((-.7,1.50,-.48),(.7,3.4,.48),lambda x,y,z: (x/.65)**2+(z/.42)**2<=1,STONE[2])
    for x in [-.45,-.23,0,.23,.45]:stroke(v,[(x,1.57,.42),(x*.7,2.73,.45)],.026,.026,0)
    ellipsoid(v,(0,3.59,.04),(.35,.48,.29),PALE)
    for s in [-1,1]:
        ellipsoid(v,(s*.13,3.67,.29),(.071,.058,.11),0)
        stroke(v,[(s*.17,3.99,0),(s*.28,4.37,0),(s*.64,4.63,0),(s*.64,5.10,0)],.086,.028,LIGHT)
        stroke(v,[(s*.42,4.47,0),(s*.82,4.52,0),(s*.87,4.80,0)],.05,.026,LIGHT)
    ellipsoid(v,(0,3.46,.30),(.08,.20,.09),LIGHT)
    stroke(v,[(.78,.54,.48),(.78,5.3,.48)],.045,.035,GOLD)
    leaf(v,(.78,4.99,.48),(.78,5.61,.48),.16,LIGHT,thickness=.065)
    m.add('AntleredHunterEffigy',v,[(p,0) for p in META['06']['blockers']])
    m.offset=local('06',[247,545])+[1.2,0,3.12];art.heartwood(m);m.offset=np.zeros(3)

def bookcase(v,width=2.64,height=4.20):
    for s in [-1,1]:
        v.box((s*(width/2-.09),height/2,0),(.18,height,.87),BARK[1])
        for y in [.12,height-.16]:v.box((0,y,0),(width+.18,.24,1.0),GOLD)
        for y in np.arange(.5,height-.3,.54):leaf(v,(s*(width/2-.05),y,.46),(s*(width/2-.05),y+.31,.46),.06,PALE,thickness=.035)
    for row in range(5):
        y=.30+row*.75;v.box((0,y,0),(width,.12,.84),BARK[2])
        if row==4:continue
        for j in range(int((width-.3)/.18)):
            x=-width/2+.23+j*.18;h=[.44,.54,.48,.60][(j+row)%4]
            v.box((x,y+.08+h/2,0),(.145,h,.61),[0x784d3c,0x466c63,0xbaa274,0x69728a,0x8f7744][(j+row)%5])
            for yy in [.18,h-.02]:v.box((x,y+yy,.324),(.15,.03,.03),GOLD)
            v.box((x,y+.1+h*.5,.338),(.04,.14,.03),PALE)
    ring(v,(0,height-.2,.38),(width*.47,.45),.08,GOLD,start=0,end=math.pi)

def archive(m):
    v=Volume((-1.5,0,-.66),(1.5,4.65,.66),.03);pedestal(v,2.88,1.32,.24);bookcase(v)
    m.add('IlluminatedBookGalleries',v,[(tuple(np.asarray(p)+[0,.18,-.24]),0) for p in META['08']['blockers']])
    m.add('CarvedLibraryShelves',v,[(tuple(np.asarray(META['08']['edges'][i])+[0,0,.50]),0) for i in [0,2,4,6]])

def vault(m):
    v=Volume((-1.2,0,-1.2),(1.2,5.7,1.2),.03);pedestal(v,2.28,2.28,.72)
    v.paint((-.57,.72,-.57),(.57,5.65,.57),lambda x,y,z:(np.abs(x)<np.maximum(.025,.54-np.maximum(0,y-4.5)*.44))&(np.abs(z)<np.maximum(.025,.54-np.maximum(0,y-4.5)*.44)),0x53464e)
    for y in [1.2,2.45,3.7]:
        ring(v,(0,y,.58),(.27,.42),.05,PALE)
        for s in [-1,1]:stroke(v,[(s*.37,y-.33,.60),(0,y,.60),(s*.37,y+.33,.60)],.045,.045,0)
    for s in [-1,1]:stroke(v,[(s*.49,.86,.58),(s*.49,4.4,.58)],.033,.033,GOLD)
    m.add('IncisedBloodObelisks',v,[(p,0) for p in META['09']['blockers']])
    e=Volume((-.3,1,-.1),(.3,4.6,.75),.03)
    for y in [1.2,2.45,3.7]:ellipsoid(e,(0,y,.6),(.08,.23,.06),0xd97c78)
    m.add('BloodSeals',e,[(p,0) for p in META['09']['blockers']],3)

def treasure(m):
    id=m.id; w=4.2 if id=='10' else 3.6
    v=Volume((-3.42,0,-1.32),(3.42,5.8,1.32),.03);pedestal(v,6.6 if id=='10' else 5.04,2.4,.36)
    v.box((0,.97,0),(w,1.08,1.32),BARK[1])
    v.paint((-w/2,1.44,-.66),(w/2,2.06,.66),lambda x,y,z:((y-1.44)/.60)**2+(z/.66)**2<=1,BARK[2])
    for j,x in enumerate(np.arange(-w/2+.14,w/2,.28)):
        v.box((x,.96,.636),(.25,.99,.09),[0x735036,0x805b3a,0x6d4c32][j%3])
        stroke(v,[(x-.08,.50,.688),(x-.05,.81,.688),(x-.07,1.36,.688)],.028,.026,0)
        for y in [.53,1.35]:ellipsoid(v,(x,y,.70),(.034,.033,.03),GOLD)
    for y in [.48,1.49]:v.box((0,y,.70),(w+.09,.075,.12),BRONZE)
    for s in [-1,1]:
        leaf(v,(s*.27,.72,.72),(s*.78,1.21,.73),.17,GOLD,thickness=.07)
        leaf(v,(s*.58,.67,.72),(s*1.02,1.10,.73),.14,PALE,thickness=.06)
    for x in [-w*.36,w*.36]:
        v.box((x,.99,.69),(.12,1.14,.09),GOLD)
        v.paint((x-.07,1.44,-.73),(x+.07,2.15,.73),lambda X,y,z:(((y-1.44)/.69)**2+(z/.73)**2<=1)&(((y-1.44)/.55)**2+(z/.62)**2>=1),GOLD)
        for y in [.56,.86,1.22]:ellipsoid(v,(x,y,.755),(.045,.045,.035),PALE)
    v.box((0,1.34,.76),(.42,.48,.12),GOLD);ellipsoid(v,(0,1.42,.84),(.08,.085,.07),0);v.box((0,1.27,.84),(.07,.18,.09),0)
    for x in np.arange(-w/2+.18,w/2,.28):stroke(v,[(x,.48,.676),(x+.04,.84,.68),(x-.03,1.35,.68)],.018,.018,0)
    for s in [-1,1]:
        ring(v,(s*(w/2+.1),1.0,0),(.20,.25),.05,BRONZE)
        for y in [.54,.84,1.13]:leaf(v,(s*w*.2,y,.70),(s*(w*.2+.18),y+.20,.71),.09,PALE,thickness=.045)
    ring(v,(0,3.18,-.90),(2.50,2.1),.15,PALE,start=0,end=math.pi)
    ring(v,(0,3.18,-.69),(2.27,1.89),.04,GOLD,start=0,end=math.pi)
    for s in [-1,1]:stroke(v,[(s*2.50,.48,-.90),(s*2.50,3.18,-.90)],.13,.13,PALE)
    m.add('FittedReliquaryApse',v,[(META[id]['blockers'][0],0)])

def choir(m):
    v=Volume((-2.3,0,-1.02),(2.3,9.4,1.08),.03);pedestal(v,4.44,2.04,.48)
    v.box((0,1.30,0),(4.08,1.65,1.65),BARK[0])
    for x in [-1.8,-.9,0,.9,1.8]:leaf(v,(x,.58,.86),(x,1.33,.86),.20,PALE,thickness=.07)
    for j in range(13):
        x=(j-6)*.3;h=4.8+(1-abs(j-6)/6)*2.4
        stroke(v,[(x,1.8,-.3),(x,1.8+h,-.3)],.115,.115,GOLD)
        for y in [2.05,3.3,1.8+h]:ring(v,(x,y,-.3),(.14,.14),.035,PALE,'xz')
        v.box((x,2.2,-.178),(.065,.36,.06),0)
    v.box((0,1.58,.84),(3.9,.18,.46),BARK[2])
    for j in range(25):
        x=(j-12)*.145;v.box((x,1.71,.84),(.135,.09,.42),0xcec399)
        if j%7 not in [2,6]:v.box((x+.067,1.79,.71),(.063,.06,.22),0x2e3c38)
    for x in [-2.10,2.10]:stroke(v,[(x,.48,.60),(x,4.20,.60)],.07,.07,GOLD)
    m.add('CarvedPipeOrgan',v,[(META['11']['blockers'][2],0)])
    ch=Volume((-2.1,0,-2.1),(2.1,2.7,2.1),.06)
    ring(ch,(0,.10,0),(1.8,1.8),.085,GOLD,'xz')
    for a in np.linspace(0,math.tau,12,endpoint=False):
        p=np.array([math.cos(a)*1.8,.1,math.sin(a)*1.8]);stroke(ch,[p,p+[0,.50,0]],.06,.035,LIGHT)
        if abs(math.sin(a*2))<.01:stroke(ch,[p,(0,2.6,0)],.033,.033,BRONZE)
    center=local('11',[505,426]);m.add('ChoirChandeliers',ch,[(tuple(center+[0,6.3,z]),0) for z in [-3.6,4.8]],1)

def mushroom(m,p,height,radius,name):
    stem=Volume((-1.2,0,-1.2),(1.2,height+.3,1.2),.06)
    points=[(0,0,0),(-.3,height*.30,.12),(.15,height*.65,-.12),(0,height,0)]
    stroke(stem,points,.84,.48,0x95a17b)
    for a in np.linspace(0,math.tau,12,endpoint=False):stroke(stem,[(q[0]+math.cos(a)*(.8-i*.1),q[1],q[2]+math.sin(a)*(.8-i*.1)) for i,q in enumerate(points)],.04,.03,0)
    m.add(name+'Stem',stem,[(p,0)])
    cap=Volume((-radius-.1,height-.48,-radius-.1),(radius+.1,height+2.1,radius+.1),.06)
    cap.paint((-radius,height-.18,-radius),(radius,height+2.04,radius),lambda x,y,z:(x*x+z*z<=radius**2)&(y-height<=1.9*np.maximum(0,1-(x*x+z*z)/radius**2)**.72),0x62957a)
    for a in np.linspace(0,math.tau,44,endpoint=False):
        stroke(cap,[(math.cos(a)*.6,height-.29,math.sin(a)*.6),(math.cos(a)*radius*.92,height-.29,math.sin(a)*radius*.92)],.065,.065,0xc0cf9e)
    for j in range(32):
        a=j*2.39996;rr=radius*math.sqrt((j+.4)/32)*.87; yy=height+1.9*(1-rr*rr/radius**2)**.72
        ellipsoid(cap,(math.cos(a)*rr,yy,math.sin(a)*rr),(.14+j%3*.05,.045,.13+j%3*.05),0xc1d3aa)
    m.add(name+'GilledCap',cap,[(p,0)])

def grotto(m):
    for j,p in enumerate(META['12']['blockers']):mushroom(m,p,7.5+j*1.2,5.4+j*.6,'GiantSpore'+str(j))
    for j in [0,2,4,6]:mushroom(m,META['12']['edges'][j],3.1+(j%3)*.35,1.50,'YoungSpore'+str(j))

def ascent(m):
    p=local('14',[1015,408]);v=Volume((-1.8,0,-.25),(1.8,7.2,5.6),.03)
    for j in range(14):
        h=(j+1)*.24;z=j*.36;v.box((0,h/2,z),(2.4,h,.36),STONE[(j+2)%4]);v.box((0,h+.015,z-.12),(2.40,.03,.12),PALE)
        for x in [-.78,-.39,0,.39,.78]:leaf(v,(x,h-.18,z-.19),(x,h-.04,z-.19),.05,LIGHT,thickness=.027,vein=False)
    for s in [-1,1]:
        for j in range(7):
            q=np.array([s*1.5,.6+j*.48,j*.72]);stroke(v,[q-[0,.54,0],q+[0,.54,0]],.11,.07,STONE[2]);ellipsoid(v,q+[0,.60,0],(.18,.15,.18),PALE)
        stroke(v,[(s*1.5,1.25,0),(s*1.5,4.15,4.32)],.09,.09,GOLD)
        for y in np.arange(3.6,6.4,.45):v.box((s*1.44,y,4.86),(.45,.39,.66),PALE)
    v.box((0,6.48,4.86),(3.30,.30,.81),PALE)
    for x in np.arange(-1.26,1.27,.24):leaf(v,(x,6.45,5.30),(x,6.72,5.30),.09,GOLD,thickness=.045)
    m.add('CarvedAscentStair',v,[(tuple(p),0)])
    e=Volume((-1.2,3.36,5.02),(1.2,6.4,5.18),.03);e.box((0,4.86,5.10),(2.4,3,.12),0x99cebd);m.add('UpperThreshold',e,[(tuple(p),0)],2)

BUILDERS={'01':landing,'02':sluice,'03':court,'04':barracks,'05':smithy,'06':hunter,'08':archive,'09':vault,'10':treasure,'11':choir,'12':grotto,'13':treasure,'14':ascent}

def main():
    ids=sys.argv[1:] or list(BUILDERS)
    for id in ids:
        work=HERE/'Build'/id;(work/'Evidence').mkdir(parents=True,exist_ok=True);art.HERE=work
        print('BUILD_ROOM',id,flush=True);m=RoomModel(id);walls(m);emblem(m);BUILDERS[id](m);m.save()
    records=[json.loads(p.read_text()) for p in sorted((HERE/'Evidence').glob('art-*.json'))]
    (HERE/'Evidence/art-manifest.json').write_text(json.dumps(records,indent=2))
if __name__=='__main__':main()
