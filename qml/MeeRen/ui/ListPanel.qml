// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Item {
    property string method
    property variant param
    property alias delegate: list.delegate
    property alias model: list.model

    property int item_cnt
    property int page_cnt: 1

    ListModel {
        id: list_model
    }

    CommonList {
        id: list
        anchors.fill: parent
        model: list_model
        onDragLoadMore: {
            if (item_cnt == param.count) {
                model_load(++page_cnt);
            }
        }
        onDragRefresh: {
            page_cnt = 1;
            model_refresh(1);
        }

        //keyNavigationWraps: true
    }

    ScrollDecorator {
        flickableItem: list
    }

//    Component.onCompleted: model_load(1)

    function model_refresh(page) {
        model_load(1, true);
    }

    function model_load(page, isNeedClear) {
        waiting_dlg.visible = true;
        var tmp = param;
        tmp.page = page;

        SDK.call(method, tmp, function(json) {
                     item_cnt = json.length;
                     if (isNeedClear) list.model.clear();

                     for(var i in json) {
                         list.model.append(json[i]);
                     }

                     waiting_dlg.visible = false;
                 });
    }

    function modify_model(model) {
        list.model = model;
    }

    function recover_model() {
        list.model = list_model;
    }

    function set_dragable(flag) {
        list.set_dragable(flag);
    }
}
