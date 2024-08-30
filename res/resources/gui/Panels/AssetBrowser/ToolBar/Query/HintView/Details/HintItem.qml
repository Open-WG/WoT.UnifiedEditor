import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Views.Details 1.0 as ViewDetails

ItemDelegate {
	id: control

	property var factory
	property bool viewable: false

	padding: 0
	topPadding: 0
	bottomPadding: 0
	rightPadding: 0
	leftPadding: 0

	onViewableChanged: {
		if (viewable) {
			var properties = {
				index: index,
				model: (typeof model !== "undefined") ? model : modelData,
				width: control.availableWidth,
				height: control.availableHeight
			}

			factory.createObject(control.contentItem, properties)
		}
		else if (control.contentItem.children.length) {
			factory.removeObject(control.contentItem.children[0])
		}
	}

	background: ViewDetails.RowDelegate {
		implicitHeight: ViewsSettings.rowDelegateHeight
		height: parent.height

		property QtObject styleData: QtObject {
			readonly property bool selected: control.highlighted
			readonly property bool hovered: control.hovered
		}
	}
}
