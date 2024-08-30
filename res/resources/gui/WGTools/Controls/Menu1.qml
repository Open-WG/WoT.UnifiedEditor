import QtQuick 2.11
import QtQuick.Controls 1.4
import WGTools.Controls.Styles 1.0
import WGTools.Controls.impl 1.0 as Impl

Menu {
	id: control
	style: MenuStyle {}

	property bool isSubMenu: false

	onAboutToShow: if (!isSubMenu) { Impl.MenuSupervisor.visible = true }
	onAboutToHide: if (!isSubMenu) { Impl.MenuSupervisor.visible = false }
	
	Impl.MenuSupervisor.onCloseRequest: if (!isSubMenu) { control.visible = false }
}
