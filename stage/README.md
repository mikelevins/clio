# Stage

A presentation app built on Tauri

To build:

- release:
  - also create bundles:  
    npm run tauri build
  - don't create bundles:  
    npm run tauri build -- --no-bundle

- debug:
  - also create bundles:  
    npm run tauri build -- --debug
  - don't create bundles:  
    npm run tauri build -- --debug --no-bundle

To run:
- release:
  ./src-tauri/target/release/stage
- release with CLI args:
  ./src-tauri/target/release/stage --http-port 8080 --websocket-port 8081  
  ./src-tauri/target/release/stage -H 8080 -W 8081

- debug:
  ./src-tauri/target/debug/stage
- debug with CLI args:
  ./src-tauri/target/debug/stage --http-port 8080 --websocket-port 8081  
  ./src-tauri/target/debug/stage -H 8080 -W 8081

To test and debug:
- run the debug version and right-click an element in the window to
  view the JS debugger UI

To add or modify CLI args accepted:
- Edit tauri.conf.json. Change, add, or remove elements of the "args"
  array in "plugins" > "cli".

