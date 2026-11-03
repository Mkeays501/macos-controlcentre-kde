// SPDX-License-Identifier: GPL-3.0-only
// Based on the Control Centre brightness integration by Prayag Jain.
import QtQuick
import QtQml.Models
import org.kde.plasma.private.brightnesscontrolplugin
import "../lib" as Lib
Lib.Slider {
    id: control
    // Plasma has shipped both single-display and per-display private APIs.
    readonly property bool perDisplay: typeof backend.displays !== "undefined"
    readonly property var firstDisplay: displays.count > 0 ? displays.objectAt(0) : null
    readonly property real maximum: perDisplay ? (firstDisplay?.maximum ?? 0) : (backend.brightnessMax ?? 0)
    enabled: backend.isBrightnessAvailable && maximum > 0
    title: i18n("Display")
    source: "brightness-high"
    from: 0
    to: Math.max(1, maximum)
    value: perDisplay ? (firstDisplay?.current ?? 0) : (backend.brightness ?? 0)
    secondaryTitle: enabled ? Math.round(value / maximum * 100) + "%" : i18n("Unavailable")
    onMoved: {
        if (!enabled) return
        const bounded = Math.round(Math.max(from, Math.min(maximum, value)))
        if (perDisplay) backend.setBrightness(firstDisplay.name, bounded)
        else backend.brightness = bounded
    }
    ScreenBrightnessControl { id: backend; isSilent: true }
    Instantiator {
        id: displays
        model: control.perDisplay ? backend.displays : null
        delegate: QtObject {
            required property string displayName
            required property int brightness
            required property int maxBrightness
            readonly property string name: displayName
            readonly property int current: brightness
            readonly property int maximum: maxBrightness
        }
    }
}
