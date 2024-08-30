import QtQuick 2.11
import QtQuick.Controls.impl 2.3 as Impl
import WGTools.Misc 1.0 as Misc
import WGTools.QmlUtils 1.0

Impl.IconLabel {
	readonly property real arrowCauseOffset: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
	readonly property real shortcutCauseOffset: shortcutLabel.visible ? shortcutLabel.width + control.spacing : 0

	leftPadding: control.indicator || (control.icon.source == "") ? (control.indicator.width + control.spacing) : 0
	rightPadding: shortcutCauseOffset + arrowCauseOffset

	spacing: control.spacing
	mirrored: control.mirrored
	display: control.display
	alignment: Qt.AlignLeft

	icon: control.icon
	text: control.text
	font: control.font
	color: _palette.color1

	opacity: control.enabled ? 1 : 0.5

	Misc.Text {
		id: shortcutLabel
		x: parent.width - width - arrowCauseOffset
		y: parent.height - height
		size: "Small"
		text: control.action ? StringUtils.shortcutText(control.action.shortcut) : ""
		visible: text.length
	}
}
