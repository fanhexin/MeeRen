// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI
import "../sdk.js" as SDK

Item {
    property string uid

    Flickable {
        anchors.fill: parent
        anchors.margins: UI.NORMAL_MARGIN
        clip: true
        contentHeight: content.height
        Label {
            width: parent.width
            id: content
        }
    }

    Component.onCompleted: model_load()

    function model_load() {
        waiting_dlg.visible = true;
        var param = {
            uids: uid,
            fields: "sex,birthday,hometown_location,work_history,university_history"
        };

        SDK.call('users.getInfo', param, function(json) {
                     with (json[0]) {
                         var gender = (sex)?'男':'女';
                         content.text = html_line('性别', gender)+
                                        html_line('生日', birthday)+
                                        html_line('家乡', hometown_location.province+hometown_location.city);

                         if (university_history) {
                             for (var i in university_history) {
                                 content.text += html_line('大学', university_history[i].name+'-'+
                                                           university_history[i].year+'-'+
                                                           university_history[i].department);
                             }

                         }

                         if (work_history) {
                             for (var i in work_history) {
                                 content.text += html_line('高中', work_history[i].company_name+'-'+work_history[i].start_date+'~'+work_history[i].end_date);
                             }
                         }
                     }

                     waiting_dlg.visible = false;
                 });
    }

    function html_line(key, value) {
        if (!value)
            return '';
        return '<p><span style="font:bold;">'+key+': </span>'+value+'</p>';
    }
}

