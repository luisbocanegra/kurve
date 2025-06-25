import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import com.github.luisbocanegra.audiovisualizer.process 1.0
import "code/enum.js" as Enum
import "code/globals.js" as Globals
import "code/utils.js" as Utils

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
    property int barCount: Plasmoid.configuration.barCount
    property int barWidth: Plasmoid.configuration.barWidth
    property int noiseReduction: Plasmoid.configuration.noiseReduction
    property int monstercat: Plasmoid.configuration.monstercat
    property int waves: Plasmoid.configuration.waves
    property bool centeredBars: Plasmoid.configuration.centeredBars
    property bool roundedBars: Plasmoid.configuration.roundedBars
    property bool hideWhenIdle: Plasmoid.configuration.hideWhenIdle
    property int visualizerStyle: Plasmoid.configuration.visualizerStyle
    property bool fillWave: Plasmoid.configuration.fillWave
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

    preferredRepresentation: fullRepresentation
    Plasmoid.status: hideWhenIdle && idle ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

    Process {
        id: process
        command: ["sh", "-c", `printf '[general]\nframerate=${root.framerate}\nbars=${root.barCount}\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100\n[smoothing]\nnoise_reduction=${root.noiseReduction}\nmonstercat=${root.monstercat}\nwaves=${root.waves}' | cava -p /dev/stdin`]
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

    Canvas {
        id: visualizer
        property int visualizerStyle: root.visualizerStyle
        property int barWidth: root.barWidth
        property int spacing: root.barGap
        property int barCount: root.values.length
        property bool centeredBars: root.centeredBars
        property bool roundedBars: root.roundedBars
        property var values: root.values
        property real radiusOffset: barWidth / 2
        property var barColorsCfg: root.barColorsCfg
        property int colorSourceType: barColorsCfg.sourceType
        property color customColor: barColorsCfg.custom
        property color themeColor: kirigamiColorItem.Kirigami.Theme[barColorsCfg.systemColor]
        property var singleColor: {
            let color = null;
            if (colorSourceType === 0) {
                color = customColor;
            } else if (colorSourceType === 1) {
                color = themeColor;
            }
            if (color) {
                color = Utils.alterColor(color, barColorsCfg.saturationEnabled, barColorsCfg.saturationValue, barColorsCfg.lightnessEnabled, barColorsCfg.lightnessValue, barColorsCfg.alpha);
            }
            return color;
        }
        property list<color> colors: {
            let colors = [];
            if (colorSourceType === 2) {
                colors = barColorsCfg.list.map(c => {
                    c = Utils.hexToQtColor(c);
                    return Utils.alterColor(c, barColorsCfg.saturationEnabled, barColorsCfg.saturationValue, barColorsCfg.lightnessEnabled, barColorsCfg.lightnessValue, barColorsCfg.alpha);
                });
            } else if (colorSourceType === 3) {
                for (let i = 0; i < barCount; i++) {
                    colors.push(Utils.alterColor(Utils.getRandomColor(null, 0.8, 0.7, null), barColorsCfg.saturationEnabled, barColorsCfg.saturationValue, barColorsCfg.lightnessEnabled, barColorsCfg.lightnessValue, barColorsCfg.alpha));
                }
            } else if (colorSourceType === 7) {
                for (let i = 0; i < barCount; i++) {
                    let c = Qt.hsla(i / barCount, 0.8, 0.7, 1.0);
                    colors.push(Utils.alterColor(c, barColorsCfg.saturationEnabled, barColorsCfg.saturationValue, barColorsCfg.lightnessEnabled, barColorsCfg.lightnessValue, barColorsCfg.alpha));
                }
            }
            return colors;
        }
        property bool smoothGradient: barColorsCfg.smoothGradient
        property int colorsOrientation: barColorsCfg.colorsOrientation
        property bool fillWave: root.fillWave

        width: barCount * barWidth + ((barCount - 1) * spacing)
        height: parent.height

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            if (singleColor) {
                ctx.strokeStyle = singleColor;
            } else {
                ctx.strokeStyle = Utils.buildCanvasGradient(ctx, smoothGradient, colors, colorsOrientation, height, width);
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
                const yBottom = centeredBars ? height / 2 : height - barWidth;
                const amplitude = centeredBars ? height / 2 : height - barWidth;

                ctx.beginPath();

                if (fillWave) {
                    ctx.moveTo(0, yBottom);
                }

                let prevX = 0;
                let prevY = yBottom - Math.max(0, Math.min(100, values[0])) / 100 * amplitude;
                ctx.lineTo(prevX, prevY);

                for (let i = 1; i < barCount; i++) {
                    const norm = Math.max(0, Math.min(100, values[i])) / 100;
                    const x = i * step;
                    const y = yBottom - norm * amplitude;
                    const midX = (prevX + x) / 2;
                    const midY = (prevY + y) / 2;
                    ctx.quadraticCurveTo(prevX, prevY, midX, midY);
                    prevX = x;
                    prevY = y;
                }

                ctx.lineTo(width, prevY);
                if (fillWave) {
                    ctx.lineTo(width, yBottom);
                    ctx.closePath();
                    ctx.fillStyle = ctx.strokeStyle;
                    ctx.fill();
                }
                ctx.stroke();
            }
        }
    }
}
