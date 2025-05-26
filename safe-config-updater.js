const fs = require('fs');
const path = require('path');

// Safe JSON config updater inspired by Smithery's approach
class SafeConfigUpdater {
    constructor() {
        this.configPaths = {
            claude: path.join(process.env.APPDATA, 'Claude', 'claude_desktop_config.json'),
            cursor: path.join(process.env.USERPROFILE, '.cursor', 'mcp.json'),
            windsurf: path.join(process.env.USERPROFILE, '.codeium', 'windsurf', 'mcp_config.json')
        };
    }

    // Read config safely with error handling
    readConfig(configPath) {
        try {
            if (!fs.existsSync(configPath)) {
                return { mcpServers: {} };
            }
            
            const content = fs.readFileSync(configPath, 'utf8');
            if (!content.trim()) {
                return { mcpServers: {} };
            }
            
            const parsed = JSON.parse(content);
            if (!parsed.mcpServers) {
                parsed.mcpServers = {};
            }
            
            return parsed;
        } catch (error) {
            console.error(`❌ Error reading config from ${configPath}:`, error.message);
            return null;
        }
    }
    // Write config safely with validation
    writeConfig(configPath, config) {
        try {
            // Ensure directory exists
            const dir = path.dirname(configPath);
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }

            // Validate JSON before writing
            const jsonString = JSON.stringify(config, null, 2);
            JSON.parse(jsonString); // Validate it can be parsed back

            // Write atomically (write to temp file, then rename)
            const tempPath = configPath + '.tmp';
            fs.writeFileSync(tempPath, jsonString, 'utf8');
            fs.renameSync(tempPath, configPath);
            
            return true;
        } catch (error) {
            console.error(`❌ Error writing config to ${configPath}:`, error.message);
            return false;
        }
    }

    // Add memory server to config
    addMemoryServer(client, serverPath) {
        const configPath = this.configPaths[client];
        if (!configPath) {
            console.error(`❌ Unknown client: ${client}`);
            return false;
        }

        console.log(`Configuring ${client}...`);

        const config = this.readConfig(configPath);
        if (!config) {
            console.error(`❌ Failed to read ${client} config`);
            return false;
        }

        // Check if server already exists
        if (config.mcpServers['like-i-said-memory']) {
            console.log(`⏭️  SKIP: Server already exists in ${client}`);
            return true;
        }

        // Add the new server
        config.mcpServers['like-i-said-memory'] = {
            command: 'node',
            args: [serverPath]
        };

        // Write the updated config
        if (this.writeConfig(configPath, config)) {
            console.log(`✅ SUCCESS: Added server to ${client}`);
            return true;
        } else {
            console.error(`❌ FAILED: Could not update ${client} config`);
            return false;
        }
    }
}
// Main execution
function main() {
    const args = process.argv.slice(2);
    if (args.length < 2) {
        console.error('Usage: node safe-config-updater.js <client> <server-path>');
        console.error('Clients: claude, cursor, windsurf');
        process.exit(1);
    }

    const [client, serverPath] = args;
    const updater = new SafeConfigUpdater();
    
    const success = updater.addMemoryServer(client, serverPath);
    process.exit(success ? 0 : 1);
}

if (require.main === module) {
    main();
}

module.exports = SafeConfigUpdater;