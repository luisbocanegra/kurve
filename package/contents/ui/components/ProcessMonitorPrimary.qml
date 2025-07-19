import QtQuick
import com.github.luisbocanegra.audiovisualizer.process

Item {
    id: root
    property string command: ""
    readonly property string stdout: process.stdout
    readonly property string stderr: process.stderr
    readonly property bool running: process.running
    function restart() {
        process.restart();
    }
    // the plugin keeps a single process so no special handling is needed here
    // this function is here just to match the signature of the fallback
    function start() {
        restart();
    }
    function stop() {
        process.stop();
    }
    Process {
        id: process
        command: ["sh", "-c", `${root.command}`]
    }
}
