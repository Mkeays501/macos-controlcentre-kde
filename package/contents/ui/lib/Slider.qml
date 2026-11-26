// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass Slider — Glass track with dynamic fill
import QtQuick
import "Icons.js" as Icons
import QtQuick.Controls as QQC
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
Card {
    id: control
    signal moved()
    signal clicked()
    property alias title: title.text
    property alias secondaryTitle: percentage.text
    property alias value: slider.value
    property bool useIconButton: false
    property string source: ""
    property real from: 0
    property real to: 100

    // Override Card for slider-specific styling
    radius: Math.min(24 * root.scale, height / 2)
    color: root.enableTransparency ? "#3a2a4a80" : "#1e2d3d"
    border.width: 1 * root.scale
    border.color: root.enableTransparency ? "#5aaacccc" : "#3a5a7a"
    gradient: Gradient {
        GradientStop { position: 0; color: root.enableTransparency ? "#4a3a6a77" : "#2a4a5a" }
        GradientStop { position: 0.5; color: root.enableTransparency ? "#3a2a5a66" : "#223a4a" }
        GradientStop { position: 1; color: root.enableTransparency ? "#2a1a4a55" : "#1a2a3a" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 17 * root.scale
        spacing: 5 * root.scale
        RowLayout {
            Layout.fillWidth: true
            Text { id: title; color: "#f5fcff"; font.pixelSize: 15 * root.scale; font.weight: Font.DemiBold; Layout.fillWidth: true }
            Text { id: percentage; color: "#b8dfe8"; font.pixelSize: 12 * root.scale; visible: root.showPercentage }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 12 * root.scale
            QQC.AbstractButton {
                Layout.preferredWidth: 28 * root.scale
                Layout.preferredHeight: 36 * root.scale
                enabled: control.useIconButton
                Accessible.name: i18n("Mute or unmute sound")
                contentItem: Glyph { source: control.source; color: "#f5fcff" }
                onClicked: control.clicked()
            }
            QQC.Slider {
                id: slider
                Layout.fillWidth: true
                Layout.preferredHeight: 36 * root.scale
                from: control.from
                to: Math.max(control.from + 1, control.to)
                stepSize: 1
                Accessible.name: control.title
                onMoved: control.moved()
                background: Item {
                    // Glass track background
                    Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + (slider.availableHeight - height)/2
                        width: slider.availableWidth
                        height: 6 * root.scale
                        radius: height / 2
                        color: root.enableTransparency ? "#1a1a3a88" : "#102030"
                        border.width: 1 * root.scale
                        border.color: root.enableTransparency ? "#ffffff1a" : "#ffffff0a"

                        // Inner highlight on track top
                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            height: height / 2
                            radius: parent.radius
                            clip: true
                            gradient: Gradient {
                                GradientStop { position: 0; color: root.enableTransparency ? "#ffffff10" : "#ffffff05" }
                                GradientStop { position: 1; color: "transparent" }
                            }
                        }
                    }
                    // Filled portion (glass-like)
                    Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + (slider.availableHeight - height)/2
                        width: slider.visualPosition * slider.availableWidth
                        height: 6 * root.scale
                        radius: height / 2
                        color: "#ffffff"
                        opacity: 0.9
                        // Gradient on fill for glass depth
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#ffffff" }
                            GradientStop { position: 0.5; color: "#e8f4ff" }
                            GradientStop { position: 1; color: "#cce8ff" }
                        }
                        // Top highlight on fill
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 0.5 * root.scale
                            radius: parent.radius
                            clip: true
                            gradient: Gradient {
                                GradientStop { position: 0; color: "#ffffff99" }
                                GradientStop { position: 0.6; color: "#ffffff33" }
                                GradientStop { position: 1; color: "transparent" }
                            }
                        }
                    }
                }
                handle: Item {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + (slider.availableHeight - height)/2
                    width: 24 * root.scale
                    height: 24 * root.scale

                    // Glass handle with shadow
                    Rectangle {
                        anchors.centerIn: parent
                        width: 22 * root.scale
                        height: 22 * root.scale
                        radius: width / 2
                        color: "#ffffff"
                        border.width: 1 * root.scale
                        border.color: root.enableTransparency ? "#ffffff33" : "#ffffff15"

                        // Handle gradient
                        gradient: Gradient {
                            GradientStop { position: 0; color: "#ffffff" }
                            GradientStop { position: 0.5; color: "#f0f8ff" }
                            GradientStop { position: 1; color: "#d8e8f8" }
                        }

                        // Top specular on handle
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 1.5 * root.scale
                            radius: parent.radius
                            clip: true
                            gradient: Gradient {
                                GradientStop { position: 0; color: "#ffffffaa" }
                                GradientStop { position: 0.5; color: "#ffffff33" }
                                GradientStop { position: 1; color: "transparent" }
                            }
                        }

                        // Focus ring
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -3 * root.scale
                            radius: parent.radius + 3 * root.scale
                            color: "transparent"
                            border.width: 2 * root.scale
                            border.color: slider.visualFocus ? "#2489ff" : "transparent"
                            opacity: slider.visualFocus ? 0.9 : 0
                            Behavior on opacity { ColorAnimation { duration: 100 } }
                        }
                    }
                    // Subtle drop shadow under handle
                    Rectangle {
                        anchors.centerIn: parent
                        width: 22 * root.scale
                        height: 22 * root.scale
                        radius: width / 2
                        color: "#000000"
                        opacity: 0.15
                        y: 2 * root.scale
                        visible: !slider.pressed
                        layer.enabled: true
                        layer.effect: FastBlur { radius: 4 * root.scale }
                    }
                }
            }
            Glyph { source: control.source; Layout.preferredWidth: 21 * root.scale; Layout.preferredHeight: width }
        }
    }
}