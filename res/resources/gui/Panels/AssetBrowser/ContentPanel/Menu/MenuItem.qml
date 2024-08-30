import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.impl 1.0 as Impl

MenuItem {
	property alias wgtAction: adapter.action

	action: adapter
	visible: wgtAction != null

	Impl.ActionAdapter {id: adapter}
}
