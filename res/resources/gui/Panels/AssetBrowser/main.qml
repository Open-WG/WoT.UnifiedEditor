import QtQuick 2.11
import QtQuick.Controls 1.4 as QuickControls1
import QtQuick.Layouts 1.4
import QtQml 2.2
import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls.impl 1.0 as Impl
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Misc 1.0 as Misc
import WGTools.QmlUtils 1.0
import "AssetTagsEditor" as AssetTagsEditor
import "ContentPanel" as ContentPanel
import "InfoPanel" as InfoPanel
import "NavigationPanel" as NavigationPanel
import "Settings.js" as Settings
import "ToolBar" as ToolBar
import "ToolBar/Query" as Query
import "QuickFilters" as Details

ControlsEx.Panel {
	id: abRoot
	title: "Asset Browser"

	property var settings: QtObject {
		property alias previewSize: toolBar.previewSize
		property alias viewMode: contentPanel.state
		property alias displayedName: contentPanel.displayedName
		property alias orientation: splitView.orientation

		property alias navigationSize: navigationPanelDrawer.size
		property alias navigationImplicitSize: navigationPanelDrawer.implicitSize
		property alias navigationState: navigationPanelDrawer.state

		property alias infoSize: infoPanelDrawer.size
		property alias infoImplicitSize: infoPanelDrawer.implicitSize
		property alias infoState: infoPanelDrawer.state

		property alias tableColumnSize: contentPanel.tableColumnSize

		property string state: context.serializedState.value
		onStateChanged: context.serializedState.value = state

		property alias sortingRole: contentPanel.sortingRole
		property alias sortingOrder: contentPanel.sortingOrder

		property string tableViewState: "relative"
	}

	Keys.onPressed: {
		if (event.key == Qt.Key_Backspace)
		{
			toolBar.prevButton.clicked()
			event.accepted = true
		}
	}

	// ************************* debug
	Loader {
		id: debugloader
		Shortcut {sequence: "Ctrl+D"; onActivated: debugloader.source = "../../WGTools/Debug/Controls/ControlsWindow.qml"}
		Connections {target: debugloader.item; onVisibleChanged: if (!debugloader.item.visible) debugloader.source = ""}
	}

	Loader {
		id: filtersLoader
		Shortcut {sequence: "Ctrl+F"; onActivated: filtersLoader.source = "../../WGTools/Debug/Filters/TestFilters.qml"}
		Connections {target: filtersLoader.item; onVisibleChanged: if (!filtersLoader.item.visible) filtersLoader.source = ""}
	}

	Loader {
		id: paletteLoader
		Shortcut {sequence: "Ctrl+Shift+P"; onActivated: paletteLoader.source = "../../WGTools/Debug/Palette.qml"}
		Connections {target: paletteLoader.item; onVisibleChanged: if (!paletteLoader.item.visible) paletteLoader.source = ""}
	}
	// ************************* debug

	AssetTagsEditor.Editor {
		id: tagsEditor
		y: parent.height
		parent: toolBar.tagsButton
		backend: context.tagsEditor
	}

	ToolBar.ToolBar {
		id: toolBar
		width: parent.width

		// Prev Button
		prevButton.enabled: false
		prevButton.onClicked: context.queryUndoStack.undo()

		// Next Button
		nextButton.enabled: false
		nextButton.onClicked: context.queryUndoStack.redo()

		// Refresh Button
		refreshButton.onClicked: context.refresh()

		// Query Edit
		queryEdit.onStartEditing: {
			context.startQueryHinting()
			var item = { item: queryEdit.getHintView(), immediate: true, destroyOnPop: true }
			contentStack.push(item)
		}

		queryEdit.onEndEditing: {
			var item = { immediate: true }
			contentStack.pop(item)
			context.stopQueryHinting()
		}

		// Preview size Slider
		previewSize: 0.3

		// Favorites CheckBox
		favoriteButton.enabled: context.tagsEditor.active
		favoriteButton.checked: context.tagsEditor.favorite
		favoriteButton.onClicked: {
			context.tagsEditor.favorite = favoriteButton.checked
			favoriteButton.checked = Qt.binding(function() { return context.tagsEditor.favorite })
		}

		// Info Button
		infoButton.checked: infoPanelDrawer.opened
		infoButton.onClicked: infoPanelDrawer.toggle()
		infoButton.onEnabledChanged: {
			if (!infoButton.enabled) {
				infoPanelDrawer.close()
			}
		}

		// Tags Button
		tagsButton.checked: tagsEditor.visible
		tagsButton.enabled: context.tagsEditor.active
		tagsButton.onClicked: tagsEditor.toggle()
		tagsButton.onEnabledChanged: tagsEditor.close()

		// ToolBar Menu
		menu.tableView: contentPanel.tableView

		menu.contentView: splitView

		menu.sortingRole: contentPanel.sortingRole
		menu.onSortingRoleChosen: contentPanel.sortingRole = role

		menu.sortingOrder: contentPanel.sortingOrder
		menu.onSortingOrderСhosen: contentPanel.sortingOrder = order

		menu.viewMode: contentPanel.state
		menu.onViewModeItemClicked: contentPanel.setViewMode(viewMode)

		menu.displayedName: contentPanel.displayedName
		menu.onDisplayedNameClicked: contentPanel.setDisplayedName(displayedName)

		menu.naviVisible: navigationPanelDrawer.opened
		menu.onNaviItemClicked: navigationPanelDrawer.toggle()

		// UndoRedo button enabling
		Connections {
			target: context.queryUndoStack
			onCanUndoChanged: toolBar.prevButton.enabled = canUndo
			onCanRedoChanged: toolBar.nextButton.enabled = canRedo
		}
	}

	Misc.SearchingIndicator {
		id: searchIndicator
		width: parent.width
		visible: context.contentModel.searching
		anchors.bottom: toolBar.bottom
	}

	QuickControls1.StackView {
		id: contentStack
		width: parent.width
		anchors.top: toolBar.bottom
		anchors.bottom: parent.bottom

		initialItem: QuickControls1.SplitView {
			id: splitView

			handleDelegate: Rectangle { width: 1; color: _palette.color7 }

			// Navigation panel
			Misc.SplitViewDrawer {
				id: navigationPanelDrawer
				view: splitView
				implicitWidth: Settings.initialNavigationPanelSize
				implicitHeight: implicitWidth
				hideable: false
				padding: ControlsSettings.doublePadding

				Accessible.name: "Navigation"

				NavigationPanel.NavigationView {
					model: context.treeModel
					selection: context.treeSelectionModel
					anchors.fill: parent
				}
			}

			ColumnLayout {
				spacing: 0
				Layout.fillWidth: true
				Layout.fillHeight: true

				Details.QuickFiltersView {
					Layout.fillWidth: true
				}

				// Content panel
				ContentPanel.ContentPanel {
					id: contentPanel
					model: context.contentModel
					selectionModel: context.contentSelectionModel
					sectionsEnabled: context.contentFiltered
					sizeMultiplier: toolBar.previewSize
					clip: true
					contextMenu: contextMenu
					onPathSelected: showDirectoryTimer.fire(selectedPath)
					onQuickSearchTextChanged: context.applyQuickSearchText(quickSearchText)

					onDoubleClicked: {
						// alternatice action
						if (Qt.ControlModifier == (ApplicationUtils.keyboardModifiers() & Qt.ControlModifier)) {
							if (altAction.enabled) {
								altAction.trigger()
							}
							return
						}

						// main action
						if (context.isCurrentFolder() || context.canOpenCurrentAsset(false))
							context.openCurrentAsset(false, "")
					}

					Layout.fillWidth: true
					Layout.fillHeight: true

					Impl.ActionAdapter {
						id: altAction
						action: context.actions.altAction
					}

					Component {
						id: contextMenu

						ContentPanel.AssetContextMenu {
							onTagsClicked: tagsEditor.open()
							onInfoClicked: infoPanelDrawer.toggle()
							onClosed: destroy()
						}
					}

					Timer {
						id: showDirectoryTimer
						property string __path
						interval: 0
						onTriggered: context.showContents(__path)

						function fire(path) {
							__path = path
							restart()
						}
					}
				}
			}

			// Info and preview panel
			Misc.SplitViewDrawer {
				id: infoPanelDrawer
				view: splitView
				implicitWidth: Settings.initialInfoPanelSize
				implicitHeight: implicitWidth
				state: "closed"

				InfoPanel.Panel {
					id: infoPanel
					assetInfo: context.currentAssetInfo
					blockContentResizing: infoPanelDrawer.closed || infoPanelDrawer.running
					anchors.fill: parent
				}
			}
		}
	}
}
