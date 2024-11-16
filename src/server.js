const express = require('express');
const multer = require('multer');
const { exec } = require('child_process');
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

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});