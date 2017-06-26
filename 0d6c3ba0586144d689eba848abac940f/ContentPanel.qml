import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

Panel {
    readonly property var pageArray: [notesComponent, cameraComponent, configComponent, singleNoteComponent]
    property int contentItem : 0

    onContentItemChanged: contentItem === 0 ? stackView.pop() : stackView.push(pageArray[contentItem])

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: pageArray[0]
    }
}
