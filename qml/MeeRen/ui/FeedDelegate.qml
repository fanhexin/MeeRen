// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK
import "../utility.js" as UTILITY

Item {
    id: feed_delegate
    height: (head_img_loader.height > view_col.height)?head_img_loader.height+2*row.anchors.margins:
                                                        view_col.height+2*row.anchors.margins
    width: parent.width
//    color: 'lightgray'

    Row {
        id: row
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: UI.NORMAL_MARGIN
        }
        spacing: UI.NORMAL_MARGIN

        Loader {
            id: head_img_loader
        }

        Column {
            id: view_col
            width: feed_delegate.width - 2*row.anchors.margins - head_img_loader.width
            spacing: UI.NORMAL_MARGIN

            Item {
                height: name_text.height
                width: view_col.width

                Label {
                    id: name_text
                    anchors{
                        top: parent.top
                        left: parent.left
                    }

                    //visible: (model.page_type == 'feeds_page')
                    text: model.name
                    color: 'steelblue'
                }

                Label {
                    id: update_time
                    anchors {
                        top: parent.top
                        right: parent.right
                    }
                    text: UTILITY.time_ago(model.update_time)
                    font.pixelSize: UI.FONT_SIZE_SMALLER
                }
            }

            Label {
                id: view_text
                visible: view_text.text
                width: view_col.width
            }

            Loader {
                id: loader
                width: view_col.width
            }

            Item {
                height: chat.height
                width: view_col.width
                visible: ((model.comments.count!=0)||(model.source!=undefined))

                Label {
                    id: bottom_text
                    anchors {
                        top: parent.top
                        left: parent.left
                    }

                    text: (model.source)?'通过'+model.source.text+'发布':''
                    font.pixelSize: UI.FONT_SIZE_SMALLER
                }

                Label {
                    id: comment_cnt
                    anchors {
                        top: parent.top
                        right: parent.right
                        rightMargin: UI.NORMAL_MARGIN
                    }
                    visible: model.comments.count
                    text: model.comments.count
                    font.pixelSize: UI.FONT_SIZE_SMALLER
                }

                Image {
                    id: chat
                    anchors {
                        top: parent.top
                        right: comment_cnt.left
                        rightMargin: UI.NORMAL_MARGIN
                    }
                    asynchronous: true
                    visible: model.comments.count
                    source: (!theme.inverted)?"../images/Microblogging.png":"../images/Microblogging-inverted.png"
                }
            }

            Loader {
                id: comment_loader
                width: view_col.width
            }
        }
    }

    Component {
        id: head_img_component
        ImageWithProcess {
            width: UI.HEAD_PIC_WIDTH
            height: UI.HEAD_PIC_WIDTH

            source: model.headurl
            onClick: {
                //不支持公共主页和小站的主页查看,因为小站和公共主页无法区分
                if (model.actor_type == 'user') {
                    appWindow.pageStack.push(Qt.resolvedUrl("../HomePage.qml"), {
                                                 uid: model.actor_id,
                                                 name: model.name
                                             });
                }
            }
        }
    }

    Component {
        id: share_blog_content
        ShareView {
            label_text: '<a style="font:bold;color:steelblue;">'+model.attachment.get(0).owner_name+'</a>'+
                  '<p style="font:bold;">'+model.title+'</p>'+
                  '<p>'+model.description+'</p>'
        }
    }

    Component {
        id: share_status_content
        ShareView {
            label_text: '<p><a style="font:bold;color:steelblue;">'+model.attachment.get(0).owner_name+': </a>'+
                  model.attachment.get(0).content+'</p>'
        }
    }

    Component {
        id: photos_view
        Item {
            height: childrenRect.height
            Flow {
                id: photo_flow
                width: parent.width
                anchors.margins: UI.SMALL_MARGIN
                spacing: UI.SMALL_MARGIN
                Repeater {
                    model: attachment.count
                    PhotoView {
                        id: photo_view
                        photo_src: attachment.get(index).src
                        onClick: pop_photo_win(index)
                        Component.onCompleted: {
                            if (attachment.count == 3) {
                                photo_view.height = UI.PHOTO_SIDE_SMALL_LEN;
                                photo_view.width = UI.PHOTO_SIDE_SMALL_LEN;
                            }
                        }
                    }
                }
            }

            Label {
                id: photo_title
                width: parent.width
                anchors {
                    top: photo_flow.bottom
                    horizontalCenter: photo_flow.horizontalCenter
                }
                text: '['+model.title+']'
                font.pixelSize: UI.FONT_SIZE_SMALLER
            }
        }
    }

    Component {
        id: share_photo_view
        ShareView {
            id: share_photo
            label_text: '<a style="font:bold;color:steelblue;">'+model.attachment.get(0).owner_name+'</a>'+
                  '<p style="font:bold;">'+model.title+'</p>';
            Component.onCompleted: {
                var handle = share_photo.add_item_to_column('PhotoView.qml', {'photo_src': attachment.get(0).src});
                handle.click.connect(function(){pop_photo_win(0);});
            }
        }
    }

    Component {
        id: comment_view
        BubbleList {
            id: comment_list
            onClick: jmp_comment_page()
            Component.onCompleted: {
                for (var i in model.comments.comment) {
                    comment_list.label_text += '<p>'+'<span style="font:bold;color:steelblue;">'+model.comments.comment[i].name+': </span>'+
                                             model.comments.comment[i].text+'</p>'+'<p>'+model.comments.comment[i].time+'</p>';
                }
                comment_list.add_text();
                comment_list.set_clickable();
            }
        }
    }


