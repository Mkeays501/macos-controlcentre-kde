import QtQml
import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kdeconnect as KdeConnect
import org.kde.plasma.core as PlasmaCore

import "../lib" as Lib
import "../js/funcs.js" as Funcs

Lib.CardButton {
    visible: root.showKDEConnect
    Layout.fillWidth: true
    Layout.fillHeight: true
    title: i18n("KDE Connect")
    Lib.Glyph {
        anchors.fill: parent
        anchors.margins: 8 * root.scale
        source: "kdeconnect-tray"
        color: "#f5fcff"
    }
    onClicked: KdeConnect.OpenConfig.openConfiguration();
}