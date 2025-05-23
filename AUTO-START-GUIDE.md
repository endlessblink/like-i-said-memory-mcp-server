## 🎯 How MCP Auto-Start Really Works

**MCP clients (Claude, Cursor, Windsurf) automatically start and stop your server as needed.**

### ✅ Correct Setup (Recommended)

1. **Configure in Claude Desktop** (`%APPDATA%\Claude\claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "like-i-said-memory": {
      "command": "node",
      "args": ["D:/MY PROJECTS/AI/LLM/AI Code Gen/my-builds/My MCP/Like-I-said-mcp-server/server.js"]
    }
  }
}
```

2. **That's it!** When you open Claude Desktop:
   - ✅ Claude automatically starts your MCP server
   - ✅ Claude communicates with it via stdin/stdout
   - ✅ Claude stops it when you close the app

### 🔄 For Other MCP Apps

**Cursor IDE**: Add to settings.json:
```json
{
  "mcp.servers": {
    "like-i-said-memory": {
      "command": "node",
      "args": ["D:/MY PROJECTS/AI/LLM/AI Code Gen/my-builds/My MCP/Like-I-said-mcp-server/server.js"]
    }
  }
}
```

**Windsurf**: Similar MCP configuration in their settings.

## 🚀 Alternative: Always-Running Server

If you want the server always running (not recommended but possible):

## 🔧 Alternative: Always-Running Server (Advanced)

**Use the wrapper for always-on server:**

```bash
# Start with wrapper (keeps server alive)
npm run start-wrapper

# Or with PM2 
npm run pm2:start-wrapper
```

**Install to Windows Startup:**
```bash
# Run this once to add to startup
powershell .\manage-server.ps1 install-startup
```

**Note**: MCP clients prefer to manage servers themselves. Only use always-running mode if you have specific needs.

## 📁 Files Created

- `start-invisible.vbs` - Silent startup script
- `server-wrapper.js` - Keeps server running with restarts  
- `manage-server.ps1` - PowerShell management commands
- `logs/wrapper.log` - Wrapper logs
- `logs/` - Log directory for PM2/wrapper

## ✅ Verification

**Check if auto-start works:**
1. Configure in Claude Desktop (see above)
2. Close and reopen Claude Desktop
3. Your MCP server should be available automatically

**Manual verification:**
```bash
powershell .\manage-server.ps1 status
```
