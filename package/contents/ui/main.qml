import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import "code/enum.js" as Enum
import "code/globals.js" as Globals
import "code/utils.js" as Utils

PlasmoidItem {
    id: main
    Plasmoid.backgroundHints: plasmoid.configuration.desktopWidgetBg
    Plasmoid.constraintHints: Plasmoid.configuration.fillPanel ? Plasmoid.CanFillArea : Plasmoid.NoHint

    property bool editMode: Plasmoid.containment.corona?.editMode ?? false
    property bool onDesktop: Plasmoid.location === PlasmaCore.Types.Floating
    property bool horizontal: Plasmoid.formFactor !== PlasmaCore.Types.Vertical

    property bool hideWhenIdle: Plasmoid.configuration.hideWhenIdle

    Plasmoid.status: PlasmaCore.Types.ActiveStatus

    function updateStatus() {
        if (Plasmoid.status === PlasmaCore.Types.RequiresAttentionStatus) {
            return;
        }
        Plasmoid.status = (hideWhenIdle && cava.idle || !cava.running) && !Plasmoid.expanded && !editMode && !cava.hasError ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus;
    }
    onExpandedChanged: {
        Utils.delay(1000, updateStatus, main);
    }

    Cava {
        id: cava
        framerate: Plasmoid.configuration.framerate
        barCount: {
            if (Plasmoid.configuration.visualizerStyle === Enum.VisualizerStyles.Wave) {
                return Math.max(2, Plasmoid.configuration.barCount);
            }
            return Plasmoid.configuration.barCount;
        }
        noiseReduction: Plasmoid.configuration.noiseReduction
        monstercat: Plasmoid.configuration.monstercat
        waves: Plasmoid.configuration.waves
        autoSensitivity: Plasmoid.configuration.autoSensitivity
        sensitivity: Plasmoid.configuration.sensitivity
        lowerCutoffFreq: Plasmoid.configuration.lowerCutoffFreq
        higherCutoffFreq: Plasmoid.configuration.higherCutoffFreq
        inputMethod: Plasmoid.configuration.inputMethod
        inputSource: Plasmoid.configuration.inputSource
        sampleRate: Plasmoid.configuration.sampleRate
        sampleBits: Plasmoid.configuration.sampleBits
        inputChannels: Plasmoid.configuration.inputChannels
        autoconnect: Plasmoid.configuration.autoconnect
        outputChannels: Plasmoid.configuration.outputChannels
        monoOption: Plasmoid.configuration.monoOption
        reverse: Plasmoid.configuration.reverse
        eq: Plasmoid.configuration.eq
        idleCheck: main.hideWhenIdle
        idleTimer: Plasmoid.configuration.idleTimer
        onIdleChanged: main.updateStatus()
        onHasErrorChanged: main.updateStatus()
        onRunningChanged: main.updateStatus()
    }

    preferredRepresentation: compactRepresentation
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: cava.running ? i18n("Stop CAVA") : i18n("Start CAVA")
            icon.name: "waveform-symbolic"
            onTriggered: {
                if (cava.running) {
                    cava.stop();
                } else {
                    cava.restart();
                }
            }
        }
    ]
}
