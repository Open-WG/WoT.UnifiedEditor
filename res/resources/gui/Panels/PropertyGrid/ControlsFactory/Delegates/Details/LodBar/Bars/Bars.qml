import QtQuick 2.7

Row {
	id: container

	readonly property bool editing: repeater.currentIndex != -1
	readonly property bool animating: {
		for (var i=0; i<repeater.count; ++i) {
			if (repeater.itemAt(i).animating) {
				return true
			}
		}
		return false
	}

	width: parent.width
	height: parent.height

	Repeater {
		id: repeater

		property int animCount: 0
		property int currentIndex: -1
		readonly property real currentItemRange: (currentIndex != -1) ? itemAt(currentIndex).relativeRange : 0

		property real duration: 500
		property int easingType: Easing.OutCubic

		model: lodbar.model
		
		Item {
			readonly property real relativeStart: model.lod.extentStart / lodbar.range
			readonly property real relativeEnd: model.lod.extentEnd / lodbar.range
			readonly property real relativeRange: relativeEnd - relativeStart

			property real expandedCoef: (repeater.currentIndex == index) ? 1 : 0
			property real collapsedCoef: (repeater.currentIndex != -1 && repeater.currentIndex != index) ? 1 : 0

			readonly property real normalW: relativeRange * (1 - (expandedCoef + collapsedCoef))
			readonly property real expandedW: 0.9 * expandedCoef
			readonly property real compressedW: 0.1 * (relativeRange / (1 - repeater.currentItemRange)) * collapsedCoef

			readonly property bool animating: anim1.running || anim2.running;

			height: parent.height
			width: parent.width * (normalW + expandedW + compressedW)

			Behavior on expandedCoef {
				NumberAnimation { id: anim1; duration: repeater.duration; easing.type: repeater.easingType }
			}

			Behavior on collapsedCoef {
				NumberAnimation { id: anim2; duration: repeater.duration; easing.type: repeater.easingType }
			}

			LodDelegate {
				id: lodDelegate
				width: parent.width
				height: parent.height

				readOnly: lodbar.readOnly
				onEditingChanged: {
					if (editing) {
						repeater.currentIndex = index
					} else if (repeater.currentIndex == index) {
						repeater.currentIndex = -1
					}
				}
			}
		}
	}
}
