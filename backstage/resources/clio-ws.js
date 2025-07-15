var ClioSocket = new WebSocket("ws://127.0.0.1:40404/");

ClioSocket.onmessage = function (event) {
    var data = JSON.parse(event.data);
    console.log("event: ");
    console.log(event);
    console.log("data: ");
    console.log(data);
}


function pingLisp () {
    ClioSocket.send("(:ping)");
}
