import QtQuick 2.10
import QtQml.Models 2.2
import WGTools.ControlsEx 1.0 as ControlsEx

ControlsEx.Panel {
	id: root
	title: "Import Mask"
	layoutHint: "center"

	implicitWidth: 1000
	implicitHeight: 1000

	color: "black"

	property real zoomFactor: 1

	Connections {
		target: context
		onPreviewSourceChanged:
		{
			var old = context.previewSource
			img.source = ""
			img.source = old
		}
	}

	MouseArea {
		anchors.fill: parent
		onWheel: {
				let delta = Math.round((wheel.angleDelta.y == 0 ? wheel.angleDelta.x : wheel.angleDelta.y) / 120)
				if((delta > 0 && root.zoomFactor <= 2) || (delta < 0 && root.zoomFactor >= 0.5))
				{
					root.zoomFactor += delta*0.04;
				}
			}
		cursorShape: flickableItem.dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
	}

	Flickable {
		id: flickableItem
		
		anchors.fill: parent

		contentWidth: width * zoomFactor
		contentHeight: height * zoomFactor
		
		Image {
			id: img
			cache: false
			source: context.previewSource
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			width: flickableItem.contentWidth
			height: flickableItem.contentHeight
			fillMode: Image.PreserveAspectFit
		}
	}
}
