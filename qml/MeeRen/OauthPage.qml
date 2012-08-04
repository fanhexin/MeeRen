import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import QtWebKit 1.0
import "./sdk.js" as SDK
import "./Database.js" as DB

Page {
    orientationLock: PageOrientation.LockPortrait

    Header {
        id: title
        content: "登录授权"
    }

    Item {
        anchors {
            top: title.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        LoginBtn {
            id: login_btn
            anchors.centerIn: parent
            onClickBtn: {
                login_btn.visible = false;
                if (web_view.status != 1) {
                    waiting_dlg.visible = true;
                }
                web_view.visible = true;
            }
        }

        WebView {
            id: web_view
            anchors.fill: parent
            visible: false
            url: SDK.generate_oauth_url()
            preferredWidth: parent.width
            preferredHeight: parent.height
            scale: 1
            smooth: false

            onUrlChanged: {
                var reg_exp = new RegExp("access_token=\(.*\)&expires_in", "g");
                var ret = reg_exp.exec(web_view.url);
                if (ret) {
                    web_view.visible = false;
                    SDK.set_token(ret[1]);
                    get_user_info(function(json) {
                                      appWindow.name = json.name;
                                      appWindow.uid = json.uid.toString();
                                      appWindow.head_url = json.tinyurl;

                                      DB.init();
                                      DB.add_session(json.uid.toString(), json.name, json.tinyurl, ret[1]);
                                  });
                    pageStack.pop();
                    pageStack.push(Qt.resolvedUrl("./MainPage.qml"));
                }
            }

            onLoadFinished: {
                evaluateJavaScript('document.getElementsByClassName("close")[0].style.display="none";document.getElementsByClassName("register")[0].style.display="none";document.getElementsByClassName("button-box item")[0].childNodes[1].style.display="none";');
                waiting_dlg.visible = false;
            }
        }
    }

    function get_user_info(func) {
        SDK.call('users.getInfo', {
                     fields: 'uid,name,tinyurl'
                 }, function(json) {
                     func(json[0]);
                 });
    }
}
