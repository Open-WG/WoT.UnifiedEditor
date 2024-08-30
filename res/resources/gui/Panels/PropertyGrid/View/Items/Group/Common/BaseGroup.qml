import QtQuick 2.7
import QtQml.Models 2.2
import WGTools.PropertyGrid 1.0 as WGTools
import WGTools.Clickomatic 1.0 as Clickomatic
import "../../../Settings.js" as Settings
import "../../Property" as Details
import "../../Grid" as Details
import "../../" as Details

Item {
	id: root

	// viewport
	property real viewportTop: isSubGroup
		? (styleData.group.viewportTop + styleData.group.childrenViewportOffset - (styleData.group.childrenY + styleData.holder.y))
		: 0

	property real viewportBottom: isSubGroup
		? (styleData.group.viewportBottom - (styleData.group.childrenY + styleData.holder.y))
		: 0

	readonly property real childrenViewportOffset: flexibleHeader
		? header.height
		: 0

	// settings
	property bool flexibleHeader: true
	property bool smoothTransitions: true

	// status
	readonly property alias expanding: root.__expanding
	readonly property alias expanded: root.__expanded

	// models
	property alias baseModel: delegateModel.model
	property alias rootIndex: delegateModel.rootIndex
	property ItemSelectionModel selection: isSubGroup ? styleData.group.selection : null
	property string childTypeRole: "nodeType"
	property string childNameRole: "name"

	// delegates
	property alias backgroundDelegate: backgroundLoader.sourceComponent
	property alias headerDelegate: header.sourceComponent

	property Component propertyDelegate: Details.PropertyItem {}
	property Component gridDelegate: Details.GridItem {}
	property Component groupDelegate: null
	property Component childDelegate: Details.FallbackItem {}

	// hierarchy
	readonly property bool isSubGroup: typeof styleData != "undefined" && typeof styleData["group"] != "undefined"
	readonly property int depth: isSubGroup ? styleData.group.depth + 1 : 0

	// dimensions
	property alias childrenSpacing: childrenColumn.spacing

	property real childrenTopPadding: 0
	property real childrenBottomPadding: 0

	readonly property alias headerY: header.y
	readonly property alias headerHeight: header.height
	readonly property alias childrenY: childrenColumn.y
	readonly property alias childrenCount: childrenRepeater.count

	// private
	property bool __expanded: false
	property bool __expanding: false
	property real __draftHeight: header.height
	property Item __selectionProcessor: isSubGroup ? styleData.group.__selectionProcessor : null;

	// --
	implicitWidth: Settings.groupImplicitWidth
	implicitHeight: header.height + childrenColumn.implicitHeight
	height: Math.round(__draftHeight)
	clip: true

	Accessible.name: (isSubGroup && model) ? model.node.name : ""

	// state
	state: (!isSubGroup || !model || model.node.expanded) ? "expanded" : ""
	states: State {
		name: "expanded"

		PropertyChanges { target: root; __draftHeight: root.implicitHeight; __expanded: true }
		PropertyChanges { target: childrenColumn; opacity: 1; visible: true }
	}

	transitions: [
		Transition {
			from: "expanded"
			enabled: root.smoothTransitions

			SequentialAnimation {
				PropertyAction { target: root; property: "__expanding"; value: true }
				PropertyAction { target: root; property: "__expanded" }
				ParallelAnimation {
					NumberAnimation { target: root; property: "__draftHeight"; duration: Settings.expandingDuration; easing.type: Easing.OutQuart }
					NumberAnimation { target: childrenColumn; property: "opacity"; duration: Settings.expandingDuration; easing.type: Easing.OutQuart }
				}
				PropertyAction { target: root; property: "__expanding"; value: false }
				PropertyAction { target: childrenColumn; property: "visible" }
			}
		},

		Transition {
			to: "expanded"
			enabled: root.smoothTransitions

			SequentialAnimation {
				PropertyAction { target: childrenColumn; property: "visible" }
				PropertyAction { target: root; property: "__expanding"; value: true }
				PropertyAction { target: root; property: "__expanded" }
				ParallelAnimation {
					NumberAnimation { target: root; property: "__draftHeight"; duration: Settings.expandingDuration; easing.type: Easing.OutQuart }
					NumberAnimation { target: childrenColumn; property: "opacity"; duration: Settings.expandingDuration; easing.type: Easing.OutQuart }
				}
				PropertyAction { target: root; property: "__expanding"; value: false }
			}
		}
	]

	onHeightChanged: {
		if (expanding) {
			if (isSubGroup) {
				var yInGroup = mapToItem(styleData.group, 0, height - header.height).y
				var delta = Math.max(0, styleData.group.viewportTop + styleData.group.childrenViewportOffset - yInGroup)

				if (delta > 0) {
					propertyGrid.contentY -= delta
				}
			} else {
				var contentY = mapToItem(propertyGrid.contentItem, 0, height - header.height).y
				if (contentY < propertyGrid.contentY) {
					propertyGrid.contentY = contentY
				}
			}
		}
	}

	function expand(smooth) {
		if (isSubGroup) {
			root.smoothTransitions = smooth || smooth === undefined
			model.node.expanded = true
		}
	}

	function toggle(smooth) {
		if (isSubGroup) {
			root.smoothTransitions = smooth || smooth === undefined
			model.node.expanded = !model.node.expanded
		}
	}

	function nodeAt(y, recursive) {
		var childrenLocalY = y - childrenY
		var child = childrenColumn.childAt(0, childrenLocalY)

		while (child && child.isGroup() && recursive === true) {
			child = child.item.nodeAt(childrenLocalY - child.y, recursive)
		}

		return child
	}

	function getGroupChainAt(y) {
		var chain = []
		var child = nodeAt(y)

		while (child && child.isGroup() && child.item) {
			chain.push(child.item.getName())
			child = child.item.nodeAt(mapToItem(child.item, 0, y).y)
		}

		return chain
	}

	function getName() {
		return isSubGroup ? model.node.name : "<root>"
	}

	function getLabelsImplicitWidth() {
		var result = 0

		for (var i=0; i<childrenRepeater.count; ++i) {
			var delegateItem = childrenRepeater.itemAt(i)
			if (delegateItem && delegateItem.item)
			{
				if (delegateItem.isGroup()) {
					var group = delegateItem.item
					result = Math.max(result, group.getLabelsImplicitWidth())
				}
				else {
					var propertyItem = delegateItem.item
					if (propertyItem.label && propertyItem.label.enabled) {
						var width = Settings.propertyLeftPadding
							+ propertyItem.label.implicitWidth
							+ Settings.propertyRightPadding;
						result = Math.max(result, width)
					}
				}
			}
		}

		return result
	}

	// clickomatic -----------------------------------
	Clickomatic.ClickomaticItem.showChild: function(name) {
		expand(false)

		var child = findChild(name)
		if (child) {
			propertyGrid.scrollToChild(child)
		}
	}

	function findChild(name) {
		for (var i=0; i<childrenRepeater.count; ++i) {
			var item = childrenRepeater.itemAt(i)
			if (item) {
				item = item.item
				if (item && item.Accessible.name == name) {
					return item
				}
			}
		}

		return null
	}
	// -----------------------------------------------

	Loader {
		id: backgroundLoader
		anchors.fill: parent

		property QtObject styleData: QtObject {
			readonly property Item group: root
		}
	}

	Loader {
		id: header
		width: parent.width
		z: 1
		y: root.flexibleHeader
			? Math.min(
				Math.max(0, root.viewportTop),
				Math.round(root.height - height))
			: 0

		property QtObject styleData: QtObject {
			readonly property Item group: root
		}
	}

	Column {
		id: childrenColumn
		width: parent.width
		y: header.height
		opacity: 0
		visible: false
		spacing: Settings.groupItemSpacing

		topPadding: childrenRepeater.firstChild != undefined && !childrenRepeater.firstChild.isGroup() ? childrenTopPadding : 0
		bottomPadding: childrenRepeater.lastChild != undefined && !childrenRepeater.lastChild.isGroup() ? childrenBottomPadding : 0

		Repeater {
			id: childrenRepeater

			readonly property Item firstChild: count > 0 ? itemAt(0) : null
			readonly property Item lastChild: count > 0 ? itemAt(count - 1) : null

			model: delegateModel
		}
	}

	DelegateModel {
		id: delegateModel
		model: (root.isSubGroup && styleData.modelIndex != null) ? styleData.group.baseModel : null;
		rootIndex: root.isSubGroup ? styleData.modelIndex : null;

		delegate: Item {
			id: delegateRoot

			property int itemIndex: -1
			property var itemModel: null

			readonly property var modelIndex: (itemIndex != -1) ? delegateModel.modelIndex(itemIndex) : null
			readonly property alias item: childLoader.item

			property bool _selectionSyncEnabled: true

			property var menu: childLoader.item && childLoader.item.hasOwnProperty("menu") ? childLoader.item.menu : null;

			width: parent.width
			height: childLoader.height

			property string debugId: ""
			onItemModelChanged: if (itemModel) {
				debugId = itemModel.node.name
			}

			function getType() {
				return itemModel ? itemModel[root.childTypeRole] : ""
			}

			function isGroup() {
				return getType() == "Group"
			}

			function getComponent() {
				if (itemIndex == -1)
					return null
					
				let type = getType()
				switch (type) {
					case "Property": return root.propertyDelegate
					case "Grid":     return root.gridDelegate
					case "Group":    return root.groupDelegate
					default:         return root.childDelegate
				}
			}

			function guardedForceActiveFocus(){
				_selectionSyncEnabled = false
				childLoader.forceActiveFocus()
				_selectionSyncEnabled = true
			}

			Connections {
				target: childLoader
				onActiveFocusChanged: { // TODO: think about better solution
					if (!childLoader.activeFocus)
						return

					if (delegateRoot.isGroup())
						return

					if (!delegateRoot._selectionSyncEnabled)
						return

					if (root.__selectionProcessor == null || root.__selectionProcessor.pressedIndex != null)
						return


					root.__selectionProcessor.mouseSelect(delegateRoot.modelIndex)
				}
			}

			Connections {
				target: root.__selectionProcessor
				ignoreUnknownSignals: true
				onCurrentIndexChanged: {
					if (root.__selectionProcessor.currentIndex == delegateRoot.modelIndex) {
						guardedForceActiveFocus()
					}
				}
			}

			Component.onCompleted: {
				itemIndex = Qt.binding(function() { return index })
				itemModel = Qt.binding(function() { return index != -1 ? model : null })
				
				childLoader.sourceComponent = Qt.binding(getComponent)
			}

			Component.onDestruction: {
				// console.log("onDestruction:", debugId)
				childLoader.sourceComponent = null

				itemIndex = -1
				itemModel = null
			}

			WGTools.IndexSelectionListener {
				id: selectedListener
				selectionModel: root.selection
				index: delegateRoot.modelIndex
			}

			Loader {
				id: childLoader
				width: parent.width

				readonly property int index: delegateRoot.itemIndex
				readonly property var model: delegateRoot.itemModel

				property QtObject styleData: QtObject {
					readonly property Item group: root
					readonly property Item holder: delegateRoot
					readonly property var modelIndex: delegateRoot.modelIndex
					readonly property bool selected: selectedListener.selected
					readonly property bool active: childLoader.activeFocus
				}
			}
		}
	}
}
