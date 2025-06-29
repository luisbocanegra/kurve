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
    property bool hasError: cava.error !== ""
    property string error: cava.error

    property bool hideWhenIdle: Plasmoid.configuration.hideWhenIdle
    property bool idle: cava.idle

    Plasmoid.status: hideWhenIdle && idle ? PlasmaCore.Types.HiddenStatus : PlasmaCore.Types.ActiveStatus

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
        monstercat: lasmoid.configuration.monstercat
        waves: Plasmoid.configuration.waves
    }

    preferredRepresentation: compactRepresentation
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}
}
