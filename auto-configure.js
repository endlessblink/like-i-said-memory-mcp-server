const fs = require('fs');
const path = require('path');

// Configuration paths for different MCP clients
const CONFIG_PATHS = {
    claude: path.join(process.env.APPDATA, 'Claude', 'claude_desktop_config.json'),
    cursor: path.join(process.env.APPDATA, 'Cursor', 'User', 'globalStorage', 'cursor.mcp', 'claude_desktop_config.json'),
    windsurf: path.join(process.env.APPDATA, 'Windsurf', 'User', 'globalStorage', 'windsurf.mcp', 'claude_desktop_config.json')
};

// MCP server configuration
const PROJECT_ROOT = __dirname;
const MCP_CONFIG = {
    "like-i-said-memory": {
        "command": "node",
        "args": [path.join(PROJECT_ROOT, "server.js")]
    }
};

function ensureDirectoryExists(filePath) {
    const dir = path.dirname(filePath);
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`✓ Created directory: ${dir}`);
    }
}

function backupConfig(configPath) {
    if (fs.existsSync(configPath)) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const backupPath = `${configPath}.backup.${timestamp}`;
        fs.copyFileSync(configPath, backupPath);
        console.log(`  📋 Backed up to: ${backupPath}`);
        return true;
    }
    return false;
}

function mergeOrCreateConfig(configPath, appName) {
    console.log(`\n🔧 Configuring ${appName}...`);
    
    ensureDirectoryExists(configPath);
    
    let existingConfig = { mcpServers: {} };
    
    // Load existing config if it exists
    if (fs.existsSync(configPath)) {
        try {
            const existing = fs.readFileSync(configPath, 'utf8');
            existingConfig = JSON.parse(existing);
            backupConfig(configPath);
            console.log(`  📖 Loaded existing config`);
        } catch (error) {
            console.log(`  ⚠️  Invalid JSON in existing config, creating new one`);
            backupConfig(configPath);
        }
    }
    
    // Ensure mcpServers exists
    if (!existingConfig.mcpServers) {
        existingConfig.mcpServers = {};
    }
    
    // Add or update our MCP server
    Object.assign(existingConfig.mcpServers, MCP_CONFIG);
    
    // Write updated config
    fs.writeFileSync(configPath, JSON.stringify(existingConfig, null, 2));
    console.log(`  ✅ ${appName} configured successfully!`);
    
    return true;
}

function testMCPServer() {
    console.log(`\n🧪 Testing MCP Server...`);
    const serverPath = path.join(PROJECT_ROOT, 'server.js');
    const memoryPath = path.join(PROJECT_ROOT, 'memory.json');
    
    if (!fs.existsSync(serverPath)) {
        console.log(`❌ server.js not found at: ${serverPath}`);
        return false;
    }
    
    // Ensure memory.json exists and is empty for fresh installations
    if (!fs.existsSync(memoryPath)) {
        fs.writeFileSync(memoryPath, '{}');
        console.log(`✓ Created empty memory.json`);
    }
    
    console.log(`✅ MCP Server files verified`);
    return true;
}

function main() {
    console.log('===============================================');
    console.log('   Like-I-Said MCP Auto-Configuration Tool');
    console.log('===============================================\n');
    console.log(`📍 Project Root: ${PROJECT_ROOT}\n`);
    
    let installedCount = 0;
    const results = {};
    
    // Check each application and configure if found
    Object.entries(CONFIG_PATHS).forEach(([appName, configPath]) => {
        const appDir = path.dirname(path.dirname(configPath));
        
        if (fs.existsSync(appDir)) {
            try {
                mergeOrCreateConfig(configPath, appName.toUpperCase());
                results[appName] = { installed: true, configured: true, path: configPath };
                installedCount++;
            } catch (error) {
                console.log(`  ❌ Failed to configure ${appName}: ${error.message}`);
                results[appName] = { installed: true, configured: false, error: error.message };
            }
        } else {
            console.log(`\n⚪ ${appName.toUpperCase()} - Not installed, skipping`);
            results[appName] = { installed: false, configured: false };
        }
    });
    
    // Test MCP server
    const serverWorking = testMCPServer();
    
    // Display summary
    console.log('\n===============================================');
    console.log('           🎉 CONFIGURATION COMPLETE! 🎉');
    console.log('===============================================\n');
    
    console.log('📋 RESULTS:\n');
    Object.entries(results).forEach(([appName, result]) => {
        if (result.configured) {
            console.log(`✅ ${appName.toUpperCase().padEnd(12)} - Configured successfully`);
        } else if (result.installed) {
            console.log(`❌ ${appName.toUpperCase().padEnd(12)} - Configuration failed`);
        } else {
            console.log(`⚪ ${appName.toUpperCase().padEnd(12)} - Not installed`);
        }
    });
    
    if (installedCount > 0) {
        console.log(`\n🔄 IMPORTANT: Restart your configured applications (${installedCount} found) to load the MCP server!\n`);
        console.log('🚀 Available MCP Tools:');
        console.log('   • add_memory(key, value, context?)');
        console.log('   • get_memory(key)');
        console.log('   • list_memories(prefix?)');
        console.log('   • delete_memory(key)\n');
        console.log('🌐 Optional Web Dashboard: npm run dev:full');
        console.log('   Frontend: http://localhost:5173');
        console.log('   API: http://localhost:3001');
    } else {
        console.log('\n⚠️  No MCP-compatible applications found.');
        console.log('Install Claude Desktop, Cursor, or Windsurf to use this MCP server.');
    }
    
    if (!serverWorking) {
        console.log('\n❌ MCP Server issues detected. Check your installation.');
        process.exit(1);
    }
}

if (require.main === module) {
    main();
}
