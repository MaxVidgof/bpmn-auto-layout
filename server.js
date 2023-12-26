const express = require('express');
const { layoutProcess } = require('./bpmn-auto-layout');
//import { layoutProcess } from './node_modules/bpmn-auto-layout/dist/index.esm.js';
//import { layoutProcess } from 'bpmn-auto-layout';
const { convertAll } = require('bpmn-to-image');
const bodyParser = require('body-parser');
const fs = require('fs');

const app = express();
app.use(express.static('public')); // Serve static files from the 'public' directory
app.use(bodyParser.text());  // To handle text/plain POST requests

app.post('/process-diagram', async (req, res) => {
    try {
        const diagramXML = req.body;
        const layoutedDiagramXML = await layoutProcess(diagramXML);

        //fs.writeFileSync('/tmp/diagram.bpmn', layoutedDiagramXML);
        //await convertAll([{ input: '/tmp/diagram.bpmn', outputs: ['/tmp/diagram.svg'] }]);
        //const svg = fs.readFileSync('/tmp/diagram.svg', 'utf-8');

        res.send(layoutedDiagramXML);
        //res.json({ layoutedDiagramXML, svg });  // Send both the XML and SVG as a JSON response
    } catch (error) {
        console.error('Error processing diagram XML:', error);
        res.status(500).send('Internal Server Error');
    }
});

app.listen(3000, '0.0.0.0', () => {
    console.log('Server is running on port 3000');
});
