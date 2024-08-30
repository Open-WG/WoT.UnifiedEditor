import QtQuick 2.10
import QtQml.StateMachine 1.0 as DSM
import WGTools.Controls 2.0
import WGTools.ControlsEx 1.0 as ControlsEx
import WGTools.Controls.Details 2.0
import WGTools.Clickomatic 1.0 as Clickomatic
import WGTools.Utils 1.0
import "Settings.js" as Settings
import "Details" as Details
import "Items/Common/PGRow" as Details
import "Items/Group/RootGroup" as Details
import "../ControlsFactory" as ControlsFactory

Flickable {
	id: propertyGrid

	property alias rootGroup: rootGroup
	property alias model: rootGroup.baseModel
	property alias selection: rootGroup.selection
	readonly property alias currentIndex: selectionProcessor.currentIndex

	property bool multiselection: true
	property int invalidDelegateCount: 0
	property alias multiTypeSelection: rootGroup.startFromZero

	readonly property alias splitterSharedData: splitterSharedData

	readonly property bool empty: rootGroup.childrenCount == 0
	readonly property bool controlsWheelEnabled: !postFlickingTimer.running

	property alias copyAction: copyAction
	property alias pasteAction: pasteAction

	readonly property int orientation: (width > Settings.horizontalWidthThreshold) ? Qt.Horizontal : Qt.Vertical

	Action {
		id: copyAction
		text: "&Copy"
		shortcut: StandardKey.Copy
		onTriggered: propertyGrid.copy()
	}

	Action {
		id: pasteAction
		text: "&Paste"
		shortcut: StandardKey.Paste
		onTriggered: propertyGrid.paste()
	}

	Action {
		id: revertAction
		text: "&Revert"
		onTriggered: propertyGrid.revert()
	}

	Action {
		id: infoAction
		text: "&Show info"
		onTriggered: propertyGrid.info()
	}

	Action {
		id: onlyCommonAction
		text: "Only c&ommon properties"
		checkable: true
		checked: context.hasOwnProperty("onlyCommonProperties")
			? context.onlyCommonProperties
			: false
		onToggled: context.onlyCommonProperties = checked
	}

	Action {
		id: collapseAction
		readonly property bool expanded: 'sourceModel' in model && model.sourceModel && model.sourceModel.expanded
		text: expanded ? "Collapse &all" : "Expand &all"
		onTriggered: model.expanded = !expanded
	}

	property Component contextMenu: Menu {
		MenuItem { action: copyAction }
		MenuItem { action: pasteAction }
		MenuItem { action: revertAction }

		MenuSeparator {}

		MenuItem { action: infoAction }

		MenuSeparator {}

		MenuItem { action: onlyCommonAction }
		MenuItem { action: collapseAction }
	}

	implicitWidth: rootGroup.implicitWidth + leftMargin + rightMargin
	implicitHeight: rootGroup.implicitHeight

	contentWidth: width - leftMargin - rightMargin
	contentHeight: rootGroup.height
	boundsBehavior: Flickable.StopAtBounds
	flickableDirection: Flickable.VerticalFlick
	pixelAligned: true
	maximumFlickVelocity: ControlsSettings.mouseWheelScrollVelocity
	activeFocusOnTab: false
	interactive: !selectionProcessor.frameSelectionActive //!selectionProcessor.shiftPressed
	clip: true

	function nodeAt(y) {
		return rootGroup.nodeAt(y, true)
	}

	function copy() {
		return copyPasteHelper.copy()
	}

	function paste() {
		return copyPasteHelper.paste()
	}

	function revert() {
		if (propertyGrid.selection && propertyGrid.model && propertyGrid.model.hasOwnProperty("revertToOriginal")) {
			propertyGrid.model.revertToOriginal(propertyGrid.selection.selectedIndexes)
			return true
		}

		return false
	}

	function info() {
		if (propertyGrid.selection && propertyGrid.model && propertyGrid.model.hasOwnProperty("info")) {
			propertyGrid.model.info(propertyGrid.selection.selectedIndexes)
			return true
		}

		return false
	}

	// clickomatic -----------------------------------
	Clickomatic.ClickomaticItem.showChild: function(child) {
		rootGroup.showChild(child)
	}

	function scrollToChild(child) {
		var rect = contentItem.mapFromItem(child, 0, 0, child.width, child.height)
		contentY = Math.min(rect.y, Math.max(contentY, (rect.y + rect.height) - height))
	}
	// -----------------------------------------------

	onFlickStarted: {
		postFlickingTimer.restart()
	}

	ControlsFactory.Factory {
		id: controlsFactory
	}

	Details.CopyPasteHelper {
		id: copyPasteHelper
		model: propertyGrid.model
		selectionModel: propertyGrid.selection
	}

	Details.ContextMenuHelper {
		id: contextMenuHelper
		propertyGrid: propertyGrid
	}

	Details.PGRowSplitterData {
		id: splitterSharedData
		x: Settings.splitterInitPos
	}

	/**
	 * Splitter auto position mechanism.
	 *
	 * Сlient code must maintain the consistency of properties "x" and "autoPosition" of splitterSharedData.
	 * If "autoPosition" is set to true, then property "x" cannot be changed manually.
	 * Before changing "x", set "autoPosition" to false.
	 */
	DSM.StateMachine {
		initialState: enabledState
		running: true

		DSM.State {
			id: disabledState

			DSM.SignalTransition {
				targetState: enabledState
				signal: propertyGrid.model.modelReset
			}
		}

		DSM.State {
			id: enabledState
			initialState: splitterSharedData.autoPosition ? autoState : manualState

			DSM.State {
				id: autoState

				onEntered: {
					splitterSharedData.x = Qt.binding(function() {
						return Math.min(rootGroup.getLabelsImplicitWidth(), width * Settings.splitterMaxAutoPositionRelative)
					})
				}

				onExited: {
					splitterSharedData.x = splitterSharedData.x // kill binding
				}

				DSM.SignalTransition {
					targetState: manualState
					signal: splitterSharedData.autoPositionChanged
					guard: !splitterSharedData.autoPosition
				}
			}

			DSM.State {
				id: manualState

				DSM.SignalTransition {
					targetState: autoState
					signal: splitterSharedData.autoPositionChanged
					guard: splitterSharedData.autoPosition
				}
			}

			DSM.SignalTransition {
				targetState: disabledState
				signal: propertyGrid.model.modelAboutToBeReset
			}
		}
	}

	Timer {
		id: postFlickingTimer
		interval: Settings.postFlickingDelay
	}

	Details.RootGroup {
		id: rootGroup
		width: parent.width
		viewportTop: propertyGrid.contentHeight * propertyGrid.visibleArea.yPosition
		viewportBottom: propertyGrid.contentHeight * (propertyGrid.visibleArea.yPosition + propertyGrid.visibleArea.heightRatio)
		focus: true
		__selectionProcessor: selectionProcessor
	}

	Details.ScrollController {
		flickable: propertyGrid
		model: propertyGrid.model
	}

	Details.SelectionMouseArea {
		id: selectionProcessor
		width: parent.width
		height: parent.height
		z: -1
		propertyGrid: propertyGrid
		selectionFrame: selectionFrame
		selectionFrameEnabled: false

		onRightButtonClicked: {
			if (contextMenuHelper.canShowMenu()) {
				contextMenuHelper.showMenu(mouseX, mouseY)
			}
		}

		onFrameSelectionWheel: {
			let nextContentY = propertyGrid.contentY - (ControlsSettings.mouseWheelScrollVelocity2 * delta)
			propertyGrid.contentY = Utils.clamp(nextContentY, 0, propertyGrid.contentHeight - propertyGrid.height)
		}
	}

	Keys.onMenuPressed: {
		// to prevent propogation to other items
		event.accepted = true
	}

	Keys.onReleased: {
		if(Qt.Key_Menu == event.key && !event.isAutoRepeat)
		{
			if (contextMenuHelper.canShowMenu()) {
				contextMenuHelper.showMenu(0, 0)
				event.accepted = true
			}
		}
	}

	ControlsEx.SelectionFrame {
		id: selectionFrame
	}

	Keys.forwardTo: [selectionProcessor]
	ScrollBar.vertical: ScrollBar {
		id: vscrollbar
		visible: size < 1
		Rectangle{
			color: _palette.color8
			anchors.fill: parent
		}
	}
}
