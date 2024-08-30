import QtQuick 2.7
import QtQml.Models 2.2

Rectangle {
	id: root

	Accessible.name: itemDelegate.text

	default property Item itemDelegate
	property bool closable: true

	signal closeClicked()

	implicitWidth: delegateRow.width
	implicitHeight: 18

	onItemDelegateChanged: {
		if (itemsModel.count > 1)
			itemsModel.remove(0, count-1)

		if (itemDelegate)
			itemsModel.insert(0, itemDelegate)
	}

	ObjectModel {
		id: itemsModel

		MouseArea {
			Accessible.name: "Clear"
			width: height
			height: parent.height
			visible: root.closable
			enabled: root.closable
			hoverEnabled: true

			onClicked: root.closeClicked()

			Image {
				property color color: parent.containsPress
					? _palette.color12
					: parent.containsMouse
						? _palette.color1
						: _palette.color2

				source: "image://gui/icon-filters-close?color=" + encodeURIComponent(color)
				smooth: false

				anchors.centerIn: parent

				Behavior on color {
					ColorAnimation { duration: 100 }
				}
			}
		}
	}

	Row {
		id: delegateRow
		height: parent.height

		Repeater { model: itemsModel }
	}
}
