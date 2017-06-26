import QtQuick 2.0

Panel {
    panelColor: "orange"

    MouseArea {
        anchors.fill: parent
        onClicked: contentPanel.contentItem = 0;

    }

    Component.onCompleted: {
        console.log("!", listModel.get(pressedIndex).note, listModel.get(pressedIndex).imageName)
    }
}
