function dbGetHandle(){
    try {
        var db = LocalStorage.openDatabaseSync("MapNotesDB", "1.0", "Map-Notes Database", 1000000)
    } catch (err) {
        dbEnabled = false
        console.log("Error opening database: " + err)
    }

    return db
}

function initialize(){
    db.transaction(function(tx) {
        //                    var dropResult = tx.executeSql('DROP TABLE IF EXISTS Notes');
        //                    console.log("drop", JSON.stringify(dropResult, undefined, 2));

        var results = tx.executeSql("CREATE TABLE IF NOT EXISTS Notes(note TEXT, date DATE, image TEXT, latitude REAL, longitude REAL, status INTEGER)");

        console.log("initialize", JSON.stringify(results, undefined, 2));

        dbReadAll();
    });
}

function dbReadAll(){
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

function dbAddData(){
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
