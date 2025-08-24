var ClioSocket = new WebSocket("ws://127.0.0.1:40404/");
let heartbeatInterval;

// ---------------------------------------------------------------------
// set a heartbeat to keep the websocket open
// ---------------------------------------------------------------------

ClioSocket.onopen = function() {
    console.log('Connected');
    // Send heartbeat every 20 seconds
    heartbeatInterval = setInterval(() => {
        if (ClioSocket.readyState === WebSocket.OPEN) {
            ClioSocket.send(JSON.stringify({ type: 'ping' }));
        }
    }, 20000);
};

// ---------------------------------------------------------------------
// receiving messages
// ---------------------------------------------------------------------

ClioSocket.onmessage = function (event) {
    var data = JSON.parse(event.data);
    //console.log(data);
    handleWSEvent(data);
}

function handleWSEvent(eventData) {
    let eventType = eventData['type'];
    if (eventType == 'clear') {
        Canvas.clear();
    } else if (eventType == 'ping') {
        console.log("Received WS ping");
    } else if (eventType == 'pong') {
        console.log("Received WS pong");
    } else if (eventType == 'reload') {
        window.location.reload();
    } else if (eventType == 'create-element') {
        handleCreateElement(eventData);
    } else {
        console.log("Received WS event: ");
        console.log(eventData);
    }    
}

function handleCreateElement(eventData){
    let elementType = eventData['elementType'];
    if (elementType == 'button') {
        handleCreateButton(eventData);
    } else {
        console.log("Received create element: ");
        console.log(eventData);
    }    
    
}

function handleCreateButton(eventData){
    console.log(eventData);
    let elementText = eventData['text'];
    let elementId = eventData['id'];
    let elementScriptText = eventData.onclick;
    let elementScript = eval(elementScriptText);;
    let mainContainer = document.getElementById('main-container');
    let btn = document.createElement("button");
    btn.setAttribute('id',elementId);
    btn.innerHTML = elementText;
    btn.onclick = elementScript;
    mainContainer.appendChild(btn);
}


// ---------------------------------------------------------------------
// sending messages
// ---------------------------------------------------------------------

function sendObject(object){
    ClioSocket.send(JSON.stringify(object));
}


function pingLisp () {
    sendObject("(:ping)");
}
