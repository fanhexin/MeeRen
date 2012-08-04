// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Item {
    property variant param

    property int item_cnt
    property int page_cnt: 1

    CommonList {
        id: list
        anchors.fill: parent
        delegate: BlogDelegate{}
        onDragLoadMore: {
            if (item_cnt == param.count) {
                model_load(++page_cnt);
            }
        }
        onDragRefresh: {
            page_cnt = 1;
            model_refresh(1);
        }
    }

    ScrollDecorator {
        flickableItem: list
    }

    Component.onCompleted: model_load(1)

    function model_refresh(page) {
        model_load(1, true);
    }

    function model_load(page, isNeedClear) {
        waiting_dlg.visible = true;
        var tmp = param;
        tmp.page = page;

        SDK.call("blog.gets", tmp, function(json) {
                     if (isNeedClear) list.model.clear();
                     if (json.total != "0") {
                         item_cnt = json.blogs.length;
                         for (var i in json.blogs) {
                             list.model.append({
                                                   uid: json.uid,
                                                   name: json.name,
                                                   id: json.blogs[i].id,
                                                   title: json.blogs[i].title,
                                                   content: json.blogs[i].content,
                                                   time: json.blogs[i].time
                                               });
                         }
                     }
                     waiting_dlg.visible = false;
                 });
    }
}

