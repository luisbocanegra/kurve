import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import "./components"
import "code/enum.js" as Enum
import "code/globals.js" as Globals
import "code/utils.js" as Utils

Item {
    id: root

    Layout.preferredWidth: {
        if (main.onDesktop || main.horizontal && Plasmoid.configuration.expanding) {
            return 0;
        }
        return main.horizontal ? Plasmoid.configuration.length : parent.width;
    }

    Layout.preferredHeight: {
        if (main.onDesktop || !main.horizontal && Plasmoid.configuration.expanding) {
            return 0;
        }
        return main.horizontal ? parent.height : Plasmoid.configuration.length;
    }
    Layout.fillWidth: main.horizontal && Plasmoid.configuration.expanding && !main.onDesktop
    Layout.fillHeight: !main.horizontal && Plasmoid.configuration.expanding && !main.onDesktop

    property int framerate: Plasmoid.configuration.framerate
    property int barGap: Plasmoid.configuration.barGap
    property int barCount: main.barCount
    property int barWidth: Plasmoid.configuration.barWidth
    property int noiseReduction: Plasmoid.configuration.noiseReduction
    property int monstercat: Plasmoid.configuration.monstercat
    property int waves: Plasmoid.configuration.waves
    property bool centeredBars: Plasmoid.configuration.centeredBars
    property bool roundedBars: Plasmoid.configuration.roundedBars
    property int visualizerStyle: Plasmoid.configuration.visualizerStyle
    property bool fillWave: Plasmoid.configuration.fillWave

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

    Visualizer {
        id: visualizer
        anchors.fill: parent
        visualizerStyle: root.visualizerStyle
        barWidth: root.barWidth
        barGap: root.barGap
        barCount: root.barCount
        centeredBars: root.centeredBars
        roundedBars: root.roundedBars
        fillWave: root.fillWave
        barColorsCfg: root.barColorsCfg
        waveFillColorsCfg: root.waveFillColorsCfg
        values: cava.values
        debugMode: Plasmoid.configuration.debugMode
        visible: !cava.hasError && !cava.idle
    }
    Kirigami.Icon {
        anchors.centerIn: parent
        width: Kirigami.Units.iconSizes.roundedIconSize(Math.min(main.height, main.width))
        height: width
        source: Qt.resolvedUrl("./icons/error.svg").toString().replace("file://", "")
        active: mouseArea.containsMouse
        isMask: true
        color: Kirigami.Theme.negativeTextColor
        visible: cava.hasError
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            main.expanded = !main.expanded;
        }
    }
}
