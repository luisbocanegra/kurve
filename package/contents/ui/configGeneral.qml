import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.plasma.core as PlasmaCore

KCM.SimpleKCM {
    id: root
    property alias cfg_desktopWidgetBg: desktopWidgetBackgroundRadio.value
    property alias cfg_hideWhenIdle: hideWhenIdleCheckbox.checked
    property int cfg_visualizerStyle
    property string cfg_barColors
    property string cfg_waveFillColors
    property alias cfg_debugMode: debugModeCheckbox.checked
    property alias cfg_idleTimer: idleTimerSpinbox.value
    property alias cfg_hideToolTip: hideToolTipCheckbox.checked
    property alias cfg_disableLeftClick: disableLeftClickCheckbox.checked

    Kirigami.FormLayout {
        id: parentLayout
        Layout.fillWidth: true

        CheckBox {
            id: debugModeCheckbox
            Kirigami.FormData.label: i18n("Debug mode:")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Auto-hide when idle:")
            CheckBox {
                id: hideWhenIdleCheckbox
            }
            Label {
                text: i18n("After")
            }
            SpinBox {
                id: idleTimerSpinbox
                enabled: hideWhenIdleCheckbox.checked
                from: 1
                to: 60
            }
            Label {
                text: i18n("seconds")
            }
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
        RowLayout {
            Kirigami.FormData.label: i18n("Disable tooltip:")
            CheckBox {
                id: hideToolTipCheckbox
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Disable ToolTip that shows the widget name and description.")
            }
        }
        RowLayout {
            Kirigami.FormData.label: i18n("Disable left click:")
            CheckBox {
                id: disableLeftClickCheckbox
            }
            Kirigami.ContextualHelpButton {
                toolTipText: i18n("Applet popup will still be accessible from the right click menu.")
            }
        }
    }
}
