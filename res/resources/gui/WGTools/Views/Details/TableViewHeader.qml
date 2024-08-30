import QtQuick 2.7
import WGTools.Misc 1.0 as Misc
import "ViewsSettings.js" as ViewsSettings

Rectangle {
	id: header

	property var view
	readonly property bool isCurrentColumn: (view !== undefined) && view.sortIndicatorVisible && styleData.column == view.sortIndicatorColumn

	implicitHeight: 22
	color: _palette.color8

	signal menuRequested(int column)

	Misc.Text {
		id: text
		elide: Text.ElideRight
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: styleData.textAlignment

		text: styleData.value
		color: header.isCurrentColumn ? _palette.color1 : _palette.color2

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
		anchors.right: parent.right
		anchors.rightMargin: ViewsSettings.iconMarginHeader
		anchors.left: undefined
		anchors.leftMargin: undefined
	}
	states: State {
		name: "columnTooSmall"
		AnchorChanges {
		target: sortIndicator
		anchors.left: undefined
		anchors.right: header.right
		}
		PropertyChanges {
			target: sortIndicator
			anchors.leftMargin: undefined
			anchors.rightMargin: ViewsSettings.iconMarginHeader
		}
	}
	
	onWidthChanged:{
		state = text.x + text.implicitWidth + sortIndicator.width + ViewsSettings.iconMarginHeader < header.width ?
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

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.RightButton
		propagateComposedEvents: true
		onReleased: {
			menuRequested(styleData.column)
			mouse.accepted = false
		}
	}
}
