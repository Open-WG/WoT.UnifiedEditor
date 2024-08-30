import QtQuick 2.11
import QtQuick.Layouts 1.4
import QtQuick.Controls 1.4
import QtQml.Models 2.2
import WGTools.AnimSequences 1.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls 2.0 as Controls
import WGTools.Controls.impl 1.0 as Impl
import WGTools.PropertyGrid 1.0
import Panels.PropertyGrid.View 1.0 as View
import QtQml.StateMachine 1.11 as SM
import "../../Panels/SceneOutline" as SceneOutline

ControlsEx.Panel {
	title: "Navigation"
	implicitWidth: 900
	implicitHeight: 570

	SM.StateMachine {
		running: true
		initialState: groupFS.activeFocus
			? groupState
			: pointsFS.activeFocus
				? pointsState
				: idleState

		SM.State {
			id: idleState
			onEntered: context.focusOwner = NavigationPanelContext.None

			SM.SignalTransition { targetState: groupState; signal: groupFS.activeFocusChanged; guard: groupFS.activeFocus }
			SM.SignalTransition { targetState: pointsState; signal: pointsFS.activeFocusChanged; guard: pointsFS.activeFocus }
		}

		SM.State {
			id: groupState
			onEntered: context.focusOwner = NavigationPanelContext.Group

			SM.SignalTransition { targetState: idleState; signal: groupFS.activeFocusChanged; guard: !groupFS.activeFocus }
			SM.SignalTransition { targetState: pointsState; signal: pointsFS.activeFocusChanged; guard: pointsFS.activeFocus }
		}

		SM.State {
			id: pointsState
			onEntered: context.focusOwner = NavigationPanelContext.Point

			SM.SignalTransition { targetState: idleState; signal: pointsFS.activeFocusChanged; guard: !pointsFS.activeFocus }
			SM.SignalTransition { targetState: groupState; signal: groupFS.activeFocusChanged; guard: groupFS.activeFocus }
		}
	}

	SplitView {
		id: papaRow
		anchors.fill: parent

		FocusScope {
			id: groupFS

			Layout.margins: 5
			Layout.topMargin: 0
			Layout.fillHeight: true
			Layout.fillWidth: true
			implicitWidth: papaRow.width * (1/3)
			
			ColumnLayout {
				spacing: 10
				anchors.fill: parent

				Controls.Button {
					text: "Add Group"
					icon.source: "image://gui/add"
					onClicked: context.addGroup()
					focusPolicy: Qt.StrongFocus

					Layout.fillWidth: true
				}
				Controls.Button {
					text: "Import locations.xml"
					icon.source: "image://gui/import"
					onClicked: context.importGroups()
					focusPolicy: Qt.StrongFocus

					Layout.fillWidth: true
				}

				Controls.Button {
					focusPolicy: Qt.StrongFocus
					action: Impl.ActionAdapter { action: context.makeScreenshotsAction }
					icon.source: "image://gui/navigation-point"

					Layout.fillWidth: true
				}
				
				SceneOutline.SceneBrowserView {
					sceneBrowserContext: context.groupsData

					Layout.fillHeight: true
					Layout.fillWidth: true
				}
			}
		}

		FocusScope {
			id: pointsFS

			Layout.margins: 5
			Layout.topMargin: 0
			Layout.fillHeight: true
			Layout.fillWidth: true
			implicitWidth: papaRow.width * (1/3)
			
			ColumnLayout {
				anchors.fill: parent

				Controls.Button {
					focusPolicy: Qt.StrongFocus
					action: Impl.ActionAdapter { action: context.addPointAction }
					icon.source: "image://gui/add"

					Layout.fillWidth: true
				}

				Item { // points data holder
					Layout.fillHeight: true
					Layout.fillWidth: true

					Repeater {
						id: repeater
						model: context.groupPointsModel

						SceneOutline.SceneBrowserView {
							id: pointsView
							sceneBrowserContext: model.sceneBrowserData
							visible: context.groupPointsModel.currentIndex == index
							enabled: visible

							anchors.fill: parent

							Connections {
								target: model.notifications
								onPointAdded: {
									pointsView.view.forceActiveFocus()
									pointsView.view.__listView.currentIndex = index.row
								}
							}
						}
					}
				}
			}
		}

		FocusScope {
			id: propertyGridFS

			Layout.fillHeight: true
			implicitWidth: papaRow.width * (1/3)

			View.PropertyGrid {
				id: propertyGridView
				
				anchors.fill: parent

				model: PropertyGridModel {
					id: pgModel
					source: context.settings
				}

				selection: ItemSelectionModel {
					model: pgModel
				}

				copyAction.enabled: propertyGridFS.activeFocus
				pasteAction.enabled: propertyGridFS.activeFocus
			}
		}
	}
}
