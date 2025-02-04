# clio

A UI framework for Common Lisp programs using web-browser technologies
for presentation and event handling.

The parts of clio are:

- appexec: a simple command-line app skeleton in Lisp
- backstage: a small Common Lisp library providing an HTTP backend server for a web-based UI
- stage: a Tauri-based webview application that knows how to talk to backstage

