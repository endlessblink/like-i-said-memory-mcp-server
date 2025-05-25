# 🧠 Like I Said - MCP Memory Server

A **persistent memory system** for AI assistants (Claude, Cursor, Windsurf) with an easy-to-use web dashboard.

## ✨ What This Does

- 🧠 **Remembers Everything**: Your AI assistant can store and recall information between conversations
- 🌐 **Web Dashboard**: Manage memories through a beautiful web interface
- ⚡ **One-Click Setup**: Automatically configures Claude Desktop, Cursor, and Windsurf
- 🔄 **Real-Time Sync**: Changes in the dashboard instantly sync with your AI assistants

## 🚀 Quick Start (New Users)

### **Step 1: Install** 
Download and run the installer:
```
install-mcp-memory-server.bat
```

**What it does:**
- ✅ Downloads and installs the memory server
- ✅ Configures Claude Desktop (if installed)  
- ✅ Configures Cursor IDE (if installed)
- ✅ Configures Windsurf IDE (if installed)
- ✅ Creates your personal memory database
- ✅ Tests that everything works

### **Step 2: Use Your AI Assistant**
Open Claude Desktop, Cursor, or Windsurf and try:
- "Remember that I prefer dark mode"
- "What do you remember about my preferences?"

### **Step 3: Use the Web Dashboard** (Optional)
```bash
scripts/start-dashboard.bat
```
Then visit: **http://localhost:5173**

## 🛠️ Memory Tools Your AI Can Use

Once installed, your AI assistants get these new abilities:

- **`add_memory`** - Store information: "Remember I live in New York"
- **`get_memory`** - Recall specific info: "What city do I live in?"  
- **`list_memories`** - Show all memories: "What do you remember about me?"
- **`delete_memory`** - Remove outdated info: "Forget my old email address"

## 🌐 Web Dashboard Features

**Launch with:** `scripts/start-dashboard.bat` → http://localhost:5173

- 📋 **View all memories** in a searchable table
- ➕ **Add memories** directly through the web interface
- ✏️ **Edit memories** by clicking on them
- 🗑️ **Delete memories** you no longer need
- 🔍 **Search everything** by keyword or category
- 🔄 **Real-time sync** with your AI assistants

## 📁 What Gets Installed

```
like-i-said-mcp-server/
├── install-mcp-memory-server.bat    # The installer you run (easy access!)
├── scripts/
│   ├── start-dashboard.bat          # Dashboard launcher
│   └── quick-configure.bat          # Reconfigure AI assistants
├── docs/
│   └── DASHBOARD-GUIDE.md          # Dashboard usage guide
├── memory.json                     # Your personal memory database
├── server.js                      # The memory server program  
├── dashboard-server.js            # Web dashboard backend
├── src/                           # Web dashboard frontend
└── package.json                   # Program dependencies
```

## 🔧 Advanced Commands

If you're comfortable with the command line:

```bash
# Start just the web dashboard
npm run dev:full

# Reconfigure your AI assistants  
npm run configure

# Start only the memory server
npm start
```

## 🆘 Troubleshooting

### **"My AI assistant doesn't remember anything"**
1. **Restart** your AI assistant (Claude/Cursor/Windsurf)
2. Run `scripts/quick-configure.bat` to reconfigure
3. Try saying: "Do you have access to memory tools?"

### **"Web dashboard won't load"**
1. Run `scripts/start-dashboard.bat` again
2. Wait 10 seconds, then go to http://localhost:5173
3. Make sure no other programs are using ports 3001 or 5173

### **"I want to start over"**
1. Delete the `memory.json` file
2. Run `install-mcp-memory-server.bat` again

## 💾 Your Data

- **All memories are stored locally** on your computer
- **Your data never leaves your machine** 
- **Memories are saved in:** `memory.json` in the installation folder
- **Safe to backup:** Just copy the `memory.json` file

## 📋 Requirements

- **Windows computer**
- **Node.js** (the installer will help you get this)
- **One of these AI assistants:**
  - Claude Desktop
  - Cursor IDE  
  - Windsurf IDE

## 🎉 You're All Set!

1. **Run the installer** → `install-mcp-memory-server.bat`
2. **Open your AI assistant** and ask it to remember something
3. **Use the web dashboard** → `scripts/start-dashboard.bat` for visual memory management

**Your AI assistant now has a perfect memory!** 🧠✨

---

## 🔗 Need Help?

- 📖 **Dashboard Guide**: See `docs/DASHBOARD-GUIDE.md` for detailed web interface instructions
- 🐛 **Issues**: Check the troubleshooting section above
- 💡 **Tips**: The web dashboard is great for managing lots of memories at once