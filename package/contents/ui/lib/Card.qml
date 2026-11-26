// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass — Multi-layer glass with dynamic highlights
import QtQuick
Rectangle {
    id: card
    property string prefix: ""
    property var margins: ({ top: 0, left: 0, right: 0, bottom: 0 })
    property bool isPressed: false
    property bool isHovered: false
    default property alias content: dataContainer.data

    radius: Math.min(28 * root.scale, height / 2)

    // Compute opacity based on glass intensity (10-100)
    readonly property real baseOpacity: root.enableTransparency ? (root.glassIntensity / 100.0) : 1.0
    readonly property real highlightOpacity: root.enableTransparency ? (root.glassIntensity / 150.0) : 0.0

    // Base glass color - adapts to transparency setting and intensity
    color: root.enableTransparency ? Qt.rgba(0.23, 0.16, 0.29, baseOpacity * 0.6) : "#1e2d3d"
    border.width: 1.5 * root.scale
    border.color: root.enableTransparency ? Qt.rgba(0.35, 0.67, 0.80, baseOpacity * 0.5) : "#3a5a7a"

    // Layer 1: Subtle gradient for depth (using rectangle with gradient-like layers)
    // We'll use multiple rectangles to simulate gradient
    Rectangle {
        anchors.fill: parent
        radius: card.radius
        color: root.enableTransparency ? Qt.rgba(0.29, 0.23, 0.42, baseOpacity * 0.4) : "#2a4a5a"
    }
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: height * 0.35
        radius: card.radius
        color: root.enableTransparency ? Qt.rgba(0.23, 0.16, 0.35, baseOpacity * 0.3) : "#223a4a"
    }
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: height * 0.65
        radius: card.radius
        color: root.enableTransparency ? Qt.rgba(0.16, 0.16, 0.29, baseOpacity * 0.25) : "#1a2a3a"
    }
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: height * 0.85
        radius: card.radius
        color: root.enableTransparency ? Qt.rgba(0.10, 0.10, 0.23, baseOpacity * 0.2) : "#14202a"
    }

    // Layer 2: Top highlight (catches light like real glass)
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Math.max(1, 0.18 * parent.height)
        radius: card.radius
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? Qt.rgba(1, 1, 1, highlightOpacity * 0.6) : Qt.rgba(1, 1, 1, 0.1) }
            GradientStop { position: 0.5; color: root.enableTransparency ? Qt.rgba(1, 1, 1, highlightOpacity * 0.25) : Qt.rgba(1, 1, 1, 0.04) }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Layer 3: Left edge highlight (vertical specular)
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.max(1, 0.08 * parent.width)
        radius: card.radius
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? Qt.rgba(1, 1, 1, highlightOpacity * 0.4) : Qt.rgba(1, 1, 1, 0.06) }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Layer 4: Inner border highlight (thin white line inside edge)
    Rectangle {
        anchors.fill: parent
        anchors.margins: 1.5 * root.scale
        radius: Math.max(0, card.radius - 1.5 * root.scale)
        color: "transparent"
        border.width: 1 * root.scale
        border.color: root.enableTransparency ? Qt.rgba(1, 1, 1, highlightOpacity * 0.5) : Qt.rgba(1, 1, 1, 0.06)
    }

    // Press/hover overlay
    Rectangle {
        anchors.fill: parent
        radius: card.radius
        color: card.isPressed ? Qt.rgba(1, 1, 1, 0.1) : (card.isHovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent")
        Behavior on color { ColorAnimation { duration: 100 } }
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