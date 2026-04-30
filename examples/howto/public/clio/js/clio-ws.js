// ---------------------------------------------------------------------
// clio-ws.js
// ---------------------------------------------------------------------
// Browser-side WebSocket lifecycle: open the socket, run a
// heartbeat to keep it alive, route inbound messages into the
// dispatcher defined in clio-protocol.js, and expose sendObject /
// pingLisp for outbound traffic.
//
// Loaded after clio-protocol.js and after any consumer script that
// registers inbound message handlers. The HOWTO walks through this
// load order and the reasoning behind it.

var ClioSocket = new WebSocket("ws://" + window.location.host + "/ws");
let heartbeatInterval;

// ---------------------------------------------------------------------
// keep the websocket open
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
// Parses each inbound JSON envelope and hands it to
// dispatchClioMessage from clio-protocol.js, which looks up the
// registered handler for the envelope's type and invokes it.

ClioSocket.onmessage = function (event) {
    var envelope = JSON.parse(event.data);
    dispatchClioMessage(envelope);
};

// ---------------------------------------------------------------------
// sending messages
// ---------------------------------------------------------------------

function sendObject(object) {
    ClioSocket.send(JSON.stringify(object));
}

function pingLisp() {
    sendObject({type: 'ping'});
}
