import QtQuick 2.11
import WGTools.Controls.Details 2.0 as Details

Item {
	id: placeholder

	property alias down: indecator.down

	implicitWidth: indecator.implicitWidth
	implicitHeight: indecator.implicitHeight
	width: ControlsSettings.height
	height: control.height
	x: control.width - width

	Details.ComboBoxIndicator {
		id: indecator
		x: (placeholder.width - width) / 2
		y: (placeholder.height - height) / 2
	}
}
