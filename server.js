const fs = require('fs');
const path = require('path');

class MemoryMCPServer {
    constructor() {
        // Use environment variable or default to local memory.json
        this.memoryFilePath = process.env.MEMORY_FILE_PATH || path.join(__dirname, 'memory.json');
        this.initializeMemoryFile();
    }

    initializeMemoryFile() {
        // Create memory.json if it doesn't exist
        if (!fs.existsSync(this.memoryFilePath)) {
            const initialData = {
                memories: [],
                metadata: {
                    created: new Date().toISOString(),
                    version: "1.0.0"
                }
            };
            fs.writeFileSync(this.memoryFilePath, JSON.stringify(initialData, null, 2));
            console.log(`Memory file created at: ${this.memoryFilePath}`);
        }
    }

    loadMemories() {
        try {
            const data = fs.readFileSync(this.memoryFilePath, 'utf8');
            return JSON.parse(data);
        } catch (error) {
            console.error('Error loading memories:', error);
            return { memories: [], metadata: {} };
        }
    }

    saveMemories(data) {
        try {
            fs.writeFileSync(this.memoryFilePath, JSON.stringify(data, null, 2));
            return true;
        } catch (error) {
            console.error('Error saving memories:', error);
            return false;
        }
    }

    addMemory(content, type = 'general', tags = []) {
        const data = this.loadMemories();
        const memory = {
            id: Date.now().toString(),
            content,
            type,
            tags,
            timestamp: new Date().toISOString(),
            confidence: 1.0
        };
        
        data.memories.push(memory);
        
        if (this.saveMemories(data)) {
            return { success: true, memory };
        }
        return { success: false, error: 'Failed to save memory' };
    }

    getMemory(id) {
        const data = this.loadMemories();
        const memory = data.memories.find(m => m.id === id);
        return memory ? { success: true, memory } : { success: false, error: 'Memory not found' };
    }

    listMemories(type = null, tags = null) {
        const data = this.loadMemories();
        let memories = data.memories;

        if (type) {
            memories = memories.filter(m => m.type === type);
        }

        if (tags && tags.length > 0) {
            memories = memories.filter(m => 
                tags.some(tag => m.tags.includes(tag))
            );
        }

        return { success: true, memories };
    }

    deleteMemory(id) {
        const data = this.loadMemories();
        const initialLength = data.memories.length;
        data.memories = data.memories.filter(m => m.id !== id);
        
        if (data.memories.length < initialLength) {
            if (this.saveMemories(data)) {
                return { success: true, message: 'Memory deleted' };
            }
        }
        return { success: false, error: 'Memory not found or failed to delete' };
    }

    searchMemories(query) {
        const data = this.loadMemories();
        const results = data.memories.filter(memory => 
            memory.content.toLowerCase().includes(query.toLowerCase()) ||
            memory.tags.some(tag => tag.toLowerCase().includes(query.toLowerCase()))
        );
        return { success: true, memories: results };
    }
}

// MCP Protocol Handler
class MCPProtocolHandler {
    constructor() {
        this.memoryServer = new MemoryMCPServer();
    }

    async handleRequest(request) {
        const { method, params } = request;

        switch (method) {
            case 'memory/add':
                return this.memoryServer.addMemory(
                    params.content, 
                    params.type, 
                    params.tags
                );

            case 'memory/get':
                return this.memoryServer.getMemory(params.id);

            case 'memory/list':
                return this.memoryServer.listMemories(
                    params.type, 
                    params.tags
                );

            case 'memory/delete':
                return this.memoryServer.deleteMemory(params.id);

            case 'memory/search':
                return this.memoryServer.searchMemories(params.query);

            default:
                return { success: false, error: 'Unknown method' };
        }
    }
}

// Initialize and start server
const handler = new MCPProtocolHandler();

// Handle stdin for MCP protocol
process.stdin.on('data', async (data) => {
    try {
        const request = JSON.parse(data.toString());
        const response = await handler.handleRequest(request);
        process.stdout.write(JSON.stringify(response) + '\n');
    } catch (error) {
        const errorResponse = { success: false, error: error.message };
        process.stdout.write(JSON.stringify(errorResponse) + '\n');
    }
});

console.log('MCP Memory Server started');
console.log(`Memory file: ${handler.memoryServer.memoryFilePath}`);
