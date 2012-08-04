import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Rectangle {
    width: parent.width
    height: UI.HEADER_HEIGHT

    property alias content: titleTxt.text
    property alias text_anchors: titleTxt.anchors

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    color: UI.HEADER_COLOR

    Text {
        id: titleTxt
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        color: "white"

        font {
            //family: platformLabelStyle.fontFamily
            pixelSize: UI.FONT_SIZE_LARGE
        }
    }
}
