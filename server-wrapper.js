#!/usr/bin/env node
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const LOG_FILE = path.join(__dirname, 'logs', 'wrapper.log');
let serverProcess = null;
let shouldRestart = true;
if (!fs.existsSync(path.dirname(LOG_FILE))) fs.mkdirSync(path.dirname(LOG_FILE), { recursive: true });
function log(msg) {
    const logMsg = `[${new Date().toISOString()}] ${msg}\n`;
    console.log(logMsg.trim());
    fs.appendFileSync(LOG_FILE, logMsg);
}
function startServer() {
    if (serverProcess) return;
    log('Starting MCP server...');
    serverProcess = spawn('node', ['server.js'], { cwd: __dirname, stdio: ['pipe', 'pipe', 'pipe'] });
    serverProcess.on('close', (code) => {
        log(`Server exited with code ${code}`);
        serverProcess = null;
        if (shouldRestart) setTimeout(startServer, 5000);
    });
    serverProcess.on('error', (err) => { log(`Error: ${err.message}`); serverProcess = null; });
    log(`Server started with PID: ${serverProcess.pid}`);
}
function stopServer() {
    shouldRestart = false;
    if (serverProcess) {
        log('Stopping server...');
        serverProcess.kill('SIGTERM');
        serverProcess = null;
    }
}
process.on('SIGINT', () => { stopServer(); process.exit(0); });
process.on('SIGTERM', () => { stopServer(); process.exit(0); });
log('MCP Server Wrapper starting...');
startServer();
setInterval(() => {
    if (!serverProcess && shouldRestart) {
        log('Restarting...');
        startServer();
    }
}, 30000);
