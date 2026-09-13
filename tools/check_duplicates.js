const fs = require('fs');

let vb = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');

// Find all constant declarations
const lines = vb.split('\n');
const constMap = new Map();
const duplicates = [];

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  const match = line.match(/^const\s+([A-Za-z0-9_]+)\s*:/);
  if (match) {
    const cName = match[1];
    if (constMap.has(cName)) {
      duplicates.push({ name: cName, line: i + 1, prevLine: constMap.get(cName) });
    } else {
      constMap.set(cName, i + 1);
    }
  }
}

console.log('Duplicate constants:', duplicates);
