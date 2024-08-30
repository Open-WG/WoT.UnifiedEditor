import QtQuick 2.11
import QtQuick.Layouts 1.4
import WGTools.Controls 2.0

Rectangle {
    id: root
    color: _palette.color8

    border {
		width: 1
		color: _palette.color10
	}

    implicitWidth: 250
    implicitHeight: 100

    readonly property int totalTime: 60
    property int timeout: context.remainingTime()

    Column {
        anchors.centerIn: parent
        spacing: 10

        Label {
            id: label
            text: root.timeout + (root.timeout == 1 ? " second" : " seconds") + " left untill autosave"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        ProgressBar {
            value: 1 - timeout / totalTime
            anchors.horizontalCenter: parent.horizontalCenter
        }

        RowLayout {
            width: parent.width
            spacing: 5

            Button {
                id: ok
                text: "Save now"
                implicitWidth: 98
                Layout.alignment: Qt.AlignLeft

                onClicked: context.saveNow()
             }

            Button {
                id: cancel
                text: "Cancel save"
                implicitWidth: 98
                Layout.alignment: Qt.AlignRight

                onClicked: context.cancelSave()
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        onTriggered: {
            root.timeout = context.remainingTime()
            restart()
        }
    }
}