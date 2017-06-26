import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "./functions.js" as JS

Panel {
    height: 80 * app.scaleFactor
    signal deleteRow()


    MouseArea {
        anchors.fill: parent
        onClicked: {
            pressedIndex = index;
            contentPanel.contentItem = 3;
        }
    }

    RowLayout {
        id: rl
        anchors.fill: parent
        anchors.margins: 3 * app.scaleFactor

        spacing: 2

        Image {
            id: photoDB
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            fillMode: Image.PreserveAspectCrop
            visible: source > ""
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: note
                font.pointSize: 20
                font.family: segoe.name
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignRight
                spacing: 3 * app.scaleFactor

                Text {
                    text: date
                    font.family: segoe.name
                    font.pointSize: 9
                    color: "grey"
                    horizontalAlignment: Text.AlignRight

                }

                FontAwesomeButton {
                    fontAwesomeCode: "\uf1f8"
                    //textSize: 25 * app.scaleFactor

                    onClicked: JS.dbDeleteRowData(index)
                }
            }
        }
    }
}
