// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass CardButton — Circular glass with specular highlights
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Card {
    id: button
    signal clicked()
    property string title: ""
    default property alias content: icon.data
    radius: Math.min(width, height) / 2

    // Override Card's default appearance for circular buttons
    color: root.enableTransparency ? "#3a2a4a99" : "#1e2d3d"
    border.width: 1.5 * root.scale
    border.color: root.enableTransparency ? "#5aaacccc" : "#3a5a7a"
    gradient: Gradient {
        GradientStop { position: 0; color: root.enableTransparency ? "#5a4a7ac" : "#3a5a6a" }
        GradientStop { position: 0.35; color: root.enableTransparency ? "#4a3a6a99" : "#2a4a5a" }
        GradientStop { position: 0.65; color: root.enableTransparency ? "#3a2a5a88" : "#223a4a" }
        GradientStop { position: 1; color: root.enableTransparency ? "#2a1a4a77" : "#1a2a3a" }
    }

    // Top specular highlight
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Math.max(1, 0.22 * parent.height)
        radius: button.radius
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? "#ffffff44" : "#ffffff22" }
            GradientStop { position: 0.4; color: root.enableTransparency ? "#ffffff1a" : "#ffffff0c" }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Inner border
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2 * root.scale
        radius: Math.max(0, button.radius - 2 * root.scale)
        color: "transparent"
        border.width: 1 * root.scale
        border.color: root.enableTransparency ? "#ffffff33" : "#ffffff15"
    }

    Item {
        id: icon
        anchors.centerIn: parent
        width: 30 * root.scale
        height: width
    }

    AbstractButton {
        anchors.fill: parent
        text: button.title
        Accessible.name: text
        hoverEnabled: true
        background: Rectangle {
            color: "white"
            radius: button.radius
            opacity: parent.down ? 0.20 : parent.hovered ? 0.10 : 0
            border.color: parent.visualFocus ? "white" : "transparent"
        }
        ToolTip.visible: hovered
        ToolTip.text: text
        onClicked: button.clicked()
    }
}