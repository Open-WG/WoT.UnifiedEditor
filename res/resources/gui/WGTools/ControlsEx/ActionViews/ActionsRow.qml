import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
	id: root
	
	default property list<Action> actions

	property alias delegate: repeater.delegate
	property alias spacing: layout.spacing

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight
	
	data: Row {
		id: layout

		Repeater {
			id: repeater
			model: root.actions
		}
	}
}
