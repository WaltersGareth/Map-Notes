import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Panel {
    property alias photoPreview: photoPreview
    property alias txtNote: txtNote
    property string imagePrefix: "MapNotes"

    signal submitted()

    RowLayout {
        id: textBar
        anchors.fill: parent

        FontAwesomeButton {
            id: accessCameraButton
            fontAwesomeCode: "\uf083"

            onClicked: {
                contentPanel.contentItem === 0 ?  contentPanel.contentItem = 1 : contentPanel.contentItem = 0
            }
        }


        RowLayout { //ColumnLayout {
            Layout.fillWidth: true
            Image {
                id: photoPreview
                Layout.preferredHeight: 35 * app.scaleFactor
                Layout.preferredWidth: 35 * app.scaleFactor
                fillMode: Image.PreserveAspectFit
                visible: source > ""

            }
            TextEdit {
                id: txtNote
                Layout.fillWidth: true
                font.pointSize: 14
                wrapMode: TextEdit.Wrap
            }
        }

        FontAwesomeButton{
            fontAwesomeCode: "\uf1d8"
            buttonEnabled: txtNote.text > ""

            onClicked: {submitted(); console.log(photoPreview.source)}
        }

    }
}

