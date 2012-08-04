// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Sheet {
    id: publish_sheet
    property alias head_title: title_label.text
    property alias content_text: publish_content.text
    property alias tool_bar: toolBar.tools
    signal accept(string msg)

    acceptButtonText: "发布"
    rejectButtonText: "取消"

    title: Label{
        id: title_label
        anchors.centerIn: parent
        text:'添加评论'
    }

    content: Item {
        anchors.fill: parent
        TextArea {
            id: publish_content
            height: parent.height - toolBar.height - 3
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
        }

        ToolBar {
             id: toolBar
             anchors.bottom: parent.bottom
         }
    }

    onStatusChanged: {
        if (publish_sheet.status == 1) {
            publish_content.forceActiveFocus();
        }
    }

    onAccepted: accept(publish_content.text)
//    onRejected: label.text = "Rejected!"
}
