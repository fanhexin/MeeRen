// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    width: parent.width
    height: row.height + 2*UI.NORMAL_MARGIN

    BorderImage {
        id: background
        anchors.fill: parent
        visible: mouseArea.pressed
        source: (theme.inverted)?"image://theme/meegotouch-list-inverted-background-pressed-center":"image://theme/meegotouch-list-background-pressed-center"
    }

    Row {
        id: row
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: UI.NORMAL_MARGIN
        }

        spacing: UI.LARGE_MARGIN

        Image {
            width: UI.HEAD_PIC_WIDTH
            height: UI.HEAD_PIC_WIDTH

            source: model.headurl
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: UI.HEAD_PIC_WIDTH
            sourceSize.height: UI.HEAD_PIC_WIDTH
        }

        Label {
            text: model.name
            color: "steelblue"
            font.pixelSize: UI.FONT_SIZE_LARGE
        }
    }

//    SeparatorLine {
//        anchors.top: row.bottom
//        anchors.topMargin: UI.NORMAL_MARGIN
//    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            appWindow.pageStack.push(Qt.resolvedUrl("../HomePage.qml"), {
                                         uid: model.id,
                                         name: model.name
                                     });
        }
    }
}
