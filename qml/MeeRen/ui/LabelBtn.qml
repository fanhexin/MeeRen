// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Label {
    id: me
    signal click()
    property color pressed_color: theme.inverted?"lightgray":"#2C2C2C"

    color: mouse_area.pressed?pressed_color:'steelblue'
    font.pixelSize: 22
    font.bold: true

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onClicked: click()
    }
}
