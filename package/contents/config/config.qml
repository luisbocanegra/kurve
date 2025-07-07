import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Visualizer")
        icon: "waveform-symbolic"
        source: "configVisualizer.qml"
    }
    ConfigCategory {
        name: "CAVA"
        icon: "view-process-system-symbolic"
        source: "configCava.qml"
    }
    ConfigCategory {
        name: i18n("General")
        icon: "configure-symbolic"
        source: "configGeneral.qml"
    }
}
