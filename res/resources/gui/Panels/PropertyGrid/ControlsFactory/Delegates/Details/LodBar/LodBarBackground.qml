import QtQuick 2.7
import "../../Settings.js" as Settings

Rectangle {
	implicitWidth: 100
	implicitHeight: Settings.extentSliderHeight
	color: "#303030"

	MouseArea {
		acceptedButtons: Qt.AllButtons
		anchors.fill: parent
	}
}
