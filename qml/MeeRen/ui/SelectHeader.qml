// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../UIConstants.js" as UI

Header {
    id: me
    signal clickHeader
    state: 'normal'

    Image {
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }
        asynchronous: true
        source: "image://theme/icon-m-textinput-combobox-arrow"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onPressed: {
            me.state = 'pressed';
        }

        onReleased: {
            me.state = 'normal';
            clickHeader();
        }
    }

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: me
                color: UI.HEADER_COLOR
            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: me
                color: UI.HEADER_PRESSED_COLOR
            }
        }
    ]
}
