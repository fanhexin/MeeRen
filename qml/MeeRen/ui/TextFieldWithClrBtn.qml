// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

TextField {
    id: input

    platformStyle: TextFieldStyle { paddingRight: clearButton.width }
    Image {
        id: clearButton
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        source: "image://theme/icon-m-input-clear"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                inputContext.reset();
                input.text = "";
            }
        }
    }
}
