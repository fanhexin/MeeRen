// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

PublishSheet {
    property string ugc_id
    property string user_id
    property int type

    head_title: '分享'
    onAccept: publish_share(msg)

    function publish_share(msg) {
        SDK.call("share.share", {
                     ugc_id: ugc_id,
                     user_id: user_id,
                     comment: msg,
                     type: type
                 }, function(json) {
                     info_banner.text = '分享发布成功!';
                     info_banner.show();
                 });
    }
}

