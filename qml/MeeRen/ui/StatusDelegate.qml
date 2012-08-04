// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Item {
    height: col.height + 2*col.anchors.margins
    width: parent.width
    BorderImage {
        id: background
        anchors.fill: parent
        asynchronous: true
        visible: mouseArea.pressed
        source: (theme.inverted)?"image://theme/meegotouch-list-inverted-background-pressed-center":"image://theme/meegotouch-list-background-pressed-center"
    }

    Column {
        id: col
        anchors{
            top: parent.top
            left: parent.left
            right : parent.right
            margins: UI.NORMAL_MARGIN
        }

        spacing: UI.NORMAL_MARGIN
        Label {
            width: parent.width
            id: status_text
            text: model.message
        }

        Label {
            width: parent.width
            id: update_time_text
            text: model.time
            font.pixelSize: UI.FONT_SIZE_SMALLER
        }
    }

    SeparatorLine {
        anchors.top: parent.bottom
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressAndHold: {
            var tmp = {
                type: SDK.FEED_TYPE_STATUS,
                uid: model.uid,
                id: model.status_id
            };

            action_menu.set_selc_model(tmp);
            action_menu.open();
        }
    }
}
