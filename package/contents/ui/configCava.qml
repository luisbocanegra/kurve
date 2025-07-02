import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "./components"

KCM.SimpleKCM {
    id: root
    // general
    property alias cfg_barCount: barCountSpinbox.value
    property alias cfg_framerate: framerateSpinbox.value
    property alias cfg_autoSensitivity: autoSensitivityCheckbox.checked
    property alias cfg_sensitivity: sensitivitySpinbox.value
    property alias cfg_lowerCutoffFreq: lowerCutoffFreqSpinbox.value
    property alias cfg_higherCutoffFreq: higherCutoffFreqSpinbox.value
    // smoothing
    property alias cfg_noiseReduction: noiseReductionSpinbox.value
    property alias cfg_monstercat: monstercatCheckbox.checked
    property alias cfg_waves: wavesCheckbox.checked
    // input
    property string cfg_inputMethod
    property alias cfg_inputSource: inputSourceField.text
    property int cfg_visualizerStyle
    property string cfg_barColors
    property string cfg_waveFillColors

    PactlList {
        id: pactl
    }

    ColumnLayout {
        Kirigami.FormLayout {
            id: parentLayout
            Layout.fillWidth: true

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("General")
            }

            SpinBox {
                id: framerateSpinbox
                Kirigami.FormData.label: i18n("Framerate:")
                from: 1
                to: 144
            }

            SpinBox {
                id: barCountSpinbox
                Kirigami.FormData.label: i18n("Number of bars:")
                from: 1
                to: 512
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Automatic sensitivity:")
                CheckBox {
                    id: autoSensitivityCheckbox
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Attempt to decrease sensitivity if the bars peak.")
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Sensitivity:")
                SpinBox {
                    id: sensitivitySpinbox
                    from: 1
                    to: 999
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Manual sensitivity in %.\nIf autosens is enabled, this will only be the initial value")
                }
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Frequency range (Hz):")

                Label {
                    text: i18n("Min")
                }
                SpinBox {
                    id: lowerCutoffFreqSpinbox
                    from: 20
                    to: 22000
                    stepSize: 100
                }

                Label {
                    text: i18n("Max")
                }

                SpinBox {
                    id: higherCutoffFreqSpinbox
                    from: 1
                    to: 22000
                    stepSize: 100
                }

                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Lower and higher cutoff frequencies for lowest and highest bars, the bandwidth of the visualizer.\nNote: Cava will automatically increase the higher cutoff if a too low band is specified.")
                }
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Audio Input")
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Method:")
                Layout.preferredWidth: 300
                ComboBox {
                    id: inputMethodCombobox
                    textRole: "label"
                    valueRole: "value"
                    Layout.fillWidth: true
                    model: [
                        {
                            label: i18n("Default"),
                            value: ""
                        },
                        {
                            label: "OSS",
                            value: "oss"
                        },
                        {
                            label: "PipeWire",
                            value: "pipewire"
                        },
                        {
                            label: "Sndio",
                            value: "sndio"
                        },
                        {
                            label: "JACK",
                            value: "jack"
                        },
                        {
                            label: "PulseAudio",
                            value: "pulse"
                        },
                        {
                            label: "ALSA",
                            value: "alsa"
                        },
                        {
                            label: "PortAudio",
                            value: "portaudio"
                        },
                        {
                            label: "FIFO",
                            value: "fifo"
                        },
                        {
                            label: "shmem",
                            value: "shmem"
                        },
                    ]
                    onActivated: {
                        root.cfg_inputMethod = currentValue;
                        if (!["pipewire", "pulse"].includes(root.cfg_inputMethod)) {
                            sourcesCard.visible = false;
                            root.cfg_inputSource = "";
                        }
                    }
                    Component.onCompleted: currentIndex = indexOfValue(root.cfg_inputMethod)
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Audio capturing method.\nDefaults to 'oss', 'pipewire', 'sndio', 'jack', 'pulse', 'alsa', 'portaudio' or 'fifo', in that order, dependent on what support cava was built with.\n")
                }
            }
            RowLayout {
                Kirigami.FormData.label: i18n("Source:")
                Layout.preferredWidth: 300
                TextField {
                    id: inputSourceField
                    Layout.fillWidth: true
                    placeholderText: "auto"
                }
                Button {
                    visible: ["pipewire", "pulse"].includes(root.cfg_inputMethod)
                    icon.name: sourcesCard.visible ? "arrow-up" : "arrow-down"
                    onClicked: {
                        sourcesCard.visible = !sourcesCard.visible;
                    }
                    checkable: true
                    checked: sourcesCard.visible
                }
                ToolButton {
                    onCheckedChanged: inputSourceHelpCard.visible = !inputSourceHelpCard.visible
                    checkable: true
                    icon.name: "help"
                }
            }
            Kirigami.AbstractCard {
                id: sourcesCard
                implicitHeight: 200
                visible: false
                Layout.fillWidth: true
                contentItem: ScrollView {
                    clip: true
                    ListView {
                        model: pactl.names
                        delegate: ItemDelegate {
                            id: delegate
                            required property string modelData
                            // required property Item root
                            width: ListView.view.width
                            text: modelData
                            contentItem: Label {
                                text: delegate.text
                                wrapMode: Label.WrapAnywhere
                                Layout.fillWidth: true
                                font: Kirigami.Theme.smallFont
                            }
                            ToolTip.visible: false
                            onClicked: root.cfg_inputSource = modelData
                        }
                    }
                }
            }
        }
        Kirigami.AbstractCard {
            id: inputSourceHelpCard
            spacing: 0
            visible: false
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: Kirigami.Units.largeSpacing
                Kirigami.SelectableLabel {
                    text: i18n("For pulseaudio and pipewire 'source' will be the source. Default: 'auto', which uses the monitor source of the default sink (all pulseaudio sinks(outputs) have 'monitor' sources(inputs) associated with them).")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For pipewire 'source' will be the object name or object.serial of the device to capture from. Both input and output devices are supported.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For alsa 'source' will be the capture device.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For fifo 'source' will be the path to fifo-file.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For shmem 'source' will be /squeezelite-AA:BB:CC:DD:EE:FF where 'AA:BB:CC:DD:EE:FF' will be squeezelite's MAC address.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For sndio 'source' will be a raw recording audio descriptor or a monitoring sub-device, e.g. 'rsnd/2' or 'snd/1'. Default: 'default'.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For oss 'source' will be the path to a audio device, e.g. '/dev/dsp2'. Default: '/dev/dsp', i.e. the default audio device.")
                    Layout.fillWidth: true
                }
                Kirigami.SelectableLabel {
                    text: i18n("For jack 'source' will be the name of the JACK server to connect to, e.g. 'foobar'. Default: 'default'.")
                    Layout.fillWidth: true
                }
            }
        }

        Kirigami.FormLayout {

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Smoothing")
            }

            RowLayout {
                Kirigami.FormData.label: i18n("Noise reduction:")
                SpinBox {
                    id: noiseReductionSpinbox
                    from: 0
                    to: 100
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("The raw visualization is very noisy, this factor adjusts the integral and gravity filters to keep the signal smooth.\n100 will be very slow and smooth, 0 will be fast but noisy.")
                }
            }
            RowLayout {
                Kirigami.FormData.label: i18n("Monstercat:")
                CheckBox {
                    id: monstercatCheckbox
                }
                Kirigami.ContextualHelpButton {
                    toolTipText: i18n("Enable the so-called \"Monstercat smoothing\" with or without \"waves\".")
                }
            }

            CheckBox {
                id: wavesCheckbox
                text: i18n("Waves")
                enabled: monstercatCheckbox.checked
            }
        }
    }
}
