import QtQuick
import com.github.luisbocanegra.audiovisualizer.process 1.0

Item {
    id: root
    property string command: ""
    readonly property string stdout: process.stdout
    readonly property string stderr: process.stderr
    readonly property bool running: process.running
    function restart() {
        process.restart();
    }
    function stop() {
        process.stop();
    }
    Process {
        id: process
        command: ["sh", "-c", `${root.command}`]
    }
}
