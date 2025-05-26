# 🧠 Like-I-Said Memory MCP Server

A powerful Model Context Protocol (MCP) server that provides persistent memory capabilities for AI assistants like Claude Desktop, Cursor, and Windsurf, with an elegant web dashboard for memory management.

## ✨ Features

### 🔧 MCP Server Capabilities
- **Persistent Memory Storage** - Add, retrieve, update, and delete memories
- **Context-Aware Storage** - Store memories with rich context and metadata
- **Multi-Client Support** - Works with Claude Desktop, Cursor, and Windsurf
- **JSON-Based Storage** - Simple, readable memory.json file
- **Safe Configuration** - Preserves existing MCP server configurations

### 🎨 Web Dashboard
- **Modern React Interface** - Beautiful dark theme with violet accents
- **Real-Time Statistics** - View memory counts, recent additions, and analytics
- **Advanced Search & Filtering** - Find memories by content, tags, or metadata
- **Tag-Based Organization** - Organize memories with custom tags
- **Full CRUD Operations** - Create, read, update, and delete memories via UI
- **Mobile Responsive** - Works on desktop and mobile devices

### 🚀 Installation & Updates
- **One-Click Installation** - Single batch file installs everything
- **Smart Configuration** - Automatically detects and configures AI assistants
- **Safe Updates** - Update system preserves all data and configurations
- **Cross-Platform** - Works on Windows with Node.js

## 📦 Quick Installation

### Prerequisites
- **Node.js** (v14 or higher)
- **Git** (for installation)
- At least one supported AI assistant installed

### One-Command Install
1. Download `install-mcp-memory-server.bat`
2. Place it in any empty folder
3. Run it:

```cmd
install-mcp-memory-server.bat
```

The installer will:
- ✅ Download and install the memory server
- ✅ Configure Claude Desktop, Cursor, and/or Windsurf (your choice)
- ✅ Set up the web dashboard
- ✅ Create your personal memory database
- ✅ Preserve any existing MCP configurations

## 🎯 Usage

### MCP Memory Functions
After installation, these functions are available in your AI assistants:

```javascript
// Store a memory
add_memory("project_idea", "Build a personal finance app with React", {
  "tags": ["project", "react", "finance"],
  "priority": "high"
})

// Retrieve a memory
get_memory("project_idea")

// List memories with prefix
list_memories("project_")

// Delete a memory
delete_memory("project_idea")
```

### Web Dashboard
Start the dashboard to manage memories visually:

```cmd
cd your-installation-folder
npm run dev:full
```

Then open: **http://localhost:5173**

#### Dashboard Features:
- 📊 **Dashboard Tab** - Statistics and recent memories overview
- 📝 **Memories Tab** - Full table with search, filter, and management
- ➕ **Add Memories** - Create new memories with tags and context
- ✏️ **Edit/Delete** - Modify or remove existing memories
- 🔍 **Search & Filter** - Find memories quickly by content or tags

## 🔄 Updates

### For Existing Users
Update to get new features while preserving all your data:

```cmd
# Download and run the updater:
update-mcp-memory-server.bat
```

The updater will:
- 🔍 Find your installation automatically
- 💾 Backup your data safely
- ⬇️ Download the latest version
- 🔄 Preserve all memories and configurations
- ✅ Install new features and improvements

### Available Update Commands
```cmd
# Check current version
npm run check-updates

# Update everything
npm run update

# Stop running servers
npm run kill-servers
```

## 📁 Project Structure

```
like-i-said-mcp-server/
├── 📄 server.js                     # Main MCP server
├── 📄 dashboard-server.js           # Web dashboard API
├── 📄 memory.json                   # Your memory storage
├── 📄 package.json                  # Dependencies and scripts
├── 🗂️ src/                          # React dashboard source
│   ├── 📄 App.tsx                   # Main dashboard component
│   └── 🗂️ components/              # UI components
├── 🗂️ public/                       # Static assets
├── 📄 install-mcp-memory-server.bat # One-click installer
├── 📄 update-mcp-memory-server.bat  # Smart updater
└── 📄 README.md                     # This file
```

## ⚙️ Configuration

The installer automatically configures your AI assistants:

### Claude Desktop
Location: `%APPDATA%\Claude\claude_desktop_config.json`

### Cursor
Location: `%USERPROFILE%\.cursor\mcp.json`

### Windsurf  
Location: `%USERPROFILE%\.codeium\windsurf\mcp_config.json`

All configurations add the `like-i-said-memory` server alongside your existing MCP servers.

## 🛠️ Development

### Start Development Environment
```cmd
# Start both API server and React dev server
npm run dev:full

# Or start individually:
npm run dashboard  # API server (port 3001)
npm run dev        # React dev server (port 5173)
```

### Available Scripts
```cmd
npm start           # Start MCP server only
npm run dashboard   # Start dashboard API server
npm run dev         # Start React development server
npm run dev:full    # Start both dashboard and React dev server
npm run build       # Build dashboard for production
npm run preview     # Preview production build
```

## 🔧 Troubleshooting

### Common Issues

**"Port already in use" error:**
```cmd
npm run kill-servers
```

**"Installation not found" during update:**
- Run the updater from your installation directory
- Or download fresh installer: `install-mcp-memory-server.bat`

**MCP functions not available:**
- Restart your AI assistant (Claude Desktop, Cursor, or Windsurf)
- Check that the server path in configs is correct
- Verify the MCP server is running: `npm start`

**Dashboard won't load:**
- Make sure both servers are running: `npm run dev:full`
- Check for port conflicts: `npm run kill-servers`
- Verify Node.js and npm are installed

### Getting Help
- Check the troubleshooting section in `UPDATE-GUIDE.md`
- Create an issue on GitHub with your error message
- Include your operating system and Node.js version

## 📋 Requirements

- **Windows** (tested on Windows 10/11)
- **Node.js** v14 or higher
- **Git** (for installation and updates)
- **Claude Desktop** and/or **Cursor** and/or **Windsurf**

## 🔐 Security & Privacy

- **Local Storage** - All memories stored locally in `memory.json`
- **No Cloud Sync** - Data never leaves your machine
- **Config Safety** - Installer preserves existing MCP configurations
- **Open Source** - Full source code available for review

## 📄 License

MIT License - see LICENSE file for details.

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🎉 Changelog

### v2.0.0 (Latest)
- 🎨 **New React Dashboard** - Modern UI with dark theme
- 🔍 **Advanced Search** - Filter memories by content, tags, context
- 🏷️ **Tag System** - Organize memories with custom tags
- 📊 **Statistics** - View memory analytics and recent activity
- 🛡️ **Safe Updates** - Smart updater preserves all data
- ⚡ **Performance** - Faster memory operations and UI
- 🔧 **Better Config** - Improved MCP configuration handling

### v1.0.0
- 🚀 **Initial Release** - Basic MCP server with memory functions
- 📦 **Auto-Installer** - One-click setup for all AI assistants
- 💾 **Persistent Storage** - JSON-based memory system

---

**Made with ❤️ for the AI community**