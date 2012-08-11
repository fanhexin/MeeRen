// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "ui"
import "./Database.js" as DB

Page {
    id: main_page
    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
          id: toolIcon
          iconId: "toolbar-edit"
          onClicked: {
              var tmp = Qt.createComponent("./ui/AddStatusSheet.qml");
              var sheet = tmp.createObject(main_page);
              sheet.open();
          }
        }

        ButtonRow {
          anchors {left: toolIcon.right; right: tool_menu.left}

            platformStyle: TabButtonStyle { }
            TabButton {
                iconSource: (theme.inverted)?"./images/icon-m-toolbar-list-white.png":"./images/icon-m-toolbar-list.png"
                tab: feed_tab

            }
            TabButton {
                iconSource: (theme.inverted)?"./images/icon-m-toolbar-home-white.png":"./images/icon-m-toolbar-home.png"
                tab: home_tab
            }
            TabButton {
                iconSource: (theme.inverted)?"./images/icon-m-toolbar-people-white.png":"./images/icon-m-toolbar-people-dimmed-white.png"
                tab: friends_page
            }
        }

        ToolIcon {
            id: tool_menu
            iconId: "toolbar-view-menu";
            onClicked: setting_menu.open()
        }
    }

    Menu {
        id: setting_menu
        MenuLayout {
            MenuItem { text: "切换主题"; onClicked: {theme.inverted = !theme.inverted;console.log(theme.colorScheme);} }
            MenuItem { text: "注销授权"; onClicked: logout() }
            MenuItem { text: "关于"; onClicked: about_page_show() }
        }
    }

    TabGroup {
        id: tabGroup

        currentTab: feed_tab
        FeedsPage {
            id: feed_tab
        }
        HomePage {
            id: home_tab
        }
        FriendsPage {
            id: friends_page
        }
    }

    function logout() {
        var tmp = Qt.createComponent('./ui/AlarmDlg.qml');
        var dlg = tmp.createObject(main_page, {
                                       title_text: '警告',
                                       content_text: '是否真的要注销授权？'
                                   });
        dlg.accepted.connect(function() {
                                   DB.destory();
                                   cm.clearCookies();
                                   appWindow.pageStack.clear();
                                   appWindow.pageStack.push(Qt.resolvedUrl("./OauthPage.qml"));
                               });
        dlg.open();
    }

    function about_page_show() {
        appWindow.pageStack.push(Qt.resolvedUrl("./AboutPage.qml"));
    }
}
