import QtQuick

Item {
    id: root
    property list<string> names
    RunCommand {
        id: process
        onExited: (cmd, exitCode, exitStatus, stdout, stderr) => {
            if (exitCode !== 0) {
                return;
            }
            if (stdout) {
                let output = stdout.trim().split('\n');
                output = output.map(l => l.split(/\t+/)[1]);
                output.unshift("auto");
                root.names = output;
            }
        }
    }
    Component.onCompleted: process.run("pactl list sources short && pactl list sinks short")
}
