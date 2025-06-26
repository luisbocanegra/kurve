import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes 1.9
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import "code/enum.js" as Enum
import "code/globals.js" as Globals
import "code/utils.js" as Utils
import "components" as Components

PlasmoidItem {
    id: root
    Plasmoid.constraintHints: Plasmoid.configuration.fillPanel ? Plasmoid.CanFillArea : Plasmoid.NoHint
    Plasmoid.backgroundHints: plasmoid.configuration.desktopWidgetBg
    property int widgetLength: visualizer.width
    property bool horizontal: Plasmoid.formFactor !== PlasmaCore.Types.Vertical
    Layout.preferredWidth: horizontal ? widgetLength : 0
    Layout.preferredHeight: horizontal ? Math.min(root.width, root.height) : widgetLength
    Layout.minimumWidth: root.Layout.preferredWidth
    Layout.maximumWidth: root.Layout.preferredWidth

    property list<int> values
    property int framerate: Plasmoid.configuration.framerate
    property int barGap: Plasmoid.configuration.barGap
    property int barCount: {
        if (visualizerStyle === Enum.VisualizerStyles.Wave) {
            return Math.max(2, Plasmoid.configuration.barCount);
        }
        return Plasmoid.configuration.barCount;
    }
    property int barWidth: Plasmoid.configuration.barWidth
    property int noiseReduction: Plasmoid.configuration.noiseReduction
    property int monstercat: Plasmoid.configuration.monstercat
    property int waves: Plasmoid.configuration.waves
    property bool centeredBars: Plasmoid.configuration.centeredBars
    property bool roundedBars: Plasmoid.configuration.roundedBars
    property bool hideWhenIdle: Plasmoid.configuration.hideWhenIdle
    property int visualizerStyle: Plasmoid.configuration.visualizerStyle
    property bool fillWave: Plasmoid.configuration.fillWave
    property bool debugMode: Plasmoid.configuration.debugMode
    property bool idle: true

    property var barColorsCfg: {
        let barColors;
        try {
            barColors = JSON.parse(Plasmoid.configuration.barColors);
        } catch (e) {
            console.error(e, e.stack);
            globalSettings = Globals.baseBarColors;
        }
        const config = Utils.mergeConfigs(Globals.baseBarColors, barColors);
        const configStr = JSON.stringify(config);
        if (Plasmoid.configuration.barColors !== configStr) {
            Plasmoid.configuration.barColors = configStr;
            Plasmoid.configuration.writeConfig();
        }
        return config;
    }

    property var waveFillColorsCfg: {
        let waveFillColors;
        try {
            waveFillColors = JSON.parse(Plasmoid.configuration.waveFillColors);
        } catch (e) {
            console.error(e, e.stack);
            globalSettings = Globals.baseWaveFillColors;
        }
        const config = Utils.mergeConfigs(Globals.baseWaveFillColors, waveFillColors);
        const configStr = JSON.stringify(config);
        if (Plasmoid.configuration.waveFillColors !== configStr) {
            Plasmoid.configuration.waveFillColors = configStr;
            Plasmoid.configuration.writeConfig();
        }
        return config;
    }

    preferredRepresentation: fullRepresentation
    Plasmoid.status: hideWhenIdle && idle ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

    Components.ProcessMonitor {
        id: process
        command: `printf '[general]\nframerate=${root.framerate}\nbars=${root.barCount}\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100\n[smoothing]\nnoise_reduction=${root.noiseReduction}\nmonstercat=${root.monstercat}\nwaves=${root.waves}' | cava -p /dev/stdin`
        onStdoutChanged: {
            if (process.stdout) {
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
                if (!root.idle) {
                    visualizer.requestPaint();
                }
            }
        }
    }

    Timer {
        id: idleTimer
        interval: 5000
        onTriggered: root.idle = true
    }

    Rectangle {
        id: kirigamiColorItem
        opacity: 0
        height: 1
        width: height
        Kirigami.Theme.colorSet: Kirigami.Theme[root.barColorsCfg.systemColorSet]
    }

    Rectangle {
        id: kirigamiColorItem2
        opacity: 0
        height: 1
        width: height
        Kirigami.Theme.colorSet: Kirigami.Theme[root.waveFillColorsCfg.systemColorSet]
    }

    Canvas {
        id: visualizer
        anchors.centerIn: parent
        property int visualizerStyle: root.visualizerStyle
        property int barWidth: root.barWidth
        property int spacing: root.barGap
        property int barCount: root.values.length
        property bool centeredBars: root.centeredBars
        property bool roundedBars: root.roundedBars
        property var values: root.values
        property real radiusOffset: barWidth / 2
        property bool fillWave: root.fillWave
        property int gradientHeight: height
        property int gradientWidth: width

        property var barColorsCfg: root.barColorsCfg
        property list<color> colors: Utils.getColors(barColorsCfg, barCount, kirigamiColorItem.Kirigami.Theme[barColorsCfg.systemColor])
        property var gradient: Utils.buildCanvasGradient(getContext("2d"), barColorsCfg.smoothGradient, colors, barColorsCfg.colorsOrientation, gradientHeight, gradientWidth)

        property var waveFillColorsCfg: root.waveFillColorsCfg
        property list<color> waveFillColors: Utils.getColors(waveFillColorsCfg, barCount, kirigamiColorItem2.Kirigami.Theme[waveFillColorsCfg.systemColor])
        property var waveFillGradient: Utils.buildCanvasGradient(getContext("2d"), waveFillColorsCfg.smoothGradient, waveFillColors, waveFillColorsCfg.colorsOrientation, gradientHeight, gradientWidth)

        width: barCount * barWidth + ((barCount - 1) * spacing)
        height: parent.height

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            if (barWidth % 2 === 0 && centeredBars) {
                ctx.translate(0.5, 0.5);
            }
            if (gradient) {
                ctx.strokeStyle = gradient;
            }
            if (visualizerStyle === Enum.VisualizerStyles.Bars) {
                ctx.lineCap = roundedBars ? "round" : "butt";
                ctx.lineWidth = barWidth;

                let x = barWidth / 2;

                // bars
                const centerY = height / 2;
                for (let i = 0; i < barCount; i++) {
                    const value = Math.max(1, Math.min(100, values[i]));

                    let barHeight;
                    let yBottom;
                    let yTop;
                    if (centeredBars) {
                        if (roundedBars) {
                            barHeight = (value / 100) * ((height - barWidth) / 2);
                        } else {
                            barHeight = (value / 100) * (height / 2);
                        }
                        yBottom = centerY - barHeight;
                        yTop = yBottom + (barHeight * 2);
                    } else {
                        if (roundedBars) {
                            barHeight = (value / 100) * (height - barWidth);
                            yBottom = height - radiusOffset;
                        } else {
                            barHeight = (value / 100) * height;
                            yBottom = height;
                        }
                        yTop = yBottom - barHeight;
                    }

                    ctx.beginPath();
                    ctx.moveTo(x, yBottom);
                    ctx.lineTo(x, yTop);
                    ctx.stroke();
                    x += barWidth + spacing;
                }
            } else if (visualizerStyle === Enum.VisualizerStyles.Wave) {
                if (barCount < 2)
                    return;

                ctx.lineCap = roundedBars ? "round" : "butt";
                ctx.lineWidth = barWidth;

                const step = width / (barCount - 1);
                const yBottom = centeredBars ? (height / 2) : (height - barWidth / 2);

                gradientHeight = yBottom;

                ctx.beginPath();
                let prevX = 0;
                let prevY = yBottom - Math.max(0, Math.min(100, values[0])) / 100 * yBottom;
                ctx.lineTo(prevX - 0.5, prevY);

                for (let i = 1; i < barCount; i++) {
                    const norm = Math.max(0, Math.min(100, values[i])) / 100;
                    const x = i * step;
                    const y = yBottom - norm * yBottom;
                    const midX = (prevX + x) / 2;
                    const midY = (prevY + y) / 2;
                    ctx.quadraticCurveTo(prevX, prevY, midX, midY);
                    prevX = x;
                    prevY = y;
                }

                ctx.lineTo(width + 0.5, prevY);
                ctx.stroke();

                if (fillWave) {
                    const yBottom = centeredBars ? (height / 2 + barWidth / 2) : height;
                    ctx.beginPath();
                    ctx.moveTo(0, yBottom);

                    prevX = 0;
                    prevY = yBottom - Math.max(0, Math.min(100, values[0])) / 100 * yBottom;
                    ctx.lineTo(prevX, prevY);

                    for (let i = 1; i < barCount; i++) {
                        const norm = Math.max(0, Math.min(100, values[i])) / 100;
                        const x = i * step;
                        const y = yBottom - norm * yBottom;
                        const midX = (prevX + x) / 2;
                        const midY = (prevY + y) / 2;
                        ctx.quadraticCurveTo(prevX, prevY, midX, midY);
                        prevX = x;
                        prevY = y;
                    }

                    ctx.lineTo(width, prevY);
                    ctx.lineTo(width, yBottom);
                    ctx.closePath();
                    ctx.fillStyle = waveFillGradient;
                    ctx.fill();
                }
            }
            if (barWidth % 2 === 0 && centeredBars) {
                ctx.translate(-0.5, -0.5);
            }
        }
    }

    Shape {
        id: shape
        visible: root.debugMode
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        ShapePath {
            fillColor: "transparent"
            strokeWidth: 1
            strokeColor: "red"
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 8]
            startX: 0
            startY: shape.height
            PathLine {
                x: shape.width
                y: shape.height
            }
            PathLine {
                x: shape.width
                y: 0
            }
            PathLine {
                x: 0
                y: 0
            }
            PathLine {
                x: 0
                y: shape.height
            }
        }
        ShapePath {
            fillColor: "transparent"
            strokeWidth: 1
            strokeColor: "red"
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 8]
            startX: 0
            startY: shape.height / 2
            PathLine {
                x: shape.width
                y: shape.height / 2
            }
        }
        ShapePath {
            fillColor: "transparent"
            strokeWidth: 1
            strokeColor: "red"
            strokeStyle: ShapePath.DashLine
            dashPattern: [1, 8]
            startX: shape.width / 2
            startY: 0
            PathLine {
                x: shape.width / 2
                y: shape.height
            }
        }
    }
}
