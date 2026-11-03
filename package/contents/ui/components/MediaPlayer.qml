// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.private.mpris as Mpris
import "../lib" as Lib
Lib.Card {
    id: media
    radius: 32 * root.scale
    readonly property var player: model.currentPlayer
    readonly property bool isPlaying: (player?.playbackStatus ?? 0) === Mpris.PlaybackStatus.Playing
    Mpris.Mpris2Model { id: model }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 17 * root.scale
        spacing: 5 * root.scale
        Image {
            source: media.player?.artUrl || "../../assets/music.png"
            fillMode: Image.PreserveAspectCrop
            Layout.preferredWidth: 50 * root.scale
            Layout.preferredHeight: 50 * root.scale
        }
        Item { Layout.fillHeight: true }
        Text {
            Layout.fillWidth: true
            text: media.player?.track || i18n("No media playing")
            color: "#f4fcff"; font.pixelSize: 15 * root.scale; font.weight: Font.DemiBold
            elide: Text.ElideRight
        }
        Text {
            Layout.fillWidth: true
            text: media.player?.artist || i18n("Start a media player")
            color: "#cee8f2"; font.pixelSize: 12 * root.scale
            elide: Text.ElideRight
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 0
            Lib.GlassButton {
                Layout.fillWidth: true; Layout.preferredHeight: 36 * root.scale
                circular: true; source: "media-skip-backward"; text: i18n("Previous track")
                enabled: media.player?.canGoPrevious ?? false
                onClicked: media.player.Previous()
            }
            Lib.GlassButton {
                Layout.fillWidth: true; Layout.preferredHeight: 36 * root.scale
                circular: true; source: media.isPlaying ? "media-playback-pause" : "media-playback-start"
                text: media.isPlaying ? i18n("Pause") : i18n("Play")
                enabled: media.player?.canControl ?? false
                onClicked: media.player.PlayPause()
            }
            Lib.GlassButton {
                Layout.fillWidth: true; Layout.preferredHeight: 36 * root.scale
                circular: true; source: "media-skip-forward"; text: i18n("Next track")
                enabled: media.player?.canGoNext ?? false
                onClicked: media.player.Next()
            }
        }
    }
}
