pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root
    property list<real> values
    property int fromFreq
    property int toFreq
    readonly property real freqStep: Math.abs(toFreq - fromFreq) / values.length
    signal valueChanged(index: int, newValue: real)
    signal bandAdded
    signal bandRemoved
    signal flat

    function formatFreq(freq) {
        let formatted = "";
        if (freq > 1000) {
            freq = freq / 1000;
            formatted = `${Math.round((freq * 10)) / 10} kHz`;
        } else {
            formatted = `${freq} Hz`;
        }
        return formatted;
    }

    TextMetrics {
        id: labelWidth
        text: "99.9 kHz"
        font.features: {
            "tnum": 1
        }
        font.pointSize: Kirigami.Theme.smallFont.pointSize
    }

    ScrollView {
        id: sv
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: parent.width
        RowLayout {
            // HACK: silence binding loop warnings.
            // contentWidth seems to be causing the binding loop,
            // but contentWidth is read-only and we have no control
            // over how it is calculated.
            implicitWidth: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Kirigami.Units.mediumSpacing
            Repeater {
                model: root.values
                ColumnLayout {
                    id: col
                    required property int index
                    required property var modelData
                    spacing: Kirigami.Units.smallSpacing
                    Layout.preferredWidth: labelWidth.width
                    Label {
                        text: col.index + 1
                        font.features: {
                            "tnum": 1
                        }
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        opacity: 0.75
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Label {
                        text: root.formatFreq(Math.round((col.index + 1) * root.freqStep))
                        font.features: {
                            "tnum": 1
                        }
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        opacity: 0.75
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Slider {
                        id: slider
                        orientation: Qt.Vertical
                        from: 0
                        to: 5
                        stepSize: 0.1
                        onValueChanged: {
                            root.valueChanged(col.index, value);
                        }
                        value: col.modelData
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: 250
                    }
                    Label {
                        text: parseFloat(slider.value).toFixed(1)
                        font.features: {
                            "tnum": 1
                        }
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        opacity: 0.75
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Button {
            enabled: root.values.length >= 3
            icon.name: "edit-clear"
            autoRepeat: true
            onClicked: {
                root.bandRemoved();
            }
            text: i18n("Remove band")
        }

        Button {
            icon.name: "list-add-symbolic"
            text: i18n("Add band")
            autoRepeat: true
            onClicked: {
                root.bandAdded();
            }
        }

        Button {
            icon.name: "gnumeric-object-line-symbolic"
            onClicked: {
                root.flat();
            }
            text: i18n("Flat response")
        }
    }
}
