const fs = require('fs');

const content = fs.readFileSync('scripts/voxel_builder_test.gd', 'utf8');

// Find all declared constants
const declared = new Set();
for (const line of content.split('\n')) {
  const m = line.match(/^const\s+([A-Za-z0-9_]+)\s*:/);
  if (m) declared.add(m[1]);
}

// Find all used constants C_*
const used = new Set(content.match(/\bC_[A-Za-z0-9_]+\b/g));

const missing = [];
for (const u of used) {
  if (!declared.has(u)) {
    missing.push(u);
  }
}

console.log('Total declared:', declared.size);
console.log('Total used:', used.size);
console.log('Missing constants:', missing);
