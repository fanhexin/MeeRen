// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../sdk.js" as SDK

PublishSheet {
    property string forward_id
    property string forward_owner

    head_title: '状态转发'
    onAccept: status_forward(msg)

    function status_forward(msg) {
        SDK.call("status.forward", {
                     forward_id: forward_id,
                     forward_owner: forward_owner,
                     status: msg
                 }, function(json) {
                     info_banner.text = (json.id)?'转发成功!':'转发失败!';
                     info_banner.show();
                 });
    }
}

