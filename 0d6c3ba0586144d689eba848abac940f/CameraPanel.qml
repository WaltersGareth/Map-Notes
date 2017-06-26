import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.5

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Item {
    property alias camera: camera
    visible: false

    FileFolder {
        id: imagesFolder
        path: AppFramework.standardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                cameraPanel.visible = false;
                console.log(preview)
                textBar.photoPreview.source = preview;
                textBar.txtNote.forceActiveFocus();
                contentPanel.contentItem = 0;
            }
        }
    }

    Panel {
        anchors.fill: parent

        VideoOutput {
            source: camera
            anchors.fill: parent
            focus : visible // to receive focus and capture key events when visible
            fillMode: VideoOutput.PreserveAspectFit
            //rotation: Qt.platform.os == "ios" ? 90 : 0
            autoOrientation: true
        }

        FontAwesomeButton {
            id: captureButton
            fontAwesomeCode: "\uf192"
            buttonColor: "white"

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 5
            }

            onClicked: {
                var imagePrefix = 'mapNotes'
                var imageDate = new Date();
                var imageName = imagePrefix + "-" +
                        imageDate.getUTCFullYear().toString() +
                        zeroPad(imageDate.getUTCMonth(), 2) +
                        zeroPad(imageDate.getUTCDate(), 2) +
                        "-" +
                        zeroPad(imageDate.getUTCHours(), 2) +
                        zeroPad(imageDate.getUTCMinutes(), 2) +
                        zeroPad(imageDate.getUTCSeconds(), 2) +
                        ".jpg";

                cameraPanel.camera.imageCapture.captureToLocation(imagesFolder.filePath(imageName));
            }

            function zeroPad(num, places) {
                var zero = places - num.toString().length + 1;
                return new Array(+(zero > 0 && zero)).join("0") + num;
            }
        }

        FontAwesomeButton {
            id: cameraSwitchButton
            fontAwesomeCode: "\uf021"
            buttonColor: "white"

            anchors {
                right: parent.right
                margins: 5
            }

        }
    }
}
