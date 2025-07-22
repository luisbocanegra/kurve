import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import "./components"

ColumnLayout {
    id: root
    Layout.minimumWidth: Kirigami.Units.gridUnit * 25
    Layout.maximumWidth: Kirigami.Units.gridUnit * 25
    Layout.minimumHeight: Kirigami.Units.gridUnit * 25
    Layout.maximumHeight: Kirigami.Units.gridUnit * 25
    property string cavaVersion: ""

    ColumnLayout {
        id: content
        PlasmaExtras.Heading {
            Layout.fillWidth: true
            text: Plasmoid.metaData.name
            wrapMode: Text.Wrap
            horizontalAlignment: TextEdit.AlignHCenter
        }
        PlasmaComponents.Label {
            Layout.leftMargin: Kirigami.Units.gridUnit
            Layout.rightMargin: Kirigami.Units.gridUnit
            Layout.fillWidth: true
            text: i18n("Oh no! Something went wrong")
            wrapMode: Text.Wrap
            horizontalAlignment: TextEdit.AlignHCenter
            visible: cava.hasError
            font.bold: true
            color: Kirigami.Theme.negativeTextColor
        }
        PlasmaComponents.Button {
            text: cava.running ? i18n("Stop CAVA") : i18n("Start CAVA")
            onClicked: {
                if (cava.running) {
                    cava.stop();
                } else {
                    cava.start();
                }
            }
            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaComponents.ToolButton {
            id: copyButton
            display: PlasmaComponents.AbstractButton.TextBesideIcon
            text: i18n("Copy to clipboard")
            icon.name: "edit-copy"
            onClicked: {
                textArea.selectAll();
                textArea.copy();
                textArea.deselect();
            }
            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea {
                id: textArea
                text: {
                    let msg = "";
                    if (cava.error) {
                        msg += `Error: ${cava.error}\n`;
                    }
                    if (!cava.running && cava.loadingFailed) {
                        msg += `Error: ${cava.loadingErrors.join('\n')}\n`;
                    }
                    if (cava.running) {
                        msg += `CAVA is running\n`;
                    } else {
                        msg += `❌ CAVA is not running\n`;
                    }
                    msg += `Widget version: ${Plasmoid.metaData.version}\n`;
                    if (root.cavaVersion) {
                        msg += `CAVA version: ${root.cavaVersion}\n`;
                    } else {
                        msg += `❌ CAVA not found\n`;
                    }
                    msg += `Using ProcessMonitorFallback: ${cava.usingFallback}\n`;
                    msg += `Widget install location: ${Qt.resolvedUrl("../../").toString().substring(7)}\n`;
                    msg += `\nCava command:\n${cava.cavaCommand}\n`;
                    return msg;
                }
                // HACK: silence binding loop warnings.
                // contentWidth seems to be causing the binding loop,
                // but contentWidth is read-only and we have no control
                // over how it is calculated.
                implicitWidth: 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: Text.Wrap
                readOnly: true
                selectByMouse: true
            }
        }
    }
    RunCommand {
        id: cavaVersion
        onExited: (cmd, exitCode, exitStatus, stdout, stderr) => {
            if (exitCode !== 0) {
                root.cavaVersion = "";
                return;
            }
            root.cavaVersion = stdout.trim().split(" ").pop();
        }
    }
    Component.onCompleted: cavaVersion.run("cava -v")
    Timer {
        interval: 1000
        onTriggered: {
            if (root.visible) {
                cavaVersion.run("cava -v");
            }
        }
        running: root.visible
        repeat: true
        triggeredOnStart: true
    }
}
