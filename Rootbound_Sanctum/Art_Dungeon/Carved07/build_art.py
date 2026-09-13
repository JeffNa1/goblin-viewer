"""Authored sanctuary carvings. Cubic voxels only; no bevel or smooth export.

Run locally with the existing numpy installation. The original room is not edited.
"""
from pathlib import Path
import json
import math
import struct
import time
import numpy as np
from voxels import Volume

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
STONE = [0x69796b, 0x728171, 0x7a8877, 0x818d7b]
PALE, LIGHT, DARK = 0xa7ad8d, 0xb9b999, 0x364c40
GOLD, BRONZE, JADE = 0xb19a65, 0x88784f, 0x76cab0
LEAVES = [0x354c2d, 0x496236, 0x607844, 0x799054]
BARK = [0x48382a, 0x59432e, 0x695136]


def ellipsoid(v, p, radius, tone):
    p, r = np.asarray(p), np.asarray(radius)
    v.paint(p-r, p+r, lambda x,y,z: ((x-p[0])/r[0])**2 + ((y-p[1])/r[1])**2 + ((z-p[2])/r[2])**2 <= 1, tone)


def stroke(v, points, radius, end_radius, tone):
    points = np.asarray(points, float)
    lengths = np.linalg.norm(np.diff(points, axis=0), axis=1)
    total = sum(lengths)
    distance = 0.0
    for a,b,length in zip(points[:-1], points[1:], lengths):
        if length < .00001:
            continue
        r0 = radius + (end_radius-radius) * distance / total
        r1 = radius + (end_radius-radius) * (distance+length) / total
        delta = b-a
        r = max(r0,r1)
        def field(x,y,z):
            t = np.clip(((x-a[0])*delta[0] + (y-a[1])*delta[1] + (z-a[2])*delta[2]) / length**2, 0, 1)
            return (x-a[0]-t*delta[0])**2 + (y-a[1]-t*delta[1])**2 + (z-a[2]-t*delta[2])**2 <= (r0+(r1-r0)*t)**2
        v.paint(np.minimum(a,b)-r, np.maximum(a,b)+r, field, tone)
        distance += length


def leaf(v, p, tip, width, tone, normal=(0,0,1), thickness=.10, vein=True):
    p, tip, normal = np.asarray(p,float), np.asarray(tip,float), np.asarray(normal,float)
    direction = tip-p
    length = np.linalg.norm(direction)
    axis = direction/length
    normal = normal-axis*np.dot(normal,axis)
    normal /= np.linalg.norm(normal)
    side = np.cross(axis,normal)
    def field(x,y,z):
        dx,dy,dz = x-p[0], y-p[1], z-p[2]
        t = (dx*axis[0]+dy*axis[1]+dz*axis[2])/length
        across = dx*side[0]+dy*side[1]+dz*side[2]
        depth = dx*normal[0]+dy*normal[1]+dz*normal[2]
        breadth = width*np.sin(np.clip(t,0,1)*math.pi)**.8
        return (t>=0)&(t<=1)&(np.abs(across)<=breadth)&(np.abs(depth)<=thickness*(1-.65*np.abs(across)/(breadth+.0001)))
    bound = width+thickness
    v.paint(np.minimum(p,tip)-bound, np.maximum(p,tip)+bound, field,tone)
    if vein:
        # The incised vein removes front voxels but leaves the leaf's backing.
        stroke(v,[p+direction*.16+normal*thickness, p+direction*.80+normal*thickness],v.step*.64,v.step*.56,0)


def ring(v, p, radii, thickness, tone, plane='xy', start=0, end=math.tau):
    points=[]
    for a in np.linspace(start,end,max(12,int(abs(end-start)*max(radii)/v.step*.7))):
        offset = (math.cos(a)*radii[0],math.sin(a)*radii[1],0) if plane=='xy' else (math.cos(a)*radii[0],0,math.sin(a)*radii[1])
        points.append(np.asarray(p)+offset)
    stroke(v,points,thickness,thickness,tone)


