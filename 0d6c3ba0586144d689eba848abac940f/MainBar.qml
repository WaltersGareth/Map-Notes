import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Panel {
    panelColor: "#1abc9c"
//    anchors {
//        left: parent.left
//        right: parent.right
//        top: parent.top
//        margins: 3 * app.scaleFactor
//    }

    RowLayout {
        anchors.fill: parent

        spacing: 5

        Item {
            Layout.fillWidth: true
        }

        FontAwesomeButton {
            id: uploadButton
            fontAwesomeCode: "\uf0ee"
            buttonColor: "#FAFAFA"
            enabled: false

        }

        FontAwesomeButton{
            id: configButton
            fontAwesomeCode: "\uf085"
            buttonColor: "#FAFAFA"

            onClicked: contentPanel.contentItem === 0 ?  contentPanel.contentItem = 2 : contentPanel.contentItem = 0
        }
    }
    
    
}
