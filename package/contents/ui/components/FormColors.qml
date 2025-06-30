import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    // required to align with parent form
    property alias formLayout: root
    property bool isSection: true
    property string sectionName
    // wether read from the string or existing config object
    property bool handleString
    // internal config objects to be sent, both string and json
    property string configString: "{}"
    property var config: handleString ? JSON.parse(configString) : undefined
    // to hide options that make no sense
    property var followOptions: {
        "panel": false,
        "widget": false,
        "tray": false
    }
    property bool showFollowPanel: followOptions.panel
    property bool showFollowWidget: followOptions.widget
    property bool showFollowTray: followOptions.tray
    property bool showFollowRadio: showFollowPanel || showFollowWidget || showFollowTray
    // wether or not show these options
    property bool multiColor: true
    property bool supportsGradient: false
    property bool supportsImage: false

    signal updateConfigString(string configString, var config)

    function updateConfig() {
        updateConfigString(configString, config);
    }

    twinFormLayouts: parentLayout
    Layout.fillWidth: true

    ListModel {
        id: themeColorSetModel

        ListElement {
            value: "View"
            displayName: "View"
        }

        ListElement {
            value: "Window"
            displayName: "Window"
        }

        ListElement {
            value: "Button"
            displayName: "Button"
        }

        ListElement {
            value: "Selection"
            displayName: "Selection"
        }

        ListElement {
            value: "Tooltip"
            displayName: "Tooltip"
        }

        ListElement {
            value: "Complementary"
            displayName: "Complementary"
        }

        ListElement {
            value: "Header"
            displayName: "Header"
        }
    }

    ListModel {
        id: themeColorModel

        ListElement {
            value: "textColor"
            displayName: "Text Color"
        }

        ListElement {
            value: "disabledTextColor"
            displayName: "Disabled Text Color"
        }

        ListElement {
            value: "highlightedTextColor"
            displayName: "Highlighted Text Color"
        }

        ListElement {
            value: "activeTextColor"
            displayName: "Active Text Color"
        }

        ListElement {
            value: "linkColor"
            displayName: "Link Color"
        }

        ListElement {
            value: "visitedLinkColor"
            displayName: "Visited LinkColor"
        }

        ListElement {
            value: "negativeTextColor"
            displayName: "Negative Text Color"
        }

        ListElement {
            value: "neutralTextColor"
            displayName: "Neutral Text Color"
        }

        ListElement {
            value: "positiveTextColor"
            displayName: "Positive Text Color"
        }

        ListElement {
            value: "backgroundColor"
            displayName: "Background Color"
        }

        ListElement {
            value: "highlightColor"
            displayName: "Highlight Color"
        }

        ListElement {
            value: "activeBackgroundColor"
            displayName: "Active Background Color"
        }

        ListElement {
            value: "linkBackgroundColor"
            displayName: "Link Background Color"
        }

        ListElement {
            value: "visitedLinkBackgroundColor"
            displayName: "Visited Link Background Color"
        }

        ListElement {
            value: "negativeBackgroundColor"
            displayName: "Negative Background Color"
        }

        ListElement {
            value: "neutralBackgroundColor"
            displayName: "Neutral Background Color"
        }

        ListElement {
            value: "positiveBackgroundColor"
            displayName: "Positive Background Color"
        }

        ListElement {
            value: "alternateBackgroundColor"
            displayName: "Alternate Background Color"
        }

        ListElement {
            value: "focusColor"
            displayName: "Focus Color"
        }

        ListElement {
            value: "hoverColor"
            displayName: "Hover Color"
        }
    }

    Item {
        Kirigami.FormData.isSection: root.isSection
        Kirigami.FormData.label: root.sectionName || i18n("Color")
        Layout.fillWidth: true
    }

    CheckBox {
        id: animationCheckbox

        Kirigami.FormData.label: i18n("Animation:")
        checked: root.config.animation.enabled
        onCheckedChanged: {
            root.config.animation.enabled = checked;
            root.updateConfig();
            // ensure valid option is checked as single and accent are
            // disabled in animated mode
            if (checked && (root.config.sourceType <= 1 || root.config.sourceType >= 4))
                listColorRadio.checked = true;
        }
        visible: false
    }

    SpinBox {
        id: animationInterval

        Kirigami.FormData.label: i18n("Interval (ms):")
        from: 0
        to: 30000
        stepSize: 100
        value: root.config.animation.interval
        onValueModified: {
            root.config.animation.interval = value;
            root.updateConfig();
        }
        enabled: animationCheckbox.checked
        visible: false
    }

    SpinBox {
        id: animationTransition

        Kirigami.FormData.label: i18n("Smoothing (ms):")
        from: 0
        to: animationInterval.value
        stepSize: 100
        value: root.config.animation.smoothing
        onValueModified: {
            root.config.animation.smoothing = value;
            root.updateConfig();
        }
        enabled: animationCheckbox.checked
        visible: false
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Color source:")
        RadioButton {
            id: singleColorRadio

            property int index: 0

            text: i18n("Custom")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
            enabled: !animationCheckbox.checked
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("A fixed custom color")
        }
    }

    RowLayout {
        RadioButton {
            id: accentColorRadio

            property int index: 1

            text: i18n("System")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
            enabled: !animationCheckbox.checked
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Color that updates with your System theme")
        }
    }

    RowLayout {
        visible: root.multiColor
        RadioButton {
            id: listColorRadio

            property int index: 2

            text: i18n("Custom list")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Define a list of colors that will be applied to all the elements, wraps around if there are more elements than colors")
        }
    }

    RowLayout {
        RadioButton {
            id: randomColorRadio

            property int index: 3

            text: i18n("Random")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Random color for each element")
        }
    }

    RowLayout {
        visible: root.showFollowRadio
        RadioButton {
            id: followColorRadio

            property int index: 4

            text: i18n("Follow")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
            enabled: !animationCheckbox.checked
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Follow the color of a parent element")
        }
    }

    RowLayout {
        visible: root.supportsGradient
        RadioButton {
            id: gradientRadio
            property int index: 5
            text: i18n("Gradient")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Horizontal or vertical customizable color gradient")
        }
    }

    RowLayout {
        visible: root.supportsImage
        RadioButton {
            id: imageRadio
            property int index: 6
            text: i18n("Image")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("High resolution images can slow down the desktop when the panel or widget size changes!")
        }
    }

    RowLayout {
        RadioButton {
            id: hueRadio
            property int index: 7
            text: i18n("Hue")
            ButtonGroup.group: colorModeGroup
            checked: root.config.sourceType === index
        }
        Kirigami.ContextualHelpButton {
            toolTipText: i18n("Automatically shifted color for each bar")
        }
    }

    ButtonGroup {
        id: colorModeGroup

        onCheckedButtonChanged: {
            if (checkedButton) {
                root.config.sourceType = checkedButton.index;
                root.updateConfig();
            }
        }
    }
    // >

    RadioButton {
        id: followPanelBgRadio

        property int index: 0

        Kirigami.FormData.label: i18n("Element:")
        text: i18n("Panel background")
        ButtonGroup.group: followColorGroup
        checked: root.config.followColor === index
        visible: followColorRadio.checked && root.showFollowPanel
    }

    RadioButton {
        id: followWidgetBgRadio

        property int index: 1

        text: i18n("Widget background")
        ButtonGroup.group: followColorGroup
        checked: root.config.followColor === index
        visible: followColorRadio.checked && root.showFollowWidget
    }

    RadioButton {
        id: followTrayWidgetBgRadio

        property int index: 2

        text: i18n("Tray widget background")
        ButtonGroup.group: followColorGroup
        checked: root.config.followColor === index
        visible: followColorRadio.checked && root.showFollowTray
    }

    ButtonGroup {
        id: followColorGroup

        onCheckedButtonChanged: {
            if (checkedButton) {
                root.config.followColor = checkedButton.index;
                root.updateConfig();
            }
        }
    }

    ComboBox {
        id: imageFillMode
        Kirigami.FormData.label: i18n("Positioning:")
        visible: root.supportsImage && imageRadio.checked
        model: [
            {
                'label': i18n("Stretch"),
                'fillMode': AnimatedImage.Stretch
            },
            {
                'label': i18n("Tile"),
                'fillMode': AnimatedImage.Tile
            },
            {
                'label': i18n("Scaled and Cropped"),
                'fillMode': AnimatedImage.PreserveAspectCrop
            }
        ]
        textRole: "label"
        valueRole: "fillMode"
        onActivated: {
            root.config.image.fillMode = currentValue;
            root.updateConfig();
        }
        currentIndex: indexOfValue(root.config.image.fillMode)
    }

    RowLayout {
        visible: root.supportsImage && imageRadio.checked
        Kirigami.FormData.label: i18n("Image:")
        TextField {
            id: imgTextArea
            Layout.preferredWidth: 300
            text: root.config.image.source
            onTextChanged: {
                if (root.config.image.source !== text) {
                    root.config.image.source = text;
                    root.updateConfig();
                }
            }
        }
        Button {
            icon.name: "insert-image-symbolic"
            onClicked: fileDialog.open()
        }
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFile
        title: i18n("Pick a image file")
        nameFilters: [i18n("Image files") + " (*.png *.jpg *.jpeg *.gif *.webp *.bmp *.svg)", i18n("All files") + " (*)"]
        onAccepted: {
            if (fileDialog.selectedFile) {
                console.log(fileDialog.selectedFile);
                imgTextArea.text = fileDialog.selectedFile;
            }
        }
    }

    ColorButton {
        id: customColorBtn
        Kirigami.FormData.label: i18n("Color:")
        color: root.config.custom
        visible: singleColorRadio.checked
        onAccepted: color => {
            root.config.custom = color.toString();
            root.updateConfig();
        }
    }

    ComboBox {
        id: colorSetCombobx

        Kirigami.FormData.label: i18n("Color set:")
        model: themeColorSetModel
        textRole: "displayName"
        visible: accentColorRadio.checked
        onCurrentIndexChanged: {
            root.config.systemColorSet = themeColorSetModel.get(currentIndex).value;
            root.updateConfig();
        }

        Binding {
            target: colorSetCombobx
            property: "currentIndex"
            value: {
                for (var i = 0; i < themeColorSetModel.count; i++) {
                    if (themeColorSetModel.get(i).value === root.config.systemColorSet)
                        return i;
                }
                return 0; // Default to the first item if no match is found
            }
        }
    }

    ComboBox {
        id: colorThemeCombobx

        Kirigami.FormData.label: i18n("Color:")
        model: themeColorModel
        textRole: "displayName"
        visible: accentColorRadio.checked
        onCurrentIndexChanged: {
            root.config.systemColor = themeColorModel.get(currentIndex).value;
            root.updateConfig();
        }

        Binding {
            target: colorThemeCombobx
            property: "currentIndex"
            value: {
                for (var i = 0; i < themeColorModel.count; i++) {
                    if (themeColorModel.get(i).value === root.config.systemColor)
                        return i;
                }
                return 0; // Default to the first item if no match is found
            }
        }
    }

    ColumnLayout {
        visible: root.multiColor && listColorRadio.checked
        Kirigami.FormData.label: i18n("Colors:")

        Loader {
            asynchronous: true
            sourceComponent: listColorRadio.checked ? pickerList : null
            onLoaded: {
                item.colorsList = root.config.list;
                item.onColorsChanged.connect(colorsList => {
                    root.config.list = colorsList;
                    root.updateConfig();
                });
            }
        }

        Component {
            id: pickerList

            ColorPickerList {}
        }
    }

    RadioButton {
        id: gradientHorizontalRadio
        Kirigami.FormData.label: i18n("Orientation:")
        property int index: 0
        text: i18n("Horizontal")
        ButtonGroup.group: gradientOrientationBtnGroup
        checked: root.config.colorsOrientation === index
        visible: root.config.sourceType > 1
    }

    RadioButton {
        id: gradientVerticalRadio
        property int index: 1
        text: i18n("Vertical")
        ButtonGroup.group: gradientOrientationBtnGroup
        checked: root.config.colorsOrientation === index
        visible: root.config.sourceType > 1
    }

    ButtonGroup {
        id: gradientOrientationBtnGroup

        onCheckedButtonChanged: {
            if (checkedButton) {
                root.config.colorsOrientation = checkedButton.index;
                root.updateConfig();
            }
        }
    }

    CheckBox {
        Kirigami.FormData.label: i18n("Gradient:")
        checked: root.config.smoothGradient
        onCheckedChanged: {
            root.config.smoothGradient = checked;
            root.updateConfig();
        }
        visible: root.config.sourceType > 1
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Alpha:")
        visible: colorModeGroup.checkedButton.index !== 6

        DoubleSpinBox {
            id: alphaSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.alpha ?? 0) * multiplier
            onValueModified: {
                root.config.alpha = value / alphaSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }

    Kirigami.Separator {
        Kirigami.FormData.isSection: false
        Kirigami.FormData.label: i18n("Contrast Correction")
        Layout.fillWidth: true
        visible: colorModeGroup.checkedButton.index !== 6
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Saturation:")
        visible: colorModeGroup.checkedButton.index !== 6

        CheckBox {
            id: saturationEnabled

            checked: root.config.saturationEnabled
            onCheckedChanged: {
                root.config.saturationEnabled = checked;
                root.updateConfig();
            }
        }

        DoubleSpinBox {
            id: saturationSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.saturationValue ?? 0) * multiplier
            onValueModified: {
                root.config.saturationValue = value / saturationSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Lightness:")
        visible: colorModeGroup.checkedButton.index !== 6

        CheckBox {
            id: lightnessEnabled

            checked: root.config.lightnessEnabled
            onCheckedChanged: {
                root.config.lightnessEnabled = checked;
                root.updateConfig();
            }
        }

        DoubleSpinBox {
            id: lightnessSpinbox
            from: 0 * multiplier
            to: 1 * multiplier
            value: (root.config.lightnessValue ?? 0) * multiplier
            onValueModified: {
                root.config.lightnessValue = value / lightnessSpinbox.multiplier;
                root.updateConfig();
            }
        }
    }
}
