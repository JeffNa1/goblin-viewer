"""Run the isolated room 07 art checks with the installed real renderer."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess
import sys

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
ART = HERE.parent
GODOT = Path.home() / '.gemini/antigravity/bin/godot.exe'
EVIDENCE = HERE / 'Evidence'
EVIDENCE.mkdir(exist_ok=True)


def save(name, value):
    (EVIDENCE / name).write_text(json.dumps(value, indent=2), encoding='utf-8')


def run(script, label, args=()):
    command = [str(GODOT), '--path', str(PROJECT), '--rendering-method', 'forward_plus',
               '--audio-driver', 'Dummy', '--script', script, '--', *args]
    result = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True,
                            encoding='utf-8', errors='replace', timeout=300)
    save(label + '.json', {'command': command, 'exit_code': result.returncode,
                          'stdout': result.stdout, 'stderr': result.stderr})
    print(result.stdout)
    print(result.stderr)
    print(label, 'exit_code=', result.returncode)
    return result.returncode


def preserve():
    paths = json.loads((ART / 'Evidence/protected-baseline.json').read_text(encoding='utf-8'))
    paths.update({name: '' for name in [
        'scripts/skeleton_warrior.gd', 'tools/capture_skeleton_warrior.gd',
        'Rootbound_Sanctum/Art_Dungeon/room_art.gd',
        'Rootbound_Sanctum/Art_Dungeon/early_rooms.gd',
        'Rootbound_Sanctum/Art_Dungeon/late_rooms.gd',
        'Rootbound_Sanctum/Art_Dungeon/layout_grid.gd',
        'Rootbound_Sanctum/Art_Dungeon/test_dungeon.gd']})
    hashes = {name: hashlib.sha256((PROJECT / name).read_bytes()).hexdigest()
              if (PROJECT / name).exists() else None for name in paths}
    save('protected-before.json', hashes)
    save('git-before.json', subprocess.run(['git', 'status', '--short'], cwd=PROJECT,
         capture_output=True, text=True).stdout)
    for name in ['dungeon.gd', 'room_art.gd']:
        shutil.copy2(ART / name, EVIDENCE / ('before-' + name + '.txt'))
    room = next(r for r in json.loads((PROJECT / 'data/rootbound_layout.json').read_text())['rooms'] if r['id'] == '07')
    save('room-source.json', room)
    print(json.dumps({key: room[key] for key in ['id', 'name', 'box', 'blockers']}, indent=2))


def regression(phase):
    destination = EVIDENCE / phase
    destination.mkdir(exist_ok=True)
    text = (ART / 'test_dungeon.gd').read_text(encoding='utf-8')
    text = text.replace('res://Rootbound_Sanctum/Art_Dungeon/Evidence/',
                        'res://Rootbound_Sanctum/Art_Dungeon/Polish07/Evidence/' + phase + '/')
    check = HERE / 'check_dungeon.gd'
    check.write_text(text, encoding='utf-8')
    return run('res://Rootbound_Sanctum/Art_Dungeon/Polish07/check_dungeon.gd', phase + '-regression')


if __name__ == '__main__':
    mode = sys.argv[1]
    if mode == 'baseline':
        preserve()
        sys.exit(regression('before'))
    if mode == 'regression':
        sys.exit(regression('after'))
    if mode == 'sample':
        source = PROJECT / 'Rootbound_Sanctum/Art_Sample/test_sample.gd'
        text = source.read_text(encoding='utf-8').replace(
            'res://Rootbound_Sanctum/Art_Sample/Evidence/acceptance.json',
            'res://Rootbound_Sanctum/Art_Dungeon/Polish07/Evidence/original-sample.json')
        (HERE / 'check_original_sample.gd').write_text(text, encoding='utf-8')
        sys.exit(run('res://Rootbound_Sanctum/Art_Dungeon/Polish07/check_original_sample.gd', 'original-sample-run'))
    if mode == 'launch':
        command = ['cmd.exe', '/d', '/c', str(HERE / 'Open_Room07.bat'), '--quit-after', '120']
        result = subprocess.run(command, cwd=PROJECT, capture_output=True, text=True,
                                encoding='utf-8', errors='replace', timeout=300)
        passed = result.returncode == 0 and 'ROOM_07_REVIEW_OPEN room=07' in result.stdout
        save('launcher.json', {'passed': passed, 'command': command, 'exit_code': result.returncode,
                              'stdout': result.stdout, 'stderr': result.stderr})
        print(result.stdout)
        print(result.stderr)
        sys.exit(0 if passed else 1)
    if mode == 'capture':
        sys.exit(run('res://Rootbound_Sanctum/Art_Dungeon/Polish07/capture_polish.gd',
                     sys.argv[2] + '-capture', [sys.argv[2]]))
    if mode == 'acceptance':
        sys.exit(run('res://Rootbound_Sanctum/Art_Dungeon/Polish07/test_polish.gd', sys.argv[2]))
    if mode == 'preservation':
        before = json.loads((EVIDENCE / 'protected-before.json').read_text())
        changes = []
        for name, digest in before.items():
            file = PROJECT / name
            current = hashlib.sha256(file.read_bytes()).hexdigest() if file.exists() else None
            if current != digest:
                changes.append(name)
        concurrent_paths = {'scripts/skeleton_warrior.gd', 'tools/capture_skeleton_warrior.gd'}
        immutable_changes = [name for name in changes if name not in concurrent_paths]
        concurrent_changes = [name for name in changes if name in concurrent_paths]
        report = {'checked': len(before), 'immutable_checked': len(before) - len(concurrent_paths),
                  'immutable_changed': immutable_changes, 'concurrent_changed': concurrent_changes,
                  'passed': not immutable_changes,
                  'scope': 'Passed means immutable map/art dependencies match. Concurrent character files are reported separately, not claimed unchanged.'}
        save('preservation.json', report)
        save('git-after.json', subprocess.run(['git', 'status', '--short'], cwd=PROJECT,
             capture_output=True, text=True).stdout)
        print(json.dumps(report))
        sys.exit(bool(immutable_changes))
