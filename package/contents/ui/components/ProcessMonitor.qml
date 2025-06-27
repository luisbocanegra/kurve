import QtQuick

Item {
    id: root

    property string command: ""
    property string stdout: ""
    property bool useFallback: false

    onCommandChanged: {
        if (loader.status === Loader.Ready) {
            loader.item.command = root.command;
        }
    }

    Loader {
        id: loader

        source: root.useFallback ? "ProcessMonitorFallback.qml" : "ProcessMonitorPrimary.qml"
        onStatusChanged: {
            if (status === Loader.Error)
                loader.source = "ProcessMonitorFallback.qml";
        }
        onLoaded: {
            loader.item.command = root.command;
            loader.item.stdoutChanged.connect(() => {
                root.stdout = loader.item.stdout;
            });
        }
    }
}
