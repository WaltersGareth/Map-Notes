import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Panel {
    id: configPanel


    //This is just a background graphic
    FontAwesomeButton {
        fontAwesomeCode: "\uf085"
        textSize: 250 * app.scaleFactor
        buttonColor: "#FAFAFA"

        enabled: false
        anchors{
            horizontalCenter: parent.right
            verticalCenter: parent.bottom
        }
    }
}
