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
    property alias cfg_barGap: barGapSpinbox.value
    property alias cfg_barWidth: barWidthSpinbox.value
    property alias cfg_noiseReduction: noiseReductionSpinbox.value
    property alias cfg_framerate: framerateSpinbox.value
    property alias cfg_monstercat: monstercatCheckbox.checked
    property alias cfg_waves: wavesCheckbox.checked
    property alias cfg_desktopWidgetBg: desktopWidgetBackgroundRadio.value
    property alias cfg_centeredBars: centeredBarsCheckbox.checked
    property alias cfg_roundedBars: roundedBarsCheckbox.checked
    property alias cfg_fillPanel: fillPanelCheckbox.checked
    property alias cfg_hideWhenIdle: hideWhenIdleCheckbox.checked
    property int cfg_visualizerStyle
    property string cfg_barColors

    ColumnLayout {

        Kirigami.FormLayout {
            id: parentLayout
            Layout.fillWidth: true

            SpinBox {
                id: framerateSpinbox
                Kirigami.FormData.label: i18n("Framerate:")
                from: 1
                to: 144
            }

            ComboBox {
                id: visualizerStyleCombobox
                Kirigami.FormData.label: i18n("Style:")
                textRole: "label"
                valueRole: "value"
                model: [
                    {
                        "label": i18n("Bars"),
                        "value": Enum.VisualizerStyles.Bars
                    },
                    {
                        "label": i18n("Wave"),
                        "value": Enum.VisualizerStyles.Wave
                    }
                ]
                onActivated: {
                    console.log("v", currentValue);
                    root.cfg_visualizerStyle = currentValue;
                }
                Component.onCompleted: {
                    currentIndex = indexOfValue(root.cfg_visualizerStyle);
                }
            }

            CheckBox {
                id: hideWhenIdleCheckbox
                Kirigami.FormData.label: i18n("Auto-hide when idle:")
            }

            CheckBox {
                id: fillPanelCheckbox
                Kirigami.FormData.label: i18n("Fill panel thickness:")
            }

            CheckBox {
                id: centeredBarsCheckbox
                Kirigami.FormData.label: i18n("Centered bars:")
            }

            CheckBox {
                id: roundedBarsCheckbox
                Kirigami.FormData.label: i18n("Rounded bars:")
            }

            SpinBox {
                id: barCountSpinbox
                Kirigami.FormData.label: i18n("Number of bars:")
                from: 1
                to: 512
            }

            SpinBox {
                id: barWidthSpinbox
                Kirigami.FormData.label: i18n("Bar width:")
                from: 0
                to: 100
            }

            SpinBox {
                id: barGapSpinbox
                Kirigami.FormData.label: i18n("Bar gap:")
                from: 0
                to: 20
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

            ButtonGroup {
                id: desktopWidgetBackgroundRadio
                property int value: PlasmaCore.Types.StandardBackground
            }

            RadioButton {
                Kirigami.FormData.label: i18n("Desktop background:")
                text: i18n("Default")
                checked: desktopWidgetBackgroundRadio.value == PlasmaCore.Types.StandardBackground
                onCheckedChanged: () => {
                    if (checked) {
                        desktopWidgetBackgroundRadio.value = PlasmaCore.Types.StandardBackground;
                    }
                }
                ButtonGroup.group: desktopWidgetBackgroundRadio
            }
            RadioButton {
                text: i18n("Transparent")
                checked: desktopWidgetBackgroundRadio.value == PlasmaCore.Types.NoBackground
                onCheckedChanged: () => {
                    if (checked) {
                        desktopWidgetBackgroundRadio.value = PlasmaCore.Types.NoBackground;
                    }
                }
                ButtonGroup.group: desktopWidgetBackgroundRadio
            }
            RowLayout {
                RadioButton {
                    text: i18n("Transparent with shadow")
                    checked: desktopWidgetBackgroundRadio.value == PlasmaCore.Types.ShadowBackground
                    onCheckedChanged: () => {
                        if (checked) {
                            desktopWidgetBackgroundRadio.value = PlasmaCore.Types.ShadowBackground;
                        }
                    }
                    ButtonGroup.group: desktopWidgetBackgroundRadio
                }
            }
        }

        Components.FormColors {
            configString: root.cfg_barColors
            handleString: true
            onUpdateConfigString: (newString, newConfig) => {
                root.cfg_barColors = JSON.stringify(newConfig);
            }
            sectionName: i18n("Bar Color")
            multiColor: true
        }
    }
    Component.onCompleted: console.log(root.cfg_barColors)
}
