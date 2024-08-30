import QtQuick 2.11

Item {
	id: item

	property alias row: row
	property alias buttons: row.children

	implicitWidth: row.implicitHeight
	implicitHeight: row.implicitHeight
	// enabled: false
	opacity: 0

	Row {
		id: row
		spacing: 5
	}

	states: State {
		name: "expanded"

		PropertyChanges {
			target: item
			implicitWidth: row.implicitWidth
			opacity: 1
			enabled: true
		}
	}

	transitions: [
		Transition {
			to: ""
			SequentialAnimation {
				PropertyAction { target: item; property: "enabled"}
				NumberAnimation { target: item; properties: "opacity, implicitWidth"; duration: 500; easing.type: Easing.OutCubic }
			}
		},
		Transition {
			from: ""
			SequentialAnimation {
				NumberAnimation { target: item; properties: "opacity, implicitWidth"; duration: 500; easing.type: Easing.OutCubic }
				PropertyAction { target: item; property: "enabled"}
			}
		}
	]
}
