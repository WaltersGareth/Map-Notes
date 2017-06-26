/* Copyright 2015 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4
import QtPositioning 5.3

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

App {
    id: app
    width: 400
    height: 640

    property var db: dbGetHandle()
    property real scaleFactor: AppFramework.displayScaleFactor
    property bool dbEnabled: true
    property real toolbarHeight: 50 * app.scaleFactor

    //These properties are used when the SingleNotePanel is being used.
    property int pressedIndex
    property string photoFileName

    FontLoader{
        id: segoe
        source: app.folder.fileUrl("fonts/segoeui.ttf")
    }

    FontAwesomeLoader {
        id: fontAwesome
    }

    //This sets the location for the captured pictures to be stored.
    FileFolder {
        id: imagesFolder
        path: AppFramework.standardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    }

    //This is the model used for both the main notes page and the single note page
    ListModel {
        id: databaseListModel
    }

    PositionSource {
        id: src
        updateInterval: 1000
        active: true

        onPositionChanged: {

        }
    }

    //This sets out the UI of the main page
    ColumnLayout {
        spacing:  3 * app.scaleFactor
        anchors.fill: parent

        MainBar {
            id: mainBar
            Layout.fillWidth: true
            Layout.preferredHeight: contentPanel.contentItem == 1 ? 0 : contentPanel.contentItem == 3 ? 0 : toolbarHeight
        }

        ContentPanel {
            id: contentPanel
            panelColor: "#FAFAFA"

            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        TextBar {
            id: textBar
            panelColor: "#E1F5FE"
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            Layout.preferredHeight: contentPanel.contentItem <= 1 ? toolbarHeight : 0
        }
    }

    //The following components are used to populate the contentPanel(main section)
    Component {
        id: notesComponent

        ListView {
            id: notesView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 5

            model: databaseListModel

            delegate: NoteDelegate{
                id: notesDelegate
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 3 * app.scaleFactor
                }
            }

            function initialize() {
                db.transaction(function(tx) {
                    //                    var dropResult = tx.executeSql('DROP TABLE IF EXISTS Notes');
                    //                    console.log("drop", JSON.stringify(dropResult, undefined, 2));

                    var results = tx.executeSql("CREATE TABLE IF NOT EXISTS Notes(note TEXT, date DATE, image TEXT, latitude REAL, longitude REAL, status INTEGER)");

                    console.log("initialize", JSON.stringify(results, undefined, 2));

                    dbReadAll();
                });
            }

            function dbReadAll()
            {
                db.transaction(function (tx) {
                    var results = tx.executeSql('SELECT * FROM Notes');
                    for (var i = 0; i < results.rows.length; i++) {
                        databaseListModel.append({
                                                     id: results.rows.item(i).rowid,
                                                     date: results.rows.item(i).date,
                                                     note: results.rows.item(i).note,
                                                     imageName: results.rows.item(i).image,
                                                     longitude: results.rows.item(i).longitude,
                                                     latitude: results.rows.item(i).latitude,
                                                     status: results.rows.item(i).status
                                                 })
                    }
                })
            }

            function dbAddData() {
                //Add data to notes table
                db.transaction(
                            function(tx){
                                var coord = src.position.coordinate;
                                console.log("Coordinate:", coord.longitude, coord.latitude);

                                var insertResult = tx.executeSql('INSERT INTO Notes (note, date, image, latitude, longitude, status) VALUES (?, ?, ?, ?, ?, ?)', [ textBar.txtNote.text, Date(), photoFileName, coord.latitude, coord.longitude, 1 ]);

                                db.transaction(function (tx) {
                                    var results = tx.executeSql('SELECT * FROM Notes where rowid = ' + insertResult.insertId );
                                    console.log("results length", results.rows.length);
                                    for (var i = 0; i < results.rows.length; i++) {
                                        databaseListModel.append({
                                                                     id: results.rows.item(i).rowid,
                                                                     date: results.rows.item(i).date,
                                                                     note: results.rows.item(i).note,
                                                                     imageName : results.rows.item(i).image,
                                                                     longitude: results.rows.item(i).longitude,
                                                                     latitude: results.rows.item(i).latitude,
                                                                     status: results.rows.item(i).status
                                                                 })
                                    }
                                })
                            }
                            )

                //Clean up UI
                textBar.txtNote.text = "";
                notesView.positionViewAtEnd();
                notesView.forceActiveFocus();
            }

            function dbDeleteRowData(index){
                console.log("DELETE...", index);
                db.transaction(function (tx) {
                    var results = tx.executeSql('DELETE FROM Notes where rowid = ' + index);
                    console.log("results length", results.rows.length);
                    databaseListModel.remove(index);
                })
            }

            Component.onCompleted: {
                // This connects to the textbar submit button signal and allows the dbAddRow signal to execute the append code for the list Model.
                textBar.submitted.connect(dbAddData);
                notesView.initialize();
                notesView.positionViewAtEnd();
            }
        }
    }

    Component {
        id: cameraComponent
        CameraPanel {
            id: cameraPanel
        }
    }

    Component {
        id: configComponent
        ConfigPanel {
            id: configPanel
        }
    }

    Component {
        id: singleNoteComponent
        SingleNotePanel{
            id: singleNotePanel
        }
    }

    //The following scripts are used for managing the database
    function dbGetHandle()
    {
        try {
            var db = LocalStorage.openDatabaseSync("MapNotesDB", "1.0", "Map-Notes Database", 1000000)
        } catch (err) {
            dbEnabled = false
            console.log("Error opening database: " + err)
        }

        return db
    }
}

