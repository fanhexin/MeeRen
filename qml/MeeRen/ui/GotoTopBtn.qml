// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: me
    width: 64
    height: 64
    visible: false
    z: 2

    signal click()

    states: [
        State {
            name: "Show"

            StateChangeScript {
                script: {
                    timer.start()
                    visible = true
                }
            }
        },
        State {
            name: "Hide"

            StateChangeScript {
                script: {
                    timer.stop()
                    visible = false
                }
            }
        }
    ]

    Image {
        anchors.fill: parent
        asynchronous: true
        opacity: 0.8
        source: "../images/totop.png"
    }

    Timer {
        id: timer
        interval: 1000
        onTriggered: {
            me.visible = false;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            me.state = "Hide";
            click();
        }
    }
}
