#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const readline = require('readline');

// ENVIRONMENT VARIABLE HANDLING
const DB_FILE = process.env.MEMORY_FILE_PATH || path.join(__dirname, 'memory.json');

// FILE SYSTEM INITIALIZATION
try {
  fs.mkdirSync(path.dirname(DB_FILE), { recursive: true });
  if (!fs.existsSync(DB_FILE)) {
    fs.writeFileSync(DB_FILE, '{}');
    console.log(`Created new memory store at: ${DB_FILE}`);
  }
} catch (err) {
  console.error(`FATAL: Could not initialize memory file: ${err.message}`);
  process.exit(1);
}

// REST OF SERVER CODE (same as previous working version)
// ... [include all your handlers and server logic] ...
