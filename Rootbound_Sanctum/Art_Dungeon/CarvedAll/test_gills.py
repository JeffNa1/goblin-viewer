from pathlib import Path
import json,unittest
class Gills(unittest.TestCase):
    def test_gills_project_below_the_cap(self):
        report=json.loads((Path(__file__).parent/'Evidence/art-12.json').read_text())
        part=next(p for p in report['parts'] if p['name']=='GiantSpore0GilledCap')
        self.assertLess(part['bounds'][0][1],7.5-.30,'The pale gills are buried inside the green cap.')
if __name__=='__main__':unittest.main()
