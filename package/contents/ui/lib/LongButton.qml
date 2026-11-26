import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Rectangle {
    id: button
    signal clicked()
    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias source: buttonIcon.source
    property alias sourceColor: buttonIcon.color
    property int margin: root.buttonMargin

    Layout.fillWidth: true
    Layout.preferredHeight: 56 * root.scale
    radius: 14 * root.scale

    // Glass background
    color: root.enableTransparency ? "#3a2a4a80" : "#1e2d3d"
    border.width: 1 * root.scale
    border.color: root.enableTransparency ? "#5aaacccc" : "#3a5a7a"
    gradient: Gradient {
        GradientStop { position: 0; color: root.enableTransparency ? "#4a3a6a77" : "#2a4a5a" }
        GradientStop { position: 0.5; color: root.enableTransparency ? "#3a2a5a66" : "#223a4a" }
        GradientStop { position: 1; color: root.enableTransparency ? "#2a1a4a55" : "#1a2a3a" }
    }

    // Top specular highlight
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Math.max(1, 0.25 * parent.height)
        radius: button.radius
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? "#ffffff22" : "#ffffff10" }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Inner border
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1 * root.scale
        radius: Math.max(0, button.radius - 1 * root.scale)
        color: "transparent"
        border.width: 1 * root.scale
        border.color: root.enableTransparency ? "#ffffff1a" : "#ffffff08"
    }

    // Hover/press overlay
    Rectangle {
        anchors.fill: parent
        radius: button.radius
        color: mouseArea.containsMouse && mouseArea.pressed ? "#ffffff1a" : (mouseArea.containsMouse ? "#ffffff0a" : "transparent")
        Behavior on color { ColorAnimation { duration: 80 } }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 14 * root.scale
        anchors.rightMargin: 10 * root.scale
        spacing: 12 * root.scale
        Kirigami.Icon {
            id: buttonIcon
            Layout.preferredWidth: 24 * root.scale
            Layout.preferredHeight: 24 * root.scale
            Layout.alignment: Qt.AlignVCenter
            color: button.sourceColor
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2 * root.scale
            Text {
                id: titleLabel
                Layout.fillWidth: true
                font.pixelSize: 14 * root.scale
                font.bold: true
                color: "#f5fcff"
                elide: Text.ElideRight
                maximumLineCount: 1
                verticalAlignment: Text.AlignVCenter
                layer.enabled: true
                layer.effect: DropShadow {
                    horizontalOffset: 0; verticalOffset: 1 * root.scale; radius: 2 * root.scale; samples: 8; color: "#00000080"
                }
            }
            Text {
                id: subtitleLabel
                Layout.fillWidth: true
                font.pixelSize: 11 * root.scale
                color: "#b8dfe8"
                elide: Text.ElideRight
                maximumLineCount: 1
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: button.clicked()
    }
}