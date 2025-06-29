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
    Layout.preferredHeight: content.implicitHeight
    Layout.minimumHeight: Layout.preferredHeight
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
            visible: main.hasError
            font.bold: true
            color: Kirigami.Theme.negativeTextColor
        }
        PlasmaComponents.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea {
                text: {
                    let msg = "";
                    if (main.error) {
                        msg += `Error: ${main.error}\n`;
                    }
                    msg += `Widget version: ${Plasmoid.metaData.version}\n`;
                    if (root.cavaVersion) {
                        msg += `Cava version: ${root.cavaVersion}\n`;
                    } else {
                        msg += `❌ Cava not found\n`;
                    }
                    msg += `Using ProcessMonitorFallback: ${cava.usingFallback}\n`;
                    msg += `Widget install location: ${Qt.resolvedUrl("../../").toString().substring(7)}\n`;
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
                return;
            }
            root.cavaVersion = stdout.trim().split(" ").pop();
        }
    }
    Component.onCompleted: cavaVersion.run("cava -v")
}
