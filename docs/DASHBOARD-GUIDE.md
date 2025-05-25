# 🌐 MCP Memory Dashboard - User Guide

A **visual interface** to manage all the memories your AI assistants use.

## 🚀 Getting Started

### **Start the Dashboard**
```bash
scripts/start-dashboard.bat
```
Or if you prefer command line:
```bash
npm run dev:full
```

### **Access the Dashboard**  
Open your web browser and go to: **http://localhost:5173**

*Note: Wait about 10 seconds after starting for everything to load*

## ✨ What You Can Do

### **View Your Memories**
- 📋 See **all memories** in a clean table
- 🔍 **Search** by typing keywords
- 📅 **Sort** by date or memory name
- 👀 **Preview** memory content without opening

### **Manage Memories**
- ➕ **Add new memories** with the "Add Memory" button
- ✏️ **Edit memories** by clicking on them
- 🗑️ **Delete memories** you no longer need
- 📝 **Add context/tags** to organize memories

## 🎯 How to Use

### **Adding a New Memory**
1. Click the **"Add Memory"** button
2. Enter a **key** (like "favorite_food" or "work_schedule")
3. Enter the **value** (the actual information to remember)
4. Add **context** if you want (tags, categories, notes)
5. Click **"Save"**

### **Editing an Existing Memory**
1. **Click** on any memory in the table
2. **Edit** the information you want to change
3. **Save** your changes

### **Searching for Memories**
- Type in the **search box** at the top
- Search works for **memory names** and **content**
- Results update **instantly** as you type

## 🔄 Real-Time Sync

**Important**: The dashboard shows the **exact same memories** your AI assistants use!

- ✅ **Add memory in dashboard** → Your AI can instantly access it
- ✅ **AI adds memory via chat** → Appears in dashboard immediately  
- ✅ **Edit anywhere** → Changes sync everywhere

## 💡 Pro Tips

### **Good Memory Keys**
- Use **descriptive names**: `user_favorite_pizza` instead of `food1`
- Be **consistent**: Always use underscores or always use dashes
- Include **categories**: `preference_food_pizza`, `work_meeting_schedule`

### **Using Context**
Add helpful context to organize memories:
```json
{
  "category": "preference", 
  "type": "food",
  "importance": "high"
}
```

## 🚨 Troubleshooting

### **Dashboard Won't Load**
1. Make sure you ran `scripts/start-dashboard.bat` 
2. Wait 10-15 seconds for startup
3. Try refreshing your browser
4. Check that no other programs are using ports 3001 or 5173

### **Can't See Any Memories**
1. Check if `memory.json` exists in your installation folder
2. Try adding a memory through your AI assistant first
3. Refresh the dashboard page

### **Changes Aren't Saving**
1. Make sure both the dashboard and server are running
2. Check your internet connection (even though it's local)
3. Try restarting the dashboard with `scripts/start-dashboard.bat`

## 🎉 Perfect Memory Management!

The dashboard makes it easy to:
- 📊 **See everything** your AI remembers about you
- 🧹 **Clean up** outdated information
- 📝 **Add lots of memories** quickly
- 🔍 **Find specific information** fast

**Happy memory managing!** 🧠✨