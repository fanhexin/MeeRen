// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

PublishSheet {
    property string method
    property variant param
    signal addCommentSucess(string content)

//    tool_bar: ToolBarLayout {
//        CheckBox {
//            id : silent_chk
//            text: '悄悄话'
//            anchors.verticalCenter: parent.verticalCenter
//        }
//    }

    onAccept: submit_comment(msg)

    function submit_comment(msg) {
        if (!msg)
            return;

        var tmp = param;
        tmp.content = msg;
        //tmp.type = (silent_chk.checked)?1:0;

        SDK.call(method, tmp, function(json) {
                     info_banner.text = (json.result)?'添加评论成功!':'添加评论失败!';
                     info_banner.show();
                     if (json.result)
                        addCommentSucess(msg);
                 });
    }
}
