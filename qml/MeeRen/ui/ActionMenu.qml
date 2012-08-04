// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Menu {
    id: action_menu
    property variant share_param
    property variant comment_param
    property string share_method
    property string comment_method

    MenuLayout {
        MenuItem { text: "评论"; onClicked: add_comment() }
        MenuItem { text: "分享"; onClicked: share() }
    }

    function add_comment() {
        var param = {
            method: comment_method,
            param: comment_param
        };

        var tmp = Qt.createComponent("./AddCommentSheet.qml");
        var sheet = tmp.createObject(parent, param);
        sheet.open();
    }

    function share() {
        var tmp = Qt.createComponent(share_method);
        var sheet = tmp.createObject(parent, share_param);
        sheet.open();
    }

    function set_selc_model(model) {
        switch (model.type) {
        case SDK.FEED_TYPE_STATUS:
        case SDK.FEED_TYPE_PAGE_STATUS:
            share_method = './StatusForwardSheet.qml';
            share_param = {"forward_id": model.id, "forward_owner": model.uid};

            comment_method = 'status.addComment';
            comment_param = {"owner_id": model.uid, "status_id": model.id};
            break;
        case SDK.FEED_TYPE_BLOG:
        case SDK.FEED_TYPE_PAGE_BLOG:
            share_method = './AddShareSheet.qml';
            share_param = {"ugc_id": model.id, "user_id": model.uid, "type": SDK.SHARE_TYPE_BLOG};

            comment_method = 'blog.addComment';
            comment_param = {"uid": model.uid, "id": model.id};
            break;
        case SDK.FEED_TYPE_SHARE_BLOG:
        case SDK.FEED_TYPE_PAGE_SHARE_BLOG:
        case SDK.FEED_TYPE_SHARE_PHOTO:
        case SDK.FEED_TYPE_PAGE_SHARE_PHOTO:
            share_method = './AddShareSheet.qml';
            share_param = {"ugc_id": model.id, "user_id": model.uid, "type": SDK.SHARE_TYPE_SHARE};

            comment_method = 'share.addComment';
            comment_param = {"user_id": model.uid, "share_id": model.id};
            break;
        case SDK.FEED_TYPE_PHOTO:
        case SDK.FEED_TYPE_PAGE_PHOTO:
            share_method = './AddShareSheet.qml';
            share_param = {"ugc_id": model.id, "user_id": model.uid, "type": SDK.SHARE_TYPE_PHOTO};

            comment_method = 'photos.addComment';
            //通过此参数判断传递aid还是pid
            if (model.photo_cnt == 1) {
                comment_param = {"uid": model.uid, "pid": model.id};
            }else if (model.photo_cnt > 1) {
                comment_param = {"uid": model.uid, "aid": model.id};
            }
            break;
//        case SDK.FEED_TYPE_SHARE_ALBUM:
//            break;
        default:
            break;
        }
    }
}
