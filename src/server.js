const express = require('express');
const multer = require('multer');
const { exec, execSync } = require('child_process');
const axios = require('axios');
const fs = require('fs/promises');
const path = require('path');
require('dotenv').config();

const app = express();
const upload = multer({ dest: 'uploads/' });

// Create required directories
fs.mkdir('uploads').catch(() => {});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'ok',
        timestamp: new Date().toISOString(),
        akave: {
            endpoint: process.env.NODE_ADDRESS
        }
    });
});

// File upload endpoint
app.post('/upload', upload.single('file'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ 
                success: false, 
                error: 'No file provided' 
            });
        }

        // Upload to Akave using environment variables
        const cmd = `akavecli files-streaming upload test-bucket ${req.file.path} --node-address=${process.env.NODE_ADDRESS}`;
        const { stdout } = await exec(cmd);

        // Cleanup
        await fs.unlink(req.file.path);

        res.json({ 
            success: true, 
            message: 'File uploaded successfully',
            details: stdout
        });

    } catch (error) {
        console.error('Upload error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

app.get('/download/:bucketName/:fileName', async (req, res) => {
    try {
        const { bucketName, fileName } = req.params;
        
        // Use the streaming API endpoint
        const akaveEndpoint = `http://${process.env.NODE_ADDRESS}/buckets/${bucketName}/files/${fileName}/download`;
        
        const response = await axios({
            method: 'GET',
            url: akaveEndpoint,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            responseType: 'stream'
        });

        // Set appropriate headers
        res.setHeader('Content-Type', response.headers['content-type']);
        
        // Pipe the response directly to the client
        response.data.pipe(res);

    } catch (error) {
        console.error('Download error:', error);
        res.status(500).json({ 
            success: false, 
            error: error.message 
        });
    }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});