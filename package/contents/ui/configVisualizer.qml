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
    property alias cfg_barGap: barGapSpinbox.value
    property alias cfg_barWidth: barWidthSpinbox.value
    property alias cfg_desktopWidgetBg: desktopWidgetBackgroundRadio.value
    property alias cfg_centeredBars: centeredBarsCheckbox.checked
    property alias cfg_roundedBars: roundedBarsCheckbox.checked
    property alias cfg_fillPanel: fillPanelCheckbox.checked
    property alias cfg_hideWhenIdle: hideWhenIdleCheckbox.checked
    property int cfg_visualizerStyle
    property string cfg_barColors
    property string cfg_waveFillColors
    property alias cfg_fillWave: fillWaveCheckbox.checked
    property alias cfg_debugMode: debugModeCheckbox.checked

    ColumnLayout {

        Kirigami.FormLayout {
            id: parentLayout
            Layout.fillWidth: true

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
                id: fillWaveCheckbox
                text: i18n("Fill wave")
                visible: root.cfg_visualizerStyle === Enum.VisualizerStyles.Wave
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
                id: barWidthSpinbox
                Kirigami.FormData.label: i18n("Bar width:")
                from: 1
                to: 100
            }

            SpinBox {
                id: barGapSpinbox
                Kirigami.FormData.label: i18n("Bar gap:")
                from: 0
                to: 20
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
            ButtonGroup {
                id: desktopWidgetBackgroundRadio
                property int value: PlasmaCore.Types.StandardBackground
            }
            CheckBox {
                id: debugModeCheckbox
                Kirigami.FormData.label: i18n("Debug mode:")
            }
        }

        Components.FormColors {
            configString: root.cfg_barColors
            handleString: true
            onUpdateConfigString: (newString, newConfig) => {
                root.cfg_barColors = JSON.stringify(newConfig);
            }
            sectionName: root.cfg_visualizerStyle === Enum.VisualizerStyles.Wave ? i18n("Wave Color") : i18n("Bar Color")
            multiColor: true
        }

        Components.FormColors {
            configString: root.cfg_waveFillColors
            handleString: true
            onUpdateConfigString: (newString, newConfig) => {
                root.cfg_waveFillColors = JSON.stringify(newConfig);
            }
            sectionName: i18n("Wave Fill Color")
            multiColor: true
            visible: root.cfg_visualizerStyle === Enum.VisualizerStyles.Wave && fillWaveCheckbox.checked
        }
    }
}
