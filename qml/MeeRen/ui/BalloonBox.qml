// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../UIConstants.js" as UI

BorderImage {
    id: border_img
    anchors.fill: parent
    border {
        left: UI.BALLOON_BOX_BORDER_LEN
        top: UI.BALLOON_BOX_BORDER_LEN
        right: UI.BALLOON_BOX_BORDER_LEN
        bottom: UI.BALLOON_BOX_BORDER_LEN
    }
    asynchronous: true
    horizontalTileMode: BorderImage.Stretch
    verticalTileMode: BorderImage.Stretch
    //source: "../images/meegotouch-messaging-list-bubble-unread.png"
}

