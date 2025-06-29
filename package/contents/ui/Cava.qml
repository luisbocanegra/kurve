import QtQuick
import "./components"

Item {
    id: root
    property int framerate
    property int barCount
    property int noiseReduction
    property int monstercat
    property int waves
    property list<int> values
    property bool idle
    property bool hasError: error !== ""
    property string error
    property bool usingFallback: process.usingFallback
    ProcessMonitor {
        id: process
        command: `printf '[general]\nframerate=${root.framerate}\nbars=${root.barCount}\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100\n[smoothing]\nnoise_reduction=${root.noiseReduction}\nmonstercat=${root.monstercat}\nwaves=${root.waves}' | cava -p /dev/stdin`
        onStdoutChanged: {
            let output = process.stdout.trim();
            if (output.endsWith(';')) {
                output = output.slice(0, -1);
            }
            root.values = output.split(";").map(v => parseInt(v, 10));
            if (root.values.find(v => v > 0)) {
                if (idleTimer.running) {
                    idleTimer.stop();
                }
                root.idle = false;
            } else {
                idleTimer.start();
            }
        }
        onStderrChanged: root.error = process.stderr
    }

    Timer {
        id: idleTimer
        interval: 5000
        onTriggered: root.idle = true
    }
}
