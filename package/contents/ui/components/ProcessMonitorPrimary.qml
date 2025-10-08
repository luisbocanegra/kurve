import QtQuick
import com.github.luisbocanegra.audiovisualizer.process
import org.kde.plasma.plasmoid
import "../"

Item {
    id: root
    property string command: ""
    readonly property string stdout: process.stdout
    readonly property string stderr: process.stderr
    readonly property bool running: process.running
    property var logger: Logger.create(Plasmoid.configuration.debugMode ? LoggingCategory.Debug : LoggingCategory.Info)

    function restart() {
        logger.debug("ProcessMonitorPrimary.restart()");
        process.restart();
    }
    // the plugin keeps a single process so no special handling is needed here
    // this function is here just to match the signature of the fallback
    function start() {
        logger.debug("ProcessMonitorPrimary.start()");
        restart();
    }
    function stop() {
        logger.debug("ProcessMonitorPrimary.stop()");
        process.stop();
    }
    Process {
        id: process
    }

    onCommandChanged: {
        if (command == "")
            return;
        process.command = ["sh", "-c", `${command}`];
        logger.debug("ProcessMonitorPrimary.onCommandChanged:", command);
    }
}
