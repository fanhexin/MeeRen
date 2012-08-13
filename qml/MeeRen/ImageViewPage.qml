// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    property int current_index
    property alias data: img_list.model
    property int aid
    property int uid
    orientationLock: PageOrientation.LockPortrait

    Timer {
        id: timer
        interval: 5000
        onTriggered: {
            me.state = "HideBar";
        }
    }

    states: [
        State {
            name: "ShowBar"

            StateChangeScript {
                script: {
                    showToolBar = true
                    timer.start()
                }
            }
        },
        State {
            name: "HideBar"

            StateChangeScript {
                script: {
                    showToolBar = false
                }
            }
        }
    ]

    ListView {
        id: img_list
        anchors.fill: parent
        clip: true
        spacing: UI.NORMAL_MARGIN
        cacheBuffer: 480*2
        delegate: ImageViewDelegate{}
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal

        MouseArea {
            anchors.fill: parent
            onClicked: {
                me.state = (me.state == "HideBar")?"ShowBar":"HideBar";
            }
        }

        Component.onCompleted: img_list.positionViewAtIndex(current_index, ListView.Center)
    }

    ScrollDecorator {
        flickableItem: img_list
    }

    tools: ToolBarLayout {
        id: commonTools
        visible: false

        ToolIcon {
            iconId: "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

        ToolIcon {
            visible: uid
            iconId: "toolbar-pages-all"
            onClicked: {
                timer.stop();
                appWindow.pageStack.push(Qt.resolvedUrl("./ImageFlowPage.qml"), {
                                             uid: uid,
                                             aid: aid
                                         });
            }
        }
    }

    Component.onCompleted: {
        appWindow.showStatusBar = false;
        me.state = "HideBar";
    }
}
