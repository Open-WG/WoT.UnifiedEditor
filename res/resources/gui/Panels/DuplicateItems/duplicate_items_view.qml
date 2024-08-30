import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.11
import Panels.PropertyGrid.View 1.0 as View
import WGTools.PropertyGrid 1.0
import WGTools.Controls 2.0 as Controls
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls.Details 2.0 as Details
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as Styles
import WGTools.Views.Details 1.0 as ViewDetails
import WGTools.Misc 1.0 as Misc

ControlsEx.Panel {
	id: panel
	property var title: context.title
	property var layoutHint: "free"

	readonly property var __context: context
	readonly property var __spacing: 4
	property var __expandState: 0

	implicitWidth: 800
	implicitHeight: 800
	color: _palette.color8
	Accessible.name: title

	ColumnLayout {
		anchors.fill: parent
		spacing: __spacing

		RowLayout {
			spacing: __spacing
			Layout.margins: __spacing

			ControlsEx.SearchField {
				id: filter
				Layout.fillWidth: true
				placeholderText: "Filter"
				text: context.filterModel.filterTokens

				onTriggered: context.filterModel.filterTokens = filter.text
			}

			Controls.Button {
				id: find
				text: "Find"
				enabled: !context.finding

				implicitWidth: 64

				Controls.ToolTip.text: "Start finding"
				Controls.ToolTip.visible: hovered
				Controls.ToolTip.delay: ControlsSettings.tooltipDelay
				Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

				onClicked: context.find()
			}

			Controls.Button {
				id: cancel
				text: "Cancel"
				enabled: context.finding

				implicitWidth: 64

				Controls.ToolTip.text: "Cancel finding"
				Controls.ToolTip.visible: hovered
				Controls.ToolTip.delay: ControlsSettings.tooltipDelay
				Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

				onClicked: context.cancelFinding()

				Shortcut {
					sequence: "Escape"
					onActivated: __context.cancelFinding()
					enabled: __context.finding
				}
			}

			Controls.Button {
				id: showSettings
				flat: true
				icon.source: "image://gui/settings"

				implicitWidth: parent.implicitHeight
				implicitHeight: parent.implicitHeight

				Controls.ToolTip.text: "Show/hide settings"
				Controls.ToolTip.visible: hovered
				Controls.ToolTip.delay: ControlsSettings.tooltipDelay
				Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

				onClicked: {
					settings.visible = !settings.visible
				}
			}

			Controls.Button {
				id: expandCollapse
				flat: true
				icon.source: "image://gui/collapseAll"

				implicitWidth: parent.implicitHeight
				implicitHeight: parent.implicitHeight

				Controls.ToolTip.text: "Collapse all/expand all"
				Controls.ToolTip.visible: hovered
				Controls.ToolTip.delay: ControlsSettings.tooltipDelay
				Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

				onClicked: {
					__expandState = view.toggleExpandedAll()
				}
			}
		}

		View.PropertyGrid {
			id: settings
			visible: false

			Layout.fillWidth: true

			model: PropertyGridModel {
				id: pgModel
				source: context.object
				changesController: context.changesController
			}

			selection: ItemSelectionModel {
				model: pgModel
			}

			Rectangle {
				anchors.fill: parent
				visible: context.finding
				color: "#B0000000"
				z: 1

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					acceptedButtons: Qt.AllButtons
				}
			}
		}

		Views.TreeView {
			id: view

			property var __hoverRow: -1
			property var __hoverIndex: null

			model: context.model
			selection: context.selectionModel
			selectionMode: SelectionMode.ExtendedSelection

			Layout.fillHeight: true
			Layout.fillWidth: true
	
			sortIndicatorOrder: model ? model.sortOrder : Qt.AscendingOrder
			sortIndicatorVisible: true
			onSortIndicatorColumnChanged: sort()
			onSortIndicatorOrderChanged: sort()
			function sort() {
				if(!model) {
					return
				}
				var column = view.getColumn(sortIndicatorColumn)
				if(column) {
					var roleName = view.getColumn(sortIndicatorColumn).role
					model.sortByRole(roleName, sortIndicatorOrder)
				}
			}
			Component.onCompleted: {
				for (var i = 0; i < view.columnCount; i++) {
					if (context.model.roleByName(view.getColumn(i).role) == context.model.sortRole) {
						view.sortIndicatorColumn = i
						return
					}
				}
			}

			onDoubleClicked: {
				if (index.valid) {
					toggleExpanded(index)
				}
			}

			MouseArea {
				id: mouseArea

				anchors.fill: parent
				acceptedButtons: Qt.NoButton
				hoverEnabled: true
				propagateComposedEvents: true
				z: -1

				onEntered: validateHover()
				onPositionChanged: validateHover()
				onExited: invalidateHover()

				function validateHover() {
					view.__hoverRow = view.__listView.indexAt(mouseX, mouseY + view.__listView.contentY)
					view.__hoverIndex = view.indexAt(mouseX, mouseY)
				}
				function invalidateHover() {
					view.__hoverRow = -1
					view.__hoverIndex = null
				}
			}

			rowDelegate: ViewDetails.RowDelegate {
				id: rowDelegate
				hovered: view.__hoverRow == styleData.row

				Component {
					id: actionComponent

					Controls.Action {
						enabled: context.actionContext.enabled(text)

						onTriggered: {
							context.actionContext.execute(text)
						}
					}
				}

				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.RightButton
					propagateComposedEvents: true

					onReleased: {
						if (view.selection && view.__hoverIndex && view.__hoverIndex.valid) {
							if (!view.selection.isSelected(view.__hoverIndex)) {
								view.selection.setCurrentIndex(view.__hoverIndex, ItemSelectionModel.ClearAndSelect)
							}
							context.menuRequested()
						}
						mouse.accepted = false
					}
				}
			}

			Component {
				id: columnDelegate

				Misc.Text {
					verticalAlignment: Text.AlignVCenter
					horizontalAlignment: styleData.textAlignment

					text: styleData.value != undefined ? styleData.value : ""
					elide: Text.ElideRight
				}
			}

			TableViewColumn {
				role: "type"
				title: "Type"
				width: 130

				delegate: Misc.IconLabel {
					id: iconLabel
					spacing: __spacing

					label.text: styleData.value != undefined ? styleData.value : "";
					label.elide: Text.ElideRight
					icon.source: model && model.decoration ? "image://gui/" + model.decoration : ""

					// auto expand functionality
					Connections {
						target: styleData
						ignoreUnknownSignals: true
						onIndexChanged: {
							expandTimer.start()
						}
					}
					Component.onCompleted: {
						expandTimer.start()
					}

					Timer {
						id: expandTimer
						interval: 0
						onTriggered: {
							if (model != undefined && __expandState) {
								view.expand(styleData.index)
							}
						}
					}
				}
			}
			TableViewColumn {
				title: "Actions"
				width: 60
				horizontalAlignment: Qt.AlignHCenter

				delegate: RowLayout {
					anchors.fill: parent
					spacing: __spacing

					Item {
						Layout.fillWidth: true
					}

					function notifyParentMouseArea(hovered) {
						if(hovered) {
							mouseArea.entered();
						}
					}

					Controls.Button {
						flat: true
						icon.source: "image://gui/move-to"
						visible: styleData.selected || view.__hoverRow == styleData.row
						hoverEnabled: true
						
						Controls.ToolTip.text: "Move to chunk item"
						Controls.ToolTip.visible: hovered
						Controls.ToolTip.delay: ControlsSettings.tooltipDelay
						Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

						onClicked: {
							context.moveTo(styleData.index)
						}

						onHoveredChanged: notifyParentMouseArea(hovered)
					}

					Controls.Button {
						flat: true
						icon.source: "image://gui/icon-remove"
						visible: styleData.selected || view.__hoverRow == styleData.row
						hoverEnabled: true

						Controls.ToolTip.text: "Remove chunk item"
						Controls.ToolTip.visible: hovered
						Controls.ToolTip.delay: ControlsSettings.tooltipDelay
						Controls.ToolTip.timeout: ControlsSettings.tooltipTimeout

						onClicked: {
							context.remove(styleData.index)
						}

						onHoveredChanged: notifyParentMouseArea(hovered)
					}

					Item {
						Layout.fillWidth: true
					}
				}
			}
			TableViewColumn {
				role: "childrenCount"
				title: "Count"
				width: 70
				horizontalAlignment: Qt.AlignHCenter

				delegate: columnDelegate
			}
			TableViewColumn {
				role: "display"
				title: "Name"
				width: 200

				delegate: columnDelegate
			}
			TableViewColumn {
				role: "position"
				title: "Position"
				width: 140

				delegate: columnDelegate
			}
			TableViewColumn {
				role: "distance"
				title: "Distance (m)"
				width: 100

				delegate: columnDelegate
			}
			TableViewColumn {
				role: "yaw"
				title: "Yaw (deg)"
				width: 100

				delegate: columnDelegate
			}
		}

		Controls.ProgressBar {
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignTop
			implicitHeight: 3
			indeterminate: true
			visible: context.finding || context.filtering

			background: Rectangle {
				color: "transparent"
			}
		}

		StatusBar {
			Layout.fillWidth: true

			RowLayout {
				spacing: __spacing
				anchors.fill: parent

				Misc.Text {
					Layout.alignment: Qt.AlignRight
					verticalAlignment: Text.AlignVCenter

					text: "Number of matches: " + context.numberOfMatches
					elide: Text.ElideRight
				}
			}
		}
	}
}
