import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

ToolTip {
	property var source

	parent: source.handle
	text: control.labels.textFromValue(source.value, control.locale, control.labels.decimals)
	visible: (source.pressed || source.hovered || source.handle.hovered) && source.handle.visible && text
	delay: ControlsSettings.tooltipDelay
	y: -height - 5

	Binding on delay {value: 0; when: source.pressed}
	Binding on visible {value: true; when: source.pressed && text}
}
