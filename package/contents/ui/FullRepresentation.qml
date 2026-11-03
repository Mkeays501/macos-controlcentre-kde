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
    Rectangle {
        anchors.fill: parent
        radius: 30 * root.scale
        color: root.enableTransparency ? "#4023354b" : "#152e45"
        border.color: "#35ccefff"
    }
    Components.SectionNetworks { id: sectionNetworks; anchors.fill: parent; z: 20 }
    ScrollView {
        id: wrapper
        anchors.fill: parent
        anchors.margins: 14 * root.scale
        clip: true
        contentWidth: availableWidth
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ColumnLayout {
            width: wrapper.availableWidth
            spacing: 14 * root.scale
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 174 * root.scale
                spacing: 14 * root.scale
                Components.SectionButtons { Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1 }
                Components.MediaPlayer { visible: root.showMediaPlayer; Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 1 }
            }
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
            Loader {
                visible: root.showBrightness
                active: root.showBrightness
                Layout.fillWidth: true; Layout.preferredHeight: visible ? 80 * root.scale : 0
                source: "components/BrightnessSlider.qml"
            }
            Loader {
                visible: root.showVolume
                active: root.showVolume
                Layout.fillWidth: true; Layout.preferredHeight: visible ? 80 * root.scale : 0
                source: "components/Volume.qml"
            }
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
            RowLayout {
                visible: root.showKDEConnect || root.showCmd1 || root.showCmd2
                Layout.fillWidth: true; Layout.preferredHeight: 70 * root.scale
                Loader { active: root.showKDEConnect; visible: active; source: "components/KDEConnect.qml"; Layout.fillWidth: true; Layout.fillHeight: true }
                Components.CommandRun { visible: root.showCmd1; title: root.cmdTitle1; icon: root.cmdIcon1; command: root.cmdRun1; Layout.fillWidth: true; Layout.fillHeight: true }
                Components.CommandRun { visible: root.showCmd2; title: root.cmdTitle2; icon: root.cmdIcon2; command: root.cmdRun2; Layout.fillWidth: true; Layout.fillHeight: true }
            }
            Button {
                text: i18n("Edit Controls")
                Layout.alignment: Qt.AlignHCenter
                implicitHeight: 32 * root.scale
                implicitWidth: 140 * root.scale
                background: Lib.Card { radius: height / 2 }
                contentItem: Text { text: parent.text; color: "#d5f3ff"; font.pixelSize: 14 * root.scale; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: Plasmoid.internalAction("configure").trigger()
            }
        }
    }
}
