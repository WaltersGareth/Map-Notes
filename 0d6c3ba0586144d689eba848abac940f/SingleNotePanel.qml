import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtLocation 5.3
import QtPositioning 5.3

Panel {
    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        spacing: 5 * app.scaleFactor

        Text {
            text: databaseListModel.get(pressedIndex).note
            font.pointSize: 20
            font.family: segoe.name
            wrapMode: Text.WrapAnywhere
            Layout.fillWidth: true
            //elide: Text.ElideRight
            //maximumLineCount: 1
        }

        Image {
            source: imagesFolder.url + "//" + databaseListModel.get(pressedIndex).imageName
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true

            MouseArea {
                anchors.fill: parent
                onClicked: contentPanel.contentItem = 0;
            }
        }

        Map {
            Layout.fillWidth: true
            Layout.preferredHeight: app.width
            plugin:         Plugin {
                id: mapPlguin
                name: "esri"
            }
            center: QtPositioning.coordinate(databaseListModel.get(pressedIndex).latitude, databaseListModel.get(pressedIndex).longitude) // Oslo
            zoomLevel: 18

            MapQuickItem {
                id: geopointMarker

                coordinate {
                    latitude: databaseListModel.get(pressedIndex).latitude
                    longitude: databaseListModel.get(pressedIndex).longitude
                }

                //                anchorPoint {
                //                    x: markerImage.width/2
                //                    y: 0 //markerImage.height/2
                //                }

                sourceItem: FontAwesomeButton {
                    fontAwesomeCode: "\uf041"
                    buttonColor: "#E91E63"
                    enabled: false
                }
            }
        }

    }



    Component.onCompleted: {
        console.log("!", databaseListModel.get(pressedIndex).note, databaseListModel.get(pressedIndex).imageName)
    }
}
