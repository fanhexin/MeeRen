// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Dialog {
    id: me

    property alias title_text: titleLabel.text
    property alias content_text: text.text

    title: Item {
        id: titleField
        height: me.platformStyle.titleBarHeight
        width: parent.width
        Image {
            id: supplement
            source: "image://theme/icon-l-contacts"
            height: parent.height - 10
            width: 75
            fillMode: Image.PreserveAspectFit
            anchors.leftMargin: 5
            anchors.rightMargin: 5
        }

        Label {
            id: titleLabel
            anchors.left: supplement.right
            anchors.verticalCenter: titleField.verticalCenter
            font.capitalization: Font.MixedCase
            color: "white"
        }

        Image {
            id: closeButton
            anchors.verticalCenter: titleField.verticalCenter
            anchors.right: titleField.right

            source: "image://theme/icon-m-common-dialog-close"

            MouseArea {
                id: closeButtonArea
                anchors.fill: parent
                onClicked:  { me.reject(); }
            }
        }
    }

    content:Item {
        id: name
        height: childrenRect.height
        Text {
            id: text
            font.pixelSize: 22
            color: "white"
        }
    }

    buttons: ButtonRow {
        platformStyle: ButtonStyle { }
        anchors.horizontalCenter: parent.horizontalCenter
        Button {id: b1; text: "确认"; onClicked: me.accept()}
        Button {id: b2; text: "取消"; onClicked: me.reject()}
    }

}
