import QtQuick 2.7
import "../../../Common" as Common

Item {
	id: root

	implicitHeight: flow.height
	clip: true

	Flow {
		id: flow
		width: parent.width
		spacing: 5

		anchors.verticalCenter: parent.verticalCenter

		Repeater {
			id: repeater

			model: styleData.value
			delegate: Common.TagItem {
				text: modelData.name
				iconColor: modelData.color
			}
		}
	}
}
