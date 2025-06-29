import QtQuick
import com.github.luisbocanegra.audiovisualizer.process 1.0

Item {
    id: root
    property string command: ""
    property string stdout: ""
    property string stderr: ""
    Process {
        id: process
        command: ["sh", "-c", `${root.command}`]
        onStdoutChanged: {
            root.stdout = process.stdout;
        }
        onStderrChanged: {
            root.stderr = process.stderr;
        }
    }
}
