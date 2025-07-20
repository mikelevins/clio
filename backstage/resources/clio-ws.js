var ClioSocket = new WebSocket("ws://127.0.0.1:40404/");

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
    let mainContainer = document.getElementById('main-container');
    let btn = document.createElement("button");
    btn.setAttribute('id',elementId);
    btn.innerHTML = elementText;
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
