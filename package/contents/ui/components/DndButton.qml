// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import org.kde.notificationmanager as Notifications
import "../lib" as Lib
Lib.GlassButton {
    id: focus
    text: i18n("Focus")
    subtitle: inhibited ? i18n("Do Not Disturb on") : i18n("Do Not Disturb off")
    source: "notifications-disabled"
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
