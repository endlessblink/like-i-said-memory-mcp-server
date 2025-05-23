# Like I Said - MCP Memory Server

A Model Context Protocol (MCP) server for persistent AI assistant memory with **web dashboard interface**.

## ✨ Features

- 🧠 **Persistent Memory**: Store and retrieve memories across conversations
- 🌐 **Web Dashboard**: Modern React interface to view and manage memories  
- 🔄 **Real-time Updates**: Live dashboard with search and filtering
- ⚡ **Easy Setup**: Multiple deployment options
- 🔧 **MCP Compatible**: Works with Claude Desktop, Cursor, and other MCP clients

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Development Mode (Frontend + Backend)
```bash
npm run dev:full
```
- **Frontend**: http://localhost:5173 (React dashboard)
- **Backend**: http://localhost:3001 (API server)

### 3. Production Mode (MCP Server Only)
```bash
npm start
```

## 🔧 MCP Configuration

### Claude Desktop Setup
1. Copy `claude-desktop-config.template.json` to your Claude config directory
2. Update the path to point to your project location
3. Rename to `claude_desktop_config.json`

**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "like-i-said-memory": {
      "command": "node",
      "args": ["PATH_TO_YOUR_PROJECT/server.js"]
    }
  }
}
```

## 🛠️ Available Tools

- `add_memory(key, value, context?)`: Store a memory with optional context
- `get_memory(key)`: Retrieve a memory by key
- `list_memories(prefix?)`: List all memory keys (with optional prefix filter)
- `delete_memory(key)`: Delete a memory by key

## 📱 Web Dashboard

The dashboard provides:
- **Memory Browser**: View all stored memories in a searchable table
- **Search & Filter**: Find memories by key, value, or tags
- **Add/Edit**: Create and modify memories through the UI
- **Real-time**: Automatically syncs with the MCP server data

## 🗂️ Data Storage

Memories are stored in `memory.json` with structure:
```json
{
  "memory_key": {
    "value": "The actual memory content",
    "context": {
      "type": "category",
      "tags": ["tag1", "tag2"]
    },
    "timestamp": "2025-01-01T00:00:00.000Z"
  }
}
```

## 📜 Scripts

- `npm start` - Start MCP server only
- `npm run dashboard` - Start web dashboard only  
- `npm run dev:full` - Start both servers for development
- `npm run build` - Build frontend for production
- `npm run pm2:start` - Start with PM2 process manager

## 🔧 PM2 Deployment (Optional)

1. Copy and customize `ecosystem.config.template.json`
2. Install PM2: `npm install -g pm2`
3. Start: `npm run pm2:start`

## 📋 Development

Built with:
- **Backend**: Node.js, Express
- **Frontend**: React, TypeScript, Vite, Tailwind CSS
- **UI**: Shadcn/ui components

## 📄 License

MIT License - see LICENSE file for details.
