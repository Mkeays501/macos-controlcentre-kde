// SPDX-License-Identifier: GPL-3.0-only
.pragma library
function localSource(name, active) {
    var map = {
        "network-bluetooth": active ? "bluetooth-blue" : "bluetooth",
        "preferences-system-bluetooth": "pair",
        "notifications-disabled": "focus", "notifications": "focus",
        "video-display": "display", "audio-card": "sound",
        "preferences-system": "settings", "settings-configure": "settings",
        "brightness-high": "sun", "brightness-low": "sun",
        "redshift-status-on": "focus", "spectacle": "screenshot",
        "media-playback-start": "play", "media-playback-pause": "pause",
        "media-skip-backward": "previous", "media-skip-forward": "next"
    };
    var key = map[name];
    if (!key && name.indexOf("audio-volume") === 0) key = name.indexOf("muted") >= 0 ? "mute" : "sound";
    if (!key && name.indexOf("network-") === 0) key = "wifi";
    return key ? Qt.resolvedUrl("../icons/" + key + ".svg") : "";
}

function source(name, active) { return localSource(name, active) || name; }
