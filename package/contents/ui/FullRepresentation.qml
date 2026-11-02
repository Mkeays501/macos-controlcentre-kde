import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import "components" as Components

Item {
    id: fullRep
    Layout.preferredWidth: root.fullRepWidth
    Layout.preferredHeight: root.fullRepHeight
    Layout.minimumWidth: root.fullRepWidth
    Layout.maximumWidth: root.fullRepWidth
    Layout.minimumHeight: root.fullRepHeight
    Layout.maximumHeight: root.fullRepHeight
    clip: true

    // Nearly-black translucent macOS-inspired surface.
    Rectangle {
        anchors.fill: parent
        radius: 24 * root.scale
        color: "#e5222530"
        border.color: "#45ffffff"
        border.width: 1
    }

    // Network connections overlay from the original widget.
    Components.SectionNetworks {
        id: sectionNetworks
        anchors.fill: parent
        z: 20
    }

    ColumnLayout {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 16 * root.scale
        spacing: 12 * root.scale

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 26 * root.scale
            PlasmaComponents.Label {
                text: "Control Center"
                color: "#f6f7fb"
                font.pixelSize: 18 * root.scale
                font.bold: true
                Layout.fillWidth: true
            }
            PlasmaComponents.Label {
                text: "●  ●  ●"
                color: "#a3a9ba"
                font.pixelSize: 11 * root.scale
            }
        }

        RowLayout {
            id: sectionA
            Layout.fillWidth: true
            Layout.preferredHeight: root.sectionHeight
            spacing: 10 * root.scale

            // Three existing functional toggles, restyled by lib/Card.qml.
            Components.SectionButtons {
                Layout.preferredWidth: (wrapper.width - 10 * root.scale) * 0.60
                Layout.fillWidth: false
                Layout.fillHeight: true
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8 * root.scale
                Components.DndButton {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: 1
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8 * root.scale
                    Components.KDEConnect {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Components.ColorSchemeSwitcher {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
                RowLayout {
                    visible: root.showCmd1 || root.showCmd2
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8 * root.scale
                    Components.CommandRun {
                        visible: root.showCmd1
                        title: root.cmdTitle1
                        icon: root.cmdIcon1
                        command: root.cmdRun1
                        Layout.fillWidth: true
                    }
                    Components.CommandRun {
                        visible: root.showCmd2
                        title: root.cmdTitle2
                        icon: root.cmdIcon2
                        command: root.cmdRun2
                        Layout.fillWidth: true
                    }
                }
            }
        }

        // macOS-style stacked large controls. Their native sliders remain functional.
        Components.BrightnessSlider {
            Layout.fillWidth: true
            Layout.preferredHeight: 82 * root.scale
        }
        Components.Volume {
            Layout.fillWidth: true
            Layout.preferredHeight: 82 * root.scale
        }
        Components.MediaPlayer {
            Layout.fillWidth: true
            Layout.preferredHeight: 100 * root.scale
        }
        Item { Layout.fillHeight: true }
    }
}
