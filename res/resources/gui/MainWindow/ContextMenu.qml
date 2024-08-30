import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.ControlsEx.Menu 1.0

Menu {
	id: mainMenu
	property var model: context.model

	SubmenuInstantiator {
		id: submenuInstantiator
		startIndex: 0
		menu: mainMenu
		menuModel: mainMenu.model
	}

	onAboutToHide: {
		context.onAboutToHide()
	}

	onClosed: {
		context.onClosed()
	}

	onAboutToShow: {
		implicitWidth = calculateImplicitWidth()
	}
}
