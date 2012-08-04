// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Rectangle {
    width: UI.PHOTO_SIDE_NORMAL_LEN
    height: UI.PHOTO_SIDE_NORMAL_LEN
    property alias photo_src: photo.source
    signal click()

    ImageWithProcess {
        id: photo
        anchors.fill: parent
        anchors.margins: UI.SMALL_MARGIN
        fillMode: Image.PreserveAspectCrop
    }

    MouseArea {
        anchors.fill: parent
        onClicked: click()
    }
}
