import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {

    property int preferredTextWidth: Kirigami.Units.gridUnit * 20

    implicitWidth: mainLayout.implicitWidth + Kirigami.Units.gridUnit
    implicitHeight: mainLayout.implicitHeight + Kirigami.Units.gridUnit

    ColumnLayout {
        id: mainLayout

        anchors {
            centerIn: parent
        }
        spacing: 0

        PlasmaExtras.Heading {
            id: label
            Layout.fillWidth: true
            level: 3
            text: Plasmoid.metaData.name
        }

        Label {
            text: Plasmoid.metaData.description
            Layout.fillWidth: true
            wrapMode: Label.Wrap
        }
    }
}
