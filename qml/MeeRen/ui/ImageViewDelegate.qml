// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../UIConstants.js" as UI

Item {
    width: UI.SCREEN_WIDTH
    height: parent.height

    Image {
        id: photo
        height: UI.SCREEN_HEIGHT
        width: UI.SCREEN_WIDTH
        anchors.centerIn: parent
        source: model.src
        fillMode: Image.PreserveAspectFit

        onStatusChanged: {
            if (photo.status == Image.Ready)
                waiting_dlg.visible = false;
        }
        onSourceChanged: {
            if (photo.status == Image.Ready)
                return;
            waiting_dlg.visible = true;
        }
    }
}
