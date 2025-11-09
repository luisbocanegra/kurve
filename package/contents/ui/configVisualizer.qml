import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import "components" as Components
import "code/enum.js" as Enum
import "code/utils.js" as Utils

KCM.SimpleKCM {
    id: root
    property alias cfg_barGap: barGapSpinbox.value
    property alias cfg_barWidth: barWidthSpinbox.value
    property alias cfg_centeredBars: centeredBarsCheckbox.checked
    property alias cfg_roundedBars: roundedBarsCheckbox.checked
    // fill panel thickness
    property alias cfg_fillPanel: fillPanelCheckbox.checked
    property int cfg_visualizerStyle
    property alias cfg_circleMode: circleMode.checked
    property real cfg_circleModeSize
    property string cfg_barColors
    property string cfg_waveFillColors
    property alias cfg_fillWave: fillWaveCheckbox.checked
    // take all the available space in the panel
    property alias cfg_expanding: expandingCheckbox.checked
    property alias cfg_length: lengthSpinbox.value
    property int cfg_orientation

    readonly property bool vertical: {
        if (Plasmoid.formFactor == PlasmaCore.Types.Vertical) {
            return true;
        }
        return false;
    }
    readonly property string dimensionStr: vertical ? i18n("height") : i18n("width")

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
                id: circleMode
                Kirigami.FormData.label: i18n("Circle mode:")
            }

            Components.DoubleSpinBox {
                id: circleModeSize
                Kirigami.FormData.label: i18n("Circle size:")
                from: 0 * multiplier
                to: 0.99 * multiplier
                value: cfg_circleModeSize * multiplier
                onValueModified: {
                    cfg_circleModeSize = value / circleModeSize.multiplier;
                }
            }

            ComboBox {
                id: orientationCombobox
                Kirigami.FormData.label: i18n("Orientation:")
                valueRole: "value"
                textRole: "label"

                model: [
                    {
                        label: i18n("Top"),
                        value: Enum.Orientation.Top
                    },
                    {
                        label: i18n("Bottom"),
                        value: Enum.Orientation.Bottom
                    },
                    {
                        label: i18n("Left"),
                        value: Enum.Orientation.Left
                    },
                    {
                        label: i18n("Right"),
                        value: Enum.Orientation.Right
                    }
                ]
                onActivated: root.cfg_orientation = currentValue
                Component.onCompleted: currentIndex = indexOfValue(root.cfg_orientation)
            }

            CheckBox {
                id: expandingCheckbox
                visible: !(Plasmoid.location === PlasmaCore.Types.Floating)
                Kirigami.FormData.label: i18n("Fill panel %1:", root.dimensionStr)
            }
            SpinBox {
                id: lengthSpinbox
                visible: !(Plasmoid.location === PlasmaCore.Types.Floating)
                enabled: !expandingCheckbox.checked
                Kirigami.FormData.label: i18n("Fixed %1:", root.dimensionStr)
                from: 1
                to: 9999
            }

            CheckBox {
                id: fillPanelCheckbox
                visible: !(Plasmoid.location === PlasmaCore.Types.Floating)
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
                Kirigami.FormData.label: root.cfg_visualizerStyle === Enum.VisualizerStyles.Wave ? i18n("Line width:") : i18n("Bar width:")
                from: 1
                to: 999
            }

            SpinBox {
                id: barGapSpinbox
                Kirigami.FormData.label: i18n("Bar gap:")
                from: root.cfg_visualizerStyle === Enum.VisualizerStyles.Wave ? 1 : 0
                to: 999
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
