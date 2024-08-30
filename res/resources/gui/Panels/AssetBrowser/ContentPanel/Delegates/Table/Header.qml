import QtQuick 2.7
import WGTools.Misc 1.0 as Misc

//TODO: This file doesn't use. Check it and if it's true, delete it.
Rectangle {
	id: header

	property var view
	readonly property bool isCurrentColumn: (view !== undefined) && view.sortIndicatorVisible && styleData.column == view.sortIndicatorColumn

	implicitHeight: 22
	color: _palette.color8

	Misc.Text {
		id: text
		elide: Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: styleData.textAlignment

		text: styleData.value
		color: header.isCurrentColumn ? _palette.color1 : _palette.color2

		font.bold: header.isCurrentColumn

		anchors.fill: parent
		anchors.right: sortIndicator.visible ? sortIndicator.left : parent.right
		anchors.leftMargin: (horizontalAlignment == Text.AlignLeft) ? 12 : 0
		anchors.rightMargin: (horizontalAlignment == Text.AlignRight) ? 8 : 0
	}

	Image {
		id: sortIndicator
		source: "image://gui/icon-sort-order?color=" + encodeURIComponent(_palette.color2)
		visible: header.isCurrentColumn
		rotation: (view !== undefined) && (view.sortIndicatorOrder === Qt.AscendingOrder) ? 0 : 180

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: text.left
		anchors.leftMargin: text.implicitWidth + 6
		anchors.right: undefined
		anchors.rightMargin: undefined
	}

	states: State{
		name: "columnTooSmall"
		AnchorChanges {
			target: sortIndicator
			anchors.left: undefined
			anchors.right: header.right
		}
		PropertyChanges {
			target: sortIndicator
			anchors.leftMargin: undefined
			anchors.rightMargin: 6
		}
	}

	onWidthChanged:{
		state = text.x + text.implicitWidth + sortIndicator.width + 6 < header.width ?
		"": "columnTooSmall"
	}

	Misc.OptionalBorders {
		color: _palette.color9
		thickness: 1
		topVisible: false
		rightVisible: false
		leftVisible: styleData.column != 0

		anchors.fill: parent
	}
}
