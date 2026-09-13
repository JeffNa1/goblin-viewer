const fs = require('fs');
const content = fs.readFileSync('tools/test_add_archer.py', 'utf8');
const lines = content.split('\n');
for (let i = 0; i < lines.length; i++) {
  if (lines[i].includes('quiver_anchor')) {
    console.log((i+1) + ': ' + lines[i]);
  }
}
