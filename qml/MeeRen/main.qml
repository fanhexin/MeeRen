import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "ui"
import "model"
import "./Database.js" as DB
import "./sdk.js" as SDK
import Multitouch 1.0

PageStackWindow {
    id: appWindow

    property string uid
    property string name
    property string head_url
    property int time_out: 20*1000
    property real multi_touch_scale:1

    InfoBanner{
        id: info_banner
        topMargin: 40
        timerShowTime: 2*1000
        z: 1
    }

    Timer {
        id: timer
        interval: time_out
        onTriggered: {
            info_banner.text = "连接超时";
            info_banner.show();
            waiting_dlg.visible = false;
        }
    }

    WaitingDialog {
        id: waiting_dlg
        onVisibleChanged: {
            if (waiting_dlg.visible) {
                timer.start();
            }else{
                timer.stop();
            }
        }
    }

    LargePhotoView {
        id: large_photo_view_panel
    }

    ActionMenu {
        id: action_menu
    }



    Component.onCompleted: {
        DB.init();
        DB.get_session(function(item) {
                           if (item) {
                               SDK.set_token(item.access_token);
                               appWindow.uid = item.uid;
                               appWindow.name = item.name;
                               appWindow.head_url = item.head_url;

                               pageStack.push(Qt.resolvedUrl("./MainPage.qml"));
                           }else{
                               pageStack.push(Qt.resolvedUrl("./OauthPage.qml"));
                           }
                       });
    }

    function scaleChanged(scale) {
        appWindow.multi_touch_scale = scale;
    }
}
