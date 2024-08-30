import QtQuick 2.11
import WGTools.PropertyGrid 1.0

Item {
	id: positioner

	property var target
	property var data

	property alias layoutHints: layoutHints
	property alias fallback: layoutHints.fallback

	readonly property bool gridMember: data && data.node.gridMember
	readonly property bool stretchingEnabled: gridMember || layoutHints.fillWidth

	function calculateWidth() {
		if (positioner.stretchingEnabled)
			return positioner.target.parent.width
		else
			return Math.min(positioner.target.implicitWidth, positioner.target.parent.width)
	}

	function calculateHeight() {
		if (layoutHints.fillHeight)
			return positioner.target.parent.height
		else
			return positioner.target.implicitHeight
	}

	function calculateX() {
		if (stretchingEnabled)
			return 0

		if (Qt.AlignLeft == (layoutHints.horizontalAlignment & Qt.AlignLeft))
			return 0

		if (Qt.AlignRight == (layoutHints.horizontalAlignment & Qt.AlignRight))
			return (positioner.target.parent.width - positioner.target.width)

		if (Qt.AlignHCenter == (layoutHints.horizontalAlignment & Qt.AlignHCenter))
			return (positioner.target.parent.width - positioner.target.width) * 0.5

		return 0
	}

	function calculateY() {
		if (layoutHints.fillHeight)
			return 0

		if (Qt.AlignTop == (layoutHints.verticalAlignment & Qt.AlignTop))
			return 0

		if (Qt.AlignBottom == (layoutHints.verticalAlignment & Qt.AlignBottom))
			return (positioner.target.parent.height - positioner.target.height)

		if (Qt.AlignVCenter == (layoutHints.verticalAlignment & Qt.AlignVCenter))
			return (positioner.target.parent.height - positioner.target.height) * 0.5

		return 0
	}

	Binding { target: positioner.target; property: "y"     ; value: calculateY()      }
	Binding { target: positioner.target; property: "x"     ; value: calculateX()      }
	Binding { target: positioner.target; property: "height"; value: calculateHeight() }
	Binding { target: positioner.target; property: "width" ; value: calculateWidth()  }
	LayoutHints {
		id: layoutHints
		source: positioner.data ? positioner.data.node.property : null
	}
}
