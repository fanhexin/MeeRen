import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import QtWebKit 1.0
import "./sdk.js" as SDK

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
            preferredWidth: web_view.width
            preferredHeight: web_view.height
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

                                      setting.setValue("uid", json.uid.toString());
                                      setting.setValue("name", json.name);
                                      setting.setValue("head_url", json.tinyurl);
                                      setting.setValue("access_token", ret[1]);
                                      setting.setValue("dark_theme", "false");
                                  });
                    pageStack.pop();
                    pageStack.push(Qt.resolvedUrl("./MainPage.qml"));
                }
            }

            onLoadFinished: {
                var jsCode = 'document.getElementsByClassName("close")[0].style.display="none";' +
                            'document.getElementsByClassName("register")[0].style.display="none";' +
                            'document.getElementsByClassName("button-box item")[0].childNodes[1].style.display="none";' +
                            'document.body.style.fontSize="19px";' +
                            'document.getElementsByClassName("input-button")[0].style.fontSize="22px";' +
                            'document.getElementsByClassName("content")[0].style.paddingTop="100px";' +
                            'document.getElementsByClassName("item")[0].style.textAlign="center";' +
                            'document.getElementsByClassName("item")[1].style.textAlign="center";' +
                            'document.getElementsByClassName("textbox")[0].style.width="240px";' +
                            'document.getElementsByClassName("textbox")[1].style.width="240px";' +
                            'document.getElementsByClassName("button-box item")[0].style.paddingLeft="147px";'+
                            'document.getElementsByClassName("login")[0].style.width="480px";';

                evaluateJavaScript(jsCode);
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
