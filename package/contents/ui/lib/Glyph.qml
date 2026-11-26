// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Glyph — Reliable SVG rendering with proper fallback
import QtQuick
import QtQuick.Window
import org.kde.kirigami as Kirigami
import "Icons.js" as Icons
Item {
    id: glyph
    property string source: ""
    property bool active: false
    property color iconColor: active ? "#2489ff" : "white"
    readonly property url asset: Icons.localSource(source, active)

    // Primary: Custom SVG from bundled icons
    Image {
        id: svgImage
        anchors.fill: parent
        visible: glyph.asset.toString().length > 0
        source: glyph.asset
        fillMode: Image.PreserveAspectFit
        sourceSize.width: Math.ceil(width * Screen.devicePixelRatio)
        sourceSize.height: Math.ceil(height * Screen.devicePixelRatio)
        smooth: true
        color: glyph.iconColor
        // Ensure proper rendering
        mipmap: true
    }

    // Fallback: System icon theme (only if SVG not found)
    Kirigami.Icon {
        anchors.fill: parent
        visible: !svgImage.visible && glyph.source.length > 0
        source: glyph.source
        isMask: true
        color: glyph.iconColor
    }

    // Last resort: Show a simple placeholder instead of empty square
    Rectangle {
        anchors.fill: parent
        visible: !svgImage.visible && glyph.source.length === 0
        radius: width / 2
        color: "transparent"
        border.width: 2 * root.scale
        border.color: "#ffffff44"
        Text {
            anchors.centerIn: parent
            text: "?"
            color: "#ffffff66"
            font.pixelSize: Math.min(width, height) * 0.6
            font.bold: true
        }
    }
}