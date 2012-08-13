// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../UIConstants.js" as UI

Item {
    width: UI.SCREEN_WIDTH
    height: parent.height

    WaitingDialog {
        id: photo_waiting_dlg
    }

    Image {
        id: photo
        height: UI.SCREEN_HEIGHT
        width: UI.SCREEN_WIDTH
        anchors.centerIn: parent
        source: (model.raw_src)?model.raw_src:model.url_large
        fillMode: Image.PreserveAspectFit

        onStatusChanged: {
            if (photo.status == Image.Ready) {
                photo_waiting_dlg.visible = false;
            }
        }

        Component.onCompleted: {
            if (photo.status != Image.Ready) {
                photo_waiting_dlg.visible = true;
            }
        }
    }
}
