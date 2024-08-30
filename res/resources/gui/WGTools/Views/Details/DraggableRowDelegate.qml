import QtQuick 2.11
import QtQml.Models 2.11
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0
import WGTools.Controls.impl 1.0 as Impl

Item {
	id: root

	// This delegate implements only drag'n'drop functionality, the visual component is derived.
	// User can provide custom visual behavior by wrapping his implementation into this delegate.
	// When user provides no custom delegate, default row delegate implementation is used.
	default property Item contentItem: null

	onContentItemChanged: {
		if (contentItem !== null) {
			contentItem.parent = root
			root.height = Qt.binding(function() { return contentItem.height })
		}
	}

	// Reference to the parent TreeView.
	property TreeView view

	// This property enables dropping between items.
	property bool reorderEnabled: true

	// The thickness of lines used for highlighting items when drag'n'drop is active.
	property int highlightWidth: 2

	// The opacity of a fill used for highlighting items when drag'n'drop is active.
	property real highlightOpacity: 0.3

	property MouseArea __viewMouseArea: view.__mouseArea
	property var __modelAdapter: view.__model
	property Item __dragPrototype: parent.parent

	MouseArea {
		id: dragTriggerArea

		anchors.fill: parent

		onPressed: {

			if (__checkDragEnabled(__getIndex())) {
				dragAvatar.source = null
				dragAvatar.source = __dragPrototype

				__viewMouseArea.onReleased.connect(handleRelease)
				__viewMouseArea.onPositionChanged.connect(handlePositionChange)
			}

			mouse.accepted = false
		}

		function handleRelease(mouse) {

			if (__viewMouseArea.drag.active && __viewMouseArea.drag.target === dragAvatar) {
				dragAvatar.Drag.drop()
			}

			__destroyMimeData(dragAvatar.__rawMimeData);

			__viewMouseArea.drag.target = undefined

			__viewMouseArea.onReleased.disconnect(handleRelease)
			__viewMouseArea.onPositionChanged.disconnect(handlePositionChange)
		}

		function handlePositionChange(mouse) {

			__viewMouseArea.onPositionChanged.disconnect(dragTriggerArea.handlePositionChange)

			var mimeData = __mimeData(__getIndex())
			if (mimeData) {
				dragAvatar.__rawMimeData = mimeData
				dragAvatar.Drag.mimeData = __mimeDataToDict(mimeData)
				__viewMouseArea.drag.target = dragAvatar
			}
		}
	}

	Loader {
		id: delegateLoader
		sourceComponent: view.__style ? view.__style.rowDelegate : null
		active: contentItem === null
		width: parent.width
		readonly property QtObject styleData: root.parent.styleData
		readonly property var model: root.parent.model
		readonly property var modelData: root.parent.modelData
		onStatusChanged: {
			if (delegateLoader.status === Loader.Ready) {
				root.height = Qt.binding(function() { return delegateLoader.height })
			}
		}
	}

	Rectangle {
		id: dragHighlight
		anchors.fill: parent
		radius: highlightWidth
		color: "lightgrey"
		border {
			color: "darkgrey"
			width: highlightWidth
		}
		opacity: highlightOpacity
		visible: __viewMouseArea.drag.target === dragAvatar
	}

	Rectangle {
		id: dropItemHighlight
		anchors.fill: parent
		radius: highlightWidth
		color: "lightsteelblue"
		border {
			color: "steelblue"
			width: highlightWidth
		}
		opacity: highlightOpacity
		visible: centerDropArea.containsDrag 
	}

	Rectangle {
		id: topPlaceholderHightlight
		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
		}
		height: highlightWidth
		color: "black"
		visible: topDropArea.containsDrag
	}

	Rectangle {
		id: centerPlaceholderHighlight
		anchors.fill: parent
		radius: highlightWidth
		color: "transparent"
		border {
			color: "black"
			width: highlightWidth
		}
		visible: centerDropArea.containsDrag
	}

	Rectangle {
		id: bottomPlaceholderHighlight
		anchors {
			left: parent.left
			right: parent.right
			bottom: parent.bottom
		}
		height: highlightWidth
		color: "black"
		visible: bottomDropArea.containsDrag
	}

	DropArea {
		id: topDropArea
		enabled: reorderEnabled
		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
		}
		height: enabled ? parent.height * 0.2 : 0
		onEntered: {
			var mimeData = __fetchMimeData(drag.source)
			var index = __getIndex()
			var parent = view.model.parent(index)
			drag.accepted =
				mimeData &&
				__checkDropEnabled(parent) &&
				__canDropMimeData(mimeData, drag.action, index.row, index.column, parent)
		}
		onDropped: {
			var mimeData = __fetchMimeData(drop.source)
			var index = __getIndex()
			var parent = view.model.parent(index)
			__dropMimeData(mimeData, drop.action, index.row, index.column, parent)
		}
	}

	DropArea {
		id: centerDropArea
		anchors {
			left: parent.left
			right: parent.right
			top: topDropArea.bottom
			bottom: bottomDropArea.top
		}
		onEntered: {
			var mimeData = __fetchMimeData(drag.source)
			var index = __getIndex()
			drag.accepted =
				mimeData &&
				__checkDropEnabled(index) &&
				__canDropMimeData(mimeData, drag.action, -1, -1, index)
		}
		onDropped: {
			var mimeData = __fetchMimeData(drop.source)
			__dropMimeData(mimeData, drop.action, -1, -1, __getIndex())
		}
	}

	DropArea {
		id: bottomDropArea
		enabled: reorderEnabled
		anchors {
			left: parent.left
			right: parent.right
			bottom: parent.bottom
		}
		height: enabled ? parent.height * 0.2 : 0
		onEntered: {
			var mimeData = __fetchMimeData(drag.source)
			var index = __getIndex()
			var parent = view.model.parent(index)
			drag.accepted =
				mimeData &&
				__checkDropEnabled(parent) &&
				__canDropMimeData(mimeData, drag.action, index.row + 1, index.column, parent)
		}
		onDropped: {
			var mimeData = __fetchMimeData(drop.source)
			var index = __getIndex()
			var parent = view.model.parent(index)
			__dropMimeData(mimeData, drop.action, index.row + 1, index.column, parent)
		}
	}

	OpacityMask {
		id: dragAvatar

		property var __rawMimeData: null

		visible: false

		width: Math.min(__dragPrototype !== null ? __dragPrototype.width : 0, view.width)
		height: __dragPrototype !== null ? __dragPrototype.height : 0

		maskSource: dragAvatarMask

		Drag.dragType: Drag.Automatic
		Drag.supportedActions: Qt.MoveAction | Qt.CopyAction
		Drag.active: __viewMouseArea.drag.active && __viewMouseArea.drag.target === dragAvatar
		Drag.hotSpot {
			x: width * 0.3
			y: height * 0.5
		}

		RadialGradient {
			id: dragAvatarMask

			anchors.fill: parent

			visible: false

			horizontalRadius: width
			verticalRadius: height

			gradient: Gradient {
				GradientStop { position: 0.0; color: "#B0000000" }
				GradientStop { position: 1.0; color: "#40000000" }
			}
		}

		onSourceChanged: {
			if (source != null) {
				dragAvatar.grabToImage(function(result) {
					dragAvatar.Drag.imageSource = result.url
				})
			}
		}
	}

	states: [
		State {
			when: dragAvatar.Drag.active
			name: "dragging"

			PropertyChanges {
				target: view
				selectionMode: SelectionMode.NoSelection
			}

			PropertyChanges {
				target: topDropArea
				enabled: false
			}

			PropertyChanges {
				target: centerDropArea
				enabled: false
			}

			PropertyChanges {
				target: bottomDropArea
				enabled: false
			}
		}
	]

	function __fetchMimeData(item) {

		if (item === null) {
			return null
		}

		if (item.hasOwnProperty("__rawMimeData")) {
			return item.__rawMimeData
		}

		return item.Drag.mimeData
	}

	function __getIndex() {
		return __modelAdapter.mapRowToModelIndex(styleData.row)
	}

	function __getFlags(index) {
		return view.model.flags(index)
	}

	function __checkDragEnabled(index) {
		return __getFlags(index) & Qt.ItemIsDragEnabled
	}

	function __checkDropEnabled(index) {
		return __getFlags(index) & Qt.ItemIsDropEnabled
	}

	function __mimeData(index) {
		return Impl.TreeViewDragHelper.mimeData(view.model, index)
	}

	function __canDropMimeData(mimeData, action, row, column, parent) {
		return Impl.TreeViewDragHelper.canDropMimeData(view.model, mimeData, action, row, column, parent)
	}

	function __dropMimeData(mimeData, action, row, column, parent) {
		return Impl.TreeViewDragHelper.dropMimeData(view.model, mimeData, action, row, column, parent)
	}

	function __destroyMimeData(mimeData) {
		return Impl.TreeViewDragHelper.destroyMimeData(mimeData)
	}

	function __mimeDataToDict(mimeData) {
		return Impl.TreeViewDragHelper.mimeDataToDict(mimeData)
	}
}