////分割线
    SeparatorLine {
        anchors.top: parent.bottom
    }

    MouseArea {
        id: mouseArea
        z: -1
        anchors.fill: parent
        onClicked: {
            jmp_detail_page();
        }

        onPressAndHold: {
            var tmp = {
                type: model.feed_type,
                uid: model.actor_id,
            };
//由于接口不一致造成的额外判断,同照片新鲜事的评论获取
            if (model.feed_type == SDK.FEED_TYPE_PHOTO || model.feed_type == SDK.FEED_TYPE_PAGE_PHOTO) {
                tmp.photo_cnt = model.attachment.count;
                if (tmp.photo_cnt == 1) {
                    tmp.id = model.attachment.get(0).media_id;
                }else if (tmp.photo_cnt > 1) {
                    tmp.id = model.source_id;
                }
            }else {
                tmp.id = model.source_id;
            }

            action_menu.set_selc_model(tmp);
            action_menu.open();
        }
    }

    BorderImage {
        id: background
        asynchronous: true
        anchors.fill: parent
        z: -1
        visible: mouseArea.pressed
        source: (theme.inverted)?"image://theme/meegotouch-list-inverted-background-pressed-center":"image://theme/meegotouch-list-background-pressed-center"
    }

    Component.onCompleted: generate_view()

    function generate_view() {
        switch (model.feed_type) {
        case SDK.FEED_TYPE_STATUS:
        case SDK.FEED_TYPE_PAGE_STATUS:
            status_view_deal();
            break;
        case SDK.FEED_TYPE_BLOG:
        case SDK.FEED_TYPE_PAGE_BLOG:
            blog_view_deal();
            break;
        case SDK.FEED_TYPE_SHARE_BLOG:
        case SDK.FEED_TYPE_PAGE_SHARE_BLOG:
            share_blog_view_deal();
            break;
        case SDK.FEED_TYPE_PHOTO:
        case SDK.FEED_TYPE_PAGE_PHOTO:
            photo_view_deal();
            break;
        case SDK.FEED_TYPE_SHARE_PHOTO:
        case SDK.FEED_TYPE_PAGE_SHARE_PHOTO:
            share_photo_view_deal();
            break;
//        case SDK.FEED_TYPE_SHARE_ALBUM:
//            share_album_view_deal();
//            break;
        default:
            break;
        }

        if (model.page_type == 'feeds_page') {
            head_img_loader.sourceComponent = head_img_component;
            view_col.width -= UI.NORMAL_MARGIN;
        }

        if (model.comments.count) {
            comment_loader.sourceComponent = comment_view;
        }
    }

    function status_view_deal() {
        if (model.attachment.count) {
            view_text.text += model.prefix;
            loader.sourceComponent = share_status_content;
        }else{
            view_text.text += model.message;
        }
    }

    function blog_view_deal() {
        view_text.text += '<p style="font:bold;font-size:20px;">'+model.title+'</p>'+
                '<p style="font-size:20px;">'+model.description+'</p>';
    }

    function share_blog_view_deal() {
        view_text.text += (model.share_pr)?model.share_pr:'分享日志';
        loader.sourceComponent = share_blog_content;
    }

    function photo_view_deal() {
        if (model.attachment.get(0).content) {
            view_text.text += model.attachment.get(0).content;
        }else{
            view_text.text += (model.page_type != 'feeds_page')?'上传照片':'';
        }

        loader.sourceComponent = photos_view;
    }

    function share_photo_view_deal() {
        view_text.text += (model.share_pr)?model.share_pr:'分享照片';
        loader.sourceComponent = share_photo_view;
    }

    function share_album_view_deal() {
        view_text.text += model.prefix;
        loader.sourceComponent = share_photo_view;
    }

    function pop_photo_win(index) {
        large_photo_view_panel.show(attachment.get(index).raw_src);
//        var tmp = Qt.createComponent("LargePhotoView.qml");
//        var tip = tmp.createObject(appWindow, {
//                                       raw_src: attachment.get(index).raw_src
//                                   });
//        tip.show();
    }

    function jmp_comment_page() {
        appWindow.pageStack.push(Qt.resolvedUrl("../CommentPage.qml"), {
                           uid: model.actor_id,
                           id: model.source_id,
                           atta_cnt: model.attachment.count,
                           media_id: (model.attachment.count)?model.attachment.get(0).media_id:null,
                           type: model.feed_type
                       });
    }

    function jmp_detail_page(){
        var param;

        switch (model.feed_type){
        case SDK.FEED_TYPE_BLOG:
        case SDK.FEED_TYPE_PAGE_BLOG:
            param = {
                uid: model.actor_id,
                id: model.source_id,
                head_url: model.headurl,
                head_content: model.name + '的日志',
                type: model.feed_type
            };
            appWindow.pageStack.push(Qt.resolvedUrl("../BlogPage.qml"), param);
            break;
        case SDK.FEED_TYPE_SHARE_BLOG:
        case SDK.FEED_TYPE_PAGE_SHARE_BLOG:
            param = {
                user_id: model.actor_id,
                source_id: model.source_id,
                uid: model.attachment.get(0).owner_id,
                id: model.attachment.get(0).media_id,
                head_url: model.headurl,
                head_content: model.name + '的分享',
                type: model.feed_type
            };
            appWindow.pageStack.push(Qt.resolvedUrl("../BlogPage.qml"), param);
            break;
        default:
            break;
        }
    }
}

