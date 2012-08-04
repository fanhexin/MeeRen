// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    asynchronous: true
    anchors {
        left: parent.left
        right: parent.right
    }
    source: (theme.inverted)?"image://theme/meegotouch-groupheader-inverted-background":"image://theme/meegotouch-groupheader-background"
}
