import QtQuick 2.10
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import WGTools.Style 1.0
import "../Preview"
import "../TextureProperties"
import "Script.js" as Script
import "../../../Settings.js" as Settings
import WGTools.Utils 1.0

Window {
	id: window
	property alias model: grid.model
	property alias settings: grid.settings
	readonly property int shadowBorder: ControlsSettings.popupShadow1Radius
	width: column.width + shadowBorder * 2
	height: column.height + shadowBorder * 2
	color: "transparent"

	flags: Qt.ToolTip | Qt.WindowTransparentForInput | Qt.WindowStaysOnTopHint

	signal clicked(int index)
	signal doubleClicked(int index)

	PopupBackground {
		id: popupBackground
		anchors.fill: column
	}

	Rectangle {
		id: mask
		anchors.fill: column
		color: "transparent"
		visible: false

		Rectangle {
			anchors.fill: parent
			anchors.margins: 1
			radius: ControlsSettings.radius
		}
	}

	Column {
		id: column
		anchors.centerIn: parent

		Grid {
			id: grid

			property alias model: repeater.model
			property PreviewSettings settings

			spacing: repeater.count > 1 ? ControlsSettings.spacing : 0
			columns: 2

			readonly property bool showNumbers : repeater.count > 1

			Repeater {
				id: repeater

				delegate: PreviewDelegate {
					source: model
					settings: grid.settings

					title.text: Script.getImageTitleText(model.imageSide)
					title.color: _palette["axisColor" + Math.floor(model.imageSide / 2)]
					title.visible: repeater.count > 1

					onClicked: window.clicked(index)
					onDoubleClicked: window.doubleClicked(index)
				}
			}
		}

		Text {
			text: textureProperties.fileName.split("/").pop()
			color: _palette.color1
			font.pixelSize: ControlsSettings.textNormalSize
			elide: Text.ElideMiddle
			leftPadding: ControlsSettings.doublePadding
			rightPadding: leftPadding
			topPadding: leftPadding
			bottomPadding: ControlsSettings.padding
			width: grid.width
			Style.class: "text-bold"
		}

		Text {
			text: textureProperties.fileName.split("/").slice(0, -1).join("/")
			color: _palette.color2
			font.pixelSize: ControlsSettings.textTinySize
			elide: Text.ElideMiddle
			width: grid.width
			leftPadding: ControlsSettings.doublePadding
			rightPadding: leftPadding
		}

		TextureProperties {
			id: textureProperties
			width: grid.width
			fileName: model.fileName
		}

		layer.enabled: true
		layer.effect: OpacityMask {
			anchors.fill: mask
			source: column
			maskSource: mask
		}
	}

	function updatePosition(component) {
		grid.forceLayout()
		textureProperties.forceLayout()
		column.forceLayout()
		let pos = component.mapToGlobal(0, component.height / 2)
		x = pos.x - column.width - shadowBorder
		y = pos.y - column.height / 2


		let screenGeom = getScreenGeom(pos)
		if (screenGeom != null) {
			x = Utils.clamp(x, screenGeom.left - shadowBorder, screenGeom.right + shadowBorder - width)
			y = Utils.clamp(y, screenGeom.top - shadowBorder, screenGeom.bottom + shadowBorder - height)
		}
	}

	function getScreenGeom(globalPos) {
		for (var i in Qt.application.screens) {
			let screen = Qt.application.screens[i]
			let screenGeom = Qt.rect(screen.virtualX, screen.virtualY, screen.width, screen.height)
					
			if (globalPos.x >= screenGeom.left &&
				globalPos.y >= screenGeom.top &&
				globalPos.x < screenGeom.right &&
				globalPos.y < screenGeom.bottom)
			{
				return screenGeom
			}
		}

		return null
	}
}