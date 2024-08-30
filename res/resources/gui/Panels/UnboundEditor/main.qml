import QtQuick 2.11
import QtQuick.Controls 2.4
import WGTools.Controls.Details 2.0 as Details

Item {
    id: root

	x: context.cameraPosition.x
	y: context.cameraPosition.y

	Repeater {
		model: context.selectionModel
		delegate: BoundingBox {
			color: "transparent"
			border.width: ControlsSettings.borderWidth
			border.color: _palette.color12

			Rectangle {
				color: parent.border.color
				anchors.left: parent.left
				anchors.bottom: parent.top

				height: 20 
				width: header.width

				Text {
					id: header
					padding: 4
					verticalAlignment: Text.AlignVCenter
					color: _palette.color1
					font.pixelSize: ControlsSettings.textTinySize
					text: hasData ? model.header : ""
				}
			}
		}
	}

	Repeater {
		model: context.hoverModel
		delegate: BoundingBox {
			color: Qt.rgba(1, 1, 1, 0.1)
		}
	}

	Text {
		x: -root.x
		y: -root.y + root.height - height

		padding: 8
		color: _palette.color1
		font.pixelSize: ControlsSettings.textNormalSize
		text: "Zoom: " + context.cameraZoom + "%"
	}
}
