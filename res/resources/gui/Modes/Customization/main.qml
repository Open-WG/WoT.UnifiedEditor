import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 1.4
import QtQml.StateMachine 1.0 as DSM
import WGTools.Controls.Details 2.0
import WGTools.ControlsEx 1.0 as WGT
import WGTools.Breadcrumbs 1.0 as WGT
import WGTools.Misc 1.0
import "Details" as Details

WGT.Panel {
	id: panel

	property real spacing: 5

	title: context.title
	layoutHint: "right"

	SplitView {
		id: verticalLayout
		orientation: Qt.Vertical
		handleDelegate: Details.HandleDelegate {}

		anchors.fill: parent

		SplitView {
			id: horizontalLayout
			orientation: Qt.Horizontal
			handleDelegate: Details.HandleDelegate {}

			height: verticalLayout.height * 2/3
			Layout.fillWidth: true

			Item {
				visible: context.groupsEnabled
				width: horizontalLayout.width * 1/3
				Layout.fillHeight: true

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: panel.spacing
					anchors.topMargin: 0

					Details.ToolBar {
						id: groupsToolBar
						textFilter: context.groupsTextFilter
						toolBarActions: context.groupsToolBarActions
						placeholderText: "Enter a group name"

						Layout.fillWidth: true
					}

					Details.Groups {
						id: groups
						textFilter: context.groupsTextFilter
						model: context.groupsProxyModel
						selection: context.groupsSelectionProxyModel
						onRightClicked: context.showGroupContextMenu()
					}
				}
			}

			Item {
				Layout.fillWidth: true
				Layout.fillHeight: true

				ColumnLayout {
					spacing: panel.spacing

					anchors.fill: parent
					anchors.margins: panel.spacing
					anchors.topMargin: 0

					Details.ToolBar {
						id: elementsToolBar
						textFilter: context.elementsTextFilter
						toolBarActions: context.elementsToolBarActions
						placeholderText: "Enter a filter string (ID, Name, Texture Name)"

						Layout.fillWidth: true
					}

					WGT.BreadcrumbsView {
						model: context.elementsQuickFilters ? context.elementsQuickFilters.model : null
						selection: context.elementsQuickFilters ? context.elementsQuickFilters.selection : null
						visible: count > 0

						Layout.fillWidth: true
					}

					Details.Elements {
						id: elements
						model: context.elementsProxyModel
						selection: context.elementsSelectionProxyModel
						focus: true

						textFilter: context.elementsTextFilter
						quickFilters: context.elementsQuickFilters

						onClickedOutSide: {
							context.elementsSelectionModel.clearSelection()

							if (mouse.button == Qt.RightButton) {
								context.showElementContextMenu()
							}
						}

						Layout.fillWidth: true
						Layout.fillHeight: true

						signal elementClicked()

						delegate: Details.ElementDelegate {
							width: elements.cellWidth
							height: elements.cellHeight
							onClicked: elements.elementClicked()
							onRightClicked: context.showElementContextMenu()
						}
					}
				}
			}
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true

			Details.Properties {
				id: pg
				assetSelection: context.assetSelection
				changesController: context.changesController

				anchors.fill: parent
				anchors.margins: panel.spacing
				
				Binding on source {
					when: elementsSelectionState.active && !elementsObjectComposer.processing
					value: elementsObjectComposer.object
				}

				Binding on source {
					when: groupsSelectionState.active && !groupObjectComposer.processing
					value: groupObjectComposer.object
				}
				
				QtMiltiselectionComposer {
					id: elementsObjectComposer
					selectionModel: context.elementsSelectionModel // compose multiselection from source selectionModel
				}

				QtMiltiselectionComposer {
					id: groupObjectComposer
					selectionModel: context.groupsSelectionModel // compose multiselection from source selectionModel
				}
			}
		}
	}

	// selection engine
	DSM.StateMachine {
		initialState: groupsSelectionState
		running: true

		DSM.State {
			id: groupsSelectionState

			DSM.SignalTransition {
				targetState: elementsSelectionState
				signal: context.elementsSelectionModel.selectionChanged
				guard: context.elementsSelectionModel.hasSelection
			}

			DSM.SignalTransition {
				targetState: elementsSelectionState
				signal: elements.elementClicked
				guard: context.elementsSelectionModel.hasSelection
			}
		}

		DSM.State {
			id: elementsSelectionState

			DSM.SignalTransition {
				targetState: groupsSelectionState
				signal: groups.clicked
			}

			DSM.SignalTransition {
				targetState: groupsSelectionState
				signal: context.groupsSelectionModel.currentChanged
			}

			DSM.SignalTransition {
				targetState: groupsSelectionState
				signal: context.elementsSelectionModel.selectionChanged
				guard: !context.elementsSelectionModel.hasSelection
			}
		}
	}
}
