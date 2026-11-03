// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import org.kde.plasma.private.volume
import "../lib" as Lib
Lib.Slider {
    id: audio
    title: i18n("Sound")
    useIconButton: true
    readonly property var sink: PreferredDevice.sink
    readonly property bool sinkAvailable: !!sink && sink.name !== "auto_null"
    enabled: sinkAvailable
    from: 0
    to: 100
    value: sinkAvailable ? Math.round(sink.volume / PulseAudio.NormalVolume * 100) : 0
    secondaryTitle: sinkAvailable ? Math.round(value) + "%" : i18n("Unavailable")
    source: sinkAvailable ? AudioIcon.forVolume(value, sink.muted, "") : "audio-volume-muted"
    onMoved: {
        if (!sinkAvailable) return
        sink.muted = false
        sink.volume = Math.round(value * PulseAudio.NormalVolume / 100)
        if (root.playVolumeFeedback && !debounce.running) {
            feedback.play(sink.index)
            debounce.start()
        }
    }
    onClicked: { if (sinkAvailable) sink.muted = !sink.muted }
    VolumeFeedback { id: feedback }
    Timer { id: debounce; interval: 150 }
}
