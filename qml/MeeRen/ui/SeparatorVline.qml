// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    asynchronous: true
//    anchors {
//        top: parent.top
//        bottom: parent.bottom
//    }

    source: (theme.inverted)?"image://theme/meegotouch-separator-inverted-background-vertical":"image://theme/meegotouch-separator-background-vertical"
}
