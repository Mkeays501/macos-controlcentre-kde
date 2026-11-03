import QtQuick
import org.kde.kcmutils
import "../lib" as Lib
Lib.GlassButton {
    visible: root.showNightColor
    circular: true
    text: i18n("Night Light settings")
    source: "redshift-status-on"
    onClicked: KCMLauncher.openSystemSettings("kcm_nightlight")
}
