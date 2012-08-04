// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    id: row
    height: col.height
    property alias label_text: content.text

    SeparatorVline {
        height: parent.height
    }

    Column {
        id: col
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: UI.BALLOON_BOX_BORDER_LEN
        }

        Label {
            id: content
            visible: content.text
            width: col.width
            font.pixelSize: UI.FONT_SIZE_SMALLER
        }

        Loader {
            id: loader
            width: col.width
        }
    }

    function add_item_to_column(qml_file, param) {
        var com = Qt.createComponent(qml_file);
        return com.createObject(col, param);
    }
}

