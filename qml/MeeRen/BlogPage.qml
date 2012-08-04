// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "ui"
import "./sdk.js" as SDK
import "./UIConstants.js" as UI
import "./utility.js" as UTILITY

Page {
    id: me
    orientationLock: PageOrientation.LockPortrait

    property string user_id
    property string source_id
    property string uid
    property string id
    property string head_url
    property string head_content
    property int type

    property int comments_cnt
    property int share_comments_cnt
    property string method
    property variant param
    property color bg_color: (theme.inverted)?'#000000':'#E0E1E2'
    property color text_color: (theme.inverted)?'#ffffff':'#191919'

    Header {
        id: user_header
        content: head_content
    }

    Flickable {
        id: contentFlickable
        visible: false
        anchors {
            top : user_header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: blog_detail.height + blog_title.height + btn_loader.height +UI.NORMAL_MARGIN*4
        clip: true

        BlogHeader{
            id: blog_title

            head_src: head_url
        }

        WebView {
            id: blog_detail

            anchors {
                top: blog_title.bottom
                left: parent.left
                right: parent.right
                topMargin: 2
            }

            settings.autoLoadImages: false
            settings.defaultFontSize: UI.DEFAULT_FONT_SIZE
            preferredWidth: UI.SCREEN_WIDTH
            preferredHeight: 10
        }

        SeparatorLine {
            id: separator_line
            anchors.top: blog_detail.bottom
            //anchors.topMargin: UI.NORMAL_MARGIN
        }

        Loader {
            id: btn_loader
            anchors {
                top: separator_line.bottom
                topMargin: UI.NORMAL_MARGIN
                horizontalCenter: parent.horizontalCenter
            }
        }

        Component {
            id: btn
            Button {
                id: comment_btn
                text: '查看评论' + '(' + comments_cnt + ')'
                onClicked: {
                    if (comments_cnt) {
                        pageStack.push(Qt.resolvedUrl("./CommentPage.qml"), {
                                           uid: uid,
                                           id: id,
                                           type: SDK.FEED_TYPE_BLOG
                                       });
                    }
                }
            }
        }

        Component {
            id: btn_row
            ButtonRow {
                 Button {
                     text: "分享评论"+'('+share_comments_cnt+')'
                     onClicked: {
                         if (share_comments_cnt) {
                             pageStack.push(Qt.resolvedUrl("./CommentPage.qml"), {
                                                uid: user_id,
                                                id: source_id,
                                                type: SDK.FEED_TYPE_SHARE_BLOG
                                            });
                         }
                     }
                 }
                 Button {
                     text: "站内评论"+'('+comments_cnt+')'
                     onClicked: {
                         if (comments_cnt) {
                             pageStack.push(Qt.resolvedUrl("./CommentPage.qml"), {
                                                uid: uid,
                                                id: id,
                                                type: SDK.FEED_TYPE_BLOG
                                            });
                         }
                     }
                 }
             }
        }
    }


    ScrollDecorator {
        id: scrollDecorator
        flickableItem: contentFlickable
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

        ToolIcon {
            iconId: "toolbar-edit";
            onClicked: add_comment()
        }

        ToolIcon {
            iconId: "toolbar-share";
            onClicked: {
                var tmp = Qt.createComponent("./ui/AddShareSheet.qml");
                var sheet = tmp.createObject(me, {
                                                 ugc_id: id,
                                                 user_id: uid,
                                                 type: SDK.SHARE_TYPE_BLOG
                                           });
                sheet.open();
            }
        }
    }

    Component.onCompleted: model_load()

    function model_load() {
        waiting_dlg.visible = true;
        SDK.call("blog.get", {
                     uid: uid,
                     id: id
                 }, function(json) {
                     blog_detail.html = '<html><body style="background-color:'+bg_color+';color:'+text_color+'">'+
                             UTILITY.filter_html_tag(json.content)+'</body></html>';
                     comments_cnt  = json.comment_count;
                     blog_title.head_text = '<p>'+json.title+'</p>' +
                             '<p style="font-size:20px;">'+UTILITY.time_ago(json.time)+'  分享'+json.share_count+'次'+'  浏览'+json.view_count+'次'+'</p>';
                     waiting_dlg.visible = false;
                     contentFlickable.visible = true;
                 });

        switch (type) {
        case SDK.FEED_TYPE_BLOG:
        case SDK.FEED_TYPE_PAGE_BLOG:
            method = 'blog.addComment';
            param = {uid: uid, id: id};

            btn_loader.sourceComponent = btn;
            break;
        case SDK.FEED_TYPE_SHARE_BLOG:
        case SDK.FEED_TYPE_PAGE_SHARE_BLOG:
            method = 'share.addComment';
            param = {user_id: user_id, share_id: source_id};

            btn_loader.sourceComponent = btn_row;
            SDK.call("share.getComments", {
                         user_id: user_id,
                         share_id: source_id,
                         page: 1,
                         count: 10
                     }, function(json) {
                         share_comments_cnt = json.total;
                     });
            break;
        }

        if (!head_url) {
            SDK.call('users.getInfo', {uids: uid, fields: 'tinyurl'}, function(json) {
                         blog_title.head_src = json[0].tinyurl;
                     });
        }
    }

    function add_comment() {
        var tmp = Qt.createComponent("./ui/AddCommentSheet.qml");
        var sheet = tmp.createObject(me, {
                                       method: method,
                                       param: param
                                   });
        sheet.addCommentSucess.connect(onAddCommentSucess);
        sheet.open();
    }

    function onAddCommentSucess() {
        if (method == 'blog.addComment') {
            comments_cnt++;
        }else{
            share_comments_cnt++;
        }
    }
}
