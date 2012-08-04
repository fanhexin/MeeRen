// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../UIConstants.js" as UI
Header {
    property alias head_src: head_img.source

    Image {
        id: head_img
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        fillMode: Image.PreserveAspectFit
        sourceSize.width: UI.HEAD_PIC_WIDTH
        sourceSize.height: UI.HEAD_PIC_WIDTH
    }

    text_anchors.left: head_img.right
}
