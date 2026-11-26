// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass Focus Button — Wide pill with state indication
import QtQuick
import org.kde.notificationmanager as Notifications
import "../lib" as Lib
Lib.GlassButton {
    id: focus
    text: i18n("Focus")
    subtitle: inhibited ? i18n("Do Not Disturb on") : i18n("Do Not Disturb off")
    source: "notifications-disabled"
    active: inhibited
    activeColor: "#ff6b4a" // Warm accent for DND on
    readonly property bool inhibited: settings.notificationsInhibitedUntil.getTime() > Date.now()
        || settings.notificationsInhibitedByApplication
        || (settings.inhibitNotificationsWhenScreensMirrored && settings.screensMirrored)
    // Keep the glass pill; the subtitle describes the actual backend state.
    Notifications.Settings { id: settings }
    onClicked: {
        if (inhibited) {
            settings.notificationsInhibitedUntil = undefined
            settings.revokeApplicationInhibitions()
        } else {
            let until = new Date()
            until.setFullYear(until.getFullYear() + 1)
            settings.notificationsInhibitedUntil = until
        }
        settings.save()
    }
}