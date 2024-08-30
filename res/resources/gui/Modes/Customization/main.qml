import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 1.4 as C1
import QtQuick.Controls 2.3 as QtControls
import WGTools.ControlsEx 1.0 as ControlsEx
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Views.Details 1.0 as Views
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.Details 2.0 as Details
import WGTools.Style 1.0
import WGTools.Debug 1.0
import WGTools.Misc 1.0


ControlsEx.Panel {
	id: panel

	property var itemWidth: 100
	property var itemHeight: 120
	property var itemSpacing: 4
	property var highlightRadius: 4

	title: context.title
	layoutHint: "right"

	Accessible.name: title

	Connections {
		target: context
		onScrollTo: {
			grid.currentIndex = index
			grid.positionViewAtIndex(grid.currentIndex, GridView.Contain)  
		}
	}

	C1.SplitView {
		orientation: Qt.Vertical
		anchors.fill: parent

		GridView {
			id: grid
			width: parent.width
			height: parent.height * 2 / 3

			clip: true
			focus: true

			cellWidth: itemWidth
			cellHeight: itemHeight

			highlight: Rectangle {
				color:  _palette.color3
				radius: highlightRadius
			}

			delegate: delegate

			model: context.model
			Controls.ScrollBar.vertical: Controls.ScrollBar {}

			onCurrentIndexChanged: {
				context.model.selectionChanged(currentIndex)
			}
		}

		Component {
			id: delegate

			MouseArea {
				width: grid.cellWidth - itemSpacing
				height: grid.cellHeight - itemSpacing

                hoverEnabled: true
                property bool hovered: false

                onPositionChanged: hovered = containsMouse
			    onExited: hovered = false

                Controls.ToolTip.text: model.namePreview ? model.namePreview : model.texture
	            Controls.ToolTip.visible: hovered
				acceptedButtons: Qt.LeftButton | Qt.RightButton

				onPressed: {
					grid.currentIndex = index
				}

				onClicked : {
					if (mouse.button == Qt.RightButton) {
						context.itemContextMenu(mapToGlobal(mouse.x, mouse.y), index)
					}
				}

				Image {
					id: image

					x: highlightRadius / 2
					y: highlightRadius / 2
					width: parent.width - highlightRadius
					height: width

					source: model.texture
						? model.palette.length != 0 
							? "image://camouflagePreview/" + model.texture +
							"?imageIndex=" + model.display +
							"&R=" + encodeURIComponent(model.palette[0]) +
							"&G=" + encodeURIComponent(model.palette[1]) + 
							"&B=" + encodeURIComponent(model.palette[2]) + 
							"&A=" + encodeURIComponent(model.palette[3])
							: "image://gui/" + model.texture
						: ""
					fillMode: Image.PreserveAspectFit
					verticalAlignment: Image.AlignVCenter
					horizontalAlignment: Image.AlignHCenter
					cache: false
					smooth: true
					asynchronous: true
				}

				Text {
					anchors.top: image.bottom
					anchors.topMargin: 2
					width: image.width

					text: model.display
					horizontalAlignment:Text.AlignHCenter
					clip: true
					leftPadding: 5
					rightPadding: 5
					elide: Text.ElideRight
					Style.class: "text-base"
				}
			}
		}

		View.PropertyGrid {
			id: pg
			visible: true
			width: parent.width
			height:parent.height * 1 / 3
			//y: grid.height


			model: PropertyGridModel {
				id: pgModel
				source: context.model.customizationObject(grid.currentIndex)
				changesController: context.changesController
			}

			selection: ItemSelectionModel {
				id: pgSelectionModel
				model: pgModel
			}
		}

		PropertySelectionAdapter {
			assetSelection: context.assetSelection
			selectionModel: pgSelectionModel
		}
	}
}
