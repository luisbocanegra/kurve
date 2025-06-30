import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore
import "components" as Components
import "code/enum.js" as Enum

KCM.SimpleKCM {
    id: root
    property alias cfg_barCount: barCountSpinbox.value
    property alias cfg_noiseReduction: noiseReductionSpinbox.value
    property alias cfg_framerate: framerateSpinbox.value
    property alias cfg_monstercat: monstercatCheckbox.checked
    property alias cfg_waves: wavesCheckbox.checked
    property int cfg_visualizerStyle
    property string cfg_barColors
    property string cfg_waveFillColors

    Kirigami.FormLayout {
        id: parentLayout
        Layout.fillWidth: true

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: "CAVA"
        }

        SpinBox {
            id: framerateSpinbox
            Kirigami.FormData.label: i18n("Framerate:")
            from: 1
            to: 144
        }

        SpinBox {
            id: barCountSpinbox
            Kirigami.FormData.label: i18n("Number of bars:")
            from: 1
            to: 512
        }

        SpinBox {
            id: noiseReductionSpinbox
            Kirigami.FormData.label: i18n("Noise reduction:")
            from: 0
            to: 100
        }

        CheckBox {
            id: monstercatCheckbox
            Kirigami.FormData.label: i18n("Monstercat:")
        }

        CheckBox {
            id: wavesCheckbox
            Kirigami.FormData.label: i18n("Waves:")
        }
    }
}
