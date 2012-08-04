// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    height: (UI.HEAD_PIC_WIDTH > comment_content.height)?UI.HEAD_PIC_WIDTH+UI.NORMAL_MARGIN*2:comment_content.height+UI.NORMAL_MARGIN*2
    width: parent.width
    property string head_url: (model.headurl)?model.headurl:model.tinyurl
    property string comment_detail: (model.content)?model.content:model.text
    signal pressHold(int uid, string name)

    BorderImage {
        anchors.fill: parent
        asynchronous: true
        visible: mouse_area.pressed
        source: (theme.inverted)?"image://theme/meegotouch-list-inverted-background-pressed-center":"image://theme/meegotouch-list-background-pressed-center"
    }

    ImageWithProcess {
        id: head_img
        width: UI.HEAD_PIC_WIDTH
        height: UI.HEAD_PIC_WIDTH
        anchors {
            top: parent.top
            left: parent.left
            margins: UI.NORMAL_MARGIN
        }
        source: head_url
    }

    Label {
        id: comment_content
        anchors {
            top: parent.top
            left: head_img.right
            right: parent.right
            margins: UI.NORMAL_MARGIN
        }
        text: '<p style="color:steelblue">'+model.name+'</p>'+'<p>'+comment_detail+'</p>'+
              '<p style="font-size:20px;">'+model.time+'</p>'
        wrapMode: "WordWrap"
    }

    SeparatorLine {
        anchors.top: parent.bottom
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        onPressAndHold: {
            pressHold(model.uid, model.name);
        }
    }

}
