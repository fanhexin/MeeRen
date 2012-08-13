// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Item {
    property string uid
    property string page_type: 'feeds_page'
    property string type

    property int item_cnt
    property int page_cnt: 1
    property int default_page_count: 30

    CommonList {
        id: feed_list
        anchors.fill: parent
        delegate: FeedDelegate{}
        onDragLoadMore: {
            if (item_cnt == default_page_count) {
                model_load(type, ++page_cnt);
            }
        }
        onDragRefresh: {
            page_cnt = 1;
            model_refresh(type, 1);
        }
    }

    ScrollDecorator {
        flickableItem: feed_list
    }

    function model_refresh(type, page) {
        model_load(type, page, true);
    }

    function model_load(type, page, isNeedClear)
    {
        var param = {
            type: type,
            page: page
        };
        if (uid) param.uid = uid;

        waiting_dlg.visible = true;
        SDK.call("feed.get", param, function(json) {
                     item_cnt = json.length;
                     if (isNeedClear) feed_list.model.clear();
                     for (var i in json){

                         //屏蔽带有视频的日志新鲜事
                         if ((json[i].feed_type == SDK.FEED_TYPE_PAGE_BLOG || json[i].feed_type == SDK.FEED_TYPE_BLOG)
                                 && json[i].attachment.length)
                             continue;

                         feed_list.model.append({
                                         feed_type: json[i].feed_type,
                                         headurl: json[i].headurl,
                                         name: json[i].name,
                                         title: json[i].title,
                                         message: json[i].message,
                                         description: json[i].description,
                                         prefix: json[i].prefix,
                                         source: json[i].source,
                                         attachment: json[i].attachment,
                                         update_time: json[i].update_time,
                                         actor_id: json[i].actor_id,
                                         actor_type: json[i].actor_type,
                                         source_id: json[i].source_id,
                                         share_pr: (json[i].trace)?json[i].trace.text:null,
                                         comments: json[i].comments,
                                         href: json[i].href,
                                         page_type: page_type
                                     });
                     }
                     waiting_dlg.visible = false;
                 });
    }
}
