#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// Use environment variable or default to current directory
const DB_FILE = process.env.MEMORY_FILE_PATH || path.join(__dirname, 'memory.json');

// Ensure the directory exists
const dbDir = path.dirname(DB_FILE);
if (!fs.existsSync(dbDir)) {
  fs.mkdirSync(dbDir, { recursive: true });
}

// Create empty DB file if it doesn't exist
if (!fs.existsSync(DB_FILE)) {
  fs.writeFileSync(DB_FILE, '{}');
  console.error(`Created new memory file at: ${DB_FILE}`);
}

function readDB() {
  try { 
    return JSON.parse(fs.readFileSync(DB_FILE, 'utf8')); 
  }
  catch { 
    return {}; 
  }
}

function writeDB(data) {
  fs.writeFileSync(DB_FILE, JSON.stringify(data, null, 2));
}

function sendResponse(id, result) {
  const response = { jsonrpc: "2.0", id, result };
  process.stdout.write(JSON.stringify(response) + '\n');
}

function sendError(id, code, message) {
  const response = { jsonrpc: "2.0", id, error: { code, message } };
  process.stdout.write(JSON.stringify(response) + '\n');
}

const handlers = {
  "initialize": (id) => sendResponse(id, {
    protocolVersion: "2024-11-05",
    capabilities: { tools: { listChanged: false } },
    serverInfo: { name: "like-i-said-memory", version: "1.0.0" }
  }),
  "tools/list": (id) => sendResponse(id, {
    tools: [
      {
        name: "add_memory",
        description: "Store a memory",
        inputSchema: {
          type: "object",
          properties: { key: { type: "string" }, value: { type: "string" }, context: { type: "object" } },
          required: ["key", "value"]
        }
      },
      {
        name: "get_memory",
        description: "Retrieve a memory",
        inputSchema: {
          type: "object",
          properties: { key: { type: "string" } },
          required: ["key"]
        }
      },
      {
        name: "list_memories",
        description: "List memory keys",
        inputSchema: {
          type: "object",
          properties: { prefix: { type: "string" } }
        }
      },
      {
        name: "delete_memory",
        description: "Delete a memory",
        inputSchema: {
          type: "object",
          properties: { key: { type: "string" } },
          required: ["key"]
        }
      }
    ]
  }),
  "tools/call": (id, params) => {
    if (!params || !params.name || !params.arguments) {
      sendError(id, -32602, "Invalid params: missing name or arguments");
      return;
    }
    const { name, arguments: args } = params;
    try {
      if (name === "add_memory") {
        if (!args.key || !args.value) {
          sendError(id, -32602, "Missing required parameters: key and value");
          return;
        }
        const db = readDB();
        db[args.key] = { value: args.value, context: args.context || {}, timestamp: new Date().toISOString() };
        writeDB(db);
        sendResponse(id, { content: [{ type: "text", text: `Stored: ${args.key}` }] });
      } else if (name === "get_memory") {
        if (!args.key) {
          sendError(id, -32602, "Missing required parameter: key");
          return;
        }
        const db = readDB();
        sendResponse(id, { content: [{ type: "text", text: db[args.key] ? db[args.key].value : "Not found" }] });
      } else if (name === "list_memories") {
        const db = readDB();
        const prefix = args.prefix || '';
        const keys = Object.keys(db).filter(k => k.startsWith(prefix));
        sendResponse(id, { content: [{ type: "text", text: keys.join(', ') }] });
      } else if (name === "delete_memory") {
        if (!args.key) {
          sendError(id, -32602, "Missing required parameter: key");
          return;
        }
        const db = readDB();
        if (db[args.key]) {
          delete db[args.key];
          writeDB(db);
          sendResponse(id, { content: [{ type: "text", text: `Deleted: ${args.key}` }] });
        } else {
          sendResponse(id, { content: [{ type: "text", text: "Not found" }] });
        }
      } else {
        sendError(id, -32601, "Unknown tool");
      }
    } catch (e) {
      sendError(id, -32603, e.message);
    }
  },
  "resources/list": (id) => sendResponse(id, { resources: [] }),
  "prompts/list": (id) => sendResponse(id, { prompts: [] })
};

const rl = readline.createInterface({ input: process.stdin, output: process.stdout, terminal: false });
rl.on('line', (line) => {
  try {
    const msg = JSON.parse(line.trim());
    if (!msg.method || typeof msg.id === 'undefined
