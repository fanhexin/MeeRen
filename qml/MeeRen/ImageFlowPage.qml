// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI
import "./sdk.js" as SDK

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    property int uid
    property int aid

    property int page_cnt:1
    property int item_cnt
    property int default_page_count: 30

    ListModel {
        id: list_model
    }

    GridView {
        id: grid_view
        anchors.fill: parent
        cellHeight: 160
        cellWidth: 160
        cacheBuffer: 854*2
        model: list_model
        delegate: Component {
            Item {
                width: 160
                height: 160
                ImageWithProcess {
                    id: photo
                    anchors.fill: parent
                    anchors.margins: 1
                    fillMode: Image.PreserveAspectCrop
                    source: model.url_head
                    onClick: {
                        appWindow.pageStack.push(Qt.resolvedUrl("./ImageViewPage.qml"), {
                                                     current_index: model.index,
                                                     data: list_model
                                                 });
                    }
                }
            }
        }

        GotoTopBtn {
            id: goto_top
            anchors {
                right: parent.right
                rightMargin: UI.LARGE_MARGIN

                bottom: parent.bottom
                bottomMargin: UI.NORMAL_MARGIN
            }

            onClick: grid_view.positionViewAtBeginning()
        }

        onMovementStarted: goto_top.state = "Hide"
        onMovementEnded: {
            goto_top.state = "Show";
            if(grid_view.model.count)
            {
                if(grid_view.atYEnd) {
                    if (item_cnt == default_page_count)
                        model_load(++page_cnt);
                }
            }
        }
    }

    ScrollDecorator {
        id: scrollDecorator
        flickableItem: grid_view
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
        appWindow.showStatusBar = false;
        model_load(1);
    }

    function model_load(page) {
        waiting_dlg.visible = true;
        SDK.call("photos.get", {
                     uid: uid,
                     aid: aid,
                     count: default_page_count,
                     page: page
                 }, function(json) {
                     item_cnt = json.length;
                     for (var i in json) {
                         list_model.append(json[i]);
                     }
                     waiting_dlg.visible = false;
                 });
    }
}
