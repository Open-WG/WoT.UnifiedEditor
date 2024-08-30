import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import WGTools.AtlasEditor 1.0
import WGTools.Utils 1.0 as Utils
import WGTools.QmlUtils 1.0
import WGTools.Misc 1.0 as Misc
import "../../WGTools/Controls/Details/Settings.js" as ControlsSettings
import "Details" as Details

Item {
	id: root
	property alias model : flickable.model
	property alias viewSettings : flickable.settings
	property var selection
	property alias showNumbers: content.showNumbers
	property alias rowColumnNumbers: content.rowColumnNumbers
	property alias showGrid: content.showGrid
	property bool showEmptySlotIcons: true
	property bool allowAtlasDrag: true
	property Component atlasDelegate: Details.AtlasDelegate {}

	//Set those from the outside, so we can use custom model to display tiles
	property int atlasWidth: 0
	property int atlasHeight: 0
	property int rowCount: 0
	property int columnCount: 0
	//

	Flickable {
		id: flickable
		
		property var model
		property var settings

		property bool zoomed: false
		readonly property real defaultSizeCoefficient: Math.min(width / root.atlasWidth, height / root.atlasHeight)
		readonly property real zoomFactor: settings
			? defaultSizeCoefficient * settings.zoomFactor
			: 1

		onZoomFactorChanged: {
			update()
		}

		Connections {
			target: model && model.hasOwnProperty("atlasWidth") && model.hasOwnProperty("atlasHeight")
				? model
				: null
			onAtlasWidthChanged: flickable.update()
			onAtlasHeightChanged: flickable.update()
		}

		width: parent.width
		height: parent.height
		anchors.centerIn: parent
		leftMargin: !isNaN(contentWidth)
			? Math.max(0, Math.floor((width - contentWidth) / 2))
			: 0
		topMargin: !isNaN(contentHeight)
			? Math.max(0, Math.floor((height - contentHeight) / 2))
			: 0
		pixelAligned: true

		flickableDirection: Flickable.AutoFlickIfNeeded
		interactive: root.allowAtlasDrag

		function update() {
			if (root.atlasWidth == 0 || root.atlasHeight == 0)
				return

			var newWidth = root.atlasWidth * flickable.zoomFactor
			var newHeight = root.atlasHeight * flickable.zoomFactor
			var zoomCenter = Qt.point(
				flickable.width / 2 - flickable.leftMargin + flickable.contentX, 
				flickable.height / 2 - flickable.topMargin + flickable.contentY)

			resizeContent(newWidth, newHeight, zoomCenter)

			if (newWidth <= flickable.width) {
				flickable.contentX = (newWidth - flickable.width) + flickable.leftMargin
			}

			if (newHeight <= flickable.height) {
				flickable.contentY = (newHeight - flickable.height) + flickable.topMargin
			}
		}

		Rectangle {
			id: content
			width: flickable.contentWidth
			height: flickable.contentHeight
			implicitWidth: 300
			implicitHeight: 300
			color: "transparent"
			property bool showNumbers: false
			property bool rowColumnNumbers: false
			property bool showGrid: false
			layer.enabled: true
			
			Repeater {
				id: repeater
				model: flickable.model
				visible: true

				property int loadedNum: 0

				anchors.fill: parent

				Item {
					Accessible.name: index

					readonly property int __index: index
					readonly property var __model: model
					readonly property int __row: index / root.columnCount
					readonly property int __column: index - __row * root.columnCount
					readonly property var __modelIndex: (index != -1) ? flickable.model.index(index, 0) : null

					width: content.width / root.columnCount
					height: content.height / root.rowCount
					x: width * __column
					y: height * __row

					Loader {
						id: atlasDelegateLoader

						readonly property int index: parent.__index
						readonly property var model: parent.__model
						
						anchors.fill: parent

						property QtObject styleData: QtObject {
							readonly property var modelIndex: __modelIndex
							readonly property int row: __row
							readonly property int column: __column
							readonly property int rowCount: root.rowCount
							readonly property int columnCount: root.columnCount
							readonly property var settings: flickable.settings
							readonly property var showNumbers: content.showNumbers
							readonly property var rowColumnNumbers: content.rowColumnNumbers
							readonly property var showGrid: content.showGrid
							readonly property var selection: root.selection
						}
						sourceComponent: index < root.rowCount * root.columnCount ? root.atlasDelegate : undefined
					}
				}
			}
		}
	}

	MouseArea {
		property var _lastMouseX: 0
		property var _lastMouseY: 0
		property var _lastCursorShape: Qt.ArrowCursor
		anchors.fill: parent

		z: selectionBox.z - 1
		acceptedButtons: Qt.RightButton
		propagateComposedEvents: true
		enabled: root.allowAtlasDrag

		onPressed: {
			if (mouse.button == Qt.RightButton) {
				_lastMouseX = mouse.x
				_lastMouseY = mouse.y
				_lastCursorShape = cursorShape
				z = selectionBox.z + 1
				cursorShape = Qt.SizeAllCursor
			}
		}

		onPositionChanged: {
			if (mouse.buttons == Qt.RightButton) {
				flickable.contentX -= mouse.x - _lastMouseX
				flickable.contentY -= mouse.y - _lastMouseY

				_lastMouseX = mouse.x
				_lastMouseY = mouse.y
			}
		}

		onReleased: {
			if (mouse.button == Qt.RightButton) {
				flickable.returnToBounds()
				cursorShape = _lastCursorShape
				z = selectionBox.z - 1
			}
		}
	}

	Misc.SelectionBox {
		id: selectionBox

		enabled: root.selection ? root.selection : null
		anchors.fill: parent

		onSelectionFinished: {
			if (!(modifiers & Qt.ControlModifier)) {
				root.selection.clearSelection()
			}

			var newSelection = []

			for (var i = 0; i < repeater.count; ++i) {
				var item = repeater.itemAt(i)

				if (Utils.Geometry.overlap(x, y, width, height,
						item.x - flickable.contentX,
						item.y - flickable.contentY, 
						item.width,
						item.height)) {
					newSelection.push(item.__modelIndex)
				}
			}

			SelectionUtils.select(root.selection, newSelection, ItemSelectionModel.Select)
		}
	}
}
