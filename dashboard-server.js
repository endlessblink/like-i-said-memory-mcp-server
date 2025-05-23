const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3001;
const DB_FILE = path.join(__dirname, 'memory.json');

// Serve static files from public directory
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());

// API Endpoints
app.get('/api/memories', (req, res) => {
  try {
    const data = fs.readFileSync(DB_FILE, 'utf8');
    res.json(JSON.parse(data));
  } catch {
    res.json({});
  }
});

app.post('/api/memories', (req, res) => {
  try {
    const { key, value, context } = req.body;
    const memories = JSON.parse(fs.readFileSync(DB_FILE, 'utf8') || '{}');
    
    memories[key] = {
      value,
      context: context || {},
      timestamp: new Date().toISOString()
    };
    
    fs.writeFileSync(DB_FILE, JSON.stringify(memories, null, 2));
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.put('/api/memories/:key', (req, res) => {
  try {
    const { key } = req.params;
    const { value, context } = req.body;
    const memories = JSON.parse(fs.readFileSync(DB_FILE, 'utf8') || '{}');
    
    if (memories[key]) {
      memories[key] = {
        value,
        context: context || {},
        timestamp: new Date().toISOString()
      };
      fs.writeFileSync(DB_FILE, JSON.stringify(memories, null, 2));
      res.json({ success: true });
    } else {
      res.status(404).json({ success: false });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.delete('/api/memories/:key', (req, res) => {
  try {
    const { key } = req.params;
    const memories = JSON.parse(fs.readFileSync(DB_FILE, 'utf8') || '{}');
    
    if (memories[key]) {
      delete memories[key];
      fs.writeFileSync(DB_FILE, JSON.stringify(memories, null, 2));
      res.json({ success: true });
    } else {
      res.status(404).json({ success: false });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`Dashboard server running at http://localhost:${PORT}`);
});
