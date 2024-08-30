import QtQuick 2.11
import WGTools.Controls 2.0

Menu {
	id: submenu

	property var menuModel: null
	property var rootIndex: null

	delegate: AddTrackMenuItem {}

	AddTrackSubMenu {
		id: trackSubMenu
		menu: submenu
		menuModel: submenu.menuModel
		rootIndex: submenu.rootIndex
	}
}
