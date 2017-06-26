import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Button {
    property var fontAwesomeCode : "\uf042"  //This provides a default image
    property bool buttonEnabled: true
    property string buttonColor: "#7f8c8d"
    property real textSize: 25

    style: ButtonStyle {
        background: Rectangle {
            radius: width * 0.5
            color: "transparent"
            width: 35 * app.scaleFactor
            height: width
        }
        
        label: Text {
            font.family: fontAwesome.name
            text: fontAwesomeCode
            color: buttonColor
            enabled: buttonEnabled
            
            font.pointSize: textSize
        }
    }   
}
