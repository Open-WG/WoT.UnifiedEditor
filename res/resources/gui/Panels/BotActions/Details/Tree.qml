import QtQuick 2.11
import QtQuick.Controls 1.4
import WGTools.Controls 2.0 as Controls
import WGTools.Views 1.0 as Views
import WGTools.Views.Styles 1.0 as ViewStyles

Views.TreeView {
	id: tree
	selectionMode: SelectionMode.ExtendedSelection

	headerVisible: true
	alternatingRowColors: false

	style: ViewStyles.TreeViewStyle{
		backgroundColor: _palette.color8
	}

	Controls.Menu {
		id: menu
		width: 230
		height: 30
		Controls.MenuItem {
			text: "Copy highlighted rows to clipboard"
			onTriggered: context.copyToClipboard(tree.selection)
		}
	}

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.RightButton 
		onPressed: menu.popupEx()
	}
}
