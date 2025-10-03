import QtQuick
import QtWebSockets
import "../code/utils.js" as Utils
import org.kde.plasma.plasmoid
import "../"

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

    property var logger: Logger.create(Plasmoid.configuration.debugMode ? LoggingCategory.Debug : LoggingCategory.Info)

    // run command
    RunCommand {
        id: runCommand
        onExited: (cmd, exitCode, exitStatus, stdout, stderr) => {
            if (exitCode !== 0) {
                logger.error(`ProcessMonitorFallback cmd: ${cmd}, exitCode: ${exitCode}, exitStatus: ${exitStatus}, stdout: ${stdout}, stderr: ${stderr}`);
                root.stderr = stderr;
            } else {
                logger.debug(`cmd: ${cmd}, exitCode: ${exitCode}, exitStatus: ${exitStatus}, stdout: ${stdout}, stderr: ${stderr}`);
            }
            root.stdout = "";
            root.pid = "";
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
        onUrlChanged: url => {
            root.logger.debug("started websocket server:", url);
        }
        onClientConnected: webSocket => {
            webSocket.onTextMessageReceived.connect(function (message) {
                if (message) {
                    if (message.includes("ERROR:")) {
                        logger.error(message);
                        root.stderr = message;
                        root.stdout = "";
                        root.pid = "";
                        return;
                    }
                    if (message.includes("PID:")) {
                        root.pid = message.trim().split(" ")[1];
                        logger.debug(`started ${root.monitorCommand} with pid:`, root.pid);
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
        logger.debug("ProcessMonitorFallback.start()");
        Utils.delay(100, () => {
            isReady = true;
            runCommand.run(root.monitorCommand);
        }, root);
    }

    function stop() {
        logger.debug("ProcessMonitorFallback.stop()");
        if (pid) {
            runCommand.run(`kill -9 ${pid}`);
            pid = "";
        }
    }

    function restart() {
        logger.debug("ProcessMonitorFallback.restart()");
        stop();
        pendingRestart = true;
    }

    onCommandChanged: {
        if (!command || command == "")
            return;
        logger.debug("ProcessMonitorFallback.onCommandChanged:", command);
        restart();
    }
}
