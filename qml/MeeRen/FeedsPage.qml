// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "model"
import "./UIConstants.js" as UI
import "./sdk.js" as SDK

Page {
    orientationLock: PageOrientation.LockPortrait

    SelectionDialog {
        id: selc_dlg
        titleText: "新鲜事类型"
        selectedIndex: 0
        model: FeedTypeModel{}
        onSelectedIndexChanged: {
            feeds_list_panel.type = selc_dlg.model.get(selc_dlg.selectedIndex).type;
            feeds_list_panel.model_refresh(selc_dlg.model.get(selc_dlg.selectedIndex).type, 1);
        }
    }

    SelectHeader {
        id: header
        content: selc_dlg.model.get(selc_dlg.selectedIndex).name
        onClickHeader: selc_dlg.open();
    }

    FeedsListPanel {
        id: feeds_list_panel
        anchors.fill: parent
        anchors.topMargin: UI.HEADER_HEIGHT
        type: selc_dlg.model.get(selc_dlg.selectedIndex).type
    }

    Component.onCompleted: {
        feeds_list_panel.model_load(selc_dlg.model.get(selc_dlg.selectedIndex).type, 1);
    }
}
