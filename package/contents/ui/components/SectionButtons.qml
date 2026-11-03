// SPDX-License-Identifier: GPL-3.0-only
// Liquid Glass layout modifications, 2026. Based on Prayag Jain and Mkeays501.
import QtQuick
import QtQuick.Layouts
import org.kde.bluezqt as BluezQt
import org.kde.kcmutils
import "../lib" as Lib
import "../js/funcs.js" as Funcs
ColumnLayout {
    property QtObject btManager: BluezQt.Manager
    Network { id: network }
    spacing: 14 * root.scale
    Lib.GlassButton {
        Layout.fillWidth: true
        Layout.preferredHeight: 80 * root.scale
        text: network.availableDevices.wirelessDeviceAvailable && network.activeConnectionIcon.indexOf("wired") < 0 ? i18n("Wi-Fi") : i18n("Network")
        subtitle: network.netStatusText
        source: network.activeConnectionIcon
        onClicked: sectionNetworks.toggleNetworkSection()
    }
    RowLayout {
        spacing: 14 * root.scale
        Lib.GlassButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80 * root.scale
            circular: true
            text: i18n("Bluetooth")
            subtitle: Funcs.getBtDevice()
            source: "network-bluetooth"
            active: btManager.bluetoothOperational
            enabled: btManager.adapters.length > 0
            onClicked: Funcs.toggleBluetooth()
        }
        Lib.GlassButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80 * root.scale
            circular: true
            text: i18n("Bluetooth settings")
            subtitle: i18n("Pair and manage devices")
            source: "preferences-system-bluetooth"
            onClicked: KCMLauncher.openSystemSettings("kcm_bluetooth")
        }
    }
}
