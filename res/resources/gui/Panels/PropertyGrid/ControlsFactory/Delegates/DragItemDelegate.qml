import QtQuick 2.11
import QtQuick.Layouts 1.3
import WGTools.Controls 2.0
import WGTools.Misc 1.0 as Misc
import WGTools.PropertyGrid 1.0
import WGTools.Utils 1.0

import "Settings.js" as Settings

DragItemDelegate {
	id: control

	property var model // TODO: consider implement context property "model"

	propertyData: model ? model.node.property : null

	implicitWidth: text.width
	implicitHeight: text.height

	Misc.Text {
		id: text
		leftPadding: control.indicator && control.indicator.visible ? control.indicator.width + control.spacing : 0
		color: control.hovered ? _palette.color1 : _palette.color2
		text: "Drag to Move, ALT+Drag to Copy"
	
		verticalAlignment: Text.AlignVCenter
		font.bold: true
	}

	Drag.dragType: Drag.Automatic
	Drag.supportedActions: Qt.CopyAction | Qt.MoveAction
	Drag.proposedAction: Qt.CopyAction
	Drag.active: dragArea.drag.active
	Drag.hotSpot: Qt.point(dragView.width * 0.8, dragView.height * 0.8)
	Drag.mimeData: mimeData

	Image {
		id: dragView
		visible: false
		source: parent.imageSource
	}

	MouseArea {
		id: dragArea
		anchors.fill: parent
		drag.target: dragView
		onPressed: dragView.grabToImage(function(result) {
			parent.Drag.imageSource = result.url
		})
	}
}