class Model:
    def __init__(self):
        self.document={'asset':{'version':'2.0','generator':'Rootbound authored cubic carving'},'scene':0,'scenes':[{'nodes':[]}],'nodes':[],'meshes':[],'materials':[],'accessors':[],'bufferViews':[],'buffers':[]}
        self.binary=bytearray()
        self.records=[]
        for name,metal,rough,emission in [('stone',0,.94,None),('metal',.45,.60,None),('jade',.1,.50,[.12,.34,.24]),('flame',0,.90,[1.0,.45,.12]),('water',.1,.28,None)]:
            material={'name':name,'pbrMetallicRoughness':{'baseColorFactor':[1,1,1,1],'metallicFactor':metal,'roughnessFactor':rough}}
            if emission:
                material['emissiveFactor']=emission
            self.document['materials'].append(material)

    def array(self, data, kind):
        data=np.ascontiguousarray(data)
        while len(self.binary)%4:
            self.binary.append(0)
        offset=len(self.binary)
        self.binary.extend(data.tobytes())
        bv=len(self.document['bufferViews'])
        self.document['bufferViews'].append({'buffer':0,'byteOffset':offset,'byteLength':data.nbytes})
        accessor={'bufferView':bv,'componentType':5125 if data.dtype.kind=='u' else 5126,'count':len(data),'type':kind}
        if kind=='VEC3' and len(data):
            accessor['min']=data.min(axis=0).tolist()
            accessor['max']=data.max(axis=0).tolist()
        index=len(self.document['accessors'])
        self.document['accessors'].append(accessor)
        return index

    def add(self,name,v,placements=None,material=0):
        started=time.perf_counter()
        p,n,c,i=v.mesh()
        if len(i)==0:
            return
        mesh=len(self.document['meshes'])
        self.document['meshes'].append({'name':name,'primitives':[{'attributes':{'POSITION':self.array(p,'VEC3'),'NORMAL':self.array(n,'VEC3'),'COLOR_0':self.array(c,'VEC3')},'indices':self.array(i,'SCALAR'),'material':material}]})
        placements=placements or [((0,0,0),0)]
        for number,(position,yaw) in enumerate(placements):
            index=len(self.document['nodes'])
            self.document['nodes'].append({'name':name+'_%02d'%number,'mesh':mesh,'translation':list(position),'rotation':[0,math.sin(yaw/2),0,math.cos(yaw/2)]})
            self.document['scenes'][0]['nodes'].append(index)
        record={'name':name,'step':v.step,'occupied_voxels':int(np.count_nonzero(v.data)),'triangles':len(i)//3,'instances':len(placements),'bounds':[p.min(axis=0).tolist(),p.max(axis=0).tolist()],'mesh_seconds':round(time.perf_counter()-started,3)}
        self.records.append(record)
        print(json.dumps(record),flush=True)
        (HERE/'Evidence/build-progress.json').write_text(json.dumps(self.records,indent=2))

    def save(self):
        self.document['buffers']=[{'byteLength':len(self.binary)}]
        text=json.dumps(self.document,separators=(',',':')).encode()
        text+=b' '*((-len(text))%4)
        self.binary+=b'\0'*((-len(self.binary))%4)
        output=struct.pack('<III',0x46546c67,2,12+8+len(text)+8+len(self.binary))
        output+=struct.pack('<II',len(text),0x4e4f534a)+text
        output+=struct.pack('<II',len(self.binary),0x004e4942)+self.binary
        (HERE/'Assets').mkdir(exist_ok=True)
        (HERE/'Assets/sanctuary.glb').write_bytes(output)
        report={'room':'07','grid_only':True,'source':'authored local geometry, not copied reference assets','instanced_triangles':sum(r['triangles']*r['instances'] for r in self.records),'mesh_nodes':len(self.document['nodes']),'meshes':self.records}
        (HERE/'Evidence/build.json').write_text(json.dumps(report,indent=2))
        print('BUILD_COMPLETE',json.dumps({k:v for k,v in report.items() if k!='meshes'}),flush=True)


def guardian(model):
    v=Volume((-1.35,.30,-.30),(1.35,5.70,1.02),.03)
    v.box((0,2.9,-.06),(2.25,4.95,.30),STONE[1])
    v.box((0,2.96,.12),(1.94,4.39,.12),DARK)
    # Recessed face, triple stepped surround and a dentil crown.
    for sign in [-1,1]:
        for x,z,w in [(1.08,.22,.18),(.94,.32,.09)]:
            v.box((sign*x,2.9,z),(w,4.95,.18),PALE)
        stroke(v,[(sign*.91,.72,.42),(sign*.91,2.1,.42),(sign*.91,4.1,.42),(sign*.68,5.12,.42)],.045,.045,GOLD)
        for j in range(8):
            y=.88+j*.49
            leaf(v,(sign*1.06,y,.36),(sign*1.16,y+.35,.39),.10,LIGHT,thickness=.075)
    for y,w,z in [(.50,2.55,.22),(.68,2.39,.28),(5.13,2.34,.27),(5.31,2.55,.22),(5.46,2.65,.12)]:
        v.box((0,y,z),(w,.15,.45),PALE)
    for x in np.arange(-1.11,1.14,.21):
        v.box((x,5.24,.51),(.09,.17,.12),GOLD)
    ring(v,(0,3.66,.31),(.83,1.00),.065,BRONZE)
    # Guardian mask: deep eye sockets, cheek planes, nose and a cut mouth.
    ellipsoid(v,(0,3.59,.44),(.51,.67,.31),PALE)
    for sign in [-1,1]:
        ellipsoid(v,(sign*.22,3.68,.70),(.15,.105,.17),0)
        stroke(v,[(sign*.06,3.83,.73),(sign*.28,3.90,.72),(sign*.45,3.77,.59)],.073,.045,LIGHT)
        leaf(v,(sign*.39,3.56,.61),(sign*.58,3.21,.51),.15,STONE[2],thickness=.11)
        leaf(v,(sign*.44,3.89,.48),(sign*.80,4.24,.38),.20,PALE,thickness=.12)
        stroke(v,[(sign*.23,4.03,.44),(sign*.40,4.37,.41),(sign*.65,4.64,.36),(sign*.62,4.94,.33)],.11,.035,PALE)
        stroke(v,[(sign*.44,4.43,.41),(sign*.83,4.51,.38),(sign*.84,4.72,.34)],.068,.027,LIGHT)
    ellipsoid(v,(0,3.48,.75),(.115,.28,.15),LIGHT)
    stroke(v,[(-.19,3.24,.65),(0,3.19,.72),(.19,3.24,.65)],.040,.040,0)
    for j in [-2,-1,0,1,2]:
        x=j*.12
        stroke(v,[(x,3.12,.54),(x*1.5,2.79,.57),(x*1.8,2.37,.53),(x*.8,2.01,.43),(x*1.25,1.51,.42)],.085,.026,PALE if j%2 else STONE[3])
    for sign in [-1,1]:
        # Interlaced root scrolls under the mask are individually positioned.
        stroke(v,[(sign*.12,2.80,.42),(sign*.58,2.61,.42),(sign*.73,2.20,.41),(sign*.45,1.98,.44),(sign*.30,2.19,.46)],.07,.035,PALE)
        stroke(v,[(sign*.10,1.12,.40),(sign*.42,1.35,.44),(sign*.73,1.30,.43),(sign*.75,.98,.42),(sign*.51,.89,.40)],.08,.025,PALE)
        for y,x in [(1.63,.44),(2.50,.61),(4.29,.70)]:
            leaf(v,(sign*x,y,.49),(sign*(x+.12),y+.39,.49),.16,LIGHT,thickness=.10)
    # A few real chips expose the dark backing; no random noise coating.
    for p,r in [((1.13,1.41,.32),(.15,.11,.18)),((-1.08,4.53,.32),(.11,.15,.18)),((.44,.52,.43),(.13,.08,.13))]:
        ellipsoid(v,p,r,0)
    model.add('Guardian',v,[((-4.35,0,-9.7),0),((4.35,0,-9.7),0)])


def columns(model):
    v=Volume((-.96,0,-.96),(.96,6.39,.96),.06)
    for y,w in [(.12,1.74),(.33,1.56),(.51,1.32),(.66,1.14),(5.70,1.20),(5.94,1.56),(6.18,1.80)]:
        v.box((0,y,0),(w,.21,w),PALE)
    # Flutes are removed from the shaft rather than drawn on its front.
    v.paint((-.56,.72,-.56),(.56,5.63,.56),lambda x,y,z: x*x+z*z<=.52**2,STONE[2])
    for angle in np.linspace(0,math.tau,12,endpoint=False):
        x,z=math.cos(angle)*.51,math.sin(angle)*.51
        v.paint((x-.06,.89,z-.06),(x+.06,5.31,z+.06),lambda X,Y,Z: (X-x)**2+(Z-z)**2<.065**2,0)
    for y in [1.20,2.19,3.18,4.17,5.16]:
        v.paint((-.56,y-.025,-.56),(.56,y+.025,.56),lambda x,Y,z: x*x+z*z>.46**2,0)
    for y in [.78,2.16,5.49]:
        ring(v,(0,y,0),(.54,.54),.055,GOLD,'xz')
    for angle in np.linspace(0,math.tau,8,endpoint=False):
        radial=np.array([math.cos(angle),0,math.sin(angle)])
        leaf(v,radial*.48+[0,5.23,0],radial*.76+[0,5.87,0],.21,LIGHT,normal=radial,thickness=.12)
        leaf(v,radial*.54+[0,.27,0],radial*.55+[0,.64,0],.14,STONE[1],normal=radial,thickness=.09)
    positions=[((s*10.6,0,z),0) for s in [-1,1] for z in [-6.9,6.9]]
    positions += [((x,0,s*9),0) for s in [-1,1] for x in [-5.9,5.9]]
    model.add('Columns',v,positions)


def portals(model):
    v=Volume((-3.6,0,-.75),(3.6,6.30,.81),.06)
    for sign in [-1,1]:
        for j in range(7):
            v.box((sign*2.86,.24+j*.46,0),(.94,.42,1.14),STONE[j%4])
        for y in [.18,.42,3.09]:
            v.box((sign*2.86,y,0),(1.17,.18,1.38),PALE)
        for j in range(4):
            y=.77+j*.52
            leaf(v,(sign*2.88,y,.61),(sign*(2.88+.17),y+.40,.65),.17,PALE,thickness=.11)
            stroke(v,[(sign*2.87,y,.60),(sign*2.75,y+.23,.66),(sign*2.90,y+.46,.60)],.045,.035,GOLD)
    # Radial voussoir joints and stepped archivolts, sampled as cubic occupancy.
    for j in range(21):
        a=math.pi*j/21+.008
        b=math.pi*(j+1)/21-.008
        def stone_field(x,y,z):
            yy=y-3.05
            angle=np.arctan2(yy,x)
            return (angle>=a)&(angle<=b)&(x*x+yy*yy>=2.35**2)&(x*x+yy*yy<=3.12**2)
        v.paint((-3.2,3.04,-.57),(3.2,6.20,.57),stone_field,STONE[j%4])
    ring(v,(0,3.05,.61),(2.40,2.40),.066,PALE,start=0,end=math.pi)
    ring(v,(0,3.05,.61),(3.05,3.05),.060,PALE,start=0,end=math.pi)
    for a in np.linspace(.16,math.pi-.16,15):
        p=np.array([math.cos(a)*2.76,3.05+math.sin(a)*2.76,.64])
        tip=p+np.array([math.cos(a)*.16,math.sin(a)*.16,0])
        leaf(v,p-np.array([math.cos(a)*.12,math.sin(a)*.12,0]),tip,.08,LIGHT,thickness=.07,vein=False)
    v.box((0,5.96,.0),(.51,.60,1.44),PALE)
    leaf(v,(0,5.69,.75),(0,6.10,.75),.15,GOLD,thickness=.06)
    placements=[((0,0,z),0) for z in [-11.4,11.4,16.6]] + [((x,0,0),math.pi/2) for x in [-15,15]]
    model.add('Portals',v,placements)


def walls(model):
    source=next(r for r in json.loads((PROJECT/'data/rootbound_layout.json').read_text())['rooms'] if r['id']=='07')
    poly=(np.asarray(source['polygon'],float)-[500,685])*.12
    lengths=np.linalg.norm(np.roll(poly,-1,axis=0)-poly,axis=1)
    cumulative=np.r_[0,np.cumsum(lengths)]
    vertices=np.vstack([poly,poly[0]])
    perimeter=cumulative[-1]
    count=math.ceil(perimeter/1.08)
    unit=perimeter/count
    chunks={}
    for row in range(11):
        for j in range(count):
            distance=(j+row%2*.5)*unit
            pair=[]
            for d in [distance,distance+unit]:
                d%=perimeter
                pair.append(np.array([np.interp(d,cumulative,vertices[:,k]) for k in range(2)]))
            a,b=pair
            mid=(a+b)/2
            if any(np.linalg.norm(mid-p)<3.0 for p in [(0,-11.4),(0,11.4),(-15,0),(15,0)]):
                continue
            direction=(b-a)/np.linalg.norm(b-a)
            inward=np.array([-direction[1],direction[0]])
            mid-=inward*.25
            center=np.array([mid[0],.29+row*.56,mid[1]])
            key=(math.floor(mid[0]/6),math.floor(mid[1]/6))
            chunks.setdefault(key,[]).append((center,direction,np.linalg.norm(b-a),row,j))
    for key,bricks in chunks.items():
        centers=np.array([b[0] for b in bricks])
        v=Volume(centers.min(axis=0)-[1,.4,1],centers.max(axis=0)+[1,.55,1],.03)
        for p,d,length,row,j in bricks:
            width=length-.035
            def field(x,y,z):
                along=(x-p[0])*d[0]+(z-p[2])*d[1]
                depth=-(x-p[0])*d[1]+(z-p[2])*d[0]
                yy=y-p[1]
                return (np.abs(along)<width/2)&(np.abs(yy)<.256)&(np.abs(depth)<.29)&(np.abs(along)+np.abs(yy)<width/2+.256-.045)
            v.paint(p-[1,.28,1],p+[1,.28,1],field,STONE[(j+row*3)%4])
            if row in [0,8,10]:
                yy=p[1]+.20
                v.paint(p-[1,.0,1],p+[1,.32,1],lambda x,y,z: (np.abs((x-p[0])*d[0]+(z-p[2])*d[1])<length/2)&(np.abs(-(x-p[0])*d[1]+(z-p[2])*d[0])<.37)&(np.abs(y-yy)<.065),PALE)
            if row in [2,5,9] and j%9==0:
                inward=np.array([-d[1],0,d[0]])
                ellipsoid(v,p+inward*.30+[0,.21,0],(.13,.13,.13),0)
        model.add('Walls_%d_%d'%key,v)


def fountain(model):
    v=Volume((-2.52,0,-2.04),(2.52,1.20,2.04),.03)
    for y,w,d,h in [(.12,5.04,4.08,.24),(.30,4.80,3.84,.12),(.42,4.56,3.60,.12)]:
        v.box((0,y,0),(w,h,d),PALE if y!=.30 else STONE[0])
    for sign in [-1,1]:
        v.box((sign*2.13,.69,0),(.30,.51,3.48),STONE[2])
        v.box((0,.69,sign*1.74),(4.29,.51,.30),STONE[2])
        for y in [.48,.90,1.02]:
            v.box((0,y,sign*1.74),(4.50,.09,.39),PALE)
            v.box((sign*2.13,y,0),(.39,.09,3.51),PALE)
        for x in [-1.62,-1.08,-.54,0,.54,1.08,1.62]:
            p=(x,.53,sign*1.91)
            leaf(v,p,(x,.85,sign*1.91),.115,PALE,normal=(0,0,sign),thickness=.07)
        for z in [-1.08,-.54,0,.54,1.08]:
            leaf(v,(sign*2.30,.53,z),(sign*2.30,.85,z),.115,PALE,normal=(sign,0,0),thickness=.07)
    # Four corner rosettes replace square blank caps.
    for x in [-2.10,2.10]:
        for z in [-1.71,1.71]:
            ellipsoid(v,(x,1.01,z),(.22,.12,.22),PALE)
            for a in np.linspace(0,math.tau,6,endpoint=False):
                leaf(v,(x,1.08,z),(x+math.cos(a)*.20,1.08,z+math.sin(a)*.20),.07,GOLD,normal=(0,1,0),thickness=.035,vein=False)
    model.add('Fountain',v,[((0,0,-4.32),0)])
    w=Volume((-2,.49,-1.57),(2,.68,1.57),.03)
    w.box((0,.56,0),(3.99,.09,3.09),0x28685b)
    for radius in [.55,.91,1.36]:
        ring(w,(0,.62,0),(radius,radius*.70),.021,0x6baf91,'xz',start=.35,end=5.5)
    model.add('Water',w,[((0,0,-4.32),0)],4)


def heartwood(model):
    v=Volume((-9,0,-9),(10,9.5,2),.06)
    c=np.array([0,0,-4.32])
    main=np.array([[0,.57,0],[-.45,1.75,-.24],[-.84,3.1,-.42],[-.55,4.5,-.59],[-.09,5.8,-.9],[.7,7.65,-1.3]])+c
    stroke(v,main,.74,.12,BARK[1])
    branches=[[[ -.60,2.7,-.3],[1.1,3.9,-.5],[3.1,5.15,-.9],[5.5,6,-1.3],[8.0,7,-2.3]], [[-.74,3,-.4],[-2.1,4.2,-.2],[-4.0,4.9,.4],[-6.3,6.1,1.7],[-7.8,6.7,1.4]], [[-.36,4.9,-.6],[-1.8,6,-1.8],[-3.6,7.4,-2.7]]]
    for j,branch in enumerate(branches):
        branch=np.asarray(branch)+c
        stroke(v,branch,.40-j*.04,.045,BARK[1])
        for sign in [-1,1]:
            end=branch[-1]+[sign*.70,.40,.55]
            stroke(v,[branch[-2],branch[-1],end],.13,.024,BARK[2])
    for angle in np.linspace(0,math.tau,9,endpoint=False):
        end=c+[math.cos(angle)*1.80,.68,math.sin(angle)*1.29]
        stroke(v,[c+[-.21,1.50,0],c+[math.cos(angle)*.93,.88,math.sin(angle)*.73],end],.26,.052,BARK[1])
    # Long cut bark furrows follow the trunk, plus a knot with a dark hollow.
    for angle in np.linspace(0,math.tau,9,endpoint=False):
        points=[]
        for j,p in enumerate(main[:-1]):
            r=.69-j*.12
            points.append(p+[math.cos(angle)*r,0,math.sin(angle)*r])
        stroke(v,points,.052,.031,0)
    ellipsoid(v,c+[-.35,2.50,.35],(.30,.43,.12),BARK[2])
    ellipsoid(v,c+[-.35,2.52,.43],(.15,.25,.12),0)
    model.add('Heartwood',v)
    foliage=Volume((-9,5,-9),(10,9.5,1),.06)
    rng=np.random.default_rng(707)
    centers=[[-7.3,6.7,-2.9],[-5.8,6.1,-2.4],[-3.5,7.5,-7.0],[.7,7.7,-5.6],[5.8,6.35,-5.6],[8.0,7,-6.6]]
    for center in centers:
        for j in range(24):
            angle=j*2.39996
            start=np.asarray(center)+[math.cos(angle)*rng.uniform(.1,.9),rng.uniform(-.15,.35),math.sin(angle)*rng.uniform(.1,.65)]
            tip=start+[math.cos(angle)*.60,rng.uniform(.08,.28),math.sin(angle)*.60]
            leaf(foliage,start,tip,.20,LEAVES[j%4],normal=(0,1,0),thickness=.055,vein=False)
    model.add('Canopy',foliage)
    jewel=Volume((-.50,2.10,-.10),(.95,4.10,1.15),.03)
    ellipsoid(jewel,(.23,3.03,.72),(.25,.66,.18),JADE)
    model.add('JadeHeart',jewel,[((0,0,-4.32),0)],2)
    setting=Volume((-.60,2.10,.1),(1.0,4.10,1.15),.03)
    for sign in [-1,1]:
        stroke(setting,[(.23,2.29,.72),(.23+sign*.38,2.8,.72),(.23+sign*.37,3.3,.72),(.23,3.80,.72)],.06,.034,GOLD)
        for y in [2.65,3.45]:
            leaf(setting,(.23+sign*.31,y,.72),(.23+sign*.52,y+.18,.73),.10,GOLD,thickness=.06)
    stroke(setting,[(.23,3.80,.72),(.1,4.05,.52)],.035,.035,GOLD)
    model.add('Reliquary',setting,[((0,0,-4.32),0)],1)


def vessels(model):
    v=Volume((-.65,0,-.45),(.65,1.20,.45),.03)
    profile=np.array([[0,.23],[.10,.28],[.20,.23],[.38,.38],[.62,.37],[.82,.22],[.94,.20],[1.01,.29],[1.10,.29]])
    v.paint((-.4,0,-.4),(.4,1.11,.4),lambda x,y,z:x*x+z*z<=np.interp(y,profile[:,0],profile[:,1])**2,0x8c7851)
    # The mouth has a real hollow and a thick lip.
    v.paint((-.24,.84,-.24),(.24,1.15,.24),lambda x,y,z:x*x+z*z<.21**2,0)
    for y,r in [(.12,.26),(.27,.29),(.78,.25),(1.06,.28)]:
        ring(v,(0,y,0),(r,r),.03,GOLD,'xz')
    for angle in np.linspace(0,math.tau,8,endpoint=False):
        radial=np.array([math.cos(angle),0,math.sin(angle)])
        leaf(v,radial*.355+[0,.35,0],radial*.34+[0,.68,0],.074,PALE,normal=radial,thickness=.044)
    for sign in [-1,1]:
        stroke(v,[(sign*.23,.92,0),(sign*.48,.93,0),(sign*.54,.69,0),(sign*.36,.53,0)],.053,.053,GOLD)
    placements=[((s*10.4,0,z+.9),0) for s in [-1,1] for z in [-6.7,6.7]]
    placements += [((s*12.4,0,z),0) for s in [-1,1] for z in [-3,3]]
    model.add('Vessels',v,placements)
    # Small devotional chest at the side: curved stepped lid, bands and a lock.
    chest=Volume((-1,0,-.60),(1,1.18,.60),.03)
    chest.box((0,.35,0),(1.5,.62,.90),BARK[1])
    chest.paint((-.75,.62,-.45),(.75,1.02,.45),lambda x,y,z: ((y-.62)/.34)**2+(z/.45)**2<=1,BARK[2])
    for x in [-.51,.51]:
        chest.box((x,.35,.468),(.09,.62,.06),GOLD)
        chest.paint((x-.06,.61,-.49),(x+.06,1.07,.49),lambda X,y,z: (((y-.62)/.38)**2+(z/.49)**2<=1)&(((y-.62)/.32)**2+(z/.43)**2>=1),GOLD)
    chest.box((0,.57,.51),(.24,.30,.09),GOLD)
    ellipsoid(chest,(0,.62,.57),(.043,.051,.048),0)
    chest.box((0,.55,.56),(.042,.105,.06),0)
    for x in [-.69,-.51,0,.51,.69]:
        for y in [.15,.74]:
            ellipsoid(chest,(x,y,.495),(.033,.033,.033),PALE)
    for x in np.arange(-.6,.61,.18):
        stroke(chest,[(x,.16,.457),(x+.02,.36,.457),(x-.02,.58,.457)],.017,.017,0)
    model.add('OfferingChest',chest,[((9.70,0,3.65),0)])


def fire_and_garden(model):
    brazier=Volume((-.60,0,-.60),(.60,1.44,.60),.03)
    brazier.box((0,.12,0),(.96,.24,.96),PALE)
    profile=np.array([[.24,.29],[.42,.17],[.86,.18],[1.03,.28],[1.27,.49],[1.36,.49]])
    brazier.paint((-.5,.24,-.5),(.5,1.37,.5),lambda x,y,z:x*x+z*z<=np.interp(y,profile[:,0],profile[:,1])**2,GOLD)
    brazier.paint((-.42,1.20,-.42),(.42,1.40,.42),lambda x,y,z:x*x+z*z<.37**2,0)
    for angle in np.linspace(0,math.tau,8,endpoint=False):
        radial=np.array([math.cos(angle),0,math.sin(angle)])
        leaf(brazier,radial*.22+[0,.87,0],radial*.48+[0,1.3,0],.10,BRONZE,normal=radial,thickness=.06)
    positions=[((s*3.1,0,-8.8),0) for s in [-1,1]] + [((s*9.4,0,z+1.2),0) for s in [-1,1] for z in [-6.7,6.7]]
    model.add('Braziers',brazier,positions,1)
    flame=Volume((-.4,1.25,-.4),(.4,2.15,.4),.03)
    for j in range(7):
        angle=j*2.39996
        p=np.array([math.cos(angle)*.21,1.3,math.sin(angle)*.21])
        stroke(flame,[p,p+[.04,.26,0],p+[-.07,.57+(j%2)*.18,.03]],.10,.018,0xffcf81)
    model.add('Flames',flame,positions,3)
    candles=Volume((-.55,0,-.28),(.55,.76,.40),.03)
    candlefire=Volume((-.55,0,-.28),(.55,.90,.40),.03)
    for j in range(4):
        p=np.array([(j-1.5)*.21,0,(j%2)*.16])
        height=.21+(j%3)*.13
        candles.paint(p+[-.075,0,-.075],p+[.075,height,.075],lambda x,y,z:(x-p[0])**2+(z-p[2])**2<.071**2,0xd5c69c)
        ellipsoid(candles,p+[.058,height*.68,.035],(.035,height*.22,.04),0xd5c69c)
        stroke(candlefire,[p+[0,height,0],p+[.023,height+.13,0],p+[-.015,height+.23,0]],.045,.013,0xffd991)
    cp=[((s*1.52,1.08,-2.70),0) for s in [-1,1]]+[((s*11.7,0,z+.8),0) for s in [-1,1] for z in [-3,3]]
    model.add('Candles',candles,cp)
    model.add('CandleFlames',candlefire,cp,3)
    garden=Volume((-1.5,0,-1.5),(1.5,2,1.5),.06)
    for sign in [-1,1]:
        for j in range(6):
            start=np.array([0,.04,0])
            tip=np.array([sign*(.23+j*.12),.62-j*.062,(j-2.5)*.16])
            stroke(garden,[start,tip*.7+[0,.14,0],tip],.028,.018,LEAVES[1])
            for t in [.30,.5,.7,.86]:
                p=start+(tip-start)*t+[0,.05,0]
                for s in [-1,1]:
                    leaf(garden,p,p+[s*.17,.025,.17],.076,LEAVES[(j+s)%4],normal=(0,1,0),thickness=.04,vein=False)
    for p in [(-.72,0,.28),(.64,0,.53),(.28,0,-.62)]:
        stroke(garden,[p,np.asarray(p)+[0,.27,0]],.052,.04,0x83a780)
        ellipsoid(garden,np.asarray(p)+[0,.29,0],(.22,.11,.22),0x87b88d)
        for dx,dz in [(-.07,.06),(.09,-.02)]:
            ellipsoid(garden,np.asarray(p)+[dx,.38,dz],(.044,.018,.044),0xc0cd9b)
    model.add('Ferns',garden,[((s*11.5,0,z),0) for s in [-1,1] for z in [-6.4,6.4]])


def wall_scrolls(model):
    v=Volume((-1.8,0,-.24),(1.8,1.65,.48),.03)
    v.box((0,.79,-.06),(3.45,1.38,.24),STONE[0])
    v.box((0,.79,.075),(3.16,1.08,.06),DARK)
    for y in [.19,1.39]:
        v.box((0,y,.15),(3.51,.09,.30),PALE)
    stroke(v,[(-1.48,.56,.19),(-.90,.72,.21),(-.40,.56,.21),(0,.78,.22),(.40,.56,.21),(.90,.72,.21),(1.48,.56,.19)],.062,.062,PALE)
    for sign in [-1,1]:
        for j in range(3):
            x=sign*(.28+j*.47)
            leaf(v,(x,.64,.22),(x+sign*.18,1.15,.24),.17,LIGHT,thickness=.105)
            leaf(v,(x,.62,.22),(x-sign*.16,.36,.23),.12,PALE,thickness=.085)
    ring(v,(0,.81,.20),(.19,.32),.045,GOLD)
    model.add('WallFrieze',v,[((s*11.83,1.68,4.20),-s*math.pi/2) for s in [-1,1]])


def finish_architecture(model):
    roots=Volume((-1.7,0,-2.5),(1.2,7.5,1.2),.06)
    main=[(0,0,0),(-.48,1.1,.20),(-.21,2.35,.11),(.12,3.5,-.28),(.35,5.0,-.71),(-.12,6.1,-1.5),(-1.2,7.1,-2.1)]
    stroke(roots,main,.33,.032,BARK[1])
    for j,offset in enumerate([-.17,0,.17]):
        stroke(roots,[(p[0]+offset,p[1],p[2]+.27-j*.055) for p in main[:-1]],.035,.025,0)
    for sign in [-1,1]:
        stroke(roots,[(0,1.7,0),(sign*.41,.68,.27),(sign*.70,.13,.48),(sign*.95,.05,.64)],.13,.02,BARK[2])
    stroke(roots,[(-.16,3.1,-.1),(-.90,4.25,-.05),(-1.48,4.91,.16)],.15,.024,BARK[1])
    pos=[((11.7,0,z),0) for z in [-6.7,6.7]]+[((-11.7,0,z),math.pi) for z in [-6.7,6.7]]
    model.add('WallRoots',roots,pos)
    ivy=Volume((-1.8,.08,-2.5),(1.3,7.5,1.2),.06)
    for branch in [[(-1.1,6.8,-2),(-.8,5.8,-1.4),(-.9,4.8,-.8),(-1.15,4,-.4)],[(.45,5.7,-.6),(.66,4.75,-.3),(.7,3.7,0),(.54,2.8,.18)]]:
        stroke(ivy,branch,.033,.017,LEAVES[0])
        points=np.asarray(branch)
        for section in range(len(points)-1):
            for j in range(4):
                p=points[section]*(1-j/4)+points[section+1]*j/4
                sign=1 if j%2 else -1
                leaf(ivy,p,p+[sign*.29,-.28,.03],.15,LEAVES[(j+section)%4],thickness=.04,vein=False)
    model.add('WallIvy',ivy,pos)
    rib=Volume((4.1,6.1,-.48),(11.35,9.5,.48),.06)
    for j in range(12):
        a=j*.095+.006
        b=(j+1)*.095-.006
        def field(x,y,z):
            yy=y-6.24
            angle=np.arctan2(yy/2.70,x/10.85)
            return (angle>=a)&(angle<=b)&((x/10.6)**2+(yy/2.48)**2>=1)&((x/11.1)**2+(yy/2.96)**2<=1)
        rib.paint((4.1,6.24,-.36),(11.2,9.4,.36),field,STONE[j%4])
    points=[(math.cos(a)*10.65,6.24+math.sin(a)*2.50,.39) for a in np.linspace(0,1.10,56)]
    stroke(rib,points,.056,.056,PALE)
    model.add('VaultRibs',rib,[((0,0,z),yaw) for z in [-6.8,6.8] for yaw in [0,math.pi]])
    corridor=Volume((-2.65,0,11.35),(2.65,5.65,18.25),.03)
    for sign in [-1,1]:
        for row in range(11):
            for j in range(8):
                z=11.50+j*.90+(row%2)*.45
                corridor.box((sign*2.44,.25+row*.48,z),(.15,.438,.858),STONE[(row+j)%4])
        for y in [.14,.68,3.50,5.48]:
            corridor.box((sign*2.36,y,14.8),(.12,.12,6.84),PALE)
        for z in [12.60,14.80,17.80]:
            for y in [1.0,1.45,1.90,2.35,2.80]:
                leaf(corridor,(sign*2.30,y,z),(sign*2.30,y+.35,z+.18),.11,PALE,normal=(-sign,0,0),thickness=.065)
    model.add('CorridorAshlar',corridor)
    sconce=Volume((-.23,-.84,-.26),(.23,.15,.26),.03)
    stroke(sconce,[(0,-.80,0),(0,.02,0)],.06,.08,BARK[1])
    for y in [-.67,-.20,-.10,.08]:
        ring(sconce,(0,y,0),(.12 if y<0 else .19,.12 if y<0 else .19),.034,GOLD,'xz')
    for angle in np.linspace(0,math.tau,6,endpoint=False):
        radial=np.array([math.cos(angle),0,math.sin(angle)])
        leaf(sconce,radial*.09+[0,-.21,0],radial*.20+[0,.12,0],.085,BRONZE,normal=radial,thickness=.04,vein=False)
    tp=[((s*2.24,2.6,z),0) for s in [-1,1] for z in [13.5,17.5]]
    model.add('Sconces',sconce,tp,1)
    flames=Volume((-.23,.02,-.23),(.23,.77,.23),.03)
    for j in range(4):
        a=j*2.4
        p=np.array([math.cos(a)*.065,.1,math.sin(a)*.065])
        stroke(flames,[p,p+[.04,.23,0],p+[-.035,.51+j%2*.09,0]],.085,.014,0xffcf81)
    model.add('SconceFlames',flames,tp,3)
    seal=Volume((-2.1,0,2.1),(2.1,.06,6.3),.03)
    for radius in [1.69,1.84]:
        ring(seal,(0,.012,4.2),(radius,radius),.018,BRONZE,'xz')
    stroke(seal,[(0,.018,3.1),(-.09,.018,4.0),(.05,.018,4.7),(0,.018,5.3)],.026,.025,PALE)
    for sign in [-1,1]:
        for j in range(4):
            z=3.3+j*.43
            leaf(seal,(0,.018,z),(sign*(.67-abs(j-1.5)*.12),.018,z+.40),.14,STONE[3],normal=(0,1,0),thickness=.018,vein=False)
    model.add('FloorSeal',seal)


def main():
    (HERE/'Evidence').mkdir(exist_ok=True)
    model=Model()
    for build in [guardian,columns,portals,walls,fountain,heartwood,vessels,fire_and_garden,wall_scrolls,finish_architecture]:
        print('BUILDING',build.__name__,flush=True)
        build(model)
    model.save()


if __name__=='__main__':
    main()
