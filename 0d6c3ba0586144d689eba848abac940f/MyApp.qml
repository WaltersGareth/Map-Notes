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

    FontLoader{
        id: segoe
        source: app.folder.fileUrl("fonts/segoeui.ttf")
    }

    FontAwesomeLoader {
        id: fontAwesome
    }

    ColumnLayout {
        spacing:  3 * app.scaleFactor
        anchors.fill: parent

        MainBar {
            id: mainBar
            Layout.fillWidth: true
            Layout.preferredHeight: contentPanel.contentItem !== 1 ? toolbarHeight : 0
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
            //Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredHeight: contentPanel.contentItem !== 2 ? toolbarHeight : 0
        }
    }

    Component {
        id: notesComponent

        ListView {
            id: notesView

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 5


            model: ListModel{
                id: listModel
                Component.onCompleted: {
                    initialize();
                    notesView.positionViewAtEnd();
                }
            }
            delegate: NoteDelegate{
                id: notesDelegate
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 3 * app.scaleFactor
                }
                onDeleteRow: {
                    console.log("DELETE...", index);
                    db.transaction(function (tx) {
                        var results = tx.executeSql('DELETE FROM Notes where rowid = ' + index);
                        console.log("results length", results.rows.length);
                        listModel.remove(index);
                    })
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
                        listModel.append({
                                             id: results.rows.item(i).rowid,
                                             date: results.rows.item(i).date,
                                             note: results.rows.item(i).note,
                                             //imageName: results.rows.item(i).image
                                             status: results.rows.item(i).status
                                         })
                    }
                })
            }

            function dbAddData() {
                //Add data to notes table
                db.transaction(
                            function(tx){
                                var insertResult = tx.executeSql('INSERT INTO Notes (note, date, status) VALUES (?, ?, ?)', [ textBar.txtNote.text, Date(), 1 ]);

                                db.transaction(function (tx) {
                                    var results = tx.executeSql('SELECT * FROM Notes where rowid = ' + insertResult.insertId );
                                    console.log("results length", results.rows.length);
                                    for (var i = 0; i < results.rows.length; i++) {
                                        listModel.append({
                                                             id: results.rows.item(i).rowid,
                                                             date: results.rows.item(i).date,
                                                             note: results.rows.item(i).note,
                                                             //imageName : results.rows.item(i).image,
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

            Component.onCompleted: {
                // This connects to the textbar submit button signal and allows the dbAddRow signal to execute the append code for the list Model.
                textBar.submitted.connect(dbAddData);
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

    function dbGetHandle()
    {
        try {
            var db = LocalStorage.openDatabaseSync("DateNoteDB", "1.0", "DateNote Database", 1000000)
        } catch (err) {
            dbEnabled = false
            console.log("Error opening database: " + err)
        }

        return db
    }
}

