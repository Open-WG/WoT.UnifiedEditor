import QtQuick 2.11
import QtQuick.Layouts 1.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0
import "Delegates/Scripts.js" as Scripts

ToolBar {
	GridLayout {
		flow: _toolbar.orientation === Qt.Horizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
		columnSpacing: ControlsSettings.toolBarPadding * 2
		rowSpacing: ControlsSettings.toolBarPadding * 2
		
		Accessible.name: "Toolbar"

		Repeater {
			model: context.model
			Loader { source: Scripts.getDelegate(model.type, "Delegates") }
		}
	}
}
