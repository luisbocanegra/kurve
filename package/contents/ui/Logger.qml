pragma Singleton
import QtQuick

QtObject {
    id: root
    property int logLevel: LoggingCategory.Info
    readonly property string name: "luisbocanegra.audio.visualizer"
    readonly property LoggingCategory loggingCategory: {
        let cat;
        switch (logLevel) {
        case LoggingCategory.Info:
            cat = infoCategory;
            break;
        case LoggingCategory.Warning:
            cat = warningCategory;
            break;
        case LoggingCategory.Critical:
            cat = errorCategory;
            break;
        default:
            cat = debugCategory;
        }
        return cat;
    }

    readonly property LoggingCategory debugCategory: LoggingCategory {
        name: root.name
        defaultLogLevel: LoggingCategory.Debug
    }
    readonly property LoggingCategory infoCategory: LoggingCategory {
        name: root.name
        defaultLogLevel: LoggingCategory.Info
    }
    readonly property LoggingCategory warningCategory: LoggingCategory {
        name: root.name
        defaultLogLevel: LoggingCategory.Warning
    }
    readonly property LoggingCategory errorCategory: LoggingCategory {
        name: root.name
        defaultLogLevel: LoggingCategory.Critical
    }

    function _fmt(arg) {
        if (arg === null)
            return "null";
        if (arg === undefined)
            return "undefined";
        if (typeof arg === "object") {
            try {
                return JSON.stringify(arg);
            } catch (e) {
                return String(arg);
            }
        }
        return String(arg);
    }

    function _joinMessage(arr) {
        return Array.prototype.map.call(arr, _fmt).join(" ");
    }

    function debug(...message) {
        console.debug(loggingCategory, `[DEBUG]: ${_joinMessage(message)}`);
    }

    function info(...message) {
        console.info(loggingCategory, `[INFO]: ${_joinMessage(message)}`);
    }

    function warn(...message) {
        console.warn(loggingCategory, `[WARNING]: ${_joinMessage(message)}`);
    }

    function error(...message) {
        console.error(loggingCategory, `[ERROR]: ${_joinMessage(message)}`);
    }

    function create(logLevel) {
        if (logLevel != undefined && logLevel !== null) {
            root.logLevel = logLevel;
        }
        return this;
    }
}
