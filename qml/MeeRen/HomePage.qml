// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5

import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "model"
import "./sdk.js" as SDK
import "./UIConstants.js" as UI

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait
    property string uid: appWindow.uid
    property string name: appWindow.name

    property int item_cnt
    property int page_cnt: 1
    property int default_page_count: 30

    SelectionDialog {
        id: selc_dlg
        titleText: "个人主页"
        selectedIndex: 0
        model: HomeTypeModel{}
        onSelectedIndexChanged: load_view(selc_dlg.model.get(selc_dlg.selectedIndex).type);
    }

    SelectHeader {
        id: header
        content: selc_dlg.model.get(selc_dlg.selectedIndex).name
        onClickHeader: selc_dlg.open();
    }

    Row {
        id: user_header
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            margins: UI.NORMAL_MARGIN
        }
        spacing: UI.NORMAL_MARGIN

        ImageWithProcess {
            id: head_pic
            width: UI.USER_HOME_HEADPIC_WIDTH
            height: UI.USER_HOME_HEADPIC_WIDTH
        }

        Column {
            spacing: UI.NORMAL_MARGIN
            Label {
                id: user_name
                color: 'steelblue'
                font.pixelSize: 32
                text: name
            }

//            Label {
//                text: '最近来访'
//                font.pixelSize: UI.FONT_SIZE_SMALLER
//            }

//            CommonList {
//                id: visitors_list
//                orientation: ListView.Horizontal
//                spacing: UI.NORMAL_MARGIN
//                width: user_header.width - head_pic.width - UI.NORMAL_MARGIN
//                height: UI.HEAD_PIC_WIDTH
//                delegate: VisitorsDelegate {}
//            }
        }
    }

    SeparatorLine {
        id: line
        anchors.top: user_header.bottom
        anchors.topMargin: UI.NORMAL_MARGIN
    }

    Loader {
        id: main_loader
        anchors {
            top: line.bottom
            left: parent.left
            right : parent.right
            bottom: parent.bottom
        }
    }

    Component {
        id: feeds_component
        FeedsListPanel {
            id: feed_panel
            uid: me.uid
            type: SDK.FEED_ALL_TYPE
            page_type: 'home_page'
            Component.onCompleted: feed_panel.model_load(SDK.FEED_ALL_TYPE, 1);
        }
    }

    Component {
        id: status_component
        ListPanel {
            id: status_panel
            param: {'uid': me.uid, 'count':10}
            method: 'status.gets'
            delegate: StatusDelegate{}
            Component.onCompleted: status_panel.model_load(1)
        }
    }

    Component {
        id: blog_component
        BlogListPanel {
            param: {'uid': me.uid, 'count':20}
        }
    }

    Component {
        id: share_component
        FeedsListPanel {
            id: share_panel
            uid: me.uid
            type: SDK.FEED_TYPE_SHARE
            page_type: 'home_page'
            Component.onCompleted: share_panel.model_load(SDK.FEED_TYPE_SHARE, 1);
        }
    }

    Component {
        id: user_info_component
        UserInfoPanel {
            uid: me.uid
        }
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

    onVisibleChanged: {
        if (me.visible == true) {
            load_head_pic();
            load_view(selc_dlg.model.get(selc_dlg.selectedIndex).type);
        }
    }

    function load_view(type) {
        switch (type) {
        case 'feeds':
            main_loader.sourceComponent = feeds_component;
            break;
        case 'status':
            main_loader.sourceComponent = status_component;
            break;
        case 'blog':
            main_loader.sourceComponent = blog_component;
            break;
        case 'photo':
            break;
        case 'share':
            main_loader.sourceComponent = share_component;
            break;
        case 'info':
            main_loader.sourceComponent = user_info_component;
            break;
        default:
            break;
        }
    }

    function load_head_pic() {
        SDK.call("users.getInfo", {uids: uid, fields:"headurl"}, function(json) {
                     head_pic.source = json[0].headurl;
                 });
    }

    function load_visitors() {
        SDK.call("users.getVisitors", {page: 1}, function(json) {
                     for (var i in json.visitors) {
                         visitors_list.model.append(json.visitors[i]);
                     }
                 });
    }
}
