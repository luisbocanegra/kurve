import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

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

        RowLayout {
            Kirigami.FormData.label: i18n("Noise reduction:")
            SpinBox {
                id: noiseReductionSpinbox
                from: 0
                to: 100
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("The raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth.\n100 will be very slow and smooth, 0 will be fast but noisy.")
            }
        }
        RowLayout {
            Kirigami.FormData.label: i18n("Monstercat:")
            CheckBox {
                id: monstercatCheckbox
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Enable the so-called \"Monstercat smoothing\" with or without \"waves\".")
            }
        }

        CheckBox {
            id: wavesCheckbox
            text: i18n("Waves")
            enabled: monstercatCheckbox.checked
        }
    }
}
