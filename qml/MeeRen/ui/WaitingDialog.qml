// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Item{
    id:waitingDialog
    visible: false
    anchors.fill: parent
    z:100
    Rectangle{
        id:shaderLayer
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height
        color: "darkgray"
        opacity: 0.5
        //radius: funcContainer.style.cornersVisible ? 13 : 0
        MouseArea {
            anchors.fill: parent
        }
    }
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 100
        width: 100
        BusyIndicator {
            id: busyindicator
            style: BusyIndicatorStyle { size: "large" }
            running:  true
        }
    }
}
