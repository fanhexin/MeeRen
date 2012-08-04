// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./sdk.js" as SDK
import "./UIConstants.js" as UI
import "./utility.js" as UTIL

Page {
    orientationLock: PageOrientation.LockPortrait

    property string uid
    property string id
    property string media_id
    property string atta_cnt
    property int type

    property int item_cnt
    property int page_cnt: 1
    property int default_page_count: 20

    property string get_comment_method
    property string add_comment_method
    property variant get_comment_param
    property variant add_comment_param

    Header {
        id: page_header
        content: '查看评论'
    }

    CommonList {
        id: comment_list
        anchors.fill: parent
        anchors.topMargin: UI.HEADER_HEIGHT
        delegate: CommentDelegate{
            //onPressHold: add_comment(uid, name);
        }
        Component.onCompleted: model_load(1)
        onDragLoadMore: {
            if (item_cnt == default_page_count) {
                waiting_dlg.visible = true;
                model_load(++page_cnt);
            }
        }
        onDragRefresh: {
            page_cnt = 1;
            model_refresh();
        }
    }

    ScrollDecorator {
        flickableItem: comment_list
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
            iconId: "toolbar-edit";
            onClicked: add_comment()
        }
    }

    Component.onCompleted: init()

    function init() {
        waiting_dlg.visible = true;
        switch (type) {
        case SDK.FEED_TYPE_STATUS:
        case SDK.FEED_TYPE_PAGE_STATUS:
            get_comment_method = "status.getComment";
            get_comment_param = {
                owner_id: uid,
                status_id: id,
                count: default_page_count
            };

            add_comment_method = "status.addComment";
            add_comment_param = {
                owner_id: uid,
                status_id: id
            };
            break;
        case SDK.FEED_TYPE_BLOG:
        case SDK.FEED_TYPE_PAGE_BLOG:
            get_comment_method = "blog.getComments";
            get_comment_param = {
                uid: uid,
                id: id,
                count: default_page_count
            };

            add_comment_method = "blog.addComment";
            add_comment_param = {
                uid: uid,
                id: id
            };
            break;
        case SDK.FEED_TYPE_SHARE_BLOG:
        case SDK.FEED_TYPE_PAGE_SHARE_BLOG:
        case SDK.FEED_TYPE_SHARE_PHOTO:
        case SDK.FEED_TYPE_PAGE_SHARE_PHOTO:
        case SDK.FEED_TYPE_SHARE_ALBUM:
            get_comment_method = "share.getComments";
            get_comment_param = {
                user_id: uid,
                share_id: id,
                count: default_page_count
            };

            add_comment_method = "status.addComment";
            add_comment_param = {
                user_id: uid,
                share_id: id
            };
            break;
        case SDK.FEED_TYPE_PHOTO:
            get_comment_method = "photos.getComments";
            add_comment_method = "photos.addComment";
            if (atta_cnt == 1) {
                get_comment_param = {
                    uid: uid,
                    pid: media_id,
                    count: default_page_count
                };
                add_comment_param = {
                    uid: uid,
                    pid: media_id
                };
            }else{
                get_comment_param = {
                    uid: uid,
                    aid: id,
                    count: default_page_count
                };
                add_comment_param = {
                    uid: uid,
                    aid: id
                };
            }
            break;
        case SDK.FEED_TYPE_PAGE_PHOTO:
            get_comment_method = "photos.getComments";
            add_comment_method = "photos.addComment";
            get_comment_param = {
                uid: uid,
                aid: id,
                count: default_page_count
            };
            add_comment_param = {
                uid: uid,
                aid: id
            };
            break;
        default:
            waiting_dlg.visible = false;
            break;
        }
    }

    function model_load(page, isNeedClear) {
        get_comment_param.page = page;
        SDK.call(get_comment_method, get_comment_param, function(json) {
                     var tmp = (get_comment_method == "share.getComments")?json.comments:json;
                     onDataRecv(tmp, isNeedClear);
                 });
    }

    function model_refresh() {
        waiting_dlg.visible = true;
        model_load(1, true);
    }

    function onDataRecv(json, isNeedClear) {
        item_cnt = json.length;
        if (isNeedClear) comment_list.model.clear();
        for (var i in json) {
            comment_list.model.append(json[i]);
        }
        waiting_dlg.visible = false;
    }

    function add_comment(uid, name) {
        var param = {
            method: add_comment_method,
            param: add_comment_param
        };

        if (uid) {
            param.rid = uid;
            param.content_text = '回复'+name+': ';
        }

        var tmp = Qt.createComponent("./ui/AddCommentSheet.qml");
        var sheet = tmp.createObject(parent, param);
        sheet.addCommentSucess.connect(onAddCommentSucess);
        sheet.open();
    }

    function onAddCommentSucess(detail) {
        comment_list.model.append({
                                      tinyurl: appWindow.head_url,
                                      name: appWindow.name,
                                      text: detail,
                                      time: UTIL.now()
                                  });
    }
}
