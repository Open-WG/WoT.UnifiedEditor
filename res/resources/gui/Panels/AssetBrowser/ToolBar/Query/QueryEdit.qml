import QtQuick 2.7
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0 as Details
import WGTools.Misc 1.0 as Misc
import "HintView" as HintView
import "QueryView" as QueryView
import "HintView/Details" as HintViewDetails
import "HintView/Delegates" as HintViewDelegates

FocusScope {
	id: root

	property bool editEnabled: false
	property alias color: viewItem.color

	signal startEditing()
	signal endEditing()

	implicitWidth: ControlsSettings.width
	implicitHeight: ControlsSettings.height
	baselineOffset: textEdit.x + textEdit.baselineOffset

	onFocusChanged: {
		if (!focus) {
			p.editing = false
		}
	}

	function getHintView() {
		if (p.hintViewInstance === null) {
			p.hintViewInstance = hintViewComponent.createObject()
			p.hintViewInstance.Component.destruction.connect(function() {
				p.hintViewInstance = null
			})
		}

		return p.hintViewInstance
	}

	QtObject {
		id: p // private

		property bool editing: false
		property bool syncing: false

		property Item hintViewInstance: null
		property bool editSyncing: false
		property bool cursorPositionSyncing: false
		
		readonly property bool filtered: context.contentFiltered
		readonly property bool searching: context.contentModel.searching
		readonly property int foundCount: context.contentModel.count

		readonly property string currentPath: context.contentPath
		readonly property string currentQueryPath: context.queryPath
		readonly property string currentQueryFilters: context.queryFilters

		readonly property var queryModel: context.queryModel
		readonly property var editProxy: context.queryEditProxy
		readonly property var models: context.queryHintModels
		readonly property var delegates: {
			return {
				tags: tagDelegate,
				folders: folderDelegate
			}
		}

		onEditingChanged: {
			if (editing)
			{
				textEdit.forceActiveFocus()
				root.startEditing()
			}
			else
			{
				if (!syncing)
				{
					context.cancelQuery()
				}

				viewItem.focus = true
				root.endEditing()
			}
		}
	}

	Connections {
		target: context
		ignoreUnknownSignals: true

		onQueryApplied: {
			p.syncing = true
			p.editing = false
			p.syncing = false
		}

		onQueryCanceled: {
			p.syncing = true
			p.editing = false
			p.syncing = false
		}
	}

	Component {
		id: hintViewComponent

		Item {
			property alias currentIndex: hintView.currentIndex

			clip: true

			Keys.forwardTo: hintView

			HintView.HintView {
				id: hintView
				anchors.fill: parent

				models: p.models
				delegates: p.delegates
				headerDelegate: hintViewHeaderDelegate

				onHintClicked: context.applyHint(modelId, index)
				onHeaderClicked: context.applyQuery()
			}
		}
	}

	Component {
		id: hintViewHeaderDelegate

		HintViewDelegates.PathFiltersHeaderDelegate {
			path: p.currentQueryPath
			filters: p.currentQueryFilters
		}
	}

	Component {
		id: tagDelegate

		HintViewDelegates.TagDelegate {
			tagNameRole: "display"
			tagColorRole: "decoration"
		}
	}

	Component {
		id: folderDelegate

		HintViewDelegates.FolderDelegate {
			id: folderItem
			folderNameRole: "display"
			folderPathRole: "path"
			matchPosRole: "searchInfo.matchPos"
			matchLenRole: "searchInfo.matchLen"
			folderAreaWidth: folderTextWidthProcessor.maxWidth

			onParentChanged: {
				if (parent)
				{
					folderTextWidthProcessor.addItem(folderItem)
				}
				else
				{
					folderTextWidthProcessor.removeItem(folderItem)
				}
			}
		}
	}

	HintViewDetails.FolderTextWidthProcessor {
		id: folderTextWidthProcessor
	}

	Rectangle {
		height: 1
		width: parent.width
		color: _palette.color3
		visible: !p.editing
		anchors.bottom: parent.bottom
	}

	// [view mode]
	Rectangle {
		id: viewItem
		visible: !p.editing
		enabled: visible

		anchors.fill: parent
		anchors.topMargin: ControlsSettings.smallPadding
		anchors.bottomMargin: ControlsSettings.smallPadding

		Keys.onPressed: {
			if (event.key == Qt.Key_Enter ||
				event.key == Qt.Key_Return)
			{
				p.editing = true
				event.accepted = true
			}
		}

		MouseArea {
			onClicked: p.editing = true
			anchors.fill: parent
		}

		QueryView.QueryView {
			id: queryView
			model: visible ? p.queryModel : null;
			height: 18
			spacing: 5
			horizontalIndents: 5

			anchors.left: parent.left
			anchors.right: labels.left
			anchors.verticalCenter: parent.verticalCenter

			onClicked: p.editing = true;
			onRemoveClicked: context.removeQueryToken(index)
			onPathClicked: context.showContents(path)
		}

		Misc.SideGradient {
			orientation: Qt.Horizontal
			startGradientSize: queryView.horizontalIndents
			endGradientSize: queryView.horizontalIndents
			visible: queryView.horizontalIndents > 0
			sideColor: viewItem.color
			anchors.fill: queryView
		}

		Row {
			id: labels
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter

			Misc.IconLabel {
				visible: !p.filtered
				enabled: false
				verticalAlignment: Qt.AlignBottom
				spacing: 5

				Accessible.name: label.text

				icon.source: "image://gui/icon-magnifier?color=" + encodeURIComponent(_palette.color2)
				label.text: "Type to search"
			}

			RemoveFiltersButton {
				count: p.foundCount
				visible: p.filtered
				onClicked: context.removeFilters()
			}
		}
	}
	// [view mode]

	// [edit mode]
	TextField {
		id: textEdit
		activeFocusOnTab: false
		visible: p.editing
		enabled: visible

		anchors.fill: parent

		Accessible.name: "Text"

		// queued apply (because viewItem can handle enter event somehow right after this)
		onAccepted: acceptedTimer.start()

		Timer {
			id: acceptedTimer
			interval: 0
			onTriggered: context.applyQuery()
		}

		onTextChanged: {
			if (!p.editSyncing) {
				p.editSyncing = true
				p.editProxy.text = text
				p.editSyncing = false
			}

			if (p.hintViewInstance != null) {
				p.hintViewInstance.currentIndex = 0
			}
		}

		onCursorPositionChanged: {
			if (!p.cursorPositionSyncing) {
				p.cursorPositionSyncing = true
				p.editProxy.cursorPosition = cursorPosition
				p.cursorPositionSyncing = false
			}
		}

		Keys.forwardTo: p.hintViewInstance
		Keys.onEscapePressed: p.editing = false

		Connections {
			target: p.editProxy
			ignoreUnknownSignals: true

			onTextChanged: {
				if (!p.editSyncing) {
					p.editSyncing = true
					textEdit.text = p.editProxy.text
					p.editSyncing = false
				}
			}

			onCursorPositionChanged: {
				if (!p.cursorPositionSyncing) {
					p.cursorPositionSyncing = true
					textEdit.cursorPosition = p.editProxy.cursorPosition
					p.cursorPositionSyncing = false
				}
			}
		}
	}
	// [edit mode]
}
