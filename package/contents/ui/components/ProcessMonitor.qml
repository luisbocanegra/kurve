import QtQuick

Item {
    id: root

    property string command: ""
    readonly property string stdout: process.stdout ?? ""
    readonly property string stderr: process.stderr ?? ""
    readonly property bool forceFallback: false
    readonly property bool running: process.running ?? false
    property bool usingFallback: false
    property var process: null
    property bool loadingFailed: false
    property list<string> loadingErrors

    function restart() {
        if (process !== null) {
            process.restart();
        }
    }

    function start() {
        if (process !== null) {
            process.start();
        }
    }

    function stop() {
        if (process !== null) {
            process.stop();
        }
    }

    onCommandChanged: {
        if (process !== null) {
            process.command = root.command;
        }
    }

    Component.onCompleted: {
        let component = null;
        const sources = ["ProcessMonitorFallback.qml"];
        if (!root.forceFallback) {
            sources.unshift("ProcessMonitorPrimary.qml");
        }
        for (let source of sources) {
            component = Qt.createComponent(source);
            if (component.status === Component.Ready) {
                process = component.createObject(root);
                process.command = root.command;
                break;
            } else {
                console.warn(component.errorString());
                root.loadingErrors.push(component.errorString());
            }
        }

        if (process === null) {
            root.loadingFailed = true;
        }
        root.usingFallback = component.url.toString().includes("ProcessMonitorFallback.qml");
    }
}
