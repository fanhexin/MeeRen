// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./UIConstants.js" as UI

Page {
    Header {
        id: header
        content: '关于MeeRen'
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        contentHeight: col.height

        Image {
            id: logo
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: UI.LARGE_MARGIN
            }
            source: "./images/renren100x100.png"
        }

        Column {
            id: col
            anchors {
                top: logo.bottom
                left: parent.left
                right: parent.right
                margins: UI.NORMAL_MARGIN
            }
            spacing: UI.LARGE_MARGIN

            Label {
                width: parent.width
                wrapMode: 'WordWrap'
                text: '"MeeRen"是基于人人网开放API开发的第三方客户端，由个人开发者独立开发完成。受人人网开放API功能限制，一些重要的功能无法实现，例如消息通知。另外一些功能受限于系统框架和自身的技术目前还无法解决，例如视频播放功能(现已屏蔽视频分享新鲜事)。软件本身肯定还存在很多bug和需要改进的地方，衷心的期待您的意见和反馈。可以在新浪微博<span style="color:steelblue;">@追梦人</span>，或者点击以下邮件地址给我发送电子邮件。<p>能经得住多大诋毁就能担得起多少赞美！用MeeRen，不跟随!</p>'
            }

            Label {
                text: 'Email: <a href="mailto:fanhexin@gmail.com">fanhexin@gmail.com</a>'
                onLinkActivated: {
                    Qt.openUrlExternally(link);
                }
            }
        }
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
    }
}
