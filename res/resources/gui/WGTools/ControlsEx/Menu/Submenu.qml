import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.ControlsEx.Menu 1.0

Menu {
	id: submenu
	
	property var menuModel: null
	property var rootIndex: null
	
	onAboutToShow: {
		implicitWidth = calculateImplicitWidth()
	}

	SubmenuInstantiator {
		startIndex: 0
		menu: submenu
		menuModel: submenu.menuModel
		rootIndex: submenu.rootIndex
	}
}
