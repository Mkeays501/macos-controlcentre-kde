// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
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
    background: Card {
        id: surface
        radius: control.circular ? width / 2 : height / 2
        opacity: control.down ? 0.7 : 1
        Rectangle {
            anchors.fill: parent
            radius: surface.radius
            color: control.active ? control.activeColor : "#ffffff"
            opacity: control.active ? 0.95 : (control.hovered ? 0.12 : 0)
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: Math.max(0, surface.radius - 3)
            color: "transparent"
            border.color: control.visualFocus ? "white" : "transparent"
            border.width: 2
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
            Text {
                width: parent.width
                text: control.text
                color: "#f5fcff"
                font.pixelSize: 15 * root.scale
                font.weight: Font.DemiBold
                elide: Text.ElideRight
                maximumLineCount: 1
                clip: true
            }
            Text {
                width: parent.width
                visible: text.length > 0
                text: control.subtitle.replace(/\n/g, " · ")
                color: "#d3ebf6"
                font.pixelSize: 12 * root.scale
                elide: Text.ElideRight
                maximumLineCount: 1
                clip: true
            }
        }
    }
}
