// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Card {
    id: button
    signal clicked()
    property string title: ""
    default property alias content: icon.data
    radius: Math.min(width, height) / 2
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
