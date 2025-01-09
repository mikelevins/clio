const { invoke } = window.__TAURI__.core;
const { getMatches } = window.__TAURI__.cli;

let greetInputEl;
let greetMsgEl;

const cli_matches = await getMatches();

async function greet() {
    // Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
    greetMsgEl.textContent = await invoke("greet", { name: greetInputEl.value });
}

window.addEventListener("DOMContentLoaded", () => {
    greetInputEl = document.querySelector("#greet-input");
    greetMsgEl = document.querySelector("#greet-msg");
    climatchesEl = document.querySelector("#climatches-msg");
    climatchesEl.textContent = JSON.stringify(cli_matches);
    console.log("CLI matches:");
    console.log(JSON.stringify(cli_matches));

    document.querySelector("#greet-form").addEventListener("submit", (e) => {
        e.preventDefault();
        greet();
    });
});

// build: npm run tauri build -- --debug
