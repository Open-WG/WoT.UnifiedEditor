import QtQuick 2.11
import QtQuick.Controls.Styles 1.4

import WGTools.Controls.Details 2.0 as Details
import WGTools.Controls 2.0 as Controls

MenuStyle {
	frame: Details.MenuBackground {}
	itemDelegate.label: Text {
		padding: Details.ControlsSettings.menuStylePadding
		leftPadding: Details.ControlsSettings.menuStyleLeftPadding
		text: styleData.text
		color: styleData.enabled ? _palette.color1 : _palette.color3
	}
	itemDelegate.checkmarkIndicator: Controls.CheckBox {
		checked: styleData.checked
	}
	separator: Rectangle {
		implicitWidth: parent.width
		implicitHeight: Details.ControlsSettings.menuStyleSeparatorWidth
		color: _palette.color3
	}
}
