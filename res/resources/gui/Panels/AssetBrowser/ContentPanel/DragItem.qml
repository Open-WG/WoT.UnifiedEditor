import QtQuick 2.7
import QtGraphicalEffects 1.0
import WGTools.Resources 1.0 as WGTResources

OpacityMask  {
	id: dragItem

	property bool active: false
	property alias icon: dragItem.source
	property var files

	maskSource: dragMask

	visible: false
	width: icon ? icon.width : undefined
	height: icon ? icon.height : undefined

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
			// set file(s)
			dragItem.Drag.mimeData = {
				"text/uri-list": WGTResources.Resources.fileNameToUrl(files)
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
			GradientStop { position: 0.0; color: "#60FFFFFF" }
			GradientStop { position: 1.0; color: "#00000000" }
		}

		anchors.fill: parent
	}
}

