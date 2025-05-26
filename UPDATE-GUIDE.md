# 🔄 MCP Memory Server - Update Guide

## 🚀 Quick Update (Recommended)

**For existing users with installed servers:**

1. **Download the updater:** `update-mcp-memory-server.bat`
2. **Run it from anywhere** - it will find your installation automatically
3. **That's it!** Your data is preserved, new features are added

```cmd
# One command to update everything:
update-mcp-memory-server.bat
```

## 📋 What Gets Updated

✅ **Updated:**
- React dashboard (new features, UI improvements)
- MCP server logic (new memory functions)  
- Dependencies (security updates, bug fixes)
- Documentation and helper scripts

✅ **Preserved:**
- Your memory.json data
- Claude Desktop configuration
- Cursor configuration  
- Windsurf configuration
- All your existing memories and settings

## 🛠️ Manual Update Commands

If you prefer using npm scripts:

```cmd
# Check for updates
npm run check-updates

# Update (runs the updater)
npm run update

# Kill any running servers first
npm run kill-servers
```

## 🔍 Version Checking

```cmd
# See current version
type version.json

# Check for updates
check-for-updates.bat
```

## 🆘 Troubleshooting Updates

**Issue: "Installation not found"**
- Run the updater from your installation directory
- Or download fresh: `install-mcp-memory-server.bat`

**Issue: "Port already in use"**  
- Run: `kill-dev-servers.bat`
- Then try the update again

**Issue: "Update failed"**
- Check internet connection
- Close all AI assistants (Claude, Cursor, Windsurf)
- Try running as administrator

## 📁 Backup Policy

Every update automatically creates timestamped backups:
- `memory.json.backup.[timestamp]` - Your data
- `[installation]-backup-[timestamp]` - Full old installation

**Safe to delete backups after testing the update!**

## 🔄 Update Frequency

- **Major features:** Monthly
- **Bug fixes:** As needed  
- **Security updates:** Immediate

## 💡 Pro Tips

1. **Always restart** your AI assistants after updating
2. **Test memory functions** to confirm everything works
3. **Try the dashboard** to see new features
4. **Keep one recent backup** until you're sure everything works

---

**Need help?** Create an issue on the GitHub repository!