const { app, BrowserWindow } = require('electron')
const portfinder = require('portfinder');
const path = require('node:path')

const createWindow = () => {
    const win = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            preload: path.join(__dirname, 'preload.js')
        }
        
    })

    win.loadFile('index.html')

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
