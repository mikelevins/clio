var UpdateParameters = {};
var ClioSocket = new WebSocket("ws://127.0.0.1:40404/clio");

function updateClio() {
    console.log('updateClio:');
    console.log(UpdateParameters);
}

ClioSocket.onmessage = function (event) {
    var updateParams = JSON.parse(event.data);
    UpdateParameters = updateParams;
    updateClio();
}
