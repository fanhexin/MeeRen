// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI
import "./sdk.js" as SDK

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait

    property int page_cnt:1

    Header {
        id: header
        content: '我的好友'
    }

    ListModel {
        id: search_result
    }

    ListModel {
        id: all_friend
    }

    Item {
        id: find_friend
        height: UI.HEADER_HEIGHT
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }

        TextFieldWithClrBtn {
            id: search_input
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: UI.NORMAL_MARGIN
                rightMargin: UI.NORMAL_MARGIN
                verticalCenter: parent.verticalCenter
            }
            placeholderText: '搜索'
            onTextChanged: {
                search_result.clear();
                if (!search_input.text) {
                    list_panel.recover_model();
                    list_panel.set_dragable(true);
                }else{
//                    console.log(search_input.text);
                    list_panel.set_dragable(false);
                    search(search_input.text);
                    list_panel.modify_model(search_result);
                }
            }
        }

        SeparatorLine {
            anchors.bottom: parent.bottom
        }
    }

    ListPanel {
        id: list_panel
        anchors.fill: parent
        anchors.topMargin: header.height + find_friend.height
        method: 'friends.getFriends'
        param: {"count": 30}
        delegate: FriendsDelegate{}
    }

    Component.onCompleted: get_all_friends(1);

    onVisibleChanged: {
        if (me.visible) {
            if (search_input.text)
                return;

            if (list_panel.model.count)
                return;

            list_panel.model_load(1);
        }
    }

    function search(text) {
        for (var i = 0; i < all_friend.count; i++) {
            if (all_friend.get(i).name.indexOf(text) == 0) {
                search_result.append(all_friend.get(i));
            }
        }
    }

    function get_all_friends(page) {
        SDK.call('friends.getFriends', {page: page, count: 500}, function(json) {
                     for(var i in json) {
                         all_friend.append(json[i]);
                     }
//加载直到所有好友的加载完毕
                     if (json.length == 500) {
                         get_all_friends(++page_cnt);
                     }
                 });
    }
}
