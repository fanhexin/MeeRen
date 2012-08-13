import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "ui"
import "model"
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
        if (!setting.value("uid")) {
            pageStack.push(Qt.resolvedUrl("./OauthPage.qml"));
        }else {
            appWindow.uid = setting.value("uid").toString();
            appWindow.name = setting.value("name").toString();
            appWindow.head_url = setting.value("head_url").toString();
            theme.inverted = (setting.value("dark_theme").toString() == "true")?true:false;
            SDK.set_token(setting.value("access_token").toString());
            pageStack.push(Qt.resolvedUrl("./MainPage.qml"));
        }
    }

    function scaleChanged(scale) {
        appWindow.multi_touch_scale = scale;
    }
}
