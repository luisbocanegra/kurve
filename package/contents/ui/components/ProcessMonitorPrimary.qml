import QtQuick
import com.github.luisbocanegra.audiovisualizer.process 1.0

Item {
    id: root
    property string command: ""
    property string stdout: ""
    Process {
        id: process
        command: ["sh", "-c", `${root.command}`]
        onStdoutChanged: {
            if (process.stdout) {
                root.stdout = process.stdout;
            }
        }
    }
}
