// SPDX-License-Identifier: GPL-3.0-only
// Enhanced Liquid Glass Section Buttons — Network, Bluetooth, Focus pills
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

    // Network / Wi-Fi Pill (wide)
    Lib.GlassButton {
        Layout.fillWidth: true
        Layout.preferredHeight: 80 * root.scale
        text: network.availableDevices.wirelessDeviceAvailable && network.activeConnectionIcon.indexOf("wired") < 0 ? i18n("Wi-Fi") : i18n("Network")
        subtitle: network.netStatusText
        source: network.activeConnectionIcon
        onClicked: sectionNetworks.toggleNetworkSection()
    }

    // Bluetooth + Pair row
    RowLayout {
        spacing: 14 * root.scale
        // Bluetooth toggle (circular)
        Lib.GlassButton {
            Layout.fillWidth: true
            Layout.preferredHeight: 80 * root.scale
            circular: true
            text: i18n("Bluetooth")
            subtitle: Funcs.getBtDevice()
            source: "network-bluetooth"
            active: btManager.bluetoothOperational
            activeColor: "#2489ff"
            enabled: btManager.adapters.length > 0
            onClicked: Funcs.toggleBluetooth()
        }
        // Bluetooth settings (circular)
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