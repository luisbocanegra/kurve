import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root
    // general
    property alias cfg_barCount: barCountSpinbox.value
    property alias cfg_framerate: framerateSpinbox.value
    property alias cfg_autoSensitivity: autoSensitivityCheckbox.checked
    property alias cfg_sensitivity: sensitivitySpinbox.value
    property alias cfg_lowerCutoffFreq: lowerCutoffFreqSpinbox.value
    property alias cfg_higherCutoffFreq: higherCutoffFreqSpinbox.value
    // smoothing
    property alias cfg_noiseReduction: noiseReductionSpinbox.value
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
            Kirigami.FormData.label: i18n("General")
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

        RowLayout {
            Kirigami.FormData.label: i18n("Automatic sensitivity:")
            CheckBox {
                id: autoSensitivityCheckbox
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Attempt to decrease sensitivity if the bars peak.")
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Sensitivity:")
            SpinBox {
                id: sensitivitySpinbox
                from: 1
                to: 999
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Manual sensitivity in %.\nIf autosens is enabled, this will only be the initial value")
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Frequency range (Hz):")

            Label {
                text: i18n("Min")
            }
            SpinBox {
                id: lowerCutoffFreqSpinbox
                from: 20
                to: 22000
                stepSize: 100
            }

            Label {
                text: i18n("Max")
            }

            SpinBox {
                id: higherCutoffFreqSpinbox
                from: 1
                to: 22000
                stepSize: 100
            }

            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Lower and higher cutoff frequencies for lowest and highest bars, the bandwidth of the visualizer.\nNote: Cava will automatically increase the higher cutoff if a too low band is specified.")
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Smoothing")
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
