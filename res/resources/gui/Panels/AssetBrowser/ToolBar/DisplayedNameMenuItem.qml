import QtQuick 2.7
import QtQuick.Controls 2.4
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

MenuItem {
	property string name

	checkable: true
	checked: toolBarMenu.displayedName == name
	visible: toolBarMenu.isGrid()
	ButtonGroup.group: displayedNameGroup
	onCheckedChanged: toolBarMenu.displayedNameClicked(name)
}