// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass Button — Multi-layer with specular highlights
import QtQuick
import "Icons.js" as Icons
import QtQuick.Controls
import org.kde.kirigami as Kirigami
AbstractButton {
    id: control
    property string source: ""
    property string subtitle: ""
    property bool circular: false
    property bool active: false
    property color activeColor: "#ffffff"
    property bool showTitle: !circular
    hoverEnabled: true
    Accessible.name: text
    Accessible.description: subtitle
    ToolTip.visible: hovered
    ToolTip.text: text + (subtitle.length ? " — " + subtitle : "")

    background: Item {
        id: surface
        readonly property real r: control.circular ? width / 2 : height / 2
        readonly property real scale: root.scale

        // Base glass shape
        Rectangle {
            anchors.fill: parent
            radius: surface.r
            color: root.enableTransparency ? "#3a2a4a99" : "#1e2d3d"
            border.width: 1.5 * surface.scale
            border.color: control.active ? control.activeColor : (root.enableTransparency ? "#5aaacccc" : "#3a5a7a")

            // Gradient depth
            gradient: Gradient {
                GradientStop { position: 0; color: root.enableTransparency ? "#5a4a7ac" : "#3a5a6a" }
                GradientStop { position: 0.4; color: root.enableTransparency ? "#4a3a6a99" : "#2a4a5a" }
                GradientStop { position: 0.7; color: root.enableTransparency ? "#3a2a5a88" : "#223a4a" }
                GradientStop { position: 1; color: root.enableTransparency ? "#2a1a4a77" : "#1a2a3a" }
            }
        }

        // Top specular highlight (main glass reflection)
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: Math.max(1, 0.22 * parent.height)
            radius: surface.r
            clip: true
            gradient: Gradient {
                GradientStop { position: 0; color: root.enableTransparency ? "#ffffff44" : "#ffffff22" }
                GradientStop { position: 0.4; color: root.enableTransparency ? "#ffffff1a" : "#ffffff0c" }
                GradientStop { position: 1; color: "transparent" }
            }
        }

        // Left edge specular
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Math.max(1, 0.1 * parent.width)
            radius: surface.r
            clip: true
            gradient: Gradient {
                GradientStop { position: 0; color: root.enableTransparency ? "#ffffff2a" : "#ffffff12" }
                GradientStop { position: 1; color: "transparent" }
            }
        }

        // Inner border highlight
        Rectangle {
            anchors.fill: parent
            anchors.margins: 2 * surface.scale
            radius: Math.max(0, surface.r - 2 * surface.scale)
            color: "transparent"
            border.width: 1 * surface.scale
            border.color: root.enableTransparency ? "#ffffff33" : "#ffffff15"
        }

        // Active state overlay (colored glass)
        Rectangle {
            anchors.fill: parent
            radius: surface.r
            color: control.active ? control.activeColor : "transparent"
            opacity: control.active ? 0.35 : 0
            Behavior on opacity { ColorAnimation { duration: 150 } }
        }

        // Hover/press overlay
        Rectangle {
            anchors.fill: parent
            radius: surface.r
            color: control.down ? "#ffffff24" : (control.hovered ? "#ffffff10" : "transparent")
            Behavior on color { ColorAnimation { duration: 80 } }
        }

        // Focus ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2 * surface.scale
            radius: surface.r + 2 * surface.scale
            color: "transparent"
            border.width: 2 * surface.scale
            border.color: control.visualFocus ? "#2489ff" : "transparent"
            opacity: control.visualFocus ? 0.8 : 0
            Behavior on opacity { ColorAnimation { duration: 100 } }
        }
    }

    contentItem: Item {
        Glyph {
            id: glyph
            width: (control.circular ? 29 : 25) * root.scale
            height: width
            anchors.verticalCenter: parent.verticalCenter
            x: control.circular ? (parent.width - width)/2 : 18 * root.scale
            source: control.source
            active: control.active
        }
        Column {
            visible: control.showTitle
            anchors.left: glyph.right
            anchors.leftMargin: 10 * root.scale
            anchors.right: parent.right
            anchors.rightMargin: 10 * root.scale
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1 * root.scale
            Text {
                width: parent.width
                text: control.text
                color: "#f5fcff"
                font.pixelSize: 15 * root.scale
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                maximumLineCount: 1
                clip: true
                // Subtle text shadow for depth
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0
                    verticalOffset: 1 * root.scale
                    radius: 2 * root.scale
                    samples: 8
                    color: "#00000080"
                }
            }
            Text {
                width: parent.width
                visible: text.length > 0
                text: control.subtitle.replace(/\n/g, " · ")
                color: "#b8dfe8"
                font.pixelSize: 12 * root.scale
                elide: Text.ElideRight
                maximumLineCount: 1
                clip: true
            }
        }
    }
}