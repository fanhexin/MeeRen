// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    id: me
    property int current_index
    property variant img_url

    states: [
        State {
            name: "ShowBar"

            StateChangeScript {
                script: {
                    showToolBar = true
                    showStatusBar = true
                }
            }
        },
        State {
            name: "HideBar"

            StateChangeScript {
                script: {
                    showToolBar = false
                    showStatusBar = false
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
        model: ListModel{}
        delegate: ImageViewDelegate{}
        snapMode: ListView.SnapOneItem
        orientation: ListView.Horizontal

        MouseArea {
            anchors.fill: parent
            onClicked: {
                me.state = (me.state == "HideBar")?"ShowBar":"HideBar";
            }
        }
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
    }

    Component.onCompleted: {
        img_list.model.append({src:img_url.get(current_index).raw_src});
        for (var i = 0; i < img_url.count; i++) {
            if (i == current_index)
                continue;
            img_list.model.append({src:img_url.get(i).raw_src});
        }
    }
}
