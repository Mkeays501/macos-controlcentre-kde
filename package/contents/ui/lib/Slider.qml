// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
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
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 17 * root.scale
        spacing: 5 * root.scale
        RowLayout {
            Layout.fillWidth: true
            Text { id: title; color: "#effaff"; font.pixelSize: 15 * root.scale; font.weight: Font.DemiBold; Layout.fillWidth: true }
            Text { id: percentage; color: "#d3ebf6"; font.pixelSize: 12 * root.scale; visible: root.showPercentage }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 10 * root.scale
            QQC.AbstractButton {
                Layout.preferredWidth: 25 * root.scale
                Layout.preferredHeight: 30 * root.scale
                enabled: control.useIconButton
                Accessible.name: i18n("Mute or unmute sound")
                contentItem: Glyph { source: control.source }
                onClicked: control.clicked()
            }
            QQC.Slider {
                id: slider
                Layout.fillWidth: true
                Layout.preferredHeight: 30 * root.scale
                from: control.from
                to: Math.max(control.from + 1, control.to)
                stepSize: 1
                Accessible.name: control.title
                onMoved: control.moved()
                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + (slider.availableHeight - height)/2
                    width: slider.availableWidth
                    height: 5 * root.scale
                    radius: height / 2
                    color: "#45406784"
                    Rectangle { width: slider.visualPosition * parent.width; height: parent.height; radius: parent.radius; color: "#f9feff" }
                }
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + (slider.availableHeight - height)/2
                    width: 22 * root.scale
                    height: 18 * root.scale
                    radius: height/2
                    color: "white"
                    border.width: slider.visualFocus ? 2 : 0
                    border.color: "#2489ff"
                }
            }
            Glyph { source: control.source; Layout.preferredWidth: 21 * root.scale; Layout.preferredHeight: width }
        }
    }
}
