// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
Rectangle {
    id: card
    property string prefix: ""
    property var margins: ({ top: 0, left: 0, right: 0, bottom: 0 })
    default property alias content: dataContainer.data
    radius: Math.min(28 * root.scale, height / 2)
    color: root.enableTransparency ? "#82354b64" : "#233e56"
    border.width: 1
    border.color: "#65d3f4ff"
    gradient: Gradient {
        GradientStop { position: 0; color: root.enableTransparency ? "#a026a5ba" : "#39596d" }
        GradientStop { position: 0.48; color: root.enableTransparency ? "#850474a5" : "#24475f" }
        GradientStop { position: 1; color: root.enableTransparency ? "#9b07569b" : "#203b56" }
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: Math.max(0, card.radius - 2)
        color: "transparent"
        border.color: "#18ffffff"
    }
    Item {
        id: dataContainer
        anchors.fill: parent
        anchors.topMargin: card.margins.top * root.scale
        anchors.leftMargin: card.margins.left * root.scale
        anchors.rightMargin: card.margins.right * root.scale
        anchors.bottomMargin: card.margins.bottom * root.scale
    }
}
