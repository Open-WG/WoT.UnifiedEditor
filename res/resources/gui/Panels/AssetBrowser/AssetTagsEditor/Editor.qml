import QtQuick 2.10
import WGTools.Controls 2.0

Popup {
	id: control

	property var backend

	width: 250
	height: Math.min(250, implicitHeight)
	modal: true
	focus: true
	contentItem: EditorContent {}
}
