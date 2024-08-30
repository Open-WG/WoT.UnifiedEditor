import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQml.Models 2.11
import QtQml.StateMachine 1.0 as DSM
import WGTools.Controls 2.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Models 1.0
import WGTools.Clickomatic 1.0 as Clickomatic
import WGTools.PropertyGrid 1.0
import "View" as View

ControlsEx.Panel {
	title: context.title
	layoutHint: "right"

	implicitWidth: 400
	implicitHeight: 400

	DSM.StateMachine {
		id: splitterSyncer
		initialState: syncFrontendState
		running: true

		DSM.State {
			id: mutedState

			DSM.SignalTransition {
				targetState: syncFrontendState
				signal: pgModel.modelReset
			}
		}

		DSM.State {
			id: syncedState

			DSM.SignalTransition {
				targetState: mutedState
				signal: pgModel.modelAboutToBeReset
			}

			DSM.SignalTransition {
				targetState: syncFrontendState
				signal: context.splitterSettingsRestored
			}
			
			DSM.SignalTransition {
				targetState: syncBackendState
				signal: propertyGrid.splitterSharedData.xChanged
			}

			DSM.SignalTransition {
				targetState: syncBackendState
				signal: propertyGrid.splitterSharedData.autoPositionChanged
			}
		}

		DSM.State {
			id: syncFrontendState
			onEntered: {
				let splitterSharedData = propertyGrid.splitterSharedData
				let typeSplitterPosition = context.typeSplitterPosition

				if (!isNaN(typeSplitterPosition)) {
					splitterSharedData.autoPosition = false
					splitterSharedData.x = typeSplitterPosition
				} else {
					splitterSharedData.autoPosition = true
				}
			}

			DSM.TimeoutTransition {
				targetState: syncedState
				timeout: 0
			}
		}

		DSM.State {
			id: syncBackendState
			onEntered: {
				if (propertyGrid.splitterSharedData.autoPosition) {
					context.typeSplitterPosition = NaN
				} else {
					context.typeSplitterPosition = propertyGrid.splitterSharedData.x
				}
			}

			DSM.TimeoutTransition {
				targetState: syncedState
				timeout: 0
			}
		}
	}

	// clickomatic -----------------------------------
	Clickomatic.ClickomaticItem.showChild: function(child) {
		propertyGrid.showChild(child)
	}
	// -----------------------------------------------

	// models
	PropertyGridModel {
		id: pgModel
		source: context.object
		assetSelection: context.assetSelection
		changesController: context.changesController
	}

	PropertyGridFilterModel {
		id: pgFilterModel
		propertyGridSourceModel: pgModel
	}

	ItemSelectionModel {
		id: pgSelectionModel
		model: pgFilterModel
	}
	
	PropertySelectionAdapter {
		assetSelection: context.assetSelection
		selectionModel: pgSelectionModel
	}

	ModelElementsCounter {
		id: pgModelSize
		model: pgModel
		mode: ModelElementsCounter.RootChildren
	}

	// Filter
	ColumnLayout {
		width: parent.width
		height: parent.height
		spacing: 0

		ControlsEx.SearchField {
			id: filter
			placeholderText: "Filter"
			visible: pgModelSize.value > 0

			Layout.fillWidth: true

			function filter() {
				pgFilterModel.setFilter(text)
			}

			onTriggered: {
				filter.filter()
			}

			Connections {
				target: context
				onObjectChanged: {
					if (filter.text == "") {
						filter.filter()
					} else {
						filter.text = ""
					}
				}
			}
		}

		View.PropertyGrid {
			id: propertyGrid
			model: pgFilterModel
			selection: pgSelectionModel
			visible: !empty
			multiTypeSelection: context.typeCount > 1

			Layout.fillWidth: true
			Layout.fillHeight: true
		}

		Item {
			visible: !propertyGrid.visible
			clip: true

			Layout.fillWidth: true
			Layout.fillHeight: true

			Placeholder {
				id: placeholder
				width: parent.width
				enabled: false

				anchors.left: parent.left
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				anchors.margins: 20

				states: [
					State {
						when: placeholder.visible && context.typeCount == 0
						name: "no-object"
						PropertyChanges {
							target: placeholder
							imageSource: "image://gui/no-selected-items"
							title: "No selected items"
							text: "Please, select items from Scene Browser or in Viewport to see their properties"
						}
					},
					State {
						when: placeholder.visible && context.typeCount > 0
						name: "no-properties"
						PropertyChanges {
							target: placeholder
							imageSource: "image://gui/no-properties"
							title: "No properties"
							text: "There are no properties in selected item(s)."
						}
					}
				]
			}
		}
	}
}
