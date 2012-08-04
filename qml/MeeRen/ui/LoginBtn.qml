// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 234
    height: 48
    signal clickBtn()

    Image {
        id: btn_img
        anchors.fill: parent
        source: mouseArea.pressed?"../images/login_btn_pressed.png":"../images/login_btn.png"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: clickBtn()
    }
}
