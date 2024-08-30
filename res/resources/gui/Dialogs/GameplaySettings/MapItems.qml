import QtQuick 2.11
import WGTools.GameplaySettings 1.0
import "Details" as Details

Item {
	id: root
	property var settings: null
	property var changesController: null

	clip: true

	onChangesControllerChanged: {
		settings.changesController = context.changesController
	}

	Repeater {
		id: repeater
		model: settings ? settings.model : null

		Rectangle {
			property var position: Qt.point(x, y)
			property var halfWidth: width / 2
			property var halfHeight: height / 2
			property bool selected: settings.selectedIndex == index
			property bool inited: false

			x: modelData.position.x * root.width - halfWidth
			y: (1.0 - modelData.position.y) * root.height - halfHeight

			width: 48
			height: 48
			visible: modelData.visible || selected

			// Selection frame
			color: "transparent"
			border.color: selected ? _palette.color12 : "transparent"
			border.width: 2

			function updatePosition(commit) {
				if (!inited) {
					inited = true
					return
				}
	
				if (!selected)
					return

				var x = (position.x + halfWidth) / root.width
				var y = 1.0 - (position.y + halfHeight) / root.height
				
				settings.setItemPosition(index, x, y, commit)
			}

			onPositionChanged: updatePosition(false)

			Image {
				source: "../../../maps/mmap/icons/" + modelData.icon
				anchors.fill: parent
				opacity: !modelData.visible && selected ? 0.5 : 1
			}

			MouseArea {
				anchors.fill: parent
				drag.target: !modelData.frozen ? parent : undefined
				hoverEnabled: true

				drag.minimumX: -halfWidth
				drag.maximumX: root.width - halfWidth
				drag.minimumY: -halfHeight
				drag.maximumY: root.height - halfHeight

				onPressed: {
					settings.selectedIndex = index
				}

				onReleased: {		
					if (drag.active)
						updatePosition(true)
				}
			}
		}
    }	
}
