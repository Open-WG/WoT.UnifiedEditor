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

	property var itemSpasing: 5

	title: context.title
	layoutHint: "right"

	Accessible.name: title

	C1.SplitView {
		orientation: Qt.Vertical
		anchors.fill: parent

		GridView {
			id: grid
			width:parent.width
			height:parent.height * 2 / 3

			clip: true

			cellWidth: 100
			cellHeight: cellWidth * 1.2

			highlight: Rectangle {
				color:  _palette.color3
				radius: 5
			}

			delegate: delegate

			model: context.model
			Controls.ScrollBar.vertical: Controls.ScrollBar {}

			onCurrentIndexChanged: context.model.selectionChanged(grid.currentIndex)
		}

		Component {
			id: delegate

			QtControls.Button {
				id: control
				width: grid.cellWidth - itemSpasing
				height: grid.cellHeight - itemSpasing
				topPadding: image.height
				focusPolicy: Qt.ClickFocus

				onActiveFocusChanged: if (activeFocus) {
					grid.currentIndex = index
				}

				onClicked : {
					grid.currentIndex = index
				}

				Component.onCompleted: context.model.selectionChanged(grid.currentIndex)

				background: Image {
					id: image
					width: parent.width
					height: width

					source: model.texture ? "image://gui/" + model.texture : ""
					fillMode: Image.PreserveAspectFit
					verticalAlignment: Image.AlignVCenter
					horizontalAlignment: Image.AlignHCenter
					cache: false
					smooth: true
					asynchronous: true
				}

				contentItem : Text {
					id: label
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
				model: pgModel
			}
		}
	}
}
