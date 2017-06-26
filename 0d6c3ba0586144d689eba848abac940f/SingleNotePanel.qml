import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtLocation 5.3
import QtPositioning 5.3

Panel {
    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
        }

        spacing: 5 * app.scaleFactor

        TextEdit {
            text: databaseListModel.get(pressedIndex).note
            font.pointSize: 20
            font.family: segoe.name
            wrapMode: Text.WrapAnywhere
            Layout.fillWidth: true
            enabled: false //Allow user to edit the note. and then obviously handle the code to update.

        }

        Image {
            source: imagesFolder.url + "//" + databaseListModel.get(pressedIndex).imageName
            fillMode: Image.PreserveAspectFit
            Layout.fillWidth: true
        }

        Map {
            Layout.fillWidth: true
            Layout.preferredHeight: width
            enabled: false
            plugin: Plugin {
                id: mapPlguin
                preferred: ["ArcGIS"]
            }

            center: QtPositioning.coordinate(databaseListModel.get(pressedIndex).latitude, databaseListModel.get(pressedIndex).longitude)
            zoomLevel: 18

            MapQuickItem {
                id: geopointMarker

                coordinate {
                    latitude: databaseListModel.get(pressedIndex).latitude
                    longitude: databaseListModel.get(pressedIndex).longitude
                }

                anchorPoint {
                    x: marker.width/2
                    y: marker.height
                }

                sourceItem: FontAwesomeButton {
                    id: marker
                    fontAwesomeCode: "\uf041"
                    buttonColor: "#E91E63"
                    buttonEnabled: false
                    textSize: 35 * app.scaleFactor
                }
            }
        }

    }

    Component.onCompleted: {
        console.log("!", databaseListModel.get(pressedIndex).note, databaseListModel.get(pressedIndex).imageName)
    }
}
