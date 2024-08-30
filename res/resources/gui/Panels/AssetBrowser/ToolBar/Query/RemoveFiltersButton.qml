import QtQuick 2.11
import WGTools.Controls 2.0
import WGTools.Controls.Details 2.0

Button {
	id: control
	Accessible.name: "Clear Filters"
	property int count: 0

	text: "<b>" + count + "</b> item" + (count != 1 ? "s" : "") + " found"
	background: null

	icon.color: hovered ? _palette.color11 : _palette.color1
	icon.source: "image://gui/icon-filters-delete"

	LayoutMirroring.enabled: true
	ToolTip.text: "Clear Filters"
	ToolTip.visible: hovered
	ToolTip.delay: ControlsSettings.tooltipDelay
	ToolTip.timeout: ControlsSettings.tooltipTimeout

	Binding {target: control.contentItem; property: "color"; value: _palette.color3}
}
