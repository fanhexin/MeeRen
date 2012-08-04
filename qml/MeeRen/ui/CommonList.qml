// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

ListView {
    id: listView

    property bool allowRefresh: false
    property bool needRefresh: !listView.model.isReadingDB
    property bool isDragable: true
    signal dragRefresh
    signal dragLoadMore

    //anchors.fill: parent
    model: ListModel{}
    clip: true
    focus: true
//    orientation: ListView.Vertical
    //flickDeceleration: 1000
    cacheBuffer: 854*2

    Rectangle{
        id: updateBanner
        height: 100;
        anchors.left: parent.left;
        anchors.right: parent.right
        visible: needRefresh
        y: listView.visibleArea.yPosition > 0 ? -height : -(listView.visibleArea.yPosition * Math.max(listView.height, listView.contentHeight))-height
        color: "transparent";

        Image{
            id: img
            source: "../images/Drop-down arrow.png"
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 50

            states: [
                State {
                    name: "rotated"
                    PropertyChanges { target: img; rotation: 180 }
                },
                State {
                    name: "rotatedBack"
                    PropertyChanges { target: img; rotation: 0 }
                }

            ]

            transitions: Transition {
                RotationAnimation { duration: 200; }
            }
        }

        Label {
           id: topText;
           anchors.verticalCenter: parent.verticalCenter
           anchors.left: img.right
           anchors.leftMargin: if(parent.width > 700) {280} else {100}

           text:  listView.allowRefresh ? "松开即可刷新..." : "下拉可以刷新...";
           font.pixelSize: 20
       }

        onYChanged: {
            if (listView.flicking) return;
            var contentYPos = listView.visibleArea.yPosition * Math.max(listView.height, listView.contentHeight);
            if(listView.needRefresh) {
                if ( (contentYPos < UI.LIST_DRAG_DISTANCE) && listView.moving ) {
                    listView.allowRefresh = true;
                    img.state = "rotated";
                }
            }
        }
    }

    onMovementEnded:
    {
        if(listView.model.count != 0)
        {
            if(listView.atYEnd)
            {
                if(needRefresh && listView.allowRefresh) {
                    img.state = "rotatedBack";
                    listView.allowRefresh = false;
                }
                else {
                    if (isDragable)
                        dragLoadMore();
                }
            }
            else if (listView.atYBeginning) {
                if(needRefresh) {
                    img.state = "rotatedBack";
                    if(listView.allowRefresh) {
                        listView.allowRefresh = false;

                        if (isDragable)
                            dragRefresh();
                    }
                }
                else {
                }
            }
        }
        else {
            img.state = "rotatedBack";
            if(listView.allowRefresh) {
                listView.allowRefresh = false;
            }
        }
    }

    function set_dragable(flag) {
        updateBanner.visible = flag;
        isDragable = flag;
    }
}

