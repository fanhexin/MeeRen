// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../UIConstants.js" as UI

Item {
    id: row
    height: col.height + 2*UI.BALLOON_BOX_BORDER_LEN
    property string label_text
    signal click()

    BalloonBox {
        id: balloon_box
        source: theme.inverted?"image://theme/meegotouch-list-inverted-background":
                                "image://theme/meegotouch-list-background"
    }

    Binding {
         target: balloon_box
         property: 'source'
         value: theme.inverted?"image://theme/meegotouch-list-inverted-background":
                                "image://theme/meegotouch-list-background"
         when: theme.inverted
    }

    Column {
        id: col
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: UI.BALLOON_BOX_BORDER_LEN
        }

        Loader {
            id: loader
            width: col.width
        }
    }

    Component {
        id: bubble_list_text
        Label {
            font.pixelSize: UI.FONT_SIZE_SMALLER
            text: label_text
        }
    }

    MouseArea {
        id: mouse_area
        enabled: false
        anchors.fill: parent
        onPressed: {
            balloon_box.source = theme.inverted?"image://theme/meegotouch-list-inverted-background-pressed":
                                                 "image://theme/meegotouch-list-background-pressed";
        }

        onCanceled: {
            balloon_box.source = theme.inverted?"image://theme/meegotouch-list-inverted-background":
                                                 "image://theme/meegotouch-list-background";
        }

        onReleased: {

            balloon_box.source = theme.inverted?"image://theme/meegotouch-list-inverted-background":
                                                 "image://theme/meegotouch-list-background";
            click();
        }
    }

    Component.onCompleted: {
        if (label_text) {
            add_text();
        }
    }

    function add_text() {
        loader.sourceComponent = bubble_list_text;
    }

    function set_clickable() {
        mouse_area.enabled = true;
    }

    function add_item_to_column(qml_file, param) {
        var com = Qt.createComponent(qml_file);
        com.createObject(col, param);
    }
}

