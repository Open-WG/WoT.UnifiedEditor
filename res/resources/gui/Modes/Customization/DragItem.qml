import QtQuick 2.7
import QtGraphicalEffects 1.0

OpacityMask {
	id: dragItem

	property bool active: false
	property var payload

	maskSource: dragMask

	visible: false
	width: source ? source.width : undefined
	height: source ? source.height : undefined

	Accessible.ignored: true

	Drag.dragType: Drag.Automatic
	Drag.supportedActions: Qt.CopyAction
	Drag.proposedAction: Qt.CopyAction
	Drag.hotSpot: Qt.point(width * 0.8, height * 0.8)

	onActiveChanged: {
		if (dragItem.Drag.active == active) {
			return
		}

		if (active) {
			dragItem.Drag.mimeData = {
				"application/x-wg-customization-element": dragItem.payload
			}

			// set image
			let r = false
			if (width > 0 && height > 0)
			{
				r = dragItem.grabToImage(function(result) {
					dragItem.Drag.imageSource = result.url
					dragItem.Drag.active = true
				})
			}

			if (!r)
			{
				dragItem.Drag.imageSource = ""
				dragItem.Drag.active = true
			}
		}
		else {
			dragItem.Drag.active = false
			dragItem.Drag.mimeData = {}
			dragItem.Drag.imageSource = ""
		}
	}

	RadialGradient {
		id: dragMask
		visible: false
		horizontalRadius: width
		verticalRadius: height

		gradient: Gradient {
			GradientStop { position: 0.0; color: "#80000000" }
			GradientStop { position: 1.0; color: "#10000000" }
		}

		anchors.fill: parent
	}
}