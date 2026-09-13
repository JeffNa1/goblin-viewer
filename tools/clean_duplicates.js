const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');
const lines = vb.split('\n');
const constMap = new Map();
const newLines = [];

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  const match = line.match(/^const\s+([A-Za-z0-9_]+)\s*:/);
  if (match) {
    const cName = match[1];
    if (constMap.has(cName)) {
      console.log('Omitting duplicate constant:', cName, 'at line', i + 1);
      continue;
    } else {
      constMap.set(cName, i + 1);
    }
  }
  newLines.push(line);
}

fs.writeFileSync('scripts/voxel_builder_test.gd', newLines.join('\n'), 'utf8');
console.log('Cleaned duplicate constants from voxel_builder_test.gd');
