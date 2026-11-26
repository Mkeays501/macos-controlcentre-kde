// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass Media Player — Glass artwork overlay, better controls
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.private.mpris as Mpris
import "../lib" as Lib
Lib.Card {
    id: media
    radius: 32 * root.scale

    // Override margins for tighter layout
    margins: { top: 12, left: 14, right: 14, bottom: 14 }

    readonly property var player: model.currentPlayer
    readonly property bool isPlaying: (player?.playbackStatus ?? 0) === Mpris.PlaybackStatus.Playing
    Mpris.Mpris2Model { id: model }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0 // Card handles margins
        spacing: 6 * root.scale

        // Artwork with glass overlay
        Item {
            Layout.preferredWidth: 64 * root.scale
            Layout.preferredHeight: 64 * root.scale
            Layout.alignment: Qt.AlignHCenter

            // Background glass layer behind artwork
            Rectangle {
                anchors.fill: parent
                radius: 16 * root.scale
                color: root.enableTransparency ? "#1a1a3a66" : "#102028"
                border.width: 1 * root.scale
                border.color: root.enableTransparency ? "#ffffff1a" : "#ffffff08"
                layer.enabled: true
                layer.effect: FastBlur { radius: 8 * root.scale; transparentBorder: true }
            }

            // Artwork image
            Image {
                id: artwork
                anchors.fill: parent
                anchors.margins: 2 * root.scale
                source: media.player?.artUrl || "../../assets/music.png"
                fillMode: Image.PreserveAspectCrop
                radius: 14 * root.scale
                clip: true
                layer.enabled: true
                layer.effect: FastBlur { radius: 0; transparentBorder: true }
            }

            // Glass overlay on artwork (specular highlight)
            Rectangle {
                anchors.fill: artwork
                radius: 14 * root.scale
                color: "transparent"
                border.width: 1 * root.scale
                border.color: "#ffffff22"
                // Top specular on artwork
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: Math.max(1, 0.3 * parent.height)
                    radius: parent.radius
                    clip: true
                    gradient: Gradient {
                        GradientStop { position: 0; color: "#ffffff33" }
                        GradientStop { position: 1; color: "transparent" }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: media.player?.track || i18n("No media playing")
            color: "#f5fcff"; font.pixelSize: 15 * root.scale; font.weight: Font.DemiBold
            elide: Text.ElideRight
            layer.enabled: true
            layer.effect: DropShadow {
                horizontalOffset: 0; verticalOffset: 1 * root.scale; radius: 2 * root.scale; samples: 8; color: "#00000080"
            }
        }
        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: media.player?.artist || i18n("Start a media player")
            color: "#b8dfe8"; font.pixelSize: 12 * root.scale
            elide: Text.ElideRight
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 8 * root.scale
            Lib.GlassButton {
                Layout.preferredWidth: 44 * root.scale; Layout.preferredHeight: 44 * root.scale
                circular: true; source: "media-skip-backward"; text: i18n("Previous track")
                enabled: media.player?.canGoPrevious ?? false
                onClicked: media.player.Previous()
            }
            Lib.GlassButton {
                Layout.preferredWidth: 52 * root.scale; Layout.preferredHeight: 52 * root.scale
                circular: true; source: media.isPlaying ? "media-playback-pause" : "media-playback-start"
                text: media.isPlaying ? i18n("Pause") : i18n("Play")
                enabled: media.player?.canControl ?? false
                active: media.isPlaying
                activeColor: "#2489ff"
                onClicked: media.player.PlayPause()
            }
            Lib.GlassButton {
                Layout.preferredWidth: 44 * root.scale; Layout.preferredHeight: 44 * root.scale
                circular: true; source: "media-skip-forward"; text: i18n("Next track")
                enabled: media.player?.canGoNext ?? false
                onClicked: media.player.Next()
            }
        }
    }
}