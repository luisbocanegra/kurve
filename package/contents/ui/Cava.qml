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
    property bool running: process.running
    function restart() {
        process.restart();
    }
    function stop() {
        process.stop();
    }
    ProcessMonitor {
        id: process
        command: `cava -p /dev/stdin <<-EOF
[general]
framerate=${root.framerate}
bars=${root.barCount}
[output]
channels=mono
method=raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range=100
[smoothing]
noise_reduction=${root.noiseReduction}
monstercat=${root.monstercat}
waves=${root.waves}
EOF
`
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
                idleTimer.restart();
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
