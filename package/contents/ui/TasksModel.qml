import QtQuick
import org.kde.taskmanager as TaskManager

Item {
    id: root

    property var screenGeometry
    property bool activeExists: false
    property bool maximizedExists: false
    property bool fullScreenExists: false
    property bool visibleExists: false
    property var abstractTasksModel: TaskManager.AbstractTasksModel
    property var isMaximized: abstractTasksModel.IsMaximized
    property var isActive: abstractTasksModel.IsActive
    property var isWindow: abstractTasksModel.IsWindow
    property var isFullScreen: abstractTasksModel.IsFullScreen
    property var isMinimized: abstractTasksModel.IsMinimized
    property bool filterByActive: false
    property bool filterByScreen: true
    property bool trackLastActive: false

    function getTopTask() {
        let highestTask = null;
        let maxStackingOrder = 0;
        for (var i = 0; i < tasksModel.count; i++) {
            const currentTask = tasksModel.index(i, 0);
            if (currentTask === undefined || !tasksModel.data(currentTask, isWindow))
                continue;

            const stakingOder = tasksModel.data(currentTask, abstractTasksModel.StackingOrder);
            if (stakingOder > maxStackingOrder) {
                maxStackingOrder = stakingOder;
                highestTask = currentTask;
            }
        }
        return highestTask;
    }

    function updateWindowsInfo() {
        let activeCount = 0;
        let visibleCount = 0;
        let maximizedCount = 0;
        let fullScreenCount = 0;
        for (var i = 0; i < tasksModel.count; i++) {
            const currentTask = tasksModel.index(i, 0);
            if (currentTask === undefined || !tasksModel.data(currentTask, isWindow))
                continue;

            if (filterByActive && !tasksModel.data(currentTask, isActive))
                continue;

            visibleCount += 1;
            if (tasksModel.data(currentTask, isMaximized))
                maximizedCount += 1;

            if (tasksModel.data(currentTask, isFullScreen))
                fullScreenCount += 1;
        }

        let _activeExists = tasksModel.data(tasksModel.activeTask, isActive) || false;
        let _activeTask = null;
        let _maximizedExists = maximizedCount > 0;
        let _fullScreenExists = fullScreenCount > 0;
        let _visibleExists = visibleCount > 0;
        if (filterByActive && _activeExists) {
            _activeTask = tasksModel.activeTask;
        }

        if (filterByActive && !_activeTask && trackLastActive) {
            _activeTask = getTopTask();
            _activeExists = Boolean(_activeTask);
        }

        if (_activeTask) {
            _maximizedExists = tasksModel.data(_activeTask, isMaximized) || false;
            _fullScreenExists = tasksModel.data(_activeTask, isFullScreen) || false;
            _visibleExists = _activeExists;
        }

        activeExists = _activeExists;
        fullScreenExists = _fullScreenExists;
        maximizedExists = _maximizedExists;
        visibleExists = _visibleExists;
    }

    Connections {
        function onValueChanged() {
            if (!updateTimer.running)
                updateTimer.start();
        }

        target: plasmoid.configuration
    }

    TaskManager.VirtualDesktopInfo {
        id: virtualDesktopInfo
    }

    TaskManager.ActivityInfo {
        id: activityInfo

        readonly property string nullUuid: "00000000-0000-0000-0000-000000000000"
    }

    TaskManager.TasksModel {
        id: tasksModel

        sortMode: TaskManager.TasksModel.SortVirtualDesktop
        groupMode: TaskManager.TasksModel.GroupDisabled
        virtualDesktop: virtualDesktopInfo.currentDesktop
        activity: activityInfo.currentActivity
        screenGeometry: root.screenGeometry
        filterByVirtualDesktop: true
        filterByScreen: root.filterByScreen
        filterByActivity: true
        filterMinimized: true
        onDataChanged: {
            Qt.callLater(() => {
                if (!updateTimer.running)
                    updateTimer.start();
            });
        }
        onCountChanged: {
            Qt.callLater(() => {
                if (!updateTimer.running)
                    updateTimer.start();
            });
        }
    }

    Timer {
        id: updateTimer

        interval: 5
        onTriggered: {
            root.updateWindowsInfo();
        }
    }
}
