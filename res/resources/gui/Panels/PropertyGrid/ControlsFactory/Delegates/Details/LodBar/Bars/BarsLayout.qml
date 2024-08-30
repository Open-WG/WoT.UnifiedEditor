import QtQuick 2.7

Item {
	id: root

	property alias model: repeater.model
	property string rangeName

	property Component delegate

	property int currentIndex: -1

	property real maxCurrentItemRange: 0.9

	property real aminDuration: 500
	property int aminEasingType: Easing.OutCubic

	Row {
		anchors.fill: parent

		Repeater {
			id: repeater

			property Item currentItem: repeater.itemAt(root.currentIndex)
			readonly property real currentItemRange: 0.9

			FocusScope {
				id: lodItem

				readonly property int itemIndex: index
				readonly property var itemModel: typeof model !== "undefined" ? model : null

				readonly property real rangeStart: itemModel ? itemModel[root.rangeName + "Start"] : 0
				readonly property real rangeEnd: itemModel ? itemModel[root.rangeName + "End"] : 0
				readonly property real range: rangeEnd - rangeStart

				readonly property bool isCurrentItem: lodItem == repeater.currentItem

				property real rangeFactor: root.currentIndex != -1
					? isCurrentItem
						? repeater.currentItemRange / range
						: (1 - repeater.currentItemRange) / (1 - repeater.currentItem.range)
					: 1

				property real visualRange: range

				activeFocusOnTab: false
				width: parent.width * range * rangeFactor; //visualRange
				height: parent.height

				// states: [
				// 	State {
				// 		when: repeater.currentItem == lodItem

				// 		PropertyChanges {
				// 			target: lodItem
				// 			visualRange: 0.9
				// 		}
				// 	},
				// 	State {
				// 	 	when: (repeater.currentItem != null) && (repeater.currentItem != lodItem)

				// 		PropertyChanges {
				// 			target: lodItem
				// 			visualRange: range * ((1 - repeater.currentItem.visualRange) / (1 - repeater.currentItem.range))
				// 		}
				// 	}
				// ]

				// transitions: Transition {
				// 	NumberAnimation { property: "visualRange"; duration: root.aminDuration; easing.type: root.aminEasingType }
				// }

				Behavior on rangeFactor {
					NumberAnimation { duration: root.aminDuration; easing.type: root.aminEasingType }
				}

				Loader {
					id: loader
					sourceComponent: root.delegate
					focus: true

					readonly property alias index: lodItem.itemIndex
					readonly property alias model: lodItem.itemModel

					anchors.fill: parent
				}
			}
		}
	}
}
