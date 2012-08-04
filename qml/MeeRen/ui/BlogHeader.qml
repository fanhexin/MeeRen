// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    property alias head_src: header_pic.source
    property alias head_text: blog_title.text

    height: blog_title.height+2*UI.NORMAL_MARGIN+sline_top.height+sline_bottom.height

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    SeparatorLine {
        id: sline_top
        anchors.top: parent.top
    }

    Image {
        id: header_pic
        anchors {
            top: parent.top
            left: parent.left
            margins: UI.NORMAL_MARGIN
        }
    }

    Label {
        id: blog_title
        anchors {
            top: parent.top
            left: header_pic.right
            right: parent.right
            margins: UI.NORMAL_MARGIN
        }
        wrapMode: "WordWrap"
    }

    SeparatorLine {
        id: sline_bottom
        anchors.top: parent.bottom
    }
}
