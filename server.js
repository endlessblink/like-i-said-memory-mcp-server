#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} = require('@modelcontextprotocol/sdk/types.js');

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

// Create MCP server
const server = new Server(
  {
    name: 'like-i-said-memory',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Add tool handlers
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'add_memory',
        description: 'Store a memory with optional context',
        inputSchema: {
          type: 'object',
          properties: {
            key: {
              type: 'string',
              description: 'The key to store the memory under',
            },
            value: {
              type: 'string',
              description: 'The memory content to store',
            },
            context: {
              type: 'object',
              description: 'Optional context metadata for the memory',
            },
          },
          required: ['key', 'value'],
        },
      },
      {
        name: 'get_memory',
        description: 'Retrieve a memory by key',
        inputSchema: {
          type: 'object',
          properties: {
            key: {
              type: 'string',
              description: 'The key to retrieve the memory for',
            },
          },
          required: ['key'],
        },
      },
      {
        name: 'list_memories',
        description: 'List memory keys, optionally filtered by prefix',
        inputSchema: {
          type: 'object',
          properties: {
            prefix: {
              type: 'string',
              description: 'Optional prefix to filter memory keys',
            },
          },
        },
      },
      {
        name: 'delete_memory',
        description: 'Delete a memory by key',
        inputSchema: {
          type: 'object',
          properties: {
            key: {
              type: 'string',
              description: 'The key of the memory to delete',
            },
          },
          required: ['key'],
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'add_memory': {
        if (!args.key || !args.value) {
          throw new Error('Missing required parameters: key and value');
        }
        
        const db = readDB();
        db[args.key] = {
          value: args.value,
          context: args.context || {},
          timestamp: new Date().toISOString(),
        };
        writeDB(db);
        
        return {
          content: [
            {
              type: 'text',
              text: `Successfully stored memory with key: ${args.key}`,
            },
          ],
        };
      }

      case 'get_memory': {
        if (!args.key) {
          throw new Error('Missing required parameter: key');
        }
        
        const db = readDB();
        const memory = db[args.key];
        
        if (!memory) {
          return {
            content: [
              {
                type: 'text',
                text: `No memory found for key: ${args.key}`,
              },
            ],
          };
        }
        
        return {
          content: [
            {
              type: 'text',
              text: `Memory for "${args.key}": ${memory.value}${
                Object.keys(memory.context).length > 0 
                  ? `\nContext: ${JSON.stringify(memory.context, null, 2)}`
                  : ''
              }\nStored: ${memory.timestamp}`,
            },
          ],
        };
      }

      case 'list_memories': {
        const db = readDB();
        const prefix = args.prefix || '';
        const keys = Object.keys(db).filter(k => k.startsWith(prefix));
        
        if (keys.length === 0) {
          return {
            content: [
              {
                type: 'text',
                text: prefix 
                  ? `No memories found with prefix: ${prefix}`
                  : 'No memories stored',
              },
            ],
          };
        }
        
        return {
          content: [
            {
              type: 'text',
              text: `Found ${keys.length} memory(ies)${prefix ? ` with prefix "${prefix}"` : ''}:\n${keys.join('\n')}`,
            },
          ],
        };
      }

      case 'delete_memory': {
        if (!args.key) {
          throw new Error('Missing required parameter: key');
        }
        
        const db = readDB();
        
        if (!db[args.key]) {
          return {
            content: [
              {
                type: 'text',
                text: `No memory found for key: ${args.key}`,
              },
            ],
          };
        }
        
        delete db[args.key];
        writeDB(db);
        
        return {
          content: [
            {
              type: 'text',
              text: `Successfully deleted memory with key: ${args.key}`,
            },
          ],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `Error: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Like I Said Memory MCP Server started successfully');
}

main().catch((error) => {
  console.error('Server failed to start:', error);
  process.exit(1);
});
