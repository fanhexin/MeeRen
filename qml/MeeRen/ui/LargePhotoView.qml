// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import Multitouch 1.0

Item {
    id: me
    anchors.fill: parent
    anchors.topMargin: 35

    property alias raw_src: large_img.source
    property variant touchPoints: multitouch.touchPoints
    property int distance
    visible: false
    state: 'close'

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }

    Image {
        id: closeImg
        asynchronous: true
        anchors {
            top: parent.top
            //topMargin: 40
            left: parent.left
            rightMargin: 16
        }
        z:1

        source: "../images/qunar_dialog_delete.png"
    }

    MouseArea {
        anchors.centerIn: closeImg
        width: closeImg.width * 2
        height: closeImg.height * 2
        onClicked: {
            me.state = "close";
        }
        z: 1
    }

    Flickable {
        id: flick_able
        width: (parent.width > large_img.width*appWindow.multi_touch_scale)?large_img.width*appWindow.multi_touch_scale:parent.width
        height: (parent.height > large_img.height*appWindow.multi_touch_scale)?large_img.height*appWindow.multi_touch_scale:parent.height
        anchors.centerIn: parent
        //enabled: (touchPoints.length == 2)?false:true
//        anchors {
//            left: parent.left
//            top: parent.top
//            topMargin: 60
//            bottom: parent.bottom
//        }

        clip: true
        contentWidth: large_img.width*appWindow.multi_touch_scale
        contentHeight: large_img.height*appWindow.multi_touch_scale
        Image {
            id: large_img
            scale: appWindow.multi_touch_scale
            anchors.centerIn: parent
            onStatusChanged: {
                if (large_img.status == Image.Ready)
                    waiting_dlg.visible = false;
            }
            onSourceChanged: {
                if (large_img.status == Image.Ready)
                    return;
                waiting_dlg.visible = true;
            }
        }
    }

    transitions: [
        Transition {
            from: "close"
            to: "show"
            SequentialAnimation {
                ScriptAction {
                    script: {
                        //appWindow.showStatusBar = false;
                        me.visible = true;
                    }
                }

                PropertyAnimation {
                    target: me
                    property: "scale"
                    from: 0; to: 1
                    duration: 200
                }
            }
        },
        Transition {
            from: "show"
            to: "close"
            SequentialAnimation {
                PropertyAnimation {
                    target: me
                    property: "scale"
                    from: 1; to: 0
                    duration: 200
                }
                ScriptAction {
                    script: {
                        //appWindow.showStatusBar = true;
                        me.visible = false;
                        appWindow.multi_touch_scale = 1;
                        multitouch.clearLastScale();
                    }
                }
            }
        }
    ]

    function show(src){
        me.state = "show";
        raw_src = src;
    }
}
