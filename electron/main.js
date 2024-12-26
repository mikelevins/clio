
const remote = require('electron');
const process = require('process');
const app = remote.app;
const BrowserWindow = remote.BrowserWindow;
const portfinder = require('portfinder');
const path = require('node:path');
const exec = require('child_process').exec;
const isDev = import('electron-is-dev');

const yargs = require('yargs/yargs')

// how to hide the executable path in the argmap:
//const { hideBin } = require('yargs/helpers')
//const argmap = yargs(hideBin(process.argv)).argv
//const argmap = yargs(process.argv).argv

// how to invoke electron with command-line args (e.g):
// arguments to our electron main process come after '--'
// npm start -- --server_path /home/mikel

const argmap = yargs(process.argv);
const appPath = remote.app.getAppPath();
//const server_path = path.join(appPath,argmap['server_path']);

console.log('\argmap =='+JSON.stringify(argmap));
console.log('\n');

// how to adjust paths depending on whether the Electron app is
// in developmentor packaged for release:
const extrasPath = isDev ?
   path.join(appPath, 'src', 'main', 'extras') :
   path.join(appPath, '..', '..', 'extras');


// We finally have our exe!
//const exePath = path.join(extrasPath, 'myexe.exe');

const createWindow = () => {
    const win = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            enableRemoteModule: true,
            preload: path.join(__dirname, 'preload.js')
        }        
    })

    win.loadFile('index.html')
    exec("ls -al", {timeout: 10000, maxBuffer: 20000*1024},
         function(error, stdout, stderr) {
             var out = stdout.toString();
             const outArray = out.split('\n');

             let result = 'ls -al output:\n'
             outArray.forEach(e => {
                 result += `${e}\n`
             });
             console.log(result)
         });
}

app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit()
})


app.whenReady().then(() => {
    var httpPort = 0;
    var webSocketPort = 0;

    portfinder.setBasePort(3000);
    portfinder.setHighestPort(3999);    
    portfinder.getPort((err, port) => {
        if (err) {
            console.error(err);
            return;
        }
        httpPort = port;
        console.log('Found open HTTP port: '+httpPort.toString());
    });

    portfinder.setBasePort(4000);
    portfinder.setHighestPort(4999);
    portfinder.getPort((err, port) => {
        if (err) {
            console.error(err);
            return;
        }
        webSocketPort = port;
        console.log('Found open WebSocket port: '+webSocketPort.toString());
    });

    // TODO: create lisp process, passing httpPort and webSocketPort
    
    let win = createWindow();

})

app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
})
