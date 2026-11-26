import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.networkmanagement as PlasmaNM
import "../lib" as Lib

Lib.Card {
    id: sectionNetworks

    // NETWORK
    property var network: network

    function toggleNetworkSection() {
        if (!sectionNetworks.visible) {
            wrapper.visible = false;
            sectionNetworks.visible = true;
        } else {
            wrapper.visible = true;
            sectionNetworks.visible = false;
        }
    }

    anchors.fill: parent
    z: 999
    visible: false

    // Override margins for full-screen overlay
    margins: { top: 10, left: 10, right: 10, bottom: 10 }

    Network {
        id: network
    }

    Item {
        anchors.fill: parent

        ListView {
            anchors.fill: parent
            model: network.appletProxyModel
            clip: true

            ScrollBar.vertical: ScrollBar {
                width: 6 * root.scale
                contentItem: Rectangle {
                    radius: width / 2
                    color: "#ffffff33"
                }
            }

            delegate: ConnectionItem {
                width: parent.width
                height: root.buttonHeight
            }

            header: ColumnLayout {
                width: parent.width
                spacing: root.smallSpacing

                RowLayout {
                    height: implicitHeight + root.smallSpacing

                    // Back button with glass style
                    Lib.GlassButton {
                        Layout.preferredHeight: 40 * root.scale
                        Layout.preferredWidth: 40 * root.scale
                        circular: true
                        source: "go-previous"
                        text: i18n("Back")
                        onClicked: sectionNetworks.toggleNetworkSection()
                    }

                    PlasmaComponents.Label {
                        text: i18n("Network Connections")
                        font.pixelSize: root.largeFontSize * 1.2
                        color: "#f5fcff"
                        Layout.fillWidth: true
                    }

                    // WiFi toggle
                    PlasmaComponents3.CheckBox {
                        id: wifiSwitchButton

                        readonly property bool administrativelyEnabled: network.availableDevices.wirelessDeviceAvailable && network.enabledConnections.wirelessHwEnabled

                        Layout.rightMargin: root.smallSpacing
                        checked: administrativelyEnabled && network.enabledConnections.wirelessEnabled
                        enabled: administrativelyEnabled
                        text: administrativelyEnabled && network.enabledConnections.wirelessEnabled ? i18n("Wi-Fi On") : i18n("Wi-Fi Off")
                        visible: network.availableDevices.wirelessDeviceAvailable
                        onToggled: network.handler.enableWireless(checked)

                        PlasmaComponents3.ToolTip {
                            text: wifiSwitchButton.checked ? i18n("Disable Wi-Fi") : i18n("Enable Wi-Fi")
                        }

                        PlasmaComponents3.BusyIndicator {
                            parent: wifiSwitchButton
                            running: network.handler.scanning || timer.running

                            anchors {
                                fill: wifiSwitchButton.contentItem
                                leftMargin: wifiSwitchButton.indicator.width + wifiSwitchButton.spacing
                            }

                            Timer {
                                id: timer
                                interval: Kirigami.Units.humanMoment
                            }

                            Connections {
                                function onScanningChanged() {
                                    if (network.handler.scanning)
                                        timer.restart();
                                }
                                target: network.handler
                            }
                        }
                    }

                    // Airplane mode toggle
                    PlasmaComponents3.CheckBox {
                        id: airPlaneModeSwitchButton
                        property bool initialized: false
                        checked: PlasmaNM.Configuration.airplaneModeEnabled
                        text: PlasmaNM.Configuration.airplaneModeEnabled ? i18n("Airplane Mode On") : i18n("Airplane Mode Off")
                        visible: network.availableDevices.modemDeviceAvailable || network.availableDevices.wirelessDeviceAvailable
                        onToggled: {
                            network.handler.enableAirplaneMode(checked);
                            PlasmaNM.Configuration.airplaneModeEnabled = checked;
                        }
                        PlasmaComponents3.ToolTip {
                            text: airPlaneModeSwitchButton.checked ? i18n("Disable airplane mode") : i18n("Enable airplane mode")
                        }
                    }
                }

                // Separator with glass style
                Rectangle {
                    Layout.fillWidth: true
                    height: 1 * root.scale
                    color: root.enableTransparency ? "#ffffff1a" : "#ffffff0a"
                    radius: 0.5 * root.scale
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}