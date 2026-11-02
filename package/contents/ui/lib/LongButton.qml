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
    Layout.preferredHeight: 53 * root.scale
    color: mouseArea.containsMouse ? "#39526878" : "transparent"
    radius: 11 * root.scale

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12 * root.scale
        anchors.rightMargin: 8 * root.scale
        spacing: 10 * root.scale
        Kirigami.Icon {
            id: buttonIcon
            Layout.preferredWidth: 22 * root.scale
            Layout.preferredHeight: 22 * root.scale
            Layout.alignment: Qt.AlignVCenter
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
                color: "#f8f9fc"
                elide: Text.ElideRight
                maximumLineCount: 1
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                id: subtitleLabel
                Layout.fillWidth: true
                font.pixelSize: 11 * root.scale
                color: "#bac4d5"
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
