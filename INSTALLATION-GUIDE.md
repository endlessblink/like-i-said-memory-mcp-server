# 🚀 Quick Installation Guide

## Windows Users - Important Path Requirements

### ⚠️ Critical: Avoid Spaces in Paths
Cursor and some other MCP clients on Windows have issues with folder paths containing spaces.

### ✅ Good Installation Locations
```
C:\MCP\
D:\Development\
C:\Users\YourName\mcp-servers\
D:\Code\mcp\
```

### ❌ Bad Installation Locations (Avoid These)
```
D:\MY PROJECTS\AI\          (spaces in path)
C:\Program Files\           (spaces in path)  
C:\Users\Your Name\         (spaces in path)
Desktop\MCP Server\         (spaces in path)
```

## Quick Manual Installation

### 1. Create Installation Directory
```cmd
mkdir C:\MCP
cd C:\MCP
```

### 2. Download and Install
```cmd
git clone https://github.com/endlessblink/Like-I-Said-memory-mcp-server.git
cd Like-I-Said-memory-mcp-server
npm install
```

### 3. Configure Your AI Assistant

#### For Cursor
Edit: `%USERPROFILE%\.cursor\mcp.json`
```json
{
  "mcpServers": {
    "like-i-said-memory": {
      "command": "node",
      "args": ["C:\\MCP\\Like-I-Said-memory-mcp-server\\server.js"]
    }
  }
}
```

#### For Claude Desktop
Edit: `%APPDATA%\Claude\claude_desktop_config.json`
```json
{
  "mcpServers": {
    "like-i-said-memory": {
      "command": "node", 
      "args": ["C:\\MCP\\Like-I-Said-memory-mcp-server\\server.js"]
    }
  }
}
```

#### For Windsurf
Edit: `%USERPROFILE%\.codeium\windsurf\mcp_config.json`
```json
{
  "mcpServers": {
    "like-i-said-memory": {
      "command": "node",
      "args": ["C:\\MCP\\Like-I-Said-memory-mcp-server\\server.js"]
    }
  }
}
```

### 4. Test Installation
1. **Restart your AI assistant completely**
2. **Test with**: `Can you store "installation successful" in memory with key "test"?`
3. **Start dashboard**: `npm run dev:full` then open http://localhost:5173

## Important JSON Tips

- Use **double backslashes** (`\\`) in Windows paths within JSON
- Replace `C:\\MCP\\Like-I-Said-memory-mcp-server\\server.js` with your actual path
- Ensure the JSON syntax is valid (proper commas, brackets)
- If you have other MCP servers, add a comma after the previous server entry

## Troubleshooting

**"No tools available" in Cursor:**
1. Check your path has no spaces
2. Verify the server.js path is correct
3. Restart Cursor completely
4. Test server manually: `node C:\MCP\Like-I-Said-memory-mcp-server\server.js`

**Config file doesn't exist:**
Create the directory and file manually:
```cmd
# For Cursor
mkdir %USERPROFILE%\.cursor
echo {"mcpServers": {}} > %USERPROFILE%\.cursor\mcp.json

# For Claude Desktop  
mkdir %APPDATA%\Claude
echo {"mcpServers": {}} > %APPDATA%\Claude\claude_desktop_config.json

# For Windsurf
mkdir %USERPROFILE%\.codeium\windsurf
echo {"mcpServers": {}} > %USERPROFILE%\.codeium\windsurf\mcp_config.json
```

## Alternative: Use the Automatic Installer
If manual installation is too complex, use the one-click installer:
1. Create folder without spaces: `C:\MCP\`
2. Download `install-mcp-memory-server.bat` to that folder
3. Run it - handles everything automatically!

---
**Need help?** Create an issue at: https://github.com/endlessblink/Like-I-Said-memory-mcp-server/issues