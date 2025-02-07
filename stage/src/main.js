const { invoke } = window.__TAURI__.core;
const { getMatches } = window.__TAURI__.cli;

let greetInputEl;
let greetMsgEl;
let httpMsgEl;
let httpData = "HTTP port: ";
let wsMsgEl;
let wsData = "WebSocket port: ";
let swankMsgEl;
let swankData = "Swank port: ";

async function greet() {
    // Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
    greetMsgEl.textContent = await invoke("greet", { name: greetInputEl.value });
}

getMatches().then((result) => {
    let args = result.args;
    let hp = args.http_port;
    let wp = args.websocket_port;
    let sp = args.swank_port;
    httpMsgEl.textContent = httpData+hp.value;
    wsMsgEl.textContent = wsData+wp.value;
    swankMsgEl.textContent = swankData+sp.value;
});

window.addEventListener("DOMContentLoaded", () => {
    greetInputEl = document.querySelector("#greet-input");
    greetMsgEl = document.querySelector("#greet-msg");
    httpMsgEl = document.querySelector("#http-msg");
    wsMsgEl = document.querySelector("#ws-msg");
    swankMsgEl = document.querySelector("#swank-msg");
    
    document.querySelector("#greet-form").addEventListener("submit", (e) => {
        e.preventDefault();
        greet();
    });
});
