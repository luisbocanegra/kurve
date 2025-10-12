import QtQuick
import QtQuick.Shapes
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import "../code/utils.js" as Utils
import "../code/enum.js" as Enum
import "../code/drawCanvas.js" as DrawCanvas

Item {
    id: root
    required property int visualizerStyle
    required property int barWidth
    required property int barGap
    required property bool centeredBars
    required property bool roundedBars
    required property bool fillWave
    required property var barColorsCfg
    required property var waveFillColorsCfg
    required property bool fixVertical
    property list<int> values
    property bool debugMode: false

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
    Rectangle {
        color: Kirigami.Theme.highlightColor
        opacity: 0.2
        visible: root.debugMode
        width: canvas.width
        height: canvas.height
        anchors.centerIn: parent
    }
    Canvas {
        id: canvas
        anchors.centerIn: parent
        // renderStrategy: Canvas.Threaded
        property int visualizerStyle: root.visualizerStyle
        property int barWidth: root.barWidth
        property int spacing: {
            if (visualizerStyle === Enum.VisualizerStyles.Wave) {
                return Math.max(1, root.barGap);
            }
            return root.barGap;
        }
        property int barCount: root.values.length
        property bool centeredBars: root.centeredBars
        property bool roundedBars: root.roundedBars
        property var values: {
            if (root.debugMode) {
                let copy = root.values.slice();
                copy[0] = 100;
                return copy;
            }
            return root.values;
        }
        property bool fillWave: root.fillWave

        property real radiusOffset: barWidth / 2
        property int gradientHeight: height
        property int gradientWidth: width

        property var barColorsCfg: root.barColorsCfg
        property list<color> colors: Utils.getColors(barColorsCfg, barCount, kirigamiColorItem.Kirigami.Theme[barColorsCfg.systemColor])
        property var gradient: Utils.buildCanvasGradient(getContext("2d"), barColorsCfg.smoothGradient, colors, barColorsCfg.colorsOrientation, gradientHeight, gradientWidth)

        property var waveFillColorsCfg: root.waveFillColorsCfg
        property list<color> waveFillColors: Utils.getColors(waveFillColorsCfg, barCount, kirigamiColorItem2.Kirigami.Theme[waveFillColorsCfg.systemColor])
        property var waveFillGradient: Utils.buildCanvasGradient(getContext("2d"), waveFillColorsCfg.smoothGradient, waveFillColors, waveFillColorsCfg.colorsOrientation, gradientHeight, gradientWidth)

        width: {
            if (visualizerStyle === Enum.VisualizerStyles.Wave) {
                return barWidth + ((barCount - 1) * spacing);
            }
            return barCount * barWidth + ((barCount - 1) * spacing);
        }
        height: parent.height
        property bool fixAlign: barWidth % 2 === 0 && centeredBars && visualizerStyle === Enum.VisualizerStyles.Wave && !root.fixVertical

        onValuesChanged: canvas.requestPaint()

        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            if (fixAlign) {
                ctx.translate(0.0, 0.5);
            }
            if (root.fixVertical) {
                ctx.translate(0.0, -0.5);
            }
            if (gradient) {
                ctx.strokeStyle = gradient;
            }
            switch (visualizerStyle) {
            case Enum.VisualizerStyles.Bars:
                DrawCanvas.bars(ctx, canvas);
                break;
            case Enum.VisualizerStyles.Wave:
                DrawCanvas.wave(ctx, canvas);
                break;
            default:
                DrawCanvas.bars(ctx, canvas);
                break;
            }
            if (fixAlign) {
                ctx.translate(0.0, -0.5);
            }
        }
    }

    Shape {
        id: shape
        visible: root.debugMode
        width: canvas.width
        height: canvas.height
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
