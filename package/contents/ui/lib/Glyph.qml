// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Window
import org.kde.kirigami as Kirigami
import "Icons.js" as Icons
Item {
    id: glyph
    property string source: ""
    property bool active: false
    readonly property url asset: Icons.localSource(source, active)
    Image {
        anchors.fill: parent
        visible: glyph.asset.toString().length > 0
        source: glyph.asset
        fillMode: Image.PreserveAspectFit
        sourceSize.width: Math.ceil(width * Screen.devicePixelRatio)
        sourceSize.height: Math.ceil(height * Screen.devicePixelRatio)
        smooth: true
    }
    Kirigami.Icon {
        anchors.fill: parent
        visible: glyph.asset.toString().length === 0
        source: visible ? glyph.source : ""
        isMask: true
        color: glyph.active ? "#1678ed" : "white"
    }
}
