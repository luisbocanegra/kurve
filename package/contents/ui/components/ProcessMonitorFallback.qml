import QtQuick
import QtWebSockets 1.9
import "../code/utils.js" as Utils

Item {
    id: root
    property string command: ""
    property string stdout: ""
    property string stderr: ""

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
                        return;
                    }
                    root.stdout = message.trim().replace(/"/g, "");
                }
            });
        }
    }

    Component.onCompleted: {
        restart();
    }

    function restart() {
        runCommand.run(`pkill -f ${commandMonitorTool}`);
        Utils.delay(100, () => {
            runCommand.run(root.monitorCommand);
        }, root);
    }

    onCommandChanged: {
        restart();
    }
}
