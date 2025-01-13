const { invoke } = window.__TAURI__.core;
const { getMatches } = window.__TAURI__.cli;

let greetInputEl;
let greetMsgEl;
let matchesMsgEl;
let matchesData = "Matches";

async function greet() {
    // Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
    greetMsgEl.textContent = await invoke("greet", { name: greetInputEl.value });
}

getMatches().then((result) => {
    matchesData = result;
    matchesMsgEl.textContent = JSON.stringify(matchesData);
});

window.addEventListener("DOMContentLoaded", () => {
    greetInputEl = document.querySelector("#greet-input");
    greetMsgEl = document.querySelector("#greet-msg");
    matchesMsgEl = document.querySelector("#matches-msg");
    
    document.querySelector("#greet-form").addEventListener("submit", (e) => {
        e.preventDefault();
        greet();
    });
});
