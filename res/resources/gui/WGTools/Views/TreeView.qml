import QtQuick 2.7
import QtQuick.Controls 1.4
import WGTools.Views.Details 1.0 as Details
import WGTools.Views.Styles 1.0 as Styles
import WGTools.Controls.Details 2.0
import WGTools.Clickomatic 1.0 as Clickomatic

TreeView {
	id: root

	property alias accesibleNameRole: accesibleNameParser.roleName
	property var __internalScrollHelper: Details.ScrollHelper {parent: root}
	readonly property real rowHeight: rowLoader.item ? rowLoader.item.height : 0
	readonly property real headerHeight: headerLoader.item ? headerLoader.item.height: 0

	style: Styles.TreeViewStyle {}
	frameVisible: false

	__wheelAreaScrollSpeed: ControlsSettings.mouseWheelScrollVelocity2

	Accessible.name: "Tree View"

	signal headerMenuRequested(int column)
	signal columnIndexChanged(int index)

	headerDelegate: Details.TableViewHeader {
		id: header
		view: root

		onMenuRequested: {
			root.headerMenuRequested(column)
		}

		Connections {
			target: styleData
			ignoreUnknownSignals: true
			onColumnChanged: {
				root.columnIndexChanged(styleData.column)
			}
		}
	}
	
	Loader {
		id: rowLoader
		
		sourceComponent: root.rowDelegate

		property QtObject styleData: QtObject {
			readonly property int row: -1
			readonly property bool alternate: false
			readonly property bool selected: false
			readonly property bool hasActiveFocus: false
			readonly property bool pressed: false
		}
		Binding {
			target: rowLoader.item
			property: "visible"
			value: false
		}

		Binding {
			target: rowLoader.item
			property: "enabled"
			value: false
		}
	}

	Loader{
		id: headerLoader

		sourceComponent: root.headerDelegate
		property QtObject styleData: QtObject {
			readonly property int row: -1
			readonly property bool alternate: false
			readonly property bool selected: false
			readonly property bool hasActiveFocus: false
			readonly property bool pressed: false
			readonly property string value: ""
		}
		Binding {
			target: headerLoader.item
			property: "visible"
			value: false
		}

		Binding {
			target: headerLoader.item
			property: "enabled"
			value: false
		}

	}

	// clickomatic -----------------------------------

	Component.onCompleted: {
		children[0].Accessible.ignored = true
	}

	property var __internalAccesibleNameParser: Clickomatic.TableAccesibleNameParser {
		id: accesibleNameParser
		model: root.model
	}

	Clickomatic.ClickomaticItem.showChild: function(name) {
		var index = accesibleNameParser.findIndex(name)

		if (index.valid) {
			expandAllParents(index)
			positionViewAtIndex(index, ListView.Contain)
		}
	}
	// -----------------------------------------------

	function collapseAll() {
		if (model == null) {
			return
		}

		for (var row = model.rowCount() - 1; row >= 0; --row) {
			collapseRecursively(model.index(row, 0))
		}
	}

	function collapseRecursively(index) {
		for (var row = model.rowCount(index) - 1; row >= 0; --row) {
			collapseRecursively(model.index(row, 0, index))
		}

		if (isExpanded(index)){
			collapse(index)
		}
	}

	function expandAll() {
		if (model == null) {
			return
		}

		for (var row = 0, rows = model.rowCount(); row < rows; ++row) {
			expandRecursively(model.index(row, 0))
		}
	}

	function toggleExpandedAll() {
		if (model == null)
			return

		for (var row = 0, rows = model.rowCount(); row < rows; ++row) {
			if (isExpanded(model.index(row, 0))) {
				collapseAll()
				return 0
			}
		}

		expandAll()
		return 1
	}

	function expandRecursively(index) {
		if (!isExpanded(index)){
			expand(index)
		}

		for (var row = 0, rows = model.rowCount(index); row < rows; ++row) {
			expandRecursively(model.index(row, 0, index))
		}
	}

	function toggleExpanded(index) {
		if (isExpanded(index)) {
			collapse(index)
		} else {
			expand(index)
		}
	}

	function expandAllParents(index) {
		var parentIndex = index.parent

		while (parentIndex.valid) {
			expand(parentIndex)
			parentIndex = parentIndex.parent
		}
	}

	function positionViewAtIndex(index, mode) {
		var row = 0

		do {
			row += expandedRowsInBranch(index.model, index.parent, index.row)
			index = index.parent

		} while (index.valid)

		__listView.positionViewAtIndex(row, mode)
	}

	function positionViewAtBeginning() {
		__listView.positionViewAtBeginning()
	}

	function positionViewAtEnd() {
		__listView.positionViewAtEnd()
	}

	function expandedRowsInBranch(model, parent, lastChildIndex) {
		var rows = 0

		if (parent.valid)
			rows += 1

		if (!parent.valid || root.isExpanded(parent)) {
			var n = (lastChildIndex == -1) ? model.rowCount(parent) : lastChildIndex

			for (var i=0; i<n; ++i) {
				var child = model.index(i, 0, parent)
				rows = rows + expandedRowsInBranch(model, child, -1)
			}
		}

		return rows
	}
}
