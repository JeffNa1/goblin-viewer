const fs = require('fs');

const py = fs.readFileSync('C:/Users/Administrator/.gemini/antigravity/brain/dee0e0b1-646b-4b32-99e0-a9b632535458/scratch/add_archer_outfit3.py', 'utf8');

const anchorMatches = py.match(/([a-zA-Z0-9_]+_anchor\w*)\s*=\s*"""([\s\S]*?)"""/g);
if (anchorMatches) {
  for (const m of anchorMatches) {
    console.log(m.substring(0, 100).replace(/\n/g, ' '));
  }
}
