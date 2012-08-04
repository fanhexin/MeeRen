// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    property alias source: img.source
    property alias fillMode: img.fillMode
    signal click()

    Rectangle{
        id:shaderLayer
        anchors.fill: parent
        color: "darkgray"
        opacity: 0.5
        MouseArea {
            anchors.fill: parent
            onClicked: click()
        }
    }


    Image {
        id: img
        anchors.fill: parent
        clip: true
    }
}
