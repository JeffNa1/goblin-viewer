"""Run real-renderer acceptance and preserve logs, hashes and counts."""
from pathlib import Path
import subprocess,sys,json,hashlib,time
HERE=Path(__file__).resolve().parent
PROJECT=HERE.parents[2]
GODOT=Path.home()/'.gemini/antigravity/bin/godot.exe'
EVIDENCE=HERE/'Evidence'
RESULTS=[]
def run(name,args,expected=0):
    start=time.perf_counter()
    p=subprocess.run(args,cwd=PROJECT,capture_output=True,text=True,timeout=180)
    (EVIDENCE/(name+'.log')).write_text(p.stdout+p.stderr,encoding='utf-8')
    result={'name':name,'exit_code':p.returncode,'expected_exit':expected,'passed':p.returncode==expected,'seconds':round(time.perf_counter()-start,3)}
    RESULTS.append(result)
    (EVIDENCE/'check-runs.json').write_text(json.dumps(RESULTS,indent=2))
    print(json.dumps(result),flush=True)
    if p.returncode!=expected:print((p.stdout+p.stderr)[-6000:]);sys.exit(1)
run('voxel-unit',[sys.executable,str(HERE.parent/'Carved07/test_voxels.py')])
run('gill-depth',[sys.executable,str(HERE/'test_gills.py')])
for name in ['test_loading','test_loading_error','test_packed_floor','test_all','regression_sample','regression_baseline','regression_approved07']:
    run(name,[str(GODOT),'--path',str(PROJECT),'--rendering-method','forward_plus','--audio-driver','Dummy','--position','1800,40','--script','res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/'+name+'.gd'])
# The dummy-renderer guard must fail before replacing any valid packed room.
asset_hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in (HERE/'Assets').glob('*.scn')}
run('reject-dummy-bake',[str(GODOT),'--headless','--path',str(PROJECT),'--script','res://Rootbound_Sanctum/Art_Dungeon/CarvedAll/bake_rooms.gd','--','01'],1)
assert all(hashlib.sha256((HERE/'Assets'/name).read_bytes()).hexdigest()==value for name,value in asset_hashes.items())
protected=json.loads((EVIDENCE/'protected-before.json').read_text())
changed=[]
for name,value in protected.items():
    p=PROJECT/name
    if not p.exists() or hashlib.sha256(p.read_bytes()).hexdigest()!=value:changed.append(name)
map_changes=[name for name in changed if name.startswith('Rootbound_Sanctum/') or name=='data/rootbound_layout.json']
report={'all_tests_passed':all(x['passed'] for x in RESULTS),'protected_files_checked':len(protected),'changed_since_baseline':changed,'map_or_approved_art_changes':map_changes,'packed_room_ids':sorted(p.stem for p in (HERE/'Assets').glob('*.scn') if p.stem.isdigit()),'dummy_bake_preserved_assets':True}
(EVIDENCE/'verification.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
assert not map_changes
assert report['packed_room_ids']==[f'{i:02d}' for i in range(1,15)]
