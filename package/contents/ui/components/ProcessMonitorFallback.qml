import QtQuick
import QtWebSockets
import "../code/utils.js" as Utils

Item {
    id: root
    property string command: ""
    property string stdout: ""
    property string stderr: ""
    property bool running: stdout !== ""
    property string pid: ""
    property bool isReady: false
    property bool pendingRestart: false

    readonly property string toolsDir: Qt.resolvedUrl("../tools").toString().substring(7) + "/"
    readonly property string commandMonitorTool: "'" + toolsDir + "commandMonitor'"
    readonly property string monitorCommand: `${commandMonitorTool} ${server.url} "${command}"`

    // run command
    RunCommand {
        id: runCommand
        onExited: (cmd, exitCode, exitStatus, stdout, stderr) => {
            if (exitCode !== 0) {
                console.error(cmd, exitCode, exitStatus, stdout, stderr);
                root.stderr = stderr;
                root.stdout = "";
                root.pid = "";
            }
            if (cmd.startsWith("kill") && root.pendingRestart) {
                root.pendingRestart = false;
                root.start();
            }
        }
    }

    // get live output lines
    WebSocketServer {
        id: server
        listen: true
        onClientConnected: webSocket => {
            webSocket.onTextMessageReceived.connect(function (message) {
                if (message) {
                    if (message.includes("ERROR:")) {
                        root.stderr = message;
                        root.stdout = "";
                        root.pid = "";
                        return;
                    }
                    if (message.includes("PID:")) {
                        root.pid = message.trim().split(" ")[1];
                        root.stderr = "";
                        return;
                    }
                    root.stdout = message.trim().replace(/"/g, "");
                }
            });
        }
    }

    Component.onCompleted: {
        start();
    }

    function start() {
        Utils.delay(100, () => {
            isReady = true;
            runCommand.run(root.monitorCommand);
        }, root);
    }

    function stop() {
        if (pid) {
            runCommand.run(`kill -9 ${pid}`);
            pid = "";
        }
    }

    function restart() {
        stop();
        pendingRestart = true;
    }

    onCommandChanged: {
        restart();
    }
}
