# BPMN Auto Layout

### Usage with docker
Start the container:

```sh
docker build -t mvidgof/bpmn-auto-layout .
docker run --rm -p 3000:3000 --pid=host -ti mvidgof/bpmn-auto-layout
```

Ctrl+C to stop. Optionally add `-d` to run in background.

Send a POST request to `localhost:3000/process-diagram` with XML data as payload (see example below).

The response contians JSON data: with keys `layoutedDiagramXML` (the complete XML model) and `svg` (the BPMN model as SVG).

Example input data (produced by ChatGPT):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL"
                  xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"
                  xsi:schemaLocation="http://www.omg.org/spec/BPMN/20100524/MODEL BPMN20.xsd"
                  id="Definition"
                  targetNamespace="http://www.example.org/bpmn20">

    <bpmn:process id="mailProcessingProcess" isExecutable="false">
        <!-- Start Event -->
        <bpmn:startEvent id="startEvent">
            <bpmn:outgoing>Flow1</bpmn:outgoing>
        </bpmn:startEvent>

        <!-- Tasks -->
        <bpmn:task id="collectMail" name="Collect Mail">
            <bpmn:incoming>Flow1</bpmn:incoming>
            <bpmn:outgoing>Flow2</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="sortMail" name="Sort Mail">
            <bpmn:incoming>Flow2</bpmn:incoming>
            <bpmn:outgoing>Flow3</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="openSortRegisterMail" name="Open, Sort, and Register Mail">
            <bpmn:incoming>Flow3</bpmn:incoming>
            <bpmn:outgoing>Flow4</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="qualityCheck" name="Quality Check">
            <bpmn:incoming>Flow4</bpmn:incoming>
            <bpmn:outgoing>Flow5</bpmn:outgoing>
        </bpmn:task>

        <bpmn:exclusiveGateway id="checkCompliance">
            <bpmn:incoming>Flow5</bpmn:incoming>
            <bpmn:outgoing>Flow6</bpmn:outgoing>
            <bpmn:outgoing>Flow7</bpmn:outgoing>
        </bpmn:exclusiveGateway>

        <bpmn:task id="compileRequisitionList" name="Compile Requisition List">
            <bpmn:incoming>Flow6</bpmn:incoming>
            <bpmn:outgoing>Flow8</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="captureMatterDetails" name="Capture Matter Details">
            <bpmn:incoming>Flow7</bpmn:incoming>
            <bpmn:outgoing>Flow9</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="processFees" name="Process Fees">
            <bpmn:incoming>Flow9</bpmn:incoming>
            <bpmn:outgoing>Flow10</bpmn:outgoing>
        </bpmn:task>

        <bpmn:task id="prepareDocuments" name="Prepare Documents">
            <bpmn:incoming>Flow10</bpmn:incoming>
            <bpmn:outgoing>Flow11</bpmn:outgoing>
        </bpmn:task>

        <!-- End Event -->
        <bpmn:endEvent id="endEvent">
            <bpmn:incoming>Flow8</bpmn:incoming>
            <bpmn:incoming>Flow11</bpmn:incoming>
        </bpmn:endEvent>

        <!-- Sequence Flows -->
        <bpmn:sequenceFlow id="Flow1" sourceRef="startEvent" targetRef="collectMail"/>
        <bpmn:sequenceFlow id="Flow2" sourceRef="collectMail" targetRef="sortMail"/>
        <bpmn:sequenceFlow id="Flow3" sourceRef="sortMail" targetRef="openSortRegisterMail"/>
        <bpmn:sequenceFlow id="Flow4" sourceRef="openSortRegisterMail" targetRef="qualityCheck"/>
        <bpmn:sequenceFlow id="Flow5" sourceRef="qualityCheck" targetRef="checkCompliance"/>
        <bpmn:sequenceFlow id="Flow6" sourceRef="checkCompliance" targetRef="compileRequisitionList" name="Not Compliant"/>
        <bpmn:sequenceFlow id="Flow7" sourceRef="checkCompliance" targetRef="captureMatterDetails" name="Compliant"/>
        <bpmn:sequenceFlow id="Flow8" sourceRef="compileRequisitionList" targetRef="endEvent"/>
        <bpmn:sequenceFlow id="Flow9" sourceRef="captureMatterDetails" targetRef="processFees"/>
        <bpmn:sequenceFlow id="Flow10" sourceRef="processFees" targetRef="prepareDocuments"/>
        <bpmn:sequenceFlow id="Flow11" sourceRef="prepareDocuments" targetRef="endEvent"/>
    </bpmn:process>

</bpmn:definitions>
```
