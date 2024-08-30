import QtQuick 2.7
import QtQuick.Layouts 1.11
import WGTools.Misc 1.0
import WGTools.Controls 2.0

Item
{
	implicitWidth: text.implicitWidth
	implicitHeight: text.implicitHeight

	Rectangle
	{
		anchors.fill: parent

		color: "#400000"

		TextEdit {
			id: text
			text: $error
			readOnly: true

			anchors.fill: parent

			color: "#c0c0c0"
			selectedTextColor: "#ffffff"
			selectionColor: "#ff0000"
		}
	}
}
