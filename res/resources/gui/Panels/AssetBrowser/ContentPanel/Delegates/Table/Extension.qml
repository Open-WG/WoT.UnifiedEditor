import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

Item {
	property alias text: extent.text

	Misc.Text {
		id: extent

        anchors { verticalCenter: parent.verticalCenter; left: parent.left; right: parent.right }
		anchors.margins: 10

		elide: styleData.elideMode
		color: _palette.color2
		horizontalAlignment: styleData.textAlignment

        text: (model != null) ? model.extension : ""
	}
}