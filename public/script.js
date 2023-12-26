document.getElementById('generateButton').addEventListener('click', async () => {
    var bpmnJS = new BpmnJS({container: '#canvas'});

    const diagramXML = document.getElementById('inputArea').value;
    try {
        const response = await fetch('http://localhost:3000/process-diagram', {
            method: 'POST',
            headers: {
                'Content-Type': 'text/plain',
            },
            body: diagramXML,
        });
        //const layoutedDiagramXML = await response.text();
        const { layoutedDiagramXML, svg } = await response.json();
        document.getElementById('outputArea').value = layoutedDiagramXML;
        //document.getElementById('outputArea').value = layoutedDiagramXML;
        document.getElementById('canvas').innerHTML = svg;
        await bpmnJS.importXML(someDiagram);
    } catch (error) {
        console.error('Error:', error);
    }
});
