import QtQuick
import QtQuick.Layouts

Rectangle {
    id: card
    color: "#a93d4351"
    radius: 17 * root.scale
    border.width: 1
    border.color: "#28ffffff"
    // Keep the original Card API expected by the other components.
    property string prefix: ""
    property var margins: ({ top: 0, left: 0, right: 0, bottom: 0 })
    default property alias content: dataContainer.data
    Item {
        id: dataContainer
        anchors.fill: parent
        anchors.topMargin: card.margins.top * root.scale
        anchors.leftMargin: card.margins.left * root.scale
        anchors.rightMargin: card.margins.right * root.scale
        anchors.bottomMargin: card.margins.bottom * root.scale
    }
}
