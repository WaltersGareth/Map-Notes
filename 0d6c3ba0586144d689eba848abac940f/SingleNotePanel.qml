import QtQuick 2.0
import QtQuick.Layouts 1.1

Panel {
    panelColor: "orange"

    ColumnLayout {
        anchors.fill: parent
        spacing: 5 * app.scaleFactor

        Text {
            text: databaseListModel.get(pressedIndex).note
        }

        Image {
            source: imagesFolder.url + "//" + databaseListModel.get(pressedIndex).imageName || null
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
        }

        /*
        Text {
            text: databaseListModel.get(pressedIndex).longitude || 0
        }

        Text {
            text: databaseListModel.get(pressedIndex).latitude || 0
        }

        add Map Component here

        */

    }

    MouseArea {
        anchors.fill: parent
        onClicked: contentPanel.contentItem = 0;
    }

    Component.onCompleted: {
        console.log("!", databaseListModel.get(pressedIndex).note, databaseListModel.get(pressedIndex).imageName)
    }
}
