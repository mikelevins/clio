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
    } else{
        console.log("Received WS event: ");
        console.log(eventData);
    }    
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
