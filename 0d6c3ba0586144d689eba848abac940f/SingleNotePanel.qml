import QtQuick 2.0

Panel {
 panelColor: "orange"

 MouseArea {
     anchors.fill: parent
     onClicked: contentPanel.contentItem = 0
 }
}
