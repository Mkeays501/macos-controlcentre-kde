// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kcmutils
import "components" as Components
import "lib" as Lib
Item {
    id: fullRep
    Kirigami.Theme.inherit: false
    Kirigami.Theme.textColor: "#f5fcff"
    Layout.preferredWidth: root.fullRepWidth
    Layout.preferredHeight: Math.min(root.fullRepHeight, Screen.height * 0.85)
    Layout.minimumWidth: 320 * root.scale
    Layout.minimumHeight: 300 * root.scale

    // Main background with enhanced glass effect
    Rectangle {
        anchors.fill: parent
        radius: 30 * root.scale
        color: root.enableTransparency ? "#2a1a3a88" : "#152e45"
        border.color: "#35ccefff"
        border.width: 1.5 * root.scale

        // Main glass gradient
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? "#3a2a5acc" : "#2a4a5a" }
            GradientStop { position: 0.25; color: root.enableTransparency ? "#30204a99" : "#223a4a" }
            GradientStop { position: 0.5; color: root.enableTransparency ? "#281a4088" : "#1c303a" }
            GradientStop { position: 0.75; color: root.enableTransparency ? "#20153577" : "#182830" }
            GradientStop { position: 1; color: root.enableTransparency ? "#18102866" : "#142028" }
        }
    }

    // Top specular highlight (main window reflection)
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Math.max(1, 0.15 * parent.height)
        radius: 30 * root.scale
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? "#ffffff2a" : "#ffffff12" }
            GradientStop { position: 0.5; color: root.enableTransparency ? "#ffffff0c" : "#ffffff04" }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Left edge specular
    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.max(1, 0.06 * parent.width)
        radius: 30 * root.scale
        clip: true
        gradient: Gradient {
            GradientStop { position: 0; color: root.enableTransparency ? "#ffffff1a" : "#ffffff08" }
            GradientStop { position: 1; color: "transparent" }
        }
    }

    // Inner border highlight
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2 * root.scale
        radius: 28 * root.scale
        color: "transparent"
        border.width: 1 * root.scale
        border.color: root.enableTransparency ? "#ffffff1a" : "#ffffff08"
    }

    // Network section overlay (z: 20)
    Components.SectionNetworks { id: sectionNetworks; anchors.fill: parent; z: 20 }

    ScrollView {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 14 * root.scale
        clip: true
        contentWidth: availableWidth
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded
        ScrollBar.vertical: ScrollBar {
            width: 6 * root.scale
            policy: ScrollBar.AsNeeded
            contentItem: Rectangle {
                radius: width / 2
                color: "#ffffff33"
            }
        }

        ColumnLayout {
            id: mainColumn
            width: wrapper.availableWidth
            spacing: 14 * root.scale

            // Row 1: Network/Bluetooth/Focus + Media
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 174 * root.scale
                spacing: 14 * root.scale
                Components.SectionButtons { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1 }
                Components.MediaPlayer { visible: root.showMediaPlayer; Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1 }
            }

            // Row 2: Focus + Display/Sound settings
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 80 * root.scale
                spacing: 14 * root.scale
                Components.DndButton { visible: root.showDnd; Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 174 * root.scale }
                Lib.GlassButton {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 80 * root.scale
                    circular: true; text: i18n("Display settings"); source: "video-display"
                    onClicked: KCMLauncher.openSystemSettings("kcm_kscreen")
                }
                Lib.GlassButton {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 80 * root.scale
                    circular: true; text: i18n("Sound settings"); source: "audio-card"
                    onClicked: KCMLauncher.openSystemSettings("kcm_pulseaudio")
                }
            }

            // Brightness Slider (conditional)
            Loader {
                visible: root.showBrightness
                active: root.showBrightness
                Layout.fillWidth: true; Layout.preferredHeight: visible ? 80 * root.scale : 0
                source: "components/BrightnessSlider.qml"
            }

            // Volume Slider (conditional)
            Loader {
                visible: root.showVolume
                active: root.showVolume
                Layout.fillWidth: true; Layout.preferredHeight: visible ? 80 * root.scale : 0
                source: "components/Volume.qml"
            }

            // Row 3: Color Scheme + System Settings + Night Light + Screenshot
            RowLayout {
                Layout.fillWidth: true; Layout.preferredHeight: 80 * root.scale
                spacing: 14 * root.scale
                Components.ColorSchemeSwitcher { visible: root.showColorSwitcher; Layout.fillWidth: true; Layout.fillHeight: true }
                Lib.GlassButton {
                    circular: true; source: "preferences-system"; text: i18n("System Settings")
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: KCMLauncher.openSystemSettings("")
                }
                Lib.GlassButton {
                    visible: root.showNightColor
                    circular: true; source: "redshift-status-on"; text: i18n("Night Light settings")
                    Layout.fillWidth: true; Layout.fillHeight: true
                    onClicked: KCMLauncher.openSystemSettings("kcm_nightlight")
                }
                Components.CommandRun {
                    title: i18n("Take screenshot (Spectacle)"); icon: "spectacle"; command: "spectacle"
                    Layout.fillWidth: true; Layout.fillHeight: true
                }
            }

            // Row 4: KDE Connect + Custom Commands
            RowLayout {
                visible: root.showKDEConnect || root.showCmd1 || root.showCmd2
                Layout.fillWidth: true; Layout.preferredHeight: 70 * root.scale
                Loader { active: root.showKDEConnect; visible: active; source: "components/KDEConnect.qml"; Layout.fillWidth: true; Layout.fillHeight: true }
                Components.CommandRun { visible: root.showCmd1; title: root.cmdTitle1; icon: root.cmdIcon1; command: root.cmdRun1; Layout.fillWidth: true; Layout.fillHeight: true }
                Components.CommandRun { visible: root.showCmd2; title: root.cmdTitle2; icon: root.cmdIcon2; command: root.cmdRun2; Layout.fillWidth: true; Layout.fillHeight: true }
            }

            // Edit Controls button - FIXED: Always visible, not pushed off screen
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 48 * root.scale
                // Spacer to push Edit Controls to bottom
            }

            Button {
                text: i18n("Edit Controls")
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                implicitHeight: 36 * root.scale
                implicitWidth: 160 * root.scale
                background: Lib.Card {
                    radius: height / 2
                    // Make edit button more subtle
                    color: root.enableTransparency ? "#3a2a4a66" : "#1e2d3d"
                    border.color: root.enableTransparency ? "#5aaacccc" : "#3a5a7a"
                }
                contentItem: Text {
                    text: parent.text
                    color: "#b8dfe8"
                    font.pixelSize: 14 * root.scale
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: Plasmoid.internalAction("configure").trigger()
            }
        }
    }
}