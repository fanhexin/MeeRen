// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

PublishSheet {
    id: me
    head_title: '状态'
    onAccept: publish_status(msg)

    function publish_status(msg) {
        if (!msg)
            return;
        SDK.call("status.set", {status: msg}, function(json) {
                     info_banner.text = (json.result)?'状态发布成功!':'状态发布失败!';
                     info_banner.show();
                 });
    }
}
