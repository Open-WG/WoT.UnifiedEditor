import QtQuick 2.11

Item {
	id: root
	property Text target

	states: State {
		name: "valid"
		when: root.target != null

		PropertyChanges {
			target: root
			implicitWidth: root.target.contentWidth
			implicitHeight: root.target.contentHeight

			x: switch (root.target.horizontalAlignment) {
				case Text.AlignRight:   return (root.target.width - width) - root.target.rightPadding
				case Text.AlignHCenter: return root.target.leftPadding + (root.target.width - width) / 2
				default:                return root.target.leftPadding
			}

			y: switch (root.target.verticalAlignment) {
				case Text.AlignBottom:  return (root.target.height - height) - root.target.bottomPadding
				case Text.AlignVCenter: return root.target.topPadding + (root.target.height - height) / 2
				default:                return root.target.topPadding
			}
		}
	}
}
